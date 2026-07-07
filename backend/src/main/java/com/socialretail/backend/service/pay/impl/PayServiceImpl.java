package com.socialretail.backend.service.pay.impl;

import com.alipay.api.AlipayApiException;
import com.alipay.api.AlipayClient;
import com.alipay.api.internal.util.AlipaySignature;
import com.alipay.api.request.AlipayTradeAppPayRequest;
import com.alipay.api.request.AlipayTradeWapPayRequest;
import com.alipay.api.response.AlipayTradeAppPayResponse;
import com.alipay.api.response.AlipayTradeWapPayResponse;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.socialretail.backend.common.OrderStatus;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.config.AlipayProperties;
import com.socialretail.backend.dto.request.payment.AlipayCreatePayDTO;
import com.socialretail.backend.dto.request.payment.MockPayFailDTO;
import com.socialretail.backend.dto.request.payment.MockPaySuccessDTO;
import com.socialretail.backend.entity.order.Payment;
import com.socialretail.backend.entity.order.Order;
import com.socialretail.backend.entity.order.OrderItem;
import com.socialretail.backend.entity.order.OrderStatusLog;
import com.socialretail.backend.mapper.order.PaymentMapper;
import com.socialretail.backend.mapper.order.OrderMapper;
import com.socialretail.backend.mapper.product.ProductMapper;
import com.socialretail.backend.service.order.impl.OrderServiceImpl;
import com.socialretail.backend.service.order.OrderPointsService;
import com.socialretail.backend.service.order.OrderRewardService;
import com.socialretail.backend.service.pay.PayService;
import com.socialretail.backend.service.social.CommissionService;
import com.socialretail.backend.vo.payment.AlipayCreatePayVO;
import com.socialretail.backend.vo.payment.MockPayResultVO;
import com.socialretail.backend.vo.payment.PayOrderStatusVO;
import com.socialretail.backend.vo.payment.PaymentDetailVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.security.SecureRandom;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;

@Service
public class PayServiceImpl implements PayService {

    private static final Logger log = LoggerFactory.getLogger(PayServiceImpl.class);
    private static final int WAIT_PAY = OrderStatus.WAIT_PAY;
    private static final int WAIT_ACCEPT = OrderStatus.WAIT_ACCEPT;
    private static final int ALIPAY_SANDBOX = 1;
    private static final int MOCK = 2;
    private static final int UNPAID = 0;
    private static final int PAID = 1;
    private static final int FAILED = 2;
    private static final BigDecimal ZERO = new BigDecimal("0.00");
    private static final SecureRandom RANDOM = new SecureRandom();
    private static final DateTimeFormatter PAY_SN_TIME = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
    private static final DateTimeFormatter ALIPAY_TIME = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    private final PaymentMapper paymentMapper;
    private final OrderMapper orderMapper;
    private final ProductMapper productMapper;
    private final AlipayClient alipayClient;
    private final AlipayProperties alipayProperties;
    private final ObjectMapper objectMapper;
    private final OrderPointsService orderPointsService;
    private final OrderRewardService orderRewardService;
    private final CommissionService commissionService;

    public PayServiceImpl(PaymentMapper paymentMapper,
                          OrderMapper orderMapper,
                          ProductMapper productMapper,
                          AlipayClient alipayClient,
                          AlipayProperties alipayProperties,
                          ObjectMapper objectMapper,
                          OrderPointsService orderPointsService,
                          OrderRewardService orderRewardService,
                          CommissionService commissionService) {
        this.paymentMapper = paymentMapper;
        this.orderMapper = orderMapper;
        this.productMapper = productMapper;
        this.alipayClient = alipayClient;
        this.alipayProperties = alipayProperties;
        this.objectMapper = objectMapper;
        this.orderPointsService = orderPointsService;
        this.orderRewardService = orderRewardService;
        this.commissionService = commissionService;
    }

    @Override
    @Transactional
    public AlipayCreatePayVO createAlipayPayment(Long userId, AlipayCreatePayDTO dto) {
        validateAlipayConfiguration();
        Order order = requirePayableOrder(userId, dto.getOrderId());
        Payment payment = requireOrCreateAlipayPayment(order);
        String payType = normalizeMobilePayType(dto.getPayType());

        try {
            String payPayload;
            if ("APP".equals(payType)) {
                AlipayTradeAppPayRequest request = new AlipayTradeAppPayRequest();
                request.setNotifyUrl(alipayProperties.getNotifyUrl());
                request.setBizContent(createAlipayBizContent(
                        order, payment, "QUICK_MSECURITY_PAY"
                ));
                AlipayTradeAppPayResponse response = alipayClient.sdkExecute(request);
                payPayload = response.getBody();
                validateAlipayResponseBody(payment, response.getCode(), response.getSubCode(), payPayload);
            } else {
                AlipayTradeWapPayRequest request = new AlipayTradeWapPayRequest();
                request.setNotifyUrl(alipayProperties.getNotifyUrl());
                request.setReturnUrl(resolveMobileReturnUrl());
                request.setBizContent(createAlipayBizContent(
                        order, payment, "QUICK_WAP_WAY"
                ));
                AlipayTradeWapPayResponse response = alipayClient.pageExecute(request);
                payPayload = response.getBody();
                validateAlipayResponseBody(payment, response.getCode(), response.getSubCode(), payPayload);
            }

            return new AlipayCreatePayVO(
                    payment.getId(), payment.getPaySn(), order.getId(), order.getOrderSn(),
                    money(payment.getAmount()), "ALIPAY_SANDBOX", payType, payPayload
            );
        } catch (AlipayApiException exception) {
            log.error("调用支付宝移动端沙箱网关失败，paySn={}, payType={}",
                    payment.getPaySn(), payType, exception);
            throw alipayCreateFailed();
        }
    }

    @Override
    @Transactional
    public boolean handleAlipayNotify(Map<String, String> parameters) {
        validateAlipayConfiguration();
        if (!verifyAlipaySignature(parameters)) {
            return false;
        }
        if (!Objects.equals(alipayProperties.getAppId(), parameters.get("app_id"))) {
            log.warn("支付宝回调 app_id 不匹配，outTradeNo={}", parameters.get("out_trade_no"));
            return false;
        }

        String tradeStatus = parameters.get("trade_status");
        if (!"TRADE_SUCCESS".equals(tradeStatus) && !"TRADE_FINISHED".equals(tradeStatus)) {
            return true;
        }
        String paySn = parameters.get("out_trade_no");
        String thirdTradeNo = parameters.get("trade_no");
        BigDecimal callbackAmount = parseAmount(parameters.get("total_amount"));
        if (!StringUtils.hasText(paySn) || !StringUtils.hasText(thirdTradeNo) || callbackAmount == null) {
            return false;
        }

        Payment preliminary = paymentMapper.selectByPaySn(paySn);
        if (preliminary == null) {
            return false;
        }
        Order order = orderMapper.selectByIdForUpdate(preliminary.getOrderId());
        Payment payment = paymentMapper.selectByPaySnForUpdate(paySn);
        if (order == null || payment == null || !sameMoney(payment.getAmount(), callbackAmount)) {
            log.warn("支付宝回调支付流水或金额不匹配，paySn={}", paySn);
            return false;
        }
        if (Objects.equals(payment.getStatus(), PAID)) {
            return !StringUtils.hasText(payment.getThirdTradeNo())
                    || Objects.equals(payment.getThirdTradeNo(), thirdTradeNo);
        }
        if (!Objects.equals(order.getStatus(), WAIT_PAY)) {
            log.warn("支付宝回调对应订单不可支付，orderId={}, status={}", order.getId(), order.getStatus());
            return false;
        }

        LocalDateTime now = LocalDateTime.now();
        LocalDateTime payTime = parseAlipayTime(parameters.get("gmt_payment"), now);
        finishPayment(payment, order, ALIPAY_SANDBOX, thirdTradeNo, payTime, now, "支付宝支付成功");
        return true;
    }

    @Override
    @Transactional(readOnly = true)
    public PayOrderStatusVO getOrderPayStatus(Long userId, Long orderId) {
        Order order = requireOrder(userId, orderId);
        Payment payment = paymentMapper.selectLatestByOrderIdAndUserId(orderId, userId);
        PayOrderStatusVO vo = new PayOrderStatusVO();
        vo.setOrderId(order.getId());
        vo.setOrderSn(order.getOrderSn());
        vo.setOrderStatus(orderStatusText(order.getStatus()));
        vo.setPayAmount(payment == null ? money(order.getPayAmount()) : money(payment.getAmount()));
        if (payment == null) {
            vo.setPayStatus("UNPAID");
        } else {
            vo.setPaymentId(payment.getId());
            vo.setPaySn(payment.getPaySn());
            vo.setPayPlatform(platformText(payment.getPayPlatform()));
            vo.setPayStatus(paymentStatusText(payment.getStatus()));
            vo.setPayTime(payment.getPayTime());
        }
        return vo;
    }

    @Override
    @Transactional
    public MockPayResultVO mockPaySuccess(Long userId, MockPaySuccessDTO dto) {
        Order order = requirePayableOrder(userId, dto.getOrderId());
        if (!sameMoney(order.getPayAmount(), dto.getPayAmount())) {
            throw amountMismatch(order.getPayAmount(), dto.getPayAmount());
        }
        Payment payment = paymentMapper.selectLatestByOrderIdForUpdate(order.getId());
        if (payment != null && Objects.equals(payment.getStatus(), PAID)) {
            throw alreadyPaid();
        }
        if (payment == null) {
            payment = createPayment(order, MOCK, "MOCKPAY");
        }
        LocalDateTime now = LocalDateTime.now();
        finishPayment(payment, order, MOCK, "MOCK-" + payment.getPaySn(), now, now, "模拟支付成功");
        return toMockResult(order, payment, PAID, now, null);
    }

    @Override
    @Transactional
    public MockPayResultVO mockPayFail(Long userId, MockPayFailDTO dto) {
        Order order = requirePayableOrder(userId, dto.getOrderId());
        Payment payment = paymentMapper.selectLatestByOrderIdForUpdate(order.getId());
        if (payment != null && Objects.equals(payment.getStatus(), PAID)) {
            throw alreadyPaid();
        }
        if (payment == null) {
            payment = createPayment(order, MOCK, "MOCKPAY");
        }
        String reason = StringUtils.hasText(dto.getFailReason())
                ? dto.getFailReason().trim() : "模拟支付失败";
        LocalDateTime now = LocalDateTime.now();
        if (paymentMapper.updatePlatformAndFailed(payment.getId(), MOCK, reason, now) != 1) {
            throw alreadyPaid();
        }
        return toMockResult(order, payment, FAILED, null, reason);
    }

    @Override
    @Transactional(readOnly = true)
    public PaymentDetailVO getPaymentDetail(Long userId, Long paymentId) {
        PaymentDetailVO detail = paymentMapper.selectDetailByIdAndUserId(paymentId, userId);
        if (detail == null) {
            throw new BusinessException(40431, HttpStatus.NOT_FOUND, "支付流水不存在");
        }
        detail.setRefundAmount(money(detail.getRefundAmount()));
        return detail;
    }

    private Order requirePayableOrder(Long userId, Long orderId) {
        Order order = orderMapper.selectByIdAndUserIdForUpdate(orderId, userId);
        if (order == null) {
            throw orderNotFound();
        }
        if (!Objects.equals(order.getStatus(), WAIT_PAY)
                || (order.getPayExpireTime() != null && !order.getPayExpireTime().isAfter(LocalDateTime.now()))) {
            Payment latest = paymentMapper.selectLatestByOrderIdForUpdate(order.getId());
            if (latest != null && Objects.equals(latest.getStatus(), PAID)) {
                throw alreadyPaid();
            }
            throw paymentNotAllowed(order);
        }
        return order;
    }

    private Order requireOrder(Long userId, Long orderId) {
        Order order = orderMapper.selectByIdAndUserId(orderId, userId);
        if (order == null) {
            throw orderNotFound();
        }
        return order;
    }

    private Payment createPayment(Order order, int platform, String prefix) {
        LocalDateTime now = LocalDateTime.now();
        Payment payment = new Payment();
        payment.setOrderId(order.getId());
        payment.setPaySn(generatePaySn(prefix, now));
        payment.setPayPlatform(platform);
        payment.setAmount(money(order.getPayAmount()));
        payment.setStatus(UNPAID);
        payment.setRefundStatus(0);
        payment.setRefundAmount(ZERO);
        payment.setCreateTime(now);
        payment.setUpdateTime(now);
        if (paymentMapper.insert(payment) != 1 || payment.getId() == null) {
            throw new IllegalStateException("支付流水创建失败");
        }
        return payment;
    }

    private void finishPayment(Payment payment,
                               Order order,
                               int platform,
                               String thirdTradeNo,
                               LocalDateTime payTime,
                               LocalDateTime callbackTime,
                               String remark) {
        int nextStatus = OrderStatus.nextStatusAfterPay(order.getDeliveryType());
        if (paymentMapper.updatePlatformAndPaid(
                payment.getId(), platform, thirdTradeNo, payTime, callbackTime
        ) != 1) {
            throw alreadyPaid();
        }
        if (orderMapper.updateStatusAfterPay(order.getId(), nextStatus, payTime, callbackTime) != 1) {
            throw new BusinessException(40924, HttpStatus.CONFLICT, "当前订单状态不允许支付");
        }
        orderPointsService.consume(order);
        orderRewardService.rewardPaidOrder(order, payTime);
        java.util.List<OrderItem> orderItems = orderMapper.selectItemsByOrderId(order.getId());
        commissionService.createForPaidOrder(order, orderItems, payTime);
        for (OrderItem item : orderItems) {
            if (item.getProductId() == null || item.getQuantity() == null || item.getQuantity() <= 0) {
                continue;
            }
            if (productMapper.incrementSoldCount(item.getProductId(), item.getQuantity()) != 1) {
                throw new IllegalStateException("支付成功后更新商品销量失败，productId=" + item.getProductId());
            }
        }
        OrderStatusLog statusLog = new OrderStatusLog();
        statusLog.setOrderId(order.getId());
        statusLog.setFromStatus(WAIT_PAY);
        statusLog.setToStatus(nextStatus);
        statusLog.setStatusText(OrderStatus.merchantStatusText(nextStatus, order.getDeliveryType()));
        statusLog.setOperatorType("SYSTEM");
        statusLog.setOperatorId(null);
        statusLog.setRemark(remark + "，支付流水号：" + payment.getPaySn());
        statusLog.setCreateTime(callbackTime);
        if (orderMapper.insertStatusLog(statusLog) != 1) {
            throw new IllegalStateException("订单状态日志保存失败");
        }
    }

    private String createAlipayBizContent(Order order, Payment payment, String productCode) {
        Map<String, Object> content = new LinkedHashMap<>();
        content.put("out_trade_no", payment.getPaySn());
        content.put("total_amount", money(payment.getAmount()).toPlainString());
        content.put("subject", "社交新零售订单" + order.getOrderSn());
        content.put("product_code", productCode);
        if (order.getPayExpireTime() != null) {
            long seconds = Math.max(1, Duration.between(LocalDateTime.now(), order.getPayExpireTime()).getSeconds());
            content.put("timeout_express", Math.max(1, (seconds + 59) / 60) + "m");
        }
        try {
            return objectMapper.writeValueAsString(content);
        } catch (JsonProcessingException exception) {
            throw new IllegalStateException("支付宝请求参数生成失败", exception);
        }
    }

    private Payment requireOrCreateAlipayPayment(Order order) {
        Payment payment = paymentMapper.selectLatestByOrderIdForUpdate(order.getId());
        if (payment != null && Objects.equals(payment.getStatus(), PAID)) {
            throw alreadyPaid();
        }
        if (payment == null
                || !Objects.equals(payment.getStatus(), UNPAID)
                || !Objects.equals(payment.getPayPlatform(), ALIPAY_SANDBOX)) {
            payment = createPayment(order, ALIPAY_SANDBOX, "PAY");
        }
        return payment;
    }

    private String normalizeMobilePayType(String payType) {
        return StringUtils.hasText(payType)
                ? payType.trim().toUpperCase(Locale.ROOT)
                : "WAP";
    }

    private String resolveMobileReturnUrl() {
        return StringUtils.hasText(alipayProperties.getMobileReturnUrl())
                ? alipayProperties.getMobileReturnUrl()
                : alipayProperties.getReturnUrl();
    }

    private void validateAlipayResponseBody(
            Payment payment, String code, String subCode, String body) {
        if (!StringUtils.hasText(body)) {
            log.warn("支付宝移动支付请求创建失败，paySn={}, code={}, subCode={}",
                    payment.getPaySn(), code, subCode);
            throw alipayCreateFailed();
        }
    }

    private boolean verifyAlipaySignature(Map<String, String> parameters) {
        try {
            boolean verified = AlipaySignature.rsaCheckV1(
                    parameters, alipayProperties.getAlipayPublicKey(),
                    alipayProperties.getCharset(), alipayProperties.getSignType()
            );
            if (!verified) {
                log.warn("支付宝回调验签失败，outTradeNo={}", parameters.get("out_trade_no"));
            }
            return verified;
        } catch (AlipayApiException | RuntimeException exception) {
            log.warn("支付宝回调验签异常，outTradeNo={}", parameters.get("out_trade_no"), exception);
            return false;
        }
    }

    private MockPayResultVO toMockResult(Order order,
                                         Payment payment,
                                         int paymentStatus,
                                         LocalDateTime payTime,
                                         String failReason) {
        MockPayResultVO vo = new MockPayResultVO();
        vo.setOrderId(order.getId());
        vo.setOrderSn(order.getOrderSn());
        vo.setPaymentId(payment.getId());
        vo.setPaySn(payment.getPaySn());
        vo.setPayStatus(paymentStatusText(paymentStatus));
        vo.setOrderStatus(paymentStatus == PAID
                ? OrderStatus.userStatusCode(OrderStatus.nextStatusAfterPay(order.getDeliveryType()))
                : OrderStatus.userStatusText(order.getStatus(), order.getDeliveryType()));
        vo.setPayTime(payTime);
        vo.setFailReason(failReason);
        return vo;
    }

    private String orderStatusText(Integer status) {
        return OrderServiceImpl.statusText(status);
    }

    private String generatePaySn(String prefix, LocalDateTime time) {
        return prefix + time.format(PAY_SN_TIME) + String.format("%06d", RANDOM.nextInt(1_000_000));
    }

    private BigDecimal parseAmount(String value) {
        try {
            return StringUtils.hasText(value) ? new BigDecimal(value) : null;
        } catch (NumberFormatException exception) {
            return null;
        }
    }

    private LocalDateTime parseAlipayTime(String value, LocalDateTime fallback) {
        try {
            return StringUtils.hasText(value) ? LocalDateTime.parse(value, ALIPAY_TIME) : fallback;
        } catch (DateTimeParseException exception) {
            return fallback;
        }
    }

    private BigDecimal money(BigDecimal value) {
        return value == null ? ZERO : value.setScale(2, RoundingMode.HALF_UP);
    }

    private boolean sameMoney(BigDecimal left, BigDecimal right) {
        return left != null && right != null && money(left).compareTo(money(right)) == 0;
    }

    private String platformText(Integer platform) {
        if (Objects.equals(platform, ALIPAY_SANDBOX)) {
            return "ALIPAY_SANDBOX";
        }
        if (Objects.equals(platform, MOCK)) {
            return "MOCK";
        }
        return "UNKNOWN";
    }

    private String paymentStatusText(Integer status) {
        if (status == null) {
            return "UNPAID";
        }
        return switch (status) {
            case 0 -> "UNPAID";
            case 1 -> "PAID";
            case 2 -> "FAILED";
            case 3 -> "CLOSED";
            default -> "UNKNOWN";
        };
    }

    private void validateAlipayConfiguration() {
        if (!StringUtils.hasText(alipayProperties.getAppId())
                || !StringUtils.hasText(alipayProperties.getPrivateKey())
                || !StringUtils.hasText(alipayProperties.getAlipayPublicKey())
                || !StringUtils.hasText(alipayProperties.getServerUrl())
                || !StringUtils.hasText(alipayProperties.getNotifyUrl())) {
            throw new BusinessException(50031, HttpStatus.SERVICE_UNAVAILABLE, "支付宝沙箱配置不完整");
        }
    }

    private BusinessException orderNotFound() {
        return new BusinessException(40421, HttpStatus.NOT_FOUND, "订单不存在");
    }

    private BusinessException alreadyPaid() {
        return new BusinessException(40926, HttpStatus.CONFLICT, "订单已支付，请勿重复支付");
    }

    private BusinessException paymentNotAllowed(Order order) {
        return new BusinessException(
                40924, HttpStatus.CONFLICT, "当前订单状态不允许支付",
                Map.of("orderId", order.getId(), "status", orderStatusText(order.getStatus()))
        );
    }

    private BusinessException amountMismatch(BigDecimal orderAmount, BigDecimal requestAmount) {
        return new BusinessException(
                40925, HttpStatus.CONFLICT, "支付金额与订单应付金额不一致",
                Map.of("orderPayAmount", money(orderAmount), "requestPayAmount", money(requestAmount))
        );
    }

    private BusinessException alipayCreateFailed() {
        return new BusinessException(50031, HttpStatus.INTERNAL_SERVER_ERROR, "支付宝支付请求创建失败");
    }
}
