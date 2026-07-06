package com.socialretail.backend.controller.merchant;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.Result;
import com.socialretail.backend.entity.order.Order;
import com.socialretail.backend.entity.order.OrderItem;
import com.socialretail.backend.entity.order.Payment;
import com.socialretail.backend.entity.order.AfterSale;
import com.socialretail.backend.entity.product.Product;
import com.socialretail.backend.mapper.order.OrderMapper;
import com.socialretail.backend.mapper.order.OrderItemMapper;
import com.socialretail.backend.mapper.order.PaymentMapper;
import com.socialretail.backend.mapper.order.AfterSaleMapper;
import com.socialretail.backend.mapper.product.ProductMapper;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/merchant/orders")
public class MerchantOrderController {

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(MerchantOrderController.class);

    private final OrderMapper orderMapper;
    private final OrderItemMapper orderItemMapper;
    private final PaymentMapper paymentMapper;
    private final AfterSaleMapper afterSaleMapper;
    private final ProductMapper productMapper;

    public MerchantOrderController(OrderMapper orderMapper, OrderItemMapper orderItemMapper,
                                   PaymentMapper paymentMapper, AfterSaleMapper afterSaleMapper,
                                   ProductMapper productMapper) {
        this.orderMapper = orderMapper;
        this.orderItemMapper = orderItemMapper;
        this.paymentMapper = paymentMapper;
        this.afterSaleMapper = afterSaleMapper;
        this.productMapper = productMapper;
    }

    @GetMapping
    public Result list(HttpServletRequest request,
                       @RequestParam(required = false) Integer status,
                       @RequestParam(required = false) Integer deliveryType,
                       @RequestParam(required = false) String orderSn,
                       @RequestParam(required = false) String startDate,
                       @RequestParam(required = false) String endDate,
                       @RequestParam(defaultValue = "1") int pageNum,
                       @RequestParam(defaultValue = "10") int pageSize) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Order::getMerchantId, merchantId);
        if (status != null) {
            wrapper.eq(Order::getStatus, status);
        }
        if (deliveryType != null) {
            wrapper.eq(Order::getDeliveryType, deliveryType);
        }
        if (StringUtils.hasText(orderSn)) {
            wrapper.like(Order::getOrderSn, orderSn);
        }
        if (StringUtils.hasText(startDate)) {
            wrapper.ge(Order::getCreateTime, LocalDate.parse(startDate).atStartOfDay());
        }
        if (StringUtils.hasText(endDate)) {
            wrapper.le(Order::getCreateTime, LocalDate.parse(endDate).atTime(23, 59, 59));
        }
        wrapper.orderByDesc(Order::getCreateTime);

        Page<Order> page = new Page<>(pageNum, pageSize);
        Page<Order> result = orderMapper.selectPage(page, wrapper);

        List<Map<String, Object>> list = new ArrayList<>();
        for (Order order : result.getRecords()) {
            Map<String, Object> vo = buildOrderVO(order);
            list.add(vo);
        }
        return Result.ok(PageResult.of(list, result.getTotal(), pageNum, pageSize));
    }

    @GetMapping("/{orderId}")
    public Result detail(@PathVariable Long orderId, HttpServletRequest request) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        Order order = orderMapper.selectById(orderId);
        if (order == null || !merchantId.equals(order.getMerchantId())) {
            return Result.fail("订单不存在");
        }
        Map<String, Object> vo = buildOrderVO(order);
        // 加载订单商品
        LambdaQueryWrapper<OrderItem> itemWrapper = new LambdaQueryWrapper<>();
        itemWrapper.eq(OrderItem::getOrderId, orderId);
        List<OrderItem> items = orderItemMapper.selectList(itemWrapper);
        vo.put("items", items);

        // 加载售后信息
        LambdaQueryWrapper<AfterSale> afterSaleWrapper = new LambdaQueryWrapper<>();
        afterSaleWrapper.eq(AfterSale::getOrderId, orderId);
        List<AfterSale> afterSales = afterSaleMapper.selectList(afterSaleWrapper);
        vo.put("afterSales", afterSales);

        return Result.ok(vo);
    }

    @PostMapping("/{orderId}/accept")
    public Result accept(@PathVariable Long orderId, HttpServletRequest request) {
        return updateOrderStatus(orderId, request, 1, 2); // 待接单 -> 已接单
    }

    @PostMapping("/{orderId}/prepare")
    public Result prepare(@PathVariable Long orderId, HttpServletRequest request) {
        return updateOrderStatus(orderId, request, 2, 3); // 已接单 -> 备货中
    }

    @PostMapping("/{orderId}/ship")
    public Result ship(@PathVariable Long orderId, HttpServletRequest request) {
        return updateOrderStatus(orderId, request, 3, 4); // 备货中 -> 已发货/待自提
    }

    @PostMapping("/{orderId}/cancel")
    public Result cancel(@PathVariable Long orderId, @RequestBody Map<String, Object> body, HttpServletRequest request) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        Order order = orderMapper.selectById(orderId);
        if (order == null || !merchantId.equals(order.getMerchantId())) {
            return Result.fail("订单不存在");
        }
        String reason = (String) body.getOrDefault("reason", "商家取消");
        order.setStatus(-1);
        order.setUpdateTime(LocalDateTime.now());
        orderMapper.updateById(order);
        log.info("[商家取消订单] orderId={}, reason={}", orderId, reason);
        return Result.success(null);
    }

    private Result updateOrderStatus(Long orderId, HttpServletRequest request, int expectedStatus, int newStatus) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        Order order = orderMapper.selectById(orderId);
        if (order == null || !merchantId.equals(order.getMerchantId())) {
            return Result.fail("订单不存在");
        }
        if (order.getStatus() != null && order.getStatus() != expectedStatus) {
            return Result.fail("订单状态不正确");
        }
        order.setStatus(newStatus);
        order.setUpdateTime(LocalDateTime.now());
        orderMapper.updateById(order);
        return Result.success(null);
    }

    private Map<String, Object> buildOrderVO(Order order) {
        Map<String, Object> vo = new LinkedHashMap<>();
        vo.put("id", order.getId());
        vo.put("orderId", order.getId());
        vo.put("orderSn", order.getOrderSn());
        vo.put("userId", order.getUserId());
        vo.put("merchantId", order.getMerchantId());
        vo.put("pickupPointId", order.getPickupPointId());
        vo.put("totalAmount", order.getTotalAmount());
        vo.put("payAmount", order.getPayAmount());
        vo.put("couponDiscount", order.getCouponDiscount());
        vo.put("deliveryType", order.getDeliveryType());
        vo.put("deliveryFee", order.getDeliveryFee());
        vo.put("status", order.getStatus());
        vo.put("payMethod", order.getPayMethod());
        vo.put("payTime", order.getPayTime());
        vo.put("createTime", order.getCreateTime());
        vo.put("updateTime", order.getUpdateTime());

        // 加载订单商品（列表页也需要显示商品）
        LambdaQueryWrapper<OrderItem> itemWrapper = new LambdaQueryWrapper<>();
        itemWrapper.eq(OrderItem::getOrderId, order.getId());
        List<OrderItem> items = orderItemMapper.selectList(itemWrapper);

        // 为每个OrderItem填充商品图片
        for (OrderItem item : items) {
            if (item.getProductName() == null || item.getProductName().isEmpty()) {
                // productName为空时尝试从Product表获取
                if (item.getProductId() != null) {
                    Product p = productMapper.selectById(item.getProductId());
                    if (p != null) {
                        item.setProductName(p.getTitle());
                        item.setProductImage(p.getMainImage());
                    }
                }
            } else {
                // productName已有值，只需补充productImage
                if (item.getProductId() != null) {
                    Product p = productMapper.selectById(item.getProductId());
                    if (p != null) {
                        item.setProductImage(p.getMainImage());
                    }
                }
            }
        }
        vo.put("orderItems", items);
        vo.put("itemCount", items.size());

        return vo;
    }
}
