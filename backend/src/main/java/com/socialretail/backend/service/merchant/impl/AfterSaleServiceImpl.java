package com.socialretail.backend.service.merchant.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.entity.order.*;
import com.socialretail.backend.entity.system.Notification;
import com.socialretail.backend.entity.user.User;
import com.socialretail.backend.mapper.order.*;
import com.socialretail.backend.mapper.system.NotificationMapper;
import com.socialretail.backend.mapper.user.UserMapper;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
public class AfterSaleServiceImpl {

    @Resource
    private AfterSaleMapper afterSaleMapper;

    @Resource
    private OrderMapper orderMapper;

    @Resource
    private OrderItemMapper orderItemMapper;

    @Resource
    private PaymentMapper paymentMapper;

    @Resource
    private OrderStatusLogMapper orderStatusLogMapper;

    @Resource
    private UserMapper userMapper;

    @Resource
    private MerchantEarningsMapper merchantEarningsMapper;

    @Resource
    private NotificationMapper notificationMapper;

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();

    // ==================== 1. 售后列表 ====================

    public PageResult<Map<String, Object>> getAfterSaleList(Long merchantId, Integer type, Integer status,
                                                             String orderSn, int pageNum, int pageSize) {
        LambdaQueryWrapper<Order> orderWrapper = new LambdaQueryWrapper<>();
        orderWrapper.eq(Order::getMerchantId, merchantId);
        List<Order> orderList = orderMapper.selectList(orderWrapper);

        if (orderList.isEmpty()) {
            return PageResult.of(Collections.emptyList(), 0, pageNum, pageSize);
        }

        List<Long> orderIds = orderList.stream().map(Order::getId).collect(Collectors.toList());

        LambdaQueryWrapper<AfterSale> wrapper = new LambdaQueryWrapper<>();
        wrapper.in(AfterSale::getOrderId, orderIds);

        if (type != null) {
            wrapper.eq(AfterSale::getType, type);
        }
        if (status != null) {
            wrapper.eq(AfterSale::getStatus, status);
        }
        if (orderSn != null && !orderSn.trim().isEmpty()) {
            wrapper.like(AfterSale::getOrderSn, orderSn.trim());
        }

        wrapper.orderByDesc(AfterSale::getApplyTime);

        Page<AfterSale> page = new Page<>(pageNum, pageSize);
        Page<AfterSale> afterSalePage = afterSaleMapper.selectPage(page, wrapper);

        List<Map<String, Object>> resultList = new ArrayList<>();
        for (AfterSale as : afterSalePage.getRecords()) {
            Map<String, Object> map = new HashMap<>();
            map.put("afterSaleId", as.getId());
            map.put("orderSn", as.getOrderSn());
            map.put("orderItemId", as.getOrderItemId());
            map.put("productName", as.getProductName());
            map.put("type", as.getType());
            map.put("typeText", getAfterSaleTypeText(as.getType()));
            map.put("refundAmount", as.getRefundAmount());
            map.put("reason", as.getReason());
            map.put("appealReason", as.getReason() != null ? as.getReason() : "无");
            map.put("merchantAuditRemark", as.getRejectReason() != null ? as.getRejectReason() : "无");
            map.put("status", as.getStatus());
            map.put("statusText", getAfterSaleStatusText(as.getStatus()));
            map.put("applyTime", formatDateTime(as.getApplyTime()));
            map.put("appealTime", formatDateTime(as.getApplyTime()));
            map.put("evidenceImages", as.getEvidenceImages());

            Order order = orderMapper.selectById(as.getOrderId());
            if (order != null && order.getUserId() != null) {
                User user = userMapper.selectById(order.getUserId());
                map.put("buyerNickname", user != null ? user.getNickname() : "");
            } else {
                map.put("buyerNickname", "");
            }

            resultList.add(map);
        }

        return PageResult.of(resultList, afterSalePage.getTotal(), pageNum, pageSize);
    }

    // ==================== 2. 售后详情 ====================

    public Map<String, Object> getAfterSaleDetail(Long merchantId, Long afterSaleId) {
        AfterSale afterSale = afterSaleMapper.selectById(afterSaleId);
        if (afterSale == null) {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "售后记录不存在");
        }

        Order order = orderMapper.selectById(afterSale.getOrderId());
        if (order == null) {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "关联订单不存在");
        }
        if (!order.getMerchantId().equals(merchantId)) {
            throw new BusinessException(403, HttpStatus.FORBIDDEN, "无权查看该售后记录");
        }

        Map<String, Object> result = new HashMap<>();
        result.put("afterSaleId", afterSale.getId());
        result.put("orderSn", afterSale.getOrderSn());
        result.put("orderItemId", afterSale.getOrderItemId());
        result.put("productName", afterSale.getProductName());
        result.put("type", afterSale.getType());
        result.put("typeText", getAfterSaleTypeText(afterSale.getType()));
        result.put("refundAmount", afterSale.getRefundAmount());
        result.put("actualRefundAmount", afterSale.getActualRefundAmount());
        result.put("reason", afterSale.getReason());
        result.put("status", afterSale.getStatus());
        result.put("statusText", getAfterSaleStatusText(afterSale.getStatus()));
        result.put("applyTime", formatDateTime(afterSale.getApplyTime()));
        result.put("auditTime", formatDateTime(afterSale.getAuditTime()));
        result.put("auditRemark", afterSale.getAuditRemark());
        result.put("completeTime", formatDateTime(afterSale.getCompleteTime()));

        // skuSpecs from orderItem
        if (afterSale.getOrderItemId() != null) {
            OrderItem orderItem = orderItemMapper.selectById(afterSale.getOrderItemId());
            result.put("skuSpecs", orderItem != null ? orderItem.getSkuSpecs() : "");
        } else {
            result.put("skuSpecs", "");
        }

        // evidenceImages parse
        result.put("evidenceImages", parseEvidenceImages(afterSale.getEvidenceImages()));

        // buyer info
        if (order.getUserId() != null) {
            User user = userMapper.selectById(order.getUserId());
            if (user != null) {
                result.put("buyerNickname", user.getNickname());
                result.put("buyerPhone", user.getPhone());
            } else {
                result.put("buyerNickname", "");
                result.put("buyerPhone", "");
            }
        } else {
            result.put("buyerNickname", "");
            result.put("buyerPhone", "");
        }

        // statusTimeline
        result.put("statusTimeline", buildStatusTimeline(afterSale));

        return result;
    }

    // ==================== 3. 售后审核 ====================

    public Map<String, Object> auditAfterSale(Long merchantId, Long afterSaleId, Integer action,
                                               String remark, BigDecimal actualRefundAmount) {
        AfterSale afterSale = afterSaleMapper.selectById(afterSaleId);
        if (afterSale == null) {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "售后记录不存在");
        }

        Order order = orderMapper.selectById(afterSale.getOrderId());
        if (order == null || !order.getMerchantId().equals(merchantId)) {
            throw new BusinessException(403, HttpStatus.FORBIDDEN, "无权操作该售后记录");
        }

        if (afterSale.getStatus() == null || afterSale.getStatus() != 1) {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "当前售后状态不允许审核操作");
        }

        Map<String, Object> result = new HashMap<>();
        result.put("afterSaleId", afterSaleId);

        if (action == 1) {
            afterSale.setStatus(2);
            afterSale.setAuditRemark(remark);
            afterSale.setAuditTime(LocalDateTime.now());

            if (afterSale.getType() != null && afterSale.getType() == 1) {
                afterSale.setStatus(4);
                afterSale.setCompleteTime(LocalDateTime.now());
                processRefund(order, afterSale, actualRefundAmount);

                result.put("newStatus", 4);
                result.put("newStatusText", getAfterSaleStatusText(4));
                result.put("message", "仅退款审核通过，已完成退款");
            } else {
                result.put("newStatus", 2);
                result.put("newStatusText", getAfterSaleStatusText(2));
                result.put("message", "审核通过，等待用户退货");
            }
        } else if (action == 2) {
            afterSale.setStatus(5);
            afterSale.setAuditRemark(remark);
            afterSale.setAuditTime(LocalDateTime.now());

            result.put("newStatus", 5);
            result.put("newStatusText", getAfterSaleStatusText(5));
            result.put("message", "已拒绝售后申请");
        } else {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "无效的操作类型");
        }

        if (actualRefundAmount != null) {
            afterSale.setActualRefundAmount(actualRefundAmount);
        }

        afterSaleMapper.updateById(afterSale);

        // 通知运营平台
        Notification n = new Notification();
        n.setUserId(0L);
        n.setType("AFTERSALE_RESULT");
        n.setTitle("售后处理通知");
        n.setContent("商家「" + merchantId + "」已处理售后 #" + afterSaleId + "：" + (action == 1 ? "通过" : "拒绝"));
        n.setIsRead(0);
        n.setRelatedId(afterSaleId);
        n.setCreateTime(LocalDateTime.now());
        notificationMapper.insert(n);

        result.put("auditTime", formatDateTime(afterSale.getAuditTime()));
        return result;
    }

    // ==================== 4. 退货确认 ====================

    public Map<String, Object> returnConfirm(Long merchantId, Long afterSaleId, Integer receivedStatus, String remark) {
        AfterSale afterSale = afterSaleMapper.selectById(afterSaleId);
        if (afterSale == null) {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "售后记录不存在");
        }

        Order order = orderMapper.selectById(afterSale.getOrderId());
        if (order == null || !order.getMerchantId().equals(merchantId)) {
            throw new BusinessException(403, HttpStatus.FORBIDDEN, "无权操作该售后记录");
        }

        if (afterSale.getStatus() == null || afterSale.getStatus() != 3) {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "当前售后状态不允许退货确认操作");
        }

        afterSale.setReturnReceivedTime(LocalDateTime.now());

        Map<String, Object> result = new HashMap<>();
        result.put("afterSaleId", afterSaleId);

        if (receivedStatus == 1) {
            afterSale.setStatus(4);
            afterSale.setCompleteTime(LocalDateTime.now());
            afterSale.setAuditRemark(remark);

            processRefund(order, afterSale, afterSale.getActualRefundAmount());
            insertEarnings(order, afterSale);

            result.put("newStatus", 4);
            result.put("newStatusText", getAfterSaleStatusText(4));
            result.put("message", "已确认收货，售后完成");
        } else if (receivedStatus == 2) {
            afterSale.setStatus(5);
            afterSale.setReturnReceivedStatus(2);
            afterSale.setAuditRemark(remark);

            result.put("newStatus", 5);
            result.put("newStatusText", getAfterSaleStatusText(5));
            result.put("message", "已拒绝收货");
        } else {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "无效的收货状态");
        }

        afterSaleMapper.updateById(afterSale);

        result.put("returnReceivedTime", formatDateTime(afterSale.getReturnReceivedTime()));
        return result;
    }

    // ==================== 5. 添加工单反馈 ====================

    public Map<String, Object> addFeedback(Long merchantId, Long afterSaleId, String content, String images) {
        AfterSale afterSale = afterSaleMapper.selectById(afterSaleId);
        if (afterSale == null) {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "售后记录不存在");
        }

        Order order = orderMapper.selectById(afterSale.getOrderId());
        if (order == null || !order.getMerchantId().equals(merchantId)) {
            throw new BusinessException(403, HttpStatus.FORBIDDEN, "无权操作该售后记录");
        }

        afterSale.setFeedbackContent(content);
        afterSale.setFeedbackImages(images);
        afterSaleMapper.updateById(afterSale);

        Map<String, Object> result = new HashMap<>();
        result.put("afterSaleId", afterSaleId);
        result.put("message", "反馈已提交");
        return result;
    }

    // ==================== 6. 申诉列表（平台介入） ====================

    public PageResult<Map<String, Object>> getAppealedList(String keyword, int pageNum, int pageSize) {
        LambdaQueryWrapper<AfterSale> wrapper = new LambdaQueryWrapper<>();
        // 已申诉/待平台介入：商家已拒绝(status=5)，用户可申诉至平台
        wrapper.eq(AfterSale::getStatus, 5);

        if (keyword != null && !keyword.trim().isEmpty()) {
            wrapper.and(w -> w.like(AfterSale::getOrderSn, keyword.trim())
                    .or().like(AfterSale::getProductName, keyword.trim()));
        }

        wrapper.orderByDesc(AfterSale::getApplyTime);

        Page<AfterSale> page = new Page<>(pageNum, pageSize);
        Page<AfterSale> afterSalePage = afterSaleMapper.selectPage(page, wrapper);

        List<Map<String, Object>> resultList = new ArrayList<>();
        for (AfterSale as : afterSalePage.getRecords()) {
            Map<String, Object> map = new HashMap<>();
            map.put("afterSaleId", as.getId());
            map.put("orderSn", as.getOrderSn());
            map.put("productName", as.getProductName());
            map.put("type", as.getType());
            map.put("typeText", getAfterSaleTypeText(as.getType()));
            map.put("refundAmount", as.getRefundAmount());
            map.put("reason", as.getReason());
            map.put("appealReason", as.getReason() != null ? as.getReason() : "无");
            map.put("merchantAuditRemark", as.getRejectReason() != null ? as.getRejectReason() : "无");
            map.put("status", as.getStatus());
            map.put("statusText", getAfterSaleStatusText(as.getStatus()));
            map.put("applyTime", formatDateTime(as.getApplyTime()));
            map.put("appealTime", formatDateTime(as.getApplyTime()));
            map.put("evidenceImages", as.getEvidenceImages());

            Order order = orderMapper.selectById(as.getOrderId());
            if (order != null && order.getUserId() != null) {
                User user = userMapper.selectById(order.getUserId());
                map.put("buyerNickname", user != null ? user.getNickname() : "");
            } else {
                map.put("buyerNickname", "");
            }

            resultList.add(map);
        }

        return PageResult.of(resultList, afterSalePage.getTotal(), pageNum, pageSize);
    }

    // ==================== 7. 管理员介入处理 ====================

    public Map<String, Object> adminIntervene(Long afterSaleId, Integer action, String remark) {
        AfterSale afterSale = afterSaleMapper.selectById(afterSaleId);
        if (afterSale == null) {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "售后记录不存在");
        }

        Map<String, Object> result = new HashMap<>();
        result.put("afterSaleId", afterSaleId);

        if (action == 1) {
            // 同意退款/退货
            afterSale.setStatus(4);
            afterSale.setAuditRemark(remark);
            afterSale.setAuditTime(LocalDateTime.now());
            afterSale.setCompleteTime(LocalDateTime.now());

            Order order = orderMapper.selectById(afterSale.getOrderId());
            if (order != null) {
                processRefund(order, afterSale, afterSale.getRefundAmount());
            }

            result.put("newStatus", 4);
            result.put("newStatusText", getAfterSaleStatusText(4));
            result.put("message", "平台介入：已同意退款");
        } else if (action == 2) {
            // 拒绝
            afterSale.setStatus(5);
            afterSale.setAuditRemark(remark);
            afterSale.setAuditTime(LocalDateTime.now());

            result.put("newStatus", 5);
            result.put("newStatusText", getAfterSaleStatusText(5));
            result.put("message", "平台介入：已拒绝售后");
        } else {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "无效的操作类型");
        }

        afterSaleMapper.updateById(afterSale);
        result.put("auditTime", formatDateTime(afterSale.getAuditTime()));
        return result;
    }

    // ==================== Helper Methods ====================

    private String getAfterSaleStatusText(int status) {
        switch (status) {
            case 1:
                return "待商家处理";
            case 2:
                return "已同意/待用户退货";
            case 3:
                return "用户已退货/待商家收货";
            case 4:
                return "已完成";
            case 5:
                return "商家拒绝";
            case 6:
                return "用户取消";
            default:
                return "";
        }
    }

    private String getAfterSaleTypeText(Integer type) {
        if (type == null) {
            return "";
        }
        switch (type) {
            case 1:
                return "仅退款";
            case 2:
                return "退货退款";
            default:
                return "";
        }
    }

    private String formatDateTime(LocalDateTime dt) {
        if (dt == null) {
            return null;
        }
        return dt.format(FORMATTER);
    }

    private void processRefund(Order order, AfterSale afterSale, BigDecimal refundAmount) {
        LambdaQueryWrapper<Payment> payWrapper = new LambdaQueryWrapper<>();
        payWrapper.eq(Payment::getOrderId, order.getId());
        Payment payment = paymentMapper.selectOne(payWrapper);

        if (payment != null) {
            payment.setRefundStatus(1);
            payment.setRefundAmount(refundAmount != null ? refundAmount : afterSale.getRefundAmount());
            payment.setRefundTime(LocalDateTime.now());
            paymentMapper.updateById(payment);
        }

        order.setStatus(6);
        orderMapper.updateById(order);
    }

    private void insertEarnings(Order order, AfterSale afterSale) {
        BigDecimal refundAmount = afterSale.getActualRefundAmount() != null
                ? afterSale.getActualRefundAmount() : afterSale.getRefundAmount();
        if (refundAmount == null) {
            return;
        }

        MerchantEarnings earnings = new MerchantEarnings();
        earnings.setMerchantId(order.getMerchantId());
        earnings.setOrderId(order.getId());
        earnings.setOrderSn(order.getOrderSn());
        earnings.setAmount(refundAmount.negate());
        earnings.setStatus(1);
        earnings.setCreateTime(LocalDateTime.now());
        merchantEarningsMapper.insert(earnings);
    }

    private Object parseEvidenceImages(String evidenceImages) {
        if (evidenceImages == null || evidenceImages.trim().isEmpty()) {
            return Collections.emptyList();
        }
        try {
            return OBJECT_MAPPER.readValue(evidenceImages, new TypeReference<List<String>>() {});
        } catch (Exception e) {
            return evidenceImages;
        }
    }

    private List<Map<String, Object>> buildStatusTimeline(AfterSale afterSale) {
        List<Map<String, Object>> timeline = new ArrayList<>();

        if (afterSale.getApplyTime() != null) {
            Map<String, Object> event = new HashMap<>();
            event.put("time", formatDateTime(afterSale.getApplyTime()));
            event.put("title", "买家申请售后");
            event.put("description", "退款类型：" + getAfterSaleTypeText(afterSale.getType())
                    + "，退款金额：¥" + (afterSale.getRefundAmount() != null ? afterSale.getRefundAmount() : "0")
                    + "，原因：" + (afterSale.getReason() != null ? afterSale.getReason() : ""));
            timeline.add(event);
        }

        if (afterSale.getAuditTime() != null) {
            Map<String, Object> event = new HashMap<>();
            event.put("time", formatDateTime(afterSale.getAuditTime()));
            if (afterSale.getStatus() != null && afterSale.getStatus() == 5
                    && afterSale.getReturnReceivedStatus() == null) {
                event.put("title", "商家拒绝售后");
                event.put("description", afterSale.getAuditRemark() != null ? afterSale.getAuditRemark() : "商家拒绝了售后申请");
            } else if (afterSale.getStatus() != null && afterSale.getStatus() == 5
                    && afterSale.getReturnReceivedStatus() != null && afterSale.getReturnReceivedStatus() == 2) {
                event.put("title", "商家拒收退货");
                event.put("description", afterSale.getAuditRemark() != null ? afterSale.getAuditRemark() : "商家拒收了退货");
            } else {
                event.put("title", "商家同意售后");
                event.put("description", afterSale.getAuditRemark() != null ? afterSale.getAuditRemark() : "商家已同意售后申请");
            }
            timeline.add(event);
        }

        if (afterSale.getReturnReceivedTime() != null && afterSale.getReturnReceivedStatus() != null
                && afterSale.getReturnReceivedStatus() == 1) {
            Map<String, Object> event = new HashMap<>();
            event.put("time", formatDateTime(afterSale.getReturnReceivedTime()));
            event.put("title", "商家已收货");
            event.put("description", "商家已收到退货商品");
            timeline.add(event);
        }

        if (afterSale.getCompleteTime() != null) {
            Map<String, Object> event = new HashMap<>();
            event.put("time", formatDateTime(afterSale.getCompleteTime()));
            event.put("title", "售后已完成");
            event.put("description", "售后流程已结束");
            timeline.add(event);
        }

        if (afterSale.getFeedbackContent() != null && !afterSale.getFeedbackContent().trim().isEmpty()) {
            Map<String, Object> event = new HashMap<>();
            event.put("time", formatDateTime(afterSale.getCompleteTime()));
            event.put("title", "商家反馈");
            event.put("description", afterSale.getFeedbackContent());
            timeline.add(event);
        }

        return timeline;
    }
}
