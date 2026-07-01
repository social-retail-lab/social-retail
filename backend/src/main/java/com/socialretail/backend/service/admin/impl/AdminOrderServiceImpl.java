package com.socialretail.backend.service.admin.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.entity.member.Merchant;
import com.socialretail.backend.entity.order.Order;
import com.socialretail.backend.entity.order.OrderItem;
import com.socialretail.backend.entity.order.OrderStatusLog;
import com.socialretail.backend.entity.order.Payment;
import com.socialretail.backend.entity.user.User;
import com.socialretail.backend.mapper.member.MerchantMapper;
import com.socialretail.backend.mapper.order.OrderItemMapper;
import com.socialretail.backend.mapper.order.OrderMapper;
import com.socialretail.backend.mapper.order.OrderStatusLogMapper;
import com.socialretail.backend.mapper.order.PaymentMapper;
import com.socialretail.backend.mapper.user.UserMapper;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
public class AdminOrderServiceImpl {

    @Resource
    private OrderMapper orderMapper;

    @Resource
    private OrderItemMapper orderItemMapper;

    @Resource
    private PaymentMapper paymentMapper;

    @Resource
    private OrderStatusLogMapper orderStatusLogMapper;

    @Resource
    private MerchantMapper merchantMapper;

    @Resource
    private UserMapper userMapper;

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    public PageResult<Map<String, Object>> getOrderList(String keyword, Integer status,
                                                         int pageNum, int pageSize) {
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            wrapper.and(w -> w
                    .like(Order::getOrderSn, keyword)
                    .or()
                    .like(Order::getRemark, keyword));
        }
        if (status != null) {
            wrapper.eq(Order::getStatus, status);
        }

        wrapper.orderByDesc(Order::getCreateTime);

        Page<Order> page = new Page<>(pageNum, pageSize);
        Page<Order> orderPage = orderMapper.selectPage(page, wrapper);

        List<Map<String, Object>> resultList = new ArrayList<>();
        for (Order order : orderPage.getRecords()) {
            Map<String, Object> map = new HashMap<>();
            map.put("orderId", order.getId());
            map.put("orderSn", order.getOrderSn());
            map.put("payAmount", order.getPayAmount() != null ? order.getPayAmount() : BigDecimal.ZERO);
            map.put("totalAmount", order.getTotalAmount() != null ? order.getTotalAmount() : BigDecimal.ZERO);
            map.put("deliveryType", order.getDeliveryType() != null && order.getDeliveryType() == 1 ? "DELIVERY" : "PICKUP");
            map.put("status", getStatusCode(order.getStatus()));
            map.put("statusText", getStatusText(order.getStatus(), order.getDeliveryType()));
            map.put("createTime", formatDateTime(order.getCreateTime()));

            // 商品数量
            LambdaQueryWrapper<OrderItem> itemWrapper = new LambdaQueryWrapper<>();
            itemWrapper.eq(OrderItem::getOrderId, order.getId());
            Long itemCount = orderItemMapper.selectCount(itemWrapper);
            map.put("totalQuantity", itemCount);

            // 用户信息
            if (order.getUserId() != null) {
                User user = userMapper.selectById(order.getUserId());
                map.put("userName", user != null ? user.getNickname() : "");
                map.put("userPhone", user != null ? maskPhone(user.getPhone()) : "");
            } else {
                map.put("userName", "");
                map.put("userPhone", "");
            }

            // 商家名称
            if (order.getMerchantId() != null) {
                Merchant merchant = merchantMapper.selectById(order.getMerchantId());
                map.put("merchantName", merchant != null ? merchant.getMerchantName() : "");
            } else {
                map.put("merchantName", "");
            }

            resultList.add(map);
        }

        return PageResult.of(resultList, orderPage.getTotal(), pageNum, pageSize);
    }

    public Map<String, Object> getOrderDetail(Long orderId) {
        Order order = orderMapper.selectById(orderId);
        if (order == null) {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "订单不存在");
        }

        Map<String, Object> result = new HashMap<>();
        result.put("orderId", order.getId());
        result.put("orderSn", order.getOrderSn());
        result.put("totalAmount", order.getTotalAmount());
        result.put("payAmount", order.getPayAmount());
        result.put("discountAmount", order.getDiscountAmount());
        result.put("deliveryType", order.getDeliveryType() != null && order.getDeliveryType() == 1 ? "DELIVERY" : "PICKUP");
        result.put("status", getStatusCode(order.getStatus()));
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
            itemList.add(itemMap);
        }
        result.put("orderItems", itemList);

        // 用户信息
        if (order.getUserId() != null) {
            User user = userMapper.selectById(order.getUserId());
            result.put("userName", user != null ? user.getNickname() : "");
            result.put("userPhone", user != null ? maskPhone(user.getPhone()) : "");
        }

        // 商家名称
        if (order.getMerchantId() != null) {
            Merchant merchant = merchantMapper.selectById(order.getMerchantId());
            result.put("merchantName", merchant != null ? merchant.getMerchantName() : "");
        }

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

        // 状态日志
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

    public Map<String, Object> handleRefund(Long orderId, BigDecimal refundAmount, String reason) {
        Order order = orderMapper.selectById(orderId);
        if (order == null) {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "订单不存在");
        }

        // 查找支付记录
        LambdaQueryWrapper<Payment> payWrapper = new LambdaQueryWrapper<>();
        payWrapper.eq(Payment::getOrderId, orderId);
        Payment payment = paymentMapper.selectOne(payWrapper);
        if (payment == null) {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "未找到支付记录");
        }

        // 更新退款信息
        payment.setRefundStatus(1);
        payment.setRefundAmount(refundAmount);
        payment.setRefundTime(LocalDateTime.now());
        paymentMapper.updateById(payment);

        // 更新订单状态
        order.setStatus(4);
        order.setUpdateTime(LocalDateTime.now());
        orderMapper.updateById(order);

        // 插入状态日志
        OrderStatusLog statusLog = new OrderStatusLog();
        statusLog.setOrderId(orderId);
        statusLog.setFromStatus(6);
        statusLog.setToStatus(4);
        statusLog.setStatusText("已退款（管理员处理）");
        statusLog.setOperatorType("admin");
        statusLog.setRemark(reason);
        statusLog.setCreateTime(LocalDateTime.now());
        orderStatusLogMapper.insert(statusLog);

        Map<String, Object> result = new HashMap<>();
        result.put("orderId", orderId);
        result.put("refundAmount", refundAmount);
        result.put("message", "退款已处理");
        return result;
    }

    public Map<String, Object> closeOrder(Long orderId, String reason) {
        Order order = orderMapper.selectById(orderId);
        if (order == null) {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "订单不存在");
        }

        int oldStatus = order.getStatus();
        order.setStatus(5);
        order.setUpdateTime(LocalDateTime.now());
        if (reason != null && !reason.trim().isEmpty()) {
            order.setRemark(reason);
        }
        orderMapper.updateById(order);

        // 插入状态日志
        OrderStatusLog statusLog = new OrderStatusLog();
        statusLog.setOrderId(orderId);
        statusLog.setFromStatus(oldStatus);
        statusLog.setToStatus(5);
        statusLog.setStatusText("已关闭（管理员操作）");
        statusLog.setOperatorType("admin");
        statusLog.setRemark(reason);
        statusLog.setCreateTime(LocalDateTime.now());
        orderStatusLogMapper.insert(statusLog);

        Map<String, Object> result = new HashMap<>();
        result.put("orderId", orderId);
        result.put("newStatus", 5);
        result.put("message", "订单已关闭");
        return result;
    }

    // ==================== Helper Methods ====================

    private String getStatusCode(Integer status) {
        if (status == null) return "";
        switch (status) {
            case 1: return "WAIT_PAY";
            case 2: return "WAIT_SHIP";
            case 3: return "SHIPPING";
            case 4: return "COMPLETED";
            case 5: return "CANCELLED";
            case 6: return "REFUNDING";
            default: return "";
        }
    }

    private String getStatusText(Integer status, Integer deliveryType) {
        if (status == null) return "";
        switch (status) {
            case 1: return "待接单";
            case 2: return "已接单";
            case 3:
                if (deliveryType != null && deliveryType == 2) return "待自提";
                return "配送中";
            case 4: return "已完成";
            case 5: return "已取消";
            case 6: return "售后中";
            default: return "";
        }
    }

    private String maskPhone(String phone) {
        if (phone == null || phone.length() < 7) return phone == null ? "" : phone;
        return phone.substring(0, 3) + "****" + phone.substring(phone.length() - 4);
    }

    private String formatDateTime(LocalDateTime dt) {
        if (dt == null) return null;
        return dt.format(FORMATTER);
    }
}
