package com.socialretail.backend.controller.admin;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.entity.member.Merchant;
import com.socialretail.backend.entity.member.MerchantApply;
import com.socialretail.backend.entity.order.Order;
import com.socialretail.backend.entity.order.OrderItem;
import com.socialretail.backend.entity.order.PlatformRevenueDetail;
import com.socialretail.backend.entity.product.Category;
import com.socialretail.backend.entity.product.ProductCategoryRelation;
import com.socialretail.backend.mapper.member.MerchantApplyMapper;
import com.socialretail.backend.mapper.member.MerchantMapper;
import com.socialretail.backend.mapper.order.OrderItemMapper;
import com.socialretail.backend.mapper.order.OrderMapper;
import com.socialretail.backend.mapper.order.PlatformRevenueDetailMapper;
import com.socialretail.backend.mapper.product.CategoryMapper;
import com.socialretail.backend.mapper.product.ProductCategoryRelationMapper;
import com.socialretail.backend.mapper.user.UserMapper;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/admin/dashboard")
public class AdminDashboardController {

    @Resource private OrderMapper orderMapper;
    @Resource private OrderItemMapper orderItemMapper;
    @Resource private UserMapper userMapper;
    @Resource private MerchantMapper merchantMapper;
    @Resource private MerchantApplyMapper merchantApplyMapper;
    @Resource private PlatformRevenueDetailMapper platformRevenueDetailMapper;
    @Resource private CategoryMapper categoryMapper;
    @Resource private ProductCategoryRelationMapper productCategoryRelationMapper;

    /** 大盘指标 */
    @GetMapping("/overview")
    public Result<Map<String, Object>> overview() {
        Map<String, Object> r = new LinkedHashMap<>();

        // 总销售额
        BigDecimal totalSales = orderMapper.selectList(
            new LambdaQueryWrapper<Order>().in(Order::getStatus, 1, 2, 3)
        ).stream().map(o -> o.getPayAmount() != null ? o.getPayAmount() : BigDecimal.ZERO)
        .reduce(BigDecimal.ZERO, BigDecimal::add);
        r.put("totalSales", totalSales);

        // 总订单数
        Long totalOrders = orderMapper.selectCount(null);
        r.put("totalOrders", totalOrders);

        // 总用户数
        Long totalUsers = userMapper.selectCount(null);
        r.put("totalUsers", totalUsers);

        // 商家数
        Long individual = merchantApplyMapper.selectCount(
            new LambdaQueryWrapper<MerchantApply>().eq(MerchantApply::getApplyType, 1)
        );
        Long enterprise = merchantApplyMapper.selectCount(
            new LambdaQueryWrapper<MerchantApply>().eq(MerchantApply::getApplyType, 2)
        );
        r.put("individualMerchants", individual);
        r.put("enterpriseMerchants", enterprise);
        r.put("totalMerchants", individual + enterprise);

        // 客单价
        if (totalOrders > 0) {
            r.put("avgOrderValue", totalSales.divide(BigDecimal.valueOf(totalOrders), 2, java.math.RoundingMode.HALF_UP));
        } else {
            r.put("avgOrderValue", BigDecimal.ZERO);
        }

        return Result.success(r);
    }

    /** 商家销售额排行榜 Top10 */
    @GetMapping("/merchant-rank")
    public Result<List<Map<String, Object>>> merchantRank() {
        List<Order> orders = orderMapper.selectList(
            new LambdaQueryWrapper<Order>().in(Order::getStatus, 1, 2, 3)
        );
        Map<Long, BigDecimal> map = new HashMap<>();
        for (Order o : orders) {
            map.merge(o.getMerchantId(), o.getPayAmount() != null ? o.getPayAmount() : BigDecimal.ZERO, BigDecimal::add);
        }
        return Result.success(map.entrySet().stream()
            .sorted((a, b) -> b.getValue().compareTo(a.getValue()))
            .limit(10).map(e -> {
                Merchant m = merchantMapper.selectById(e.getKey());
                Map<String, Object> item = new HashMap<>();
                item.put("merchantId", e.getKey());
                item.put("merchantName", m != null ? m.getMerchantName() : "未知");
                item.put("totalSales", e.getValue());
                return item;
            }).collect(Collectors.toList()));
    }

    /** 商家入驻趋势（按月） */
    @GetMapping("/merchant-trend")
    public Result<List<Map<String, Object>>> merchantTrend() {
        List<MerchantApply> all = merchantApplyMapper.selectList(
            new LambdaQueryWrapper<MerchantApply>().eq(MerchantApply::getAuditStatus, 1)
        );
        DateTimeFormatter df = DateTimeFormatter.ofPattern("yyyy-MM");
        Map<String, Long> monthMap = new LinkedHashMap<>();
        for (MerchantApply a : all) {
            if (a.getApplyTime() != null) {
                String month = a.getApplyTime().format(df);
                monthMap.merge(month, 1L, Long::sum);
            }
        }
        return Result.success(monthMap.entrySet().stream()
            .map(e -> { Map<String, Object> m = new HashMap<>(); m.put("month", e.getKey()); m.put("count", e.getValue()); return m; })
            .collect(Collectors.toList()));
    }

    /** 商家分层统计 */
    @GetMapping("/merchant-tiers")
    public Result<Map<String, Object>> merchantTiers() {
        List<Order> orders = orderMapper.selectList(
            new LambdaQueryWrapper<Order>().in(Order::getStatus, 1, 2, 3)
        );
        Map<Long, BigDecimal> map = new HashMap<>();
        for (Order o : orders) {
            map.merge(o.getMerchantId(), o.getPayAmount() != null ? o.getPayAmount() : BigDecimal.ZERO, BigDecimal::add);
        }
        int head = 0, waist = 0, tail = 0;
        for (BigDecimal v : map.values()) {
            if (v.compareTo(new BigDecimal("10000")) > 0) head++;
            else if (v.compareTo(new BigDecimal("1000")) >= 0) waist++;
            else tail++;
        }
        // 无销售额的商家算尾部
        Long total = merchantApplyMapper.selectCount(
            new LambdaQueryWrapper<MerchantApply>().eq(MerchantApply::getAuditStatus, 1)
        );
        tail += (int)(total - map.size());

        Map<String, Object> r = new LinkedHashMap<>();
        r.put("head", head);
        r.put("waist", waist);
        r.put("tail", tail);
        return Result.success(r);
    }

    /** 平台抽成收入 */
    @GetMapping("/commission")
    public Result<Map<String, Object>> commission() {
        List<PlatformRevenueDetail> details = platformRevenueDetailMapper.selectList(null);
        BigDecimal commission = BigDecimal.ZERO;
        BigDecimal subsidy = BigDecimal.ZERO;
        for (PlatformRevenueDetail d : details) {
            if ("COMMISSION".equals(d.getType())) {
                commission = commission.add(d.getAmount() != null ? d.getAmount() : BigDecimal.ZERO);
            } else if ("SUBSIDY".equals(d.getType())) {
                subsidy = subsidy.add(d.getAmount() != null ? d.getAmount() : BigDecimal.ZERO);
            }
        }
        Map<String, Object> r = new LinkedHashMap<>();
        r.put("commission", commission);
        r.put("subsidy", subsidy);
        r.put("netIncome", commission.subtract(subsidy));
        return Result.success(r);
    }

    /** 类目占比（一级类目） */
    @GetMapping("/category-proportion")
    public Result<List<Map<String, Object>>> categoryProportion() {
        List<Category> L1 = categoryMapper.selectList(
            new LambdaQueryWrapper<Category>().eq(Category::getLevel, 1)
        );
        Map<Long, String> nameMap = L1.stream().collect(Collectors.toMap(Category::getId, Category::getName));
        List<ProductCategoryRelation> rels = productCategoryRelationMapper.selectList(null);
        Map<Long, Long> productCatMap = rels.stream()
            .collect(Collectors.toMap(ProductCategoryRelation::getProductId, ProductCategoryRelation::getCategoryId, (a, b) -> a));

        List<Order> orders = orderMapper.selectList(
            new LambdaQueryWrapper<Order>().in(Order::getStatus, 1, 2, 3)
        );
        List<Long> orderIds = orders.stream().map(Order::getId).collect(Collectors.toList());
        List<OrderItem> items = orderIds.isEmpty() ? Collections.emptyList() :
            orderItemMapper.selectList(new LambdaQueryWrapper<OrderItem>().in(OrderItem::getOrderId, orderIds));

        Map<Long, BigDecimal> catSales = new LinkedHashMap<>();
        for (OrderItem item : items) {
            Long catId = productCatMap.get(item.getProductId());
            if (catId == null) continue;
            Long l1 = findL1(catId, L1);
            if (l1 == null) continue;
            catSales.merge(l1, item.getItemFinalAmount() != null ? item.getItemFinalAmount() : BigDecimal.ZERO, BigDecimal::add);
        }
        return Result.success(catSales.entrySet().stream()
            .map(e -> { Map<String, Object> m = new HashMap<>(); m.put("name", nameMap.getOrDefault(e.getKey(), "未知")); m.put("amount", e.getValue()); return m; })
            .sorted((a, b) -> ((BigDecimal) b.get("amount")).compareTo((BigDecimal) a.get("amount")))
            .collect(Collectors.toList()));
    }

    private Long findL1(Long catId, List<Category> l1List) {
        Set<Long> l1Ids = l1List.stream().map(Category::getId).collect(Collectors.toSet());
        if (l1Ids.contains(catId)) return catId;
        Category c = categoryMapper.selectById(catId);
        while (c != null && c.getParentId() != null && c.getParentId() > 0) {
            if (l1Ids.contains(c.getParentId())) return c.getParentId();
            c = categoryMapper.selectById(c.getParentId());
        }
        return null;
    }
}
