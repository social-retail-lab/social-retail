package com.socialretail.backend.controller.merchant;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.entity.member.Merchant;
import com.socialretail.backend.entity.order.Order;
import com.socialretail.backend.entity.order.OrderItem;
import com.socialretail.backend.entity.product.Product;
import com.socialretail.backend.mapper.member.MerchantMapper;
import com.socialretail.backend.mapper.order.OrderItemMapper;
import com.socialretail.backend.mapper.order.OrderMapper;
import com.socialretail.backend.mapper.product.ProductMapper;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/merchant/dashboard")
public class MerchantDashboardController {

    @Resource private MerchantMapper merchantMapper;
    @Resource private OrderMapper orderMapper;
    @Resource private OrderItemMapper orderItemMapper;
    @Resource private ProductMapper productMapper;

    private Long getMerchantId(HttpServletRequest request) {
        return (Long) request.getAttribute("merchantId");
    }

    /** 核心指标 */
    @GetMapping("/metrics")
    public Result<Map<String, Object>> metrics(HttpServletRequest request) {
        Long merchantId = getMerchantId(request);
        LocalDateTime todayStart = LocalDate.now().atStartOfDay();
        Map<String, Object> result = new LinkedHashMap<>();

        // 今日销售额
        BigDecimal todaySales = orderMapper.selectList(
            new LambdaQueryWrapper<Order>()
                .eq(Order::getMerchantId, merchantId)
                .ge(Order::getCreateTime, todayStart)
                .in(Order::getStatus, 1, 2, 3)
        ).stream().map(o -> o.getPayAmount() != null ? o.getPayAmount() : BigDecimal.ZERO)
        .reduce(BigDecimal.ZERO, BigDecimal::add);
        result.put("todaySales", todaySales);

        // 今日订单量
        Long todayOrders = orderMapper.selectCount(
            new LambdaQueryWrapper<Order>()
                .eq(Order::getMerchantId, merchantId)
                .ge(Order::getCreateTime, todayStart)
        );
        result.put("todayOrders", todayOrders);

        // 在售商品数
        Long activeProducts = productMapper.selectCount(
            new LambdaQueryWrapper<Product>()
                .eq(Product::getMerchantId, merchantId)
                .eq(Product::getStatus, 1)
        );
        result.put("activeProducts", activeProducts);

        return Result.success(result);
    }

    /** 7天内商品销量TOP5 */
    @GetMapping("/product-rank")
    public Result<List<Map<String, Object>>> productRank(HttpServletRequest request) {
        Long merchantId = getMerchantId(request);
        LocalDateTime sevenDaysAgo = LocalDate.now().minusDays(7).atStartOfDay();

        List<Order> recentOrders = orderMapper.selectList(
            new LambdaQueryWrapper<Order>()
                .eq(Order::getMerchantId, merchantId)
                .ge(Order::getCreateTime, sevenDaysAgo)
                .in(Order::getStatus, 1, 2, 3)
        );
        List<Long> orderIds = recentOrders.stream().map(Order::getId).collect(Collectors.toList());
        if (orderIds.isEmpty()) return Result.success(Collections.emptyList());

        List<OrderItem> items = orderItemMapper.selectList(
            new LambdaQueryWrapper<OrderItem>().in(OrderItem::getOrderId, orderIds)
        );
        Map<Long, Map<String, Object>> productMap = new LinkedHashMap<>();
        for (OrderItem item : items) {
            productMap.compute(item.getProductId(), (k, v) -> {
                if (v == null) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("productId", item.getProductId());
                    m.put("productName", item.getProductName());
                    m.put("totalQty", item.getQuantity() != null ? item.getQuantity() : 0);
                    return m;
                }
                v.put("totalQty", ((int) v.get("totalQty")) + (item.getQuantity() != null ? item.getQuantity() : 0));
                return v;
            });
        }
        return Result.success(productMap.values().stream()
            .sorted((a, b) -> Integer.compare((int) b.get("totalQty"), (int) a.get("totalQty")))
            .limit(5).collect(Collectors.toList()));
    }

    /** 销售趋势: 7天日销售 + 8周周销售 */
    @GetMapping("/sales-trend")
    public Result<Map<String, Object>> salesTrend(HttpServletRequest request) {
        Long merchantId = getMerchantId(request);
        LocalDate today = LocalDate.now();
        Map<String, Object> result = new LinkedHashMap<>();

        // 7天
        List<Map<String, Object>> daily = new ArrayList<>();
        DateTimeFormatter df = DateTimeFormatter.ofPattern("MM-dd");
        for (int i = 6; i >= 0; i--) {
            LocalDate date = today.minusDays(i);
            LocalDateTime start = date.atStartOfDay();
            LocalDateTime end = date.plusDays(1).atStartOfDay();
            BigDecimal sum = orderMapper.selectList(
                new LambdaQueryWrapper<Order>()
                    .eq(Order::getMerchantId, merchantId)
                    .ge(Order::getCreateTime, start).lt(Order::getCreateTime, end)
                    .in(Order::getStatus, 1, 2, 3)
            ).stream().map(o -> o.getPayAmount() != null ? o.getPayAmount() : BigDecimal.ZERO)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
            Map<String, Object> d = new HashMap<>();
            d.put("date", date.format(df));
            d.put("amount", sum);
            daily.add(d);
        }
        result.put("daily", daily);

        // 8周 (周一到周日)
        List<Map<String, Object>> weekly = new ArrayList<>();
        LocalDate monday = today.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        for (int w = 7; w >= 0; w--) {
            LocalDate weekStart = monday.minusWeeks(w);
            LocalDate weekEnd = weekStart.plusDays(7);
            BigDecimal sum = orderMapper.selectList(
                new LambdaQueryWrapper<Order>()
                    .eq(Order::getMerchantId, merchantId)
                    .ge(Order::getCreateTime, weekStart.atStartOfDay())
                    .lt(Order::getCreateTime, weekEnd.atStartOfDay())
                    .in(Order::getStatus, 1, 2, 3)
            ).stream().map(o -> o.getPayAmount() != null ? o.getPayAmount() : BigDecimal.ZERO)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
            Map<String, Object> d = new HashMap<>();
            d.put("week", weekStart.format(df) + "~" + weekEnd.minusDays(1).format(df));
            d.put("amount", sum);
            weekly.add(d);
        }
        result.put("weekly", weekly);

        return Result.success(result);
    }
}
