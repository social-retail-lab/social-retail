package com.socialretail.backend.service.merchant.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.entity.member.Merchant;
import com.socialretail.backend.entity.order.Delivery;
import com.socialretail.backend.entity.order.DeliveryStatusLog;
import com.socialretail.backend.entity.order.Order;
import com.socialretail.backend.entity.order.OrderItem;
import com.socialretail.backend.entity.order.OrderStatusLog;
import com.socialretail.backend.entity.order.Payment;
import com.socialretail.backend.entity.order.PickupPoint;
import com.socialretail.backend.entity.product.Sku;
import com.socialretail.backend.entity.user.User;
import com.socialretail.backend.mapper.member.MerchantMapper;
import com.socialretail.backend.mapper.order.AfterSaleMapper;
import com.socialretail.backend.mapper.order.DeliveryMapper;
import com.socialretail.backend.mapper.order.DeliveryStatusLogMapper;
import com.socialretail.backend.mapper.order.MerchantEarningsMapper;
import com.socialretail.backend.mapper.order.OrderItemMapper;
import com.socialretail.backend.mapper.order.OrderMapper;
import com.socialretail.backend.mapper.order.OrderStatusLogMapper;
import com.socialretail.backend.mapper.order.PaymentMapper;
import com.socialretail.backend.mapper.order.PickupPointMapper;
import com.socialretail.backend.mapper.product.ProductMapper;
import com.socialretail.backend.mapper.product.SkuMapper;
import com.socialretail.backend.mapper.user.UserMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import jakarta.annotation.Resource;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

@Slf4j
@Service
public class MerchantOrderServiceImpl {

    @Resource
    private OrderMapper orderMapper;

    @Resource
    private OrderItemMapper orderItemMapper;

    @Resource
    private PaymentMapper paymentMapper;

    @Resource
    private DeliveryMapper deliveryMapper;

    @Resource
    private AfterSaleMapper afterSaleMapper;

    @Resource
    private PickupPointMapper pickupPointMapper;

    @Resource
    private OrderStatusLogMapper orderStatusLogMapper;

    @Resource
    private DeliveryStatusLogMapper deliveryStatusLogMapper;

    @Resource
    private MerchantEarningsMapper merchantEarningsMapper;

    @Resource
    private MerchantMapper merchantMapper;

    @Resource
    private UserMapper userMapper;

    @Resource
    private SkuMapper skuMapper;

    @Resource
    private ProductMapper productMapper;

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    private static final Random RANDOM = new Random();

    public PageResult<Map<String, Object>> getOrderList(Long merchantId, Integer status, Integer deliveryType,
                                                         String orderSn, String startDate, String endDate,
                                                         int pageNum, int pageSize) {
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Order::getMerchantId, merchantId);

        if (status != null) {
            wrapper.eq(Order::getStatus, status);
        }
        if (deliveryType != null) {
            wrapper.eq(Order::getDeliveryType, deliveryType);
        }
        if (orderSn != null && !orderSn.trim().isEmpty()) {
            wrapper.like(Order::getOrderSn, orderSn.trim());
        }
        if (startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty()) {
            LocalDateTime start = LocalDateTime.parse(startDate + " 00:00:00", FORMATTER);
            LocalDateTime end = LocalDateTime.parse(endDate + " 23:59:59", FORMATTER);
            wrapper.between(Order::getCreateTime, start, end);
        }

        wrapper.orderByDesc(Order::getCreateTime);

        Page<Order> page = new Page<>(pageNum, pageSize);
        Page<Order> orderPage = orderMapper.selectPage(page, wrapper);

        List<Map<String, Object>> resultList = new ArrayList<>();
        for (Order order : orderPage.getRecords()) {
            Map<String, Object> map = new HashMap<>();
            map.put("orderId", order.getId());
            map.put("orderSn", order.getOrderSn());
            map.put("totalAmount", order.getTotalAmount());
            map.put("payAmount", order.getPayAmount());
            map.put("deliveryType", order.getDeliveryType());
            map.put("deliveryTypeText", getDeliveryTypeText(order.getDeliveryType()));
            map.put("status", order.getStatus());
            map.put("statusText", getStatusText(order.getStatus(), order.getDeliveryType()));
            map.put("createTime", formatDateTime(order.getCreateTime()));

            // 查询商品数量
            LambdaQueryWrapper<OrderItem> itemWrapper = new LambdaQueryWrapper<>();
            itemWrapper.eq(OrderItem::getOrderId, order.getId());
            Long itemCount = orderItemMapper.selectCount(itemWrapper);
            map.put("itemCount", itemCount);

            // 查询订单商品
            List<OrderItem> items = orderItemMapper.selectList(itemWrapper);
            List<Map<String, Object>> itemList = new ArrayList<>();
            for (OrderItem item : items) {
                Map<String, Object> itemMap = new HashMap<>();
                itemMap.put("id", item.getId());
                itemMap.put("skuId", item.getSkuId());
                itemMap.put("productName", item.getProductName());
                itemMap.put("skuSpecs", item.getSkuSpecs());
                itemMap.put("price", item.getPrice());
                itemMap.put("quantity", item.getQuantity());
                // 查询商品图片
                try {
                    if (item.getSkuId() != null) {
                        Sku sku = skuMapper.selectById(item.getSkuId());
                        if (sku != null && sku.getProductId() != null) {
                            com.socialretail.backend.entity.product.Product product = productMapper.selectById(sku.getProductId());
                            itemMap.put("productImage", product != null ? product.getMainImage() : "");
                        } else {
                            itemMap.put("productImage", "");
                        }
                    } else {
                        itemMap.put("productImage", "");
                    }
                } catch (Exception e) {
                    itemMap.put("productImage", "");
                }
                itemList.add(itemMap);
            }
            map.put("orderItems", itemList);

            // 查询买家信息
            if (order.getUserId() != null) {
                User user = userMapper.selectById(order.getUserId());
                if (user != null) {
                    map.put("buyerNickname", user.getNickname());
                    map.put("buyerPhone", maskPhone(user.getPhone()));
                } else {
                    map.put("buyerNickname", "");
                    map.put("buyerPhone", "");
                }
            } else {
                map.put("buyerNickname", "");
                map.put("buyerPhone", "");
            }

            // 查询自提点名称
            if (order.getPickupPointId() != null) {
                PickupPoint pickupPoint = pickupPointMapper.selectById(order.getPickupPointId());
                map.put("pickupPointName", pickupPoint != null ? pickupPoint.getName() : "");
            } else {
                map.put("pickupPointName", "");
            }

            resultList.add(map);
        }

        return PageResult.of(resultList, orderPage.getTotal(), pageNum, pageSize);
    }

    public Map<String, Object> getOrderDetail(Long orderId, Long merchantId) {
        Order order = orderMapper.selectById(orderId);
        if (order == null) {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "订单不存在");
        }
        if (!order.getMerchantId().equals(merchantId)) {
            throw new BusinessException(403, HttpStatus.FORBIDDEN, "无权查看该订单");
        }

        Map<String, Object> result = new HashMap<>();
        result.put("orderId", order.getId());
        result.put("orderSn", order.getOrderSn());
        result.put("totalAmount", order.getTotalAmount());
        result.put("payAmount", order.getPayAmount());
        result.put("discountAmount", order.getDiscountAmount());
        result.put("deliveryType", order.getDeliveryType());
        result.put("deliveryTypeText", getDeliveryTypeText(order.getDeliveryType()));
        result.put("status", order.getStatus());
        result.put("statusText", getStatusText(order.getStatus(), order.getDeliveryType()));
        result.put("remark", order.getRemark());
        result.put("pickupCode", order.getPickupCode());
        result.put("createTime", formatDateTime(order.getCreateTime()));
        result.put("updateTime", formatDateTime(order.getUpdateTime()));
        result.put("acceptTime", formatDateTime(order.getAcceptTime()));
        result.put("prepareTime", formatDateTime(order.getPrepareTime()));
        result.put("completeTime", formatDateTime(order.getCompleteTime()));

        // 订单商品
        LambdaQueryWrapper<OrderItem> itemWrapper = new LambdaQueryWrapper<>();
        itemWrapper.eq(OrderItem::getOrderId, orderId);
        List<OrderItem> orderItems = orderItemMapper.selectList(itemWrapper);
        List<Map<String, Object>> itemList = new ArrayList<>();
        for (OrderItem item : orderItems) {
            Map<String, Object> itemMap = new HashMap<>();
            itemMap.put("id", item.getId());
            itemMap.put("skuId", item.getSkuId());
            itemMap.put("productName", item.getProductName());
            itemMap.put("skuSpecs", item.getSkuSpecs());
            itemMap.put("price", item.getPrice());
            itemMap.put("quantity", item.getQuantity());
            // 查询商品图片
            try {
                if (item.getSkuId() != null) {
                    Sku sku = skuMapper.selectById(item.getSkuId());
                    if (sku != null && sku.getProductId() != null) {
                        com.socialretail.backend.entity.product.Product product = productMapper.selectById(sku.getProductId());
                        itemMap.put("productImage", product != null ? product.getMainImage() : "");
                    } else {
                        itemMap.put("productImage", "");
                    }
                } else {
                    itemMap.put("productImage", "");
                }
            } catch (Exception e) {
                itemMap.put("productImage", "");
            }
            itemList.add(itemMap);
        }
        result.put("orderItems", itemList);

        // 支付信息
        LambdaQueryWrapper<Payment> payWrapper = new LambdaQueryWrapper<>();
        payWrapper.eq(Payment::getOrderId, orderId);
        Payment payment = paymentMapper.selectOne(payWrapper);
        if (payment != null) {
            Map<String, Object> payMap = new HashMap<>();
            payMap.put("paySn", payment.getPaySn());
            payMap.put("payPlatform", payment.getPayPlatform());
            payMap.put("amount", payment.getAmount());
            payMap.put("status", payment.getStatus());
            payMap.put("payTime", formatDateTime(payment.getPayTime()));
            payMap.put("refundStatus", payment.getRefundStatus());
            payMap.put("refundAmount", payment.getRefundAmount());
            payMap.put("refundTime", formatDateTime(payment.getRefundTime()));
            result.put("payment", payMap);
        }

        // 自提点信息
        if (order.getPickupPointId() != null) {
            PickupPoint pickupPoint = pickupPointMapper.selectById(order.getPickupPointId());
            if (pickupPoint != null) {
                Map<String, Object> ppMap = new HashMap<>();
                ppMap.put("id", pickupPoint.getId());
                ppMap.put("name", pickupPoint.getName());
                ppMap.put("address", pickupPoint.getAddress());
                ppMap.put("contactPhone", pickupPoint.getContactPhone());
                result.put("pickupPoint", ppMap);
            }
        }

        // 收货地址（配送单才有，从用户表模拟）
        if (order.getDeliveryType() != null && order.getDeliveryType() == 1 && order.getUserId() != null) {
            User user = userMapper.selectById(order.getUserId());
            if (user != null) {
                Map<String, Object> addrMap = new HashMap<>();
                addrMap.put("consignee", user.getNickname());
                addrMap.put("phone", user.getPhone());
                addrMap.put("address", "");
                result.put("address", addrMap);
            }
        }

        // 配送信息
        LambdaQueryWrapper<Delivery> deliveryWrapper = new LambdaQueryWrapper<>();
        deliveryWrapper.eq(Delivery::getOrderId, orderId);
        Delivery delivery = deliveryMapper.selectOne(deliveryWrapper);
        if (delivery != null) {
            Map<String, Object> deliveryMap = new HashMap<>();
            deliveryMap.put("id", delivery.getId());
            deliveryMap.put("deliverySn", delivery.getDeliverySn());
            deliveryMap.put("dispatcherName", delivery.getDispatcherName());
            deliveryMap.put("dispatcherPhone", delivery.getDispatcherPhone());
            deliveryMap.put("status", delivery.getStatus());
            deliveryMap.put("remark", delivery.getRemark());
            deliveryMap.put("startTime", formatDateTime(delivery.getStartTime()));
            deliveryMap.put("endTime", formatDateTime(delivery.getEndTime()));
            deliveryMap.put("simulateCompleteTime", formatDateTime(delivery.getSimulateCompleteTime()));
            result.put("delivery", deliveryMap);
        }

        // 状态日志（时间线）
        LambdaQueryWrapper<OrderStatusLog> logWrapper = new LambdaQueryWrapper<>();
        logWrapper.eq(OrderStatusLog::getOrderId, orderId);
        logWrapper.orderByAsc(OrderStatusLog::getCreateTime);
        List<OrderStatusLog> statusLogs = orderStatusLogMapper.selectList(logWrapper);
        List<Map<String, Object>> timelineList = new ArrayList<>();
        for (OrderStatusLog log : statusLogs) {
            Map<String, Object> logMap = new HashMap<>();
            logMap.put("id", log.getId());
            logMap.put("fromStatus", log.getFromStatus());
            logMap.put("toStatus", log.getToStatus());
            logMap.put("statusText", log.getStatusText());
            logMap.put("operatorType", log.getOperatorType());
            logMap.put("remark", log.getRemark());
            logMap.put("createTime", formatDateTime(log.getCreateTime()));
            timelineList.add(logMap);
        }
        result.put("timeline", timelineList);

        return result;
    }

    public Map<String, Object> acceptOrder(Long orderId, Long merchantId, String remark) {
        Order order = orderMapper.selectById(orderId);
        if (order == null) {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "订单不存在");
        }
        if (!order.getMerchantId().equals(merchantId)) {
            throw new BusinessException(403, HttpStatus.FORBIDDEN, "无权操作该订单");
        }
        if (order.getStatus() != 1) {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "当前订单状态不允许接单");
        }

        // 更新订单
        order.setStatus(2);
        order.setAcceptTime(LocalDateTime.now());
        if (remark != null && !remark.trim().isEmpty()) {
            order.setRemark(remark);
        }
        order.setUpdateTime(LocalDateTime.now());
        orderMapper.updateById(order);

        // 插入状态日志
        OrderStatusLog statusLog = new OrderStatusLog();
        statusLog.setOrderId(orderId);
        statusLog.setFromStatus(1);
        statusLog.setToStatus(2);
        statusLog.setStatusText("已接单");
        statusLog.setOperatorType("merchant");
        statusLog.setOperatorId(merchantId);
        statusLog.setRemark(remark);
        statusLog.setCreateTime(LocalDateTime.now());
        orderStatusLogMapper.insert(statusLog);

        Map<String, Object> result = new HashMap<>();
        result.put("orderId", orderId);
        result.put("newStatus", 2);
        result.put("newStatusText", "已接单");
        result.put("acceptTime", formatDateTime(LocalDateTime.now()));
        return result;
    }

    public Map<String, Object> prepareGoods(Long orderId, Long merchantId, String remark) {
        Order order = orderMapper.selectById(orderId);
        if (order == null) {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "订单不存在");
        }
        if (!order.getMerchantId().equals(merchantId)) {
            throw new BusinessException(403, HttpStatus.FORBIDDEN, "无权操作该订单");
        }
        if (order.getStatus() != 2) {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "当前订单状态不允许备货");
        }

        // 扣减库存
        LambdaQueryWrapper<OrderItem> itemWrapper = new LambdaQueryWrapper<>();
        itemWrapper.eq(OrderItem::getOrderId, orderId);
        List<OrderItem> orderItems = orderItemMapper.selectList(itemWrapper);
        for (OrderItem item : orderItems) {
            Sku sku = skuMapper.selectById(item.getSkuId());
            if (sku == null) {
                throw new BusinessException(400, HttpStatus.BAD_REQUEST, "商品SKU不存在: " + item.getSkuId());
            }
            if (sku.getStock() < item.getQuantity()) {
                throw new BusinessException(400, HttpStatus.BAD_REQUEST, "商品[" + item.getProductName() + "]库存不足");
            }
            sku.setStock(sku.getStock() - item.getQuantity());
            skuMapper.updateById(sku);
        }

        // 更新订单状态
        order.setStatus(3);
        order.setPrepareTime(LocalDateTime.now());
        order.setUpdateTime(LocalDateTime.now());
        orderMapper.updateById(order);

        Map<String, Object> result = new HashMap<>();
        result.put("orderId", orderId);
        result.put("newStatus", 3);

        String statusText;
        if (order.getDeliveryType() != null && order.getDeliveryType() == 2) {
            // 自提：生成提货码
            String pickupCode = generatePickupCode();
            order.setPickupCode(pickupCode);
            orderMapper.updateById(order);
            statusText = "待自提";
            result.put("pickupCode", pickupCode);
        } else {
            // 配送：创建配送记录
            statusText = "配送中";
            Delivery delivery = new Delivery();
            delivery.setOrderId(orderId);
            delivery.setDeliverySn(generateSn("DL"));
            delivery.setStatus(1);
            delivery.setStartTime(LocalDateTime.now());
            delivery.setSimulateCompleteTime(LocalDateTime.now().plusMinutes(30));
            deliveryMapper.insert(delivery);

            Map<String, Object> deliveryMap = new HashMap<>();
            deliveryMap.put("deliveryId", delivery.getId());
            deliveryMap.put("deliverySn", delivery.getDeliverySn());
            deliveryMap.put("status", 1);
            result.put("delivery", deliveryMap);
        }

        result.put("newStatusText", statusText);

        // 插入状态日志
        OrderStatusLog statusLog = new OrderStatusLog();
        statusLog.setOrderId(orderId);
        statusLog.setFromStatus(2);
        statusLog.setToStatus(3);
        statusLog.setStatusText(statusText);
        statusLog.setOperatorType("merchant");
        statusLog.setOperatorId(merchantId);
        statusLog.setRemark(remark);
        statusLog.setCreateTime(LocalDateTime.now());
        orderStatusLogMapper.insert(statusLog);

        return result;
    }

    public Map<String, Object> shipOrder(Long orderId, Long merchantId, String remark) {
        Order order = orderMapper.selectById(orderId);
        if (order == null) {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "订单不存在");
        }
        if (!order.getMerchantId().equals(merchantId)) {
            throw new BusinessException(403, HttpStatus.FORBIDDEN, "无权操作该订单");
        }
        if (order.getDeliveryType() == null || order.getDeliveryType() != 1) {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "非配送订单，无法发货");
        }
        if (order.getStatus() != 2) {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "当前订单状态不允许发货");
        }

        // 查找或创建配送记录
        LambdaQueryWrapper<Delivery> deliveryWrapper = new LambdaQueryWrapper<>();
        deliveryWrapper.eq(Delivery::getOrderId, orderId);
        Delivery delivery = deliveryMapper.selectOne(deliveryWrapper);
        if (delivery == null) {
            delivery = new Delivery();
            delivery.setOrderId(orderId);
            delivery.setDeliverySn(generateSn("DL"));
            delivery.setStatus(1);
            delivery.setStartTime(LocalDateTime.now());
            delivery.setSimulateCompleteTime(LocalDateTime.now().plusMinutes(30));
            deliveryMapper.insert(delivery);
        }

        // 更新配送记录
        Integer fromDeliveryStatus = delivery.getStatus();
        delivery.setStatus(2);
        delivery.setStartTime(LocalDateTime.now());
        delivery.setSimulateCompleteTime(LocalDateTime.now().plusMinutes(2));
        if (remark != null && !remark.trim().isEmpty()) {
            delivery.setRemark(remark);
        }
        deliveryMapper.updateById(delivery);

        // 更新订单状态
        order.setStatus(3);
        order.setUpdateTime(LocalDateTime.now());
        orderMapper.updateById(order);

        // 插入订单状态日志
        OrderStatusLog statusLog = new OrderStatusLog();
        statusLog.setOrderId(orderId);
        statusLog.setFromStatus(2);
        statusLog.setToStatus(3);
        statusLog.setStatusText("配送中");
        statusLog.setOperatorType("merchant");
        statusLog.setOperatorId(merchantId);
        statusLog.setRemark(remark);
        statusLog.setCreateTime(LocalDateTime.now());
        orderStatusLogMapper.insert(statusLog);

        // 插入配送状态日志
        DeliveryStatusLog deliveryLog = new DeliveryStatusLog();
        deliveryLog.setDeliveryId(delivery.getId());
        deliveryLog.setFromStatus(fromDeliveryStatus);
        deliveryLog.setToStatus(2);
        deliveryLog.setStatusText("已分配骑手");
        deliveryLog.setRemark(remark);
        deliveryLog.setCreateTime(LocalDateTime.now());
        deliveryStatusLogMapper.insert(deliveryLog);

        Map<String, Object> result = new HashMap<>();
        result.put("orderId", orderId);
        result.put("deliveryId", delivery.getId());
        result.put("deliverySn", delivery.getDeliverySn());
        result.put("deliveryStatus", 2);
        result.put("deliveryStatusText", "已分配骑手");
        result.put("newStatus", 3);
        result.put("newStatusText", "配送中");
        result.put("startTime", formatDateTime(LocalDateTime.now()));
        result.put("simulateCompleteTime", formatDateTime(LocalDateTime.now().plusMinutes(2)));
        return result;
    }

    public Map<String, Object> cancelOrder(Long orderId, Long merchantId, String reason) {
        Order order = orderMapper.selectById(orderId);
        if (order == null) {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "订单不存在");
        }
        if (!order.getMerchantId().equals(merchantId)) {
            throw new BusinessException(403, HttpStatus.FORBIDDEN, "无权操作该订单");
        }
        if (order.getStatus() != 1) {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "当前订单状态不允许取消");
        }

        // 更新订单状态
        order.setStatus(5);
        order.setUpdateTime(LocalDateTime.now());
        if (reason != null && !reason.trim().isEmpty()) {
            order.setRemark(reason);
        }
        orderMapper.updateById(order);

        // 插入状态日志
        OrderStatusLog statusLog = new OrderStatusLog();
        statusLog.setOrderId(orderId);
        statusLog.setFromStatus(1);
        statusLog.setToStatus(5);
        statusLog.setStatusText("已取消");
        statusLog.setOperatorType("merchant");
        statusLog.setOperatorId(merchantId);
        statusLog.setRemark(reason);
        statusLog.setCreateTime(LocalDateTime.now());
        orderStatusLogMapper.insert(statusLog);

        Map<String, Object> result = new HashMap<>();
        result.put("orderId", orderId);
        result.put("newStatus", 5);
        result.put("newStatusText", "已取消");
        return result;
    }

    // ==================== Helper Methods ====================

    private String getStatusText(Integer status, Integer deliveryType) {
        if (status == null) {
            return "";
        }
        switch (status) {
            case 1:
                return "待接单";
            case 2:
                return "已接单";
            case 3:
                if (deliveryType != null && deliveryType == 2) {
                    return "待自提";
                }
                return "配送中";
            case 4:
                return "已完成";
            case 5:
                return "已取消";
            case 6:
                return "售后中";
            default:
                return "";
        }
    }

    private String getDeliveryTypeText(Integer type) {
        if (type == null) {
            return "";
        }
        switch (type) {
            case 1:
                return "配送";
            case 2:
                return "自提";
            default:
                return "";
        }
    }

    private String maskPhone(String phone) {
        if (phone == null || phone.length() < 7) {
            return phone == null ? "" : phone;
        }
        return phone.substring(0, 3) + "****" + phone.substring(phone.length() - 4);
    }

    private String generatePickupCode() {
        int code = 100000 + RANDOM.nextInt(900000);
        return String.valueOf(code);
    }

    private String generateSn(String prefix) {
        String datePart = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        int randomPart = 1000 + RANDOM.nextInt(9000);
        return prefix + datePart + randomPart;
    }

    private String formatDateTime(LocalDateTime dt) {
        if (dt == null) {
            return null;
        }
        return dt.format(FORMATTER);
    }
}
