package com.socialretail.backend.controller.merchant;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.socialretail.backend.common.Result;
import com.socialretail.backend.entity.order.Order;
import com.socialretail.backend.entity.order.OrderItem;
import com.socialretail.backend.entity.product.Product;
import com.socialretail.backend.mapper.order.OrderMapper;
import com.socialretail.backend.mapper.order.OrderItemMapper;
import com.socialretail.backend.mapper.product.ProductMapper;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/merchant/dashboard")
public class MerchantDashboardController {

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(MerchantDashboardController.class);

    private final OrderMapper orderMapper;
    private final OrderItemMapper orderItemMapper;
    private final ProductMapper productMapper;

    public MerchantDashboardController(OrderMapper orderMapper, OrderItemMapper orderItemMapper, ProductMapper productMapper) {
        this.orderMapper = orderMapper;
        this.orderItemMapper = orderItemMapper;
        this.productMapper = productMapper;
    }

    @GetMapping("/metrics")
    public Result metrics(HttpServletRequest request) {
        Long merchantId = (Long) request.getAttribute("merchantId");

        // 今日销售额 & 订单量
        LocalDateTime todayStart = LocalDate.now().atStartOfDay();
        LambdaQueryWrapper<Order> orderWrapper = new LambdaQueryWrapper<>();
        orderWrapper.eq(Order::getMerchantId, merchantId)
                    .ge(Order::getCreateTime, todayStart)
                    .gt(Order::getStatus, 0);
        List<Order> todayOrders = orderMapper.selectList(orderWrapper);
        BigDecimal todaySales = BigDecimal.ZERO;
        for (Order o : todayOrders) {
            if (o.getPayAmount() != null) {
                todaySales = todaySales.add(o.getPayAmount());
            }
        }

        // 在售商品数
        LambdaQueryWrapper<Product> productWrapper = new LambdaQueryWrapper<>();
        productWrapper.eq(Product::getMerchantId, merchantId)
                      .eq(Product::getStatus, 1);
        long activeProducts = productMapper.selectCount(productWrapper);

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("todaySales", todaySales.setScale(2, RoundingMode.HALF_UP));
        data.put("todayOrders", todayOrders.size());
        data.put("activeProducts", (int) activeProducts);
        return Result.ok(data);
    }

    @GetMapping("/product-rank")
    public Result productRank(HttpServletRequest request) {
        Long merchantId = (Long) request.getAttribute("merchantId");

        // 1. 查询商家所有订单
        LambdaQueryWrapper<Order> orderWrapper = new LambdaQueryWrapper<>();
        orderWrapper.eq(Order::getMerchantId, merchantId).gt(Order::getStatus, 0);
        List<Order> orders = orderMapper.selectList(orderWrapper);

        if (orders.isEmpty()) {
            return Result.ok(Collections.emptyList());
        }

        List<Long> orderIds = orders.stream().map(Order::getId).collect(Collectors.toList());

        // 2. 查询订单商品
        LambdaQueryWrapper<OrderItem> itemWrapper = new LambdaQueryWrapper<>();
        itemWrapper.in(OrderItem::getOrderId, orderIds);
        List<OrderItem> items = orderItemMapper.selectList(itemWrapper);

        // 3. 按 productId 汇总销量
        Map<Long, Integer> qtyMap = new LinkedHashMap<>();
        for (OrderItem item : items) {
            qtyMap.merge(item.getProductId(), item.getQuantity() != null ? item.getQuantity() : 0, Integer::sum);
        }

        // 4. 按销量排序取 TOP5
        List<Map.Entry<Long, Integer>> sorted = qtyMap.entrySet().stream()
                .sorted((a, b) -> b.getValue().compareTo(a.getValue()))
                .limit(5)
                .collect(Collectors.toList());

        if (sorted.isEmpty()) {
            return Result.ok(Collections.emptyList());
        }

        // 5. 查询商品名称
        List<Long> productIds = sorted.stream().map(Map.Entry::getKey).collect(Collectors.toList());
        LambdaQueryWrapper<Product> productWrapper = new LambdaQueryWrapper<>();
        productWrapper.in(Product::getId, productIds);
        List<Product> products = productMapper.selectList(productWrapper);
        Map<Long, String> nameMap = products.stream()
                .collect(Collectors.toMap(Product::getId, Product::getTitle));

        // 6. 组装结果
        List<Map<String, Object>> list = new ArrayList<>();
        for (Map.Entry<Long, Integer> entry : sorted) {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("productName", nameMap.getOrDefault(entry.getKey(), "商品#" + entry.getKey()));
            item.put("totalQty", entry.getValue());
            list.add(item);
        }

        return Result.ok(list);
    }

    @GetMapping("/sales-trend")
    public Result salesTrend(HttpServletRequest request) {
        Long merchantId = (Long) request.getAttribute("merchantId");

        // 查询最近30天的订单
        LocalDateTime start30 = LocalDate.now().minusDays(30).atStartOfDay();
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Order::getMerchantId, merchantId)
               .ge(Order::getCreateTime, start30)
               .gt(Order::getStatus, 0);
        List<Order> orders = orderMapper.selectList(wrapper);

        // 近7天
        List<Map<String, Object>> daily = new ArrayList<>();
        for (int i = 6; i >= 0; i--) {
            LocalDate date = LocalDate.now().minusDays(i);
            BigDecimal amount = BigDecimal.ZERO;
            for (Order o : orders) {
                if (o.getCreateTime() != null && o.getCreateTime().toLocalDate().equals(date) && o.getPayAmount() != null) {
                    amount = amount.add(o.getPayAmount());
                }
            }
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("date", date.format(DateTimeFormatter.ofPattern("MM-dd")));
            item.put("amount", amount.setScale(2, RoundingMode.HALF_UP));
            daily.add(item);
        }

        // 近8周
        List<Map<String, Object>> weekly = new ArrayList<>();
        for (int i = 7; i >= 0; i--) {
            LocalDate weekStart = LocalDate.now().minusWeeks(i).with(java.time.DayOfWeek.MONDAY);
            LocalDate weekEnd = weekStart.plusDays(6);
            BigDecimal amount = BigDecimal.ZERO;
            for (Order o : orders) {
                if (o.getCreateTime() != null && !o.getCreateTime().toLocalDate().isBefore(weekStart)
                        && !o.getCreateTime().toLocalDate().isAfter(weekEnd) && o.getPayAmount() != null) {
                    amount = amount.add(o.getPayAmount());
                }
            }
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("week", "W" + weekStart.get(java.time.temporal.WeekFields.of(Locale.getDefault()).weekOfWeekBasedYear()));
            item.put("amount", amount.setScale(2, RoundingMode.HALF_UP));
            weekly.add(item);
        }

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("daily", daily);
        data.put("weekly", weekly);
        return Result.ok(data);
    }
}
