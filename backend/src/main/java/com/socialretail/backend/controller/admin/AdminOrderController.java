package com.socialretail.backend.controller.admin;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.Result;
import com.socialretail.backend.entity.member.Merchant;
import com.socialretail.backend.entity.member.User;
import com.socialretail.backend.entity.order.Order;
import com.socialretail.backend.entity.order.OrderItem;
import com.socialretail.backend.entity.product.Product;
import com.socialretail.backend.mapper.member.MerchantMapper;
import com.socialretail.backend.mapper.member.UserMapper;
import com.socialretail.backend.mapper.order.OrderMapper;
import com.socialretail.backend.mapper.order.OrderItemMapper;
import com.socialretail.backend.mapper.product.ProductMapper;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/admin")
public class AdminOrderController {

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(AdminOrderController.class);

    private final OrderMapper orderMapper;
    private final OrderItemMapper orderItemMapper;
    private final ProductMapper productMapper;
    private final UserMapper userMapper;
    private final MerchantMapper merchantMapper;

    public AdminOrderController(OrderMapper orderMapper, OrderItemMapper orderItemMapper,
                                 ProductMapper productMapper, UserMapper userMapper,
                                 MerchantMapper merchantMapper) {
        this.orderMapper = orderMapper;
        this.orderItemMapper = orderItemMapper;
        this.productMapper = productMapper;
        this.userMapper = userMapper;
        this.merchantMapper = merchantMapper;
    }

    @GetMapping("/orders")
    public Result listOrders(@RequestParam(required = false) String status,
                              @RequestParam(required = false) String keyword,
                              @RequestParam(defaultValue = "1") int page,
                              @RequestParam(defaultValue = "10") int pageSize) {
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
        if (status != null && !status.isBlank()) {
            try {
                wrapper.eq(Order::getStatus, Integer.parseInt(status));
            } catch (NumberFormatException ignored) {}
        }
        if (keyword != null && !keyword.isBlank()) {
            wrapper.like(Order::getOrderSn, keyword);
        }
        wrapper.orderByDesc(Order::getCreateTime);

        Page<Order> mpPage = new Page<>(page, pageSize);
        Page<Order> result = orderMapper.selectPage(mpPage, wrapper);

        // 为每个订单加载商品和用户/商家信息
        List<Map<String, Object>> list = new ArrayList<>();
        for (Order order : result.getRecords()) {
            Map<String, Object> vo = new LinkedHashMap<>();
            vo.put("id", order.getId());
            vo.put("orderSn", order.getOrderSn());
            vo.put("userId", order.getUserId());
            vo.put("merchantId", order.getMerchantId());
            vo.put("totalAmount", order.getTotalAmount());
            vo.put("payAmount", order.getPayAmount());
            vo.put("deliveryType", order.getDeliveryType());
            vo.put("status", order.getStatus());
            vo.put("createTime", order.getCreateTime());

            // 用户信息
            if (order.getUserId() != null) {
                User user = userMapper.selectById(order.getUserId());
                if (user != null) {
                    vo.put("userName", user.getNickname());
                    vo.put("userPhone", user.getPhone());
                }
            }
            // 商家信息
            if (order.getMerchantId() != null) {
                Merchant merchant = merchantMapper.selectById(order.getMerchantId());
                if (merchant != null) {
                    vo.put("merchantName", merchant.getMerchantName());
                }
            }

            LambdaQueryWrapper<OrderItem> itemWrapper = new LambdaQueryWrapper<>();
            itemWrapper.eq(OrderItem::getOrderId, order.getId());
            List<OrderItem> items = orderItemMapper.selectList(itemWrapper);

            // 为每个OrderItem填充商品图片
            for (OrderItem item : items) {
                if (item.getProductName() == null || item.getProductName().isEmpty()) {
                    if (item.getProductId() != null) {
                        Product p = productMapper.selectById(item.getProductId());
                        if (p != null) {
                            item.setProductName(p.getTitle());
                            item.setProductImage(p.getMainImage());
                        }
                    }
                } else if (item.getProductId() != null) {
                    Product p = productMapper.selectById(item.getProductId());
                    if (p != null) {
                        item.setProductImage(p.getMainImage());
                    }
                }
            }
            vo.put("orderItems", items);
            vo.put("totalQuantity", items.size());
            list.add(vo);
        }

        return Result.ok(PageResult.of(list, result.getTotal(), page, pageSize));
    }

    @GetMapping("/orders/{orderId}")
    public Result getOrderDetail(@PathVariable Long orderId) {
        Order order = orderMapper.selectById(orderId);
        if (order == null) {
            return Result.fail("订单不存在");
        }

        LambdaQueryWrapper<OrderItem> itemWrapper = new LambdaQueryWrapper<>();
        itemWrapper.eq(OrderItem::getOrderId, orderId);
        List<OrderItem> items = orderItemMapper.selectList(itemWrapper);

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("order", order);
        data.put("items", items);
        return Result.success(data);
    }

    @PostMapping("/orders/{orderId}/refund")
    public Result handleRefund(@PathVariable Long orderId, @RequestBody Map<String, Object> body) {
        Order order = orderMapper.selectById(orderId);
        if (order == null) {
            return Result.fail("订单不存在");
        }

        BigDecimal refundAmount = new BigDecimal(body.get("refundAmount").toString());
        String reason = (String) body.getOrDefault("reason", "");

        order.setStatus(7); // 已退款
        order.setUpdateTime(LocalDateTime.now());
        orderMapper.updateById(order);

        log.info("[平台退款] orderId={}, amount={}, reason={}", orderId, refundAmount, reason);
        return Result.success(null);
    }

    @PostMapping("/orders/{orderId}/close")
    public Result closeOrder(@PathVariable Long orderId, @RequestBody Map<String, Object> body) {
        Order order = orderMapper.selectById(orderId);
        if (order == null) {
            return Result.fail("订单不存在");
        }

        String reason = (String) body.getOrDefault("reason", "");
        order.setStatus(6); // 已关闭
        order.setUpdateTime(LocalDateTime.now());
        orderMapper.updateById(order);

        log.info("[平台关闭订单] orderId={}, reason={}", orderId, reason);
        return Result.success(null);
    }
}
