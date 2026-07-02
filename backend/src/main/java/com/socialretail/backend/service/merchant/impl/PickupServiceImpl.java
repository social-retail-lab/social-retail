package com.socialretail.backend.service.merchant.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.socialretail.backend.common.OrderStatus;
import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.entity.order.MerchantEarnings;
import com.socialretail.backend.entity.order.Order;
import com.socialretail.backend.entity.order.OrderItem;
import com.socialretail.backend.entity.order.OrderStatusLog;
import com.socialretail.backend.entity.order.PickupPoint;
import com.socialretail.backend.entity.user.User;
import com.socialretail.backend.mapper.order.MerchantEarningsMapper;
import com.socialretail.backend.mapper.order.OrderItemMapper;
import com.socialretail.backend.mapper.order.OrderMapper;
import com.socialretail.backend.mapper.order.OrderStatusLogMapper;
import com.socialretail.backend.mapper.order.PickupPointMapper;
import com.socialretail.backend.mapper.user.UserMapper;
import com.socialretail.backend.service.merchant.PickupService;

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
import java.util.Random;

@Slf4j
@Service
public class PickupServiceImpl implements PickupService {

    @Resource
    private OrderMapper orderMapper;

    @Resource
    private OrderItemMapper orderItemMapper;

    @Resource
    private PickupPointMapper pickupPointMapper;

    @Resource
    private OrderStatusLogMapper orderStatusLogMapper;

    @Resource
    private MerchantEarningsMapper merchantEarningsMapper;

    @Resource
    private UserMapper userMapper;

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    private static final Random RANDOM = new Random();

    /**
     * 自提取货码核销
     */
    public Map<String, Object> verifyPickup(Long merchantId, String pickupCode) {
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Order::getPickupCode, pickupCode);
        Order order = orderMapper.selectOne(wrapper);

        if (order == null) {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "取货码不存在或已使用");
        }
        if (!order.getMerchantId().equals(merchantId)) {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "该订单不属于本店");
        }
        if (order.getDeliveryType() == null || order.getDeliveryType() != 2) {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "该订单非自提订单");
        }
        if (order.getStatus() == null || order.getStatus() != OrderStatus.IN_PROGRESS) {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "订单状态不允许核销");
        }

        LocalDateTime now = LocalDateTime.now();

        order.setStatus(OrderStatus.COMPLETED);
        order.setCompleteTime(now);
        orderMapper.updateById(order);

        OrderStatusLog statusLog = new OrderStatusLog();
        statusLog.setOrderId(order.getId());
        statusLog.setFromStatus(OrderStatus.IN_PROGRESS);
        statusLog.setToStatus(OrderStatus.COMPLETED);
        statusLog.setStatusText("已完成");
        statusLog.setOperatorType("merchant");
        statusLog.setOperatorId(merchantId);
        statusLog.setCreateTime(now);
        orderStatusLogMapper.insert(statusLog);

        MerchantEarnings earnings = new MerchantEarnings();
        earnings.setMerchantId(merchantId);
        earnings.setOrderId(order.getId());
        earnings.setOrderSn(order.getOrderSn());
        earnings.setAmount(order.getPayAmount());
        earnings.setStatus(0);
        earnings.setFreezeTime(now);
        earnings.setUnfreezeTime(now.plusHours(2));
        earnings.setCreateTime(now);
        merchantEarningsMapper.insert(earnings);

        Map<String, Object> result = new HashMap<>();
        result.put("orderId", order.getId());
        result.put("orderSn", order.getOrderSn());
        result.put("newStatus", OrderStatus.COMPLETED);
        result.put("newStatusText", "已完成");
        result.put("completeTime", formatDateTime(now));
        return result;
    }

    /**
     * 获取自提核销记录
     */
    public PageResult<Map<String, Object>> getPickupRecords(Long merchantId, String startDate, String endDate,
                                                             int pageNum, int pageSize) {
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Order::getMerchantId, merchantId);
        wrapper.eq(Order::getDeliveryType, 2);
        wrapper.eq(Order::getStatus, OrderStatus.COMPLETED);

        if (startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty()) {
            LocalDateTime start = LocalDateTime.parse(startDate + " 00:00:00", FORMATTER);
            LocalDateTime end = LocalDateTime.parse(endDate + " 23:59:59", FORMATTER);
            wrapper.between(Order::getCompleteTime, start, end);
        }

        wrapper.orderByDesc(Order::getCompleteTime);

        Page<Order> page = new Page<>(pageNum, pageSize);
        Page<Order> orderPage = orderMapper.selectPage(page, wrapper);

        List<Map<String, Object>> resultList = new ArrayList<>();
        for (Order order : orderPage.getRecords()) {
            Map<String, Object> map = new HashMap<>();
            map.put("orderId", order.getId());
            map.put("orderSn", order.getOrderSn());
            map.put("pickupCode", order.getPickupCode());
            map.put("totalAmount", order.getTotalAmount());
            map.put("verifyTime", formatDateTime(order.getCompleteTime()));

            if (order.getPickupPointId() != null) {
                PickupPoint pickupPoint = pickupPointMapper.selectById(order.getPickupPointId());
                map.put("pickupPointName", pickupPoint != null ? pickupPoint.getName() : "");
            } else {
                map.put("pickupPointName", "");
            }

            if (order.getUserId() != null) {
                User user = userMapper.selectById(order.getUserId());
                map.put("buyerNickname", user != null ? user.getNickname() : "");
            } else {
                map.put("buyerNickname", "");
            }

            resultList.add(map);
        }

        return PageResult.of(resultList, orderPage.getTotal(), pageNum, pageSize);
    }

    private String formatDateTime(LocalDateTime dt) {
        if (dt == null) {
            return null;
        }
        return dt.format(FORMATTER);
    }
}
