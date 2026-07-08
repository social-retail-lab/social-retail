package com.socialretail.backend.controller.admin;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.socialretail.backend.common.Result;
import com.socialretail.backend.entity.member.Merchant;
import com.socialretail.backend.entity.order.AfterSale;
import com.socialretail.backend.entity.order.Order;
import com.socialretail.backend.entity.order.OrderItem;
import com.socialretail.backend.entity.order.PlatformAccountSummary;
import com.socialretail.backend.entity.order.PlatformRevenueDetail;
import com.socialretail.backend.entity.product.Category;
import com.socialretail.backend.entity.product.ProductCategoryRelation;
import com.socialretail.backend.entity.review.OrderReview;
import com.socialretail.backend.mapper.member.MerchantMapper;
import com.socialretail.backend.mapper.order.AfterSaleMapper;
import com.socialretail.backend.mapper.order.OrderItemMapper;
import com.socialretail.backend.mapper.order.OrderMapper;
import com.socialretail.backend.mapper.order.PlatformAccountSummaryMapper;
import com.socialretail.backend.mapper.order.PlatformRevenueDetailMapper;
import com.socialretail.backend.mapper.product.CategoryMapper;
import com.socialretail.backend.mapper.product.ProductCategoryRelationMapper;
import com.socialretail.backend.mapper.review.OrderReviewMapper;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/admin/dashboard")
public class DashboardController {

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(DashboardController.class);

    @Resource
    private OrderMapper orderMapper;

    @Resource
    private MerchantMapper merchantMapper;

    @Resource
    private PlatformAccountSummaryMapper platformAccountSummaryMapper;

    @Resource
    private PlatformRevenueDetailMapper platformRevenueDetailMapper;

    @Resource
    private OrderItemMapper orderItemMapper;

    @Resource
    private ProductCategoryRelationMapper productCategoryRelationMapper;

    @Resource
    private CategoryMapper categoryMapper;

    @Resource
    private AfterSaleMapper afterSaleMapper;

    @Resource
    private OrderReviewMapper orderReviewMapper;

    private static final DateTimeFormatter MONTH_FMT = DateTimeFormatter.ofPattern("yyyy-MM");

    // ========== 概览数据 ==========
    @GetMapping("/overview")
    public Result<Map<String, Object>> overview() {
        log.info("[运营看板] 概览数据");

        // 总销售金额（已支付+已完成订单的实付金额）
        List<Order> allOrders = orderMapper.selectList(null);
        BigDecimal totalSales = allOrders.stream()
                .filter(o -> o.getStatus() != null && o.getStatus() >= 2 && o.getStatus() != 5)
                .map(o -> o.getPayAmount() != null ? o.getPayAmount() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        // 总订单数
        long totalOrders = allOrders.stream()
                .filter(o -> o.getStatus() != null && o.getStatus() >= 2 && o.getStatus() != 5)
                .count();

        // 总订单数（用于客单价）
        long paidOrders = totalOrders;
        BigDecimal avgOrderValue = paidOrders > 0
                ? totalSales.divide(BigDecimal.valueOf(paidOrders), 2, RoundingMode.HALF_UP)
                : BigDecimal.ZERO;

        // 总商家数
        List<Merchant> allMerchants = merchantMapper.selectList(null);
        long totalMerchants = allMerchants.stream().filter(m -> m.getStatus() != null && m.getStatus() == 1).count();

        // 个体/企业商家数（通过userId区分：userId>=1001且<=1025为个体，其他为企业 - 简化处理）
        long individualMerchants = allMerchants.stream()
                .filter(m -> m.getStatus() != null && m.getStatus() == 1 && m.getUserId() != null && m.getUserId() >= 1000 && m.getUserId() < 2000)
                .count();
        long enterpriseMerchants = totalMerchants - individualMerchants;

        // 总用户数 - 从订单中统计唯一用户
        long totalUsers = allOrders.stream()
                .filter(o -> o.getUserId() != null)
                .map(Order::getUserId)
                .distinct()
                .count();

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("totalSales", totalSales.toString());
        result.put("totalOrders", totalOrders);
        result.put("totalUsers", totalUsers);
        result.put("totalMerchants", totalMerchants);
        result.put("individualMerchants", individualMerchants);
        result.put("enterpriseMerchants", enterpriseMerchants);
        result.put("avgOrderValue", avgOrderValue.toString());

        log.info("[运营看板] 概览: totalSales={}, totalOrders={}, totalUsers={}", totalSales, totalOrders, totalUsers);
        return Result.ok(result);
    }

    // ========== 商家销售额排行（按月，默认取最近三个月，返回含月份信息的数据） ==========
    @GetMapping("/merchant-rank")
    public Result<Map<String, Object>> merchantRank(@RequestParam(required = false) String month) {
        log.info("[运营看板] 商家排行 month={}", month);

        String targetMonth = month != null ? month : LocalDate.now().format(MONTH_FMT);

        // 查询所有订单，按月份和商家分组统计
        List<Order> allOrders = orderMapper.selectList(null);

        // 用Map存储：月份 -> 商家ID -> 金额
        Map<String, Map<Long, BigDecimal>> monthlyMerchantSales = new LinkedHashMap<>();

        for (Order o : allOrders) {
            if (o.getStatus() == null || o.getStatus() < 2 || o.getStatus() == 5) continue;
            if (o.getMerchantId() == null) continue;
            String orderMonth = getMonthFromOrder(o);
            if (orderMonth == null) continue;

            BigDecimal amount = o.getPayAmount() != null ? o.getPayAmount() : BigDecimal.ZERO;
            monthlyMerchantSales.computeIfAbsent(orderMonth, k -> new LinkedHashMap<>())
                    .merge(o.getMerchantId(), amount, BigDecimal::add);
        }

        // 收集所有 merchantId
        Set<Long> allMerchantIds = new HashSet<>();
        monthlyMerchantSales.values().forEach(m -> allMerchantIds.addAll(m.keySet()));

        // 获取商家名称映射
        Map<Long, String> merchantNameMap = new HashMap<>();
        if (!allMerchantIds.isEmpty()) {
            List<Merchant> merchants = merchantMapper.selectBatchIds(allMerchantIds);
            for (Merchant m : merchants) {
                merchantNameMap.put(m.getId(), m.getMerchantName() != null ? m.getMerchantName() : "商家" + m.getId());
            }
        }

        // 获取最近三个月的列表
        List<String> recentMonths = monthlyMerchantSales.keySet().stream()
                .sorted(Comparator.reverseOrder())
                .limit(3)
                .collect(Collectors.toList());

        // 构建返回数据
        List<Map<String, Object>> monthRankList = new ArrayList<>();
        for (String m : recentMonths) {
            Map<Long, BigDecimal> merchantSales = monthlyMerchantSales.get(m);
            if (merchantSales == null) continue;

            List<Map<String, Object>> top5 = merchantSales.entrySet().stream()
                    .sorted((a, b) -> b.getValue().compareTo(a.getValue()))
                    .limit(5)
                    .map(e -> {
                        Map<String, Object> item = new LinkedHashMap<>();
                        item.put("merchantId", e.getKey());
                        item.put("merchantName", merchantNameMap.getOrDefault(e.getKey(), "商家" + e.getKey()));
                        item.put("totalSales", e.getValue().toString());
                        return item;
                    })
                    .collect(Collectors.toList());

            Map<String, Object> monthData = new LinkedHashMap<>();
            monthData.put("month", m);
            monthData.put("rankList", top5);
            monthRankList.add(monthData);
        }

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("months", recentMonths);
        result.put("monthRankList", monthRankList);

        // 如果指定了月份，也返回该月的top5（兼容旧接口）
        if (month != null) {
            Map<Long, BigDecimal> merchantSales = monthlyMerchantSales.get(targetMonth);
            if (merchantSales != null) {
                List<Map<String, Object>> top5 = merchantSales.entrySet().stream()
                        .sorted((a, b) -> b.getValue().compareTo(a.getValue()))
                        .limit(5)
                        .map(e -> {
                            Map<String, Object> item = new LinkedHashMap<>();
                            item.put("merchantId", e.getKey());
                            item.put("merchantName", merchantNameMap.getOrDefault(e.getKey(), "商家" + e.getKey()));
                            item.put("totalSales", e.getValue().toString());
                            return item;
                        })
                        .collect(Collectors.toList());
                result.put("currentMonthRank", top5);
            }
        }

        // 兼容旧接口：返回拓扑10列表
        Map<Long, BigDecimal> allSalesByMerchant = new LinkedHashMap<>();
        for (Map<Long, BigDecimal> ms : monthlyMerchantSales.values()) {
            ms.forEach((mid, amt) -> allSalesByMerchant.merge(mid, amt, BigDecimal::add));
        }
        List<Map<String, Object>> allTopRank = allSalesByMerchant.entrySet().stream()
                .sorted((a, b) -> b.getValue().compareTo(a.getValue()))
                .limit(10)
                .map(e -> {
                    Map<String, Object> item = new LinkedHashMap<>();
                    item.put("merchantId", e.getKey());
                    item.put("merchantName", merchantNameMap.getOrDefault(e.getKey(), "商家" + e.getKey()));
                    item.put("totalSales", e.getValue().toString());
                    return item;
                })
                .collect(Collectors.toList());
        // 如果前端仍然期望旧格式的数组，提供 rankList 字段
        result.put("rankList", allTopRank);

        return Result.ok(result);
    }

    // ========== 商家入驻趋势 ==========
    @GetMapping("/merchant-trend")
    public Result<List<Map<String, Object>>> merchantTrend() {
        log.info("[运营看板] 商家入驻趋势");
        List<Merchant> merchants = merchantMapper.selectList(null);

        Map<String, Long> monthCount = new TreeMap<>();
        for (Merchant m : merchants) {
            if (m.getCreateTime() == null) continue;
            String mth = m.getCreateTime().format(MONTH_FMT);
            monthCount.merge(mth, 1L, Long::sum);
        }

        List<Map<String, Object>> result = new ArrayList<>();
        for (Map.Entry<String, Long> e : monthCount.entrySet()) {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("month", e.getKey());
            item.put("count", e.getValue());
            result.add(item);
        }
        return Result.ok(result);
    }

    // ========== 商家分层 ==========
    @GetMapping("/merchant-tiers")
    public Result<Map<String, Object>> merchantTiers() {
        log.info("[运营看板] 商家分层");
        List<Order> allOrders = orderMapper.selectList(null);

        // 按商家统计销售额
        Map<Long, BigDecimal> merchantSales = new LinkedHashMap<>();
        for (Order o : allOrders) {
            if (o.getStatus() == null || o.getStatus() < 2 || o.getStatus() == 5) continue;
            if (o.getMerchantId() == null) continue;
            BigDecimal amount = o.getPayAmount() != null ? o.getPayAmount() : BigDecimal.ZERO;
            merchantSales.merge(o.getMerchantId(), amount, BigDecimal::add);
        }

        long micro = 0, tail = 0, waist = 0, head = 0;
        for (BigDecimal sales : merchantSales.values()) {
            if (sales.compareTo(BigDecimal.valueOf(100000)) > 0) head++;
            else if (sales.compareTo(BigDecimal.valueOf(10000)) >= 0) waist++;
            else if (sales.compareTo(BigDecimal.valueOf(1000)) >= 0) tail++;
            else micro++;
        }

        // 统计小微商家（包含无销售额的商家）
        List<Merchant> allMerchants = merchantMapper.selectList(new LambdaQueryWrapper<Merchant>().eq(Merchant::getStatus, 1));
        long merchantsWithSales = micro + tail + waist + head;
        long merchantsWithoutSales = allMerchants.size() - merchantsWithSales;
        micro += merchantsWithoutSales;

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("micro", micro);
        result.put("tail", tail);
        result.put("waist", waist);
        result.put("head", head);
        return Result.ok(result);
    }

    // ========== 平台抽成收入（月/季/年三维度，含环比/同比） ==========
    @GetMapping("/commission")
    public Result<Map<String, Object>> commission() {
        log.info("[运营看板] 平台抽成");
        List<Order> allOrders = orderMapper.selectList(null);

        LocalDate now = LocalDate.now();

        // 月维度
        Map<String, Object> monthData = buildPeriodWithGrowth(allOrders,
                now.minusDays(30), now,           // 本月
                now.minusDays(60), now.minusDays(30),  // 上月(环比)
                now.minusDays(395), now.minusDays(365) // 去年同月(同比)
        );

        // 季度维度
        Map<String, Object> quarterData = buildPeriodWithGrowth(allOrders,
                now.minusDays(90), now,            // 本季度
                now.minusDays(180), now.minusDays(90),  // 上季度(环比)
                now.minusDays(455), now.minusDays(365)  // 去年同季度(同比)
        );

        // 年度维度
        Map<String, Object> yearData = buildPeriodWithGrowth(allOrders,
                now.minusDays(365), now,           // 本年
                now.minusDays(730), now.minusDays(365), // 上年(环比)
                null, null                         // 年维度不计算同比
        );

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("month", monthData);
        result.put("quarter", quarterData);
        result.put("year", yearData);
        return Result.ok(result);
    }

    /** 计算指定区间的佣金、补贴、净收入 */
    private Map<String, Object> calcCommissionRange(List<Order> orders, LocalDate since, LocalDate until) {
        BigDecimal commissionTotal = BigDecimal.ZERO;
        BigDecimal subsidyTotal = BigDecimal.ZERO;

        for (Order o : orders) {
            if (o.getStatus() == null || o.getStatus() != 4) continue;
            if (o.getPayTime() == null) continue;
            LocalDate payDate = o.getPayTime().toLocalDate();
            if (payDate.isBefore(since) || !payDate.isBefore(until)) continue;
            if (o.getCommission() != null) commissionTotal = commissionTotal.add(o.getCommission());
            if (o.getPlatformSubsidy() != null) subsidyTotal = subsidyTotal.add(o.getPlatformSubsidy());
        }

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("commission", commissionTotal.toString());
        data.put("subsidy", subsidyTotal.toString());
        data.put("netIncome", commissionTotal.subtract(subsidyTotal).toString());
        return data;
    }

    /** 构建含环比/同比数据的周期数据 */
    private Map<String, Object> buildPeriodWithGrowth(List<Order> orders,
                                                       LocalDate curFrom, LocalDate curTo,
                                                       LocalDate prevFrom, LocalDate prevTo,
                                                       LocalDate yoyFrom, LocalDate yoyTo) {
        Map<String, Object> result = calcCommissionRange(orders, curFrom, curTo);

        // 环比
        Map<String, Object> prevData = null;
        String prevGrowth = null;
        if (prevFrom != null && prevTo != null) {
            prevData = calcCommissionRange(orders, prevFrom, prevTo);
            prevGrowth = calcGrowthPercent(getNetIncome(result), getNetIncome(prevData));
        }
        result.put("prevPeriod", prevData != null ? prevData : Collections.emptyMap());
        result.put("prevGrowth", prevGrowth != null ? prevGrowth : "暂无数据");

        // 同比
        String yoyGrowth = null;
        if (yoyFrom != null && yoyTo != null) {
            Map<String, Object> yoyData = calcCommissionRange(orders, yoyFrom, yoyTo);
            yoyGrowth = calcGrowthPercent(getNetIncome(result), getNetIncome(yoyData));
        }
        result.put("yoyGrowth", yoyGrowth != null ? yoyGrowth : "暂无数据");

        return result;
    }

    private BigDecimal getNetIncome(Map<String, Object> data) {
        try {
            return new BigDecimal((String) data.get("netIncome"));
        } catch (Exception e) {
            return BigDecimal.ZERO;
        }
    }

    /** 计算涨幅百分比：(current - previous) / previous * 100 */
    private String calcGrowthPercent(BigDecimal current, BigDecimal previous) {
        if (previous.compareTo(BigDecimal.ZERO) == 0) {
            return current.compareTo(BigDecimal.ZERO) > 0 ? "新增" : "0.00%";
        }
        BigDecimal growth = current.subtract(previous)
                .divide(previous, 4, RoundingMode.HALF_UP)
                .multiply(BigDecimal.valueOf(100));
        return growth.setScale(2, RoundingMode.HALF_UP).toString() + "%";
    }

    /** 已废弃，保留兼容 */
    private Map<String, Object> calcCommission(List<Order> orders, LocalDate since) {
        return calcCommissionRange(orders, since, LocalDate.now().plusDays(1));
    }

    // ========== 类目销售额占比 ==========
    @GetMapping("/category-proportion")
    public Result<List<Map<String, Object>>> categoryProportion() {
        log.info("[运营看板] 类目占比");

        // Get all orders with items
        List<Order> orders = orderMapper.selectList(null);

        // Build first-level category sales map
        Map<String, BigDecimal> catSales = new LinkedHashMap<>();

        for (Order order : orders) {
            if (order.getStatus() == null || order.getStatus() < 2 || order.getStatus() == 5) continue;
            List<OrderItem> items = orderItemMapper.selectList(
                    new LambdaQueryWrapper<OrderItem>().eq(OrderItem::getOrderId, order.getId()));

            for (OrderItem item : items) {
                if (item.getProductId() == null) continue;
                // Find category for this product through product_category_relation
                List<ProductCategoryRelation> rels = productCategoryRelationMapper.selectList(
                        new LambdaQueryWrapper<ProductCategoryRelation>().eq(ProductCategoryRelation::getProductId, item.getProductId()));

                for (ProductCategoryRelation rel : rels) {
                    Category cat = categoryMapper.selectById(rel.getCategoryId());
                    if (cat == null) continue;
                    // Find first-level category
                    Category parentCat = (cat.getParentId() != null && cat.getParentId() > 0)
                            ? categoryMapper.selectById(cat.getParentId()) : cat;
                    if (parentCat == null) continue;
                    String catName = parentCat.getName() != null ? parentCat.getName() : "其他";
                    BigDecimal amount = item.getPrice() != null
                            ? item.getPrice().multiply(BigDecimal.valueOf(item.getQuantity() != null ? item.getQuantity() : 1))
                            : BigDecimal.ZERO;
                    catSales.merge(catName, amount, BigDecimal::add);
                }
            }
        }

        List<Map<String, Object>> result = catSales.entrySet().stream()
                .sorted((a, b) -> b.getValue().compareTo(a.getValue()))
                .map(e -> {
                    Map<String, Object> item = new LinkedHashMap<>();
                    item.put("name", e.getKey());
                    item.put("amount", e.getValue().toString());
                    return item;
                })
                .collect(Collectors.toList());

        return Result.ok(result);
    }

    // ========== 售后申请率（按月折线图+环比） ==========
    @GetMapping("/after-sale-rate")
    public Result<Map<String, Object>> afterSaleRate() {
        log.info("[运营看板] 售后申请率");

        List<Order> allOrders = orderMapper.selectList(null);
        List<AfterSale> allAfterSales = afterSaleMapper.selectList(null);

        LocalDate now = LocalDate.now();
        List<Map<String, Object>> monthly = new ArrayList<>();

        // 只取近3个月
        for (int i = 2; i >= 0; i--) {
            LocalDate monthStart = now.minusMonths(i).withDayOfMonth(1);
            LocalDate monthEnd = monthStart.plusMonths(1);

            long ordersInMonth = allOrders.stream()
                    .filter(o -> o.getStatus() != null && o.getStatus() == 4 && o.getCreateTime() != null)
                    .filter(o -> {
                        LocalDate ct = o.getCreateTime().toLocalDate();
                        return !ct.isBefore(monthStart) && ct.isBefore(monthEnd);
                    })
                    .count();

            long afterSalesInMonth = allAfterSales.stream()
                    .filter(a -> a.getApplyTime() != null)
                    .filter(a -> {
                        LocalDate at = a.getApplyTime().toLocalDate();
                        return !at.isBefore(monthStart) && at.isBefore(monthEnd);
                    })
                    .count();

            String rate = ordersInMonth > 0
                    ? new BigDecimal(afterSalesInMonth).multiply(BigDecimal.valueOf(100))
                            .divide(BigDecimal.valueOf(ordersInMonth), 2, RoundingMode.HALF_UP).toString()
                    : "0.00";

            Map<String, Object> item = new LinkedHashMap<>();
            item.put("month", monthStart.toString().substring(0, 7));
            item.put("orderCount", ordersInMonth);
            item.put("afterSaleCount", afterSalesInMonth);
            item.put("rate", rate);
            monthly.add(item);
        }

        // 当前月 vs 上月
        Map<String, Object> cur = monthly.get(monthly.size() - 1);
        Map<String, Object> prev = monthly.size() > 1 ? monthly.get(monthly.size() - 2) : null;

        String curRate = (String) cur.get("rate");
        String prevRate = prev != null ? (String) prev.get("rate") : "0";

        BigDecimal curBd = new BigDecimal(curRate);
        BigDecimal prevBd = new BigDecimal(prevRate);
        String growth = prevBd.compareTo(BigDecimal.ZERO) > 0
                ? curBd.subtract(prevBd).divide(prevBd, 4, RoundingMode.HALF_UP).multiply(BigDecimal.valueOf(100)).setScale(2, RoundingMode.HALF_UP).toString() + "%"
                : (curBd.compareTo(BigDecimal.ZERO) > 0 ? "新增" : "0%");

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("monthly", monthly);
        result.put("currentRate", curRate + "%");
        result.put("prevRate", prev != null ? prevRate + "%" : "暂无数据");
        result.put("growth", growth);
        result.put("currentMonth", cur.get("month"));

        return Result.ok(result);
    }

    // ========== 商家评价星级 ==========
    @GetMapping("/merchant-rating")
    public Result<Map<String, Object>> merchantRating(
            @RequestParam(defaultValue = "desc") String sortOrder,
            @RequestParam(required = false) Integer page,
            @RequestParam(required = false) Integer pageSize) {
        log.info("[运营看板] 商家评价星级 sortOrder={} page={} pageSize={}", sortOrder, page, pageSize);

        List<OrderReview> allReviews = orderReviewMapper.selectList(null);

        // 总体贝叶斯评分
        long totalCount = allReviews.size();
        long totalSum = 0;
        for (OrderReview r : allReviews) {
            if (r.getRating() != null) {
                totalSum += r.getRating();
            }
        }
        double overallBayesian = totalCount > 0
                ? new BigDecimal(totalSum + 40).divide(new BigDecimal(totalCount + 10), 1, RoundingMode.HALF_UP).doubleValue()
                : 0.0;

        // 按商家统计
        Map<Long, long[]> merchantStats = new LinkedHashMap<>(); // [sum, count]
        for (OrderReview r : allReviews) {
            if (r.getMerchantId() == null || r.getRating() == null) continue;
            long[] stats = merchantStats.computeIfAbsent(r.getMerchantId(), k -> new long[2]);
            stats[0] += r.getRating();
            stats[1]++;
        }

        // 获取商家名称映射和联系信息
        Map<Long, Merchant> merchantMap = new HashMap<>();
        if (!merchantStats.isEmpty()) {
            List<Merchant> merchants = merchantMapper.selectBatchIds(merchantStats.keySet());
            for (Merchant m : merchants) {
                merchantMap.put(m.getId(), m);
            }
        }

        List<Map<String, Object>> merchantList = new ArrayList<>();
        for (Map.Entry<Long, long[]> entry : merchantStats.entrySet()) {
            long mid = entry.getKey();
            long[] stats = entry.getValue();
            long sum = stats[0];
            long count = stats[1];

            double avgRating = count > 0
                    ? new BigDecimal(sum).divide(new BigDecimal(count), 1, RoundingMode.HALF_UP).doubleValue()
                    : 0.0;
            double bayesianRating = count > 0
                    ? new BigDecimal(sum + 40).divide(new BigDecimal(count + 10), 1, RoundingMode.HALF_UP).doubleValue()
                    : 0.0;

            Merchant m = merchantMap.get(mid);
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("merchantId", mid);
            item.put("merchantName", m != null && m.getMerchantName() != null ? m.getMerchantName() : "商家" + mid);
            item.put("contactName", m != null ? m.getContactName() : "");
            item.put("contactPhone", m != null ? m.getContactPhone() : "");
            item.put("avgRating", avgRating);
            item.put("bayesianRating", bayesianRating);
            item.put("reviewCount", count);
            merchantList.add(item);
        }

        // 按avgRating排序
        if ("asc".equals(sortOrder)) {
            merchantList.sort(Comparator.comparingDouble(m -> ((Number) m.get("avgRating")).doubleValue()));
        } else {
            merchantList.sort((a, b) -> Double.compare(
                    ((Number) b.get("avgRating")).doubleValue(),
                    ((Number) a.get("avgRating")).doubleValue()));
        }

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("overallRating", overallBayesian);

        // 分页支持
        if (page != null && pageSize != null && page > 0 && pageSize > 0) {
            int total = merchantList.size();
            int fromIndex = (page - 1) * pageSize;
            int toIndex = Math.min(fromIndex + pageSize, total);
            if (fromIndex < total) {
                data.put("merchants", merchantList.subList(fromIndex, toIndex));
            } else {
                data.put("merchants", new ArrayList<>());
            }
            data.put("total", total);
            data.put("pages", (int) Math.ceil((double) total / pageSize));
            data.put("current", page);
        } else {
            data.put("merchants", merchantList);
        }

        return Result.ok(data);
    }

    private String getMonthFromOrder(Order o) {
        if (o.getCreateTime() != null) return o.getCreateTime().format(MONTH_FMT);
        if (o.getPayTime() != null) return o.getPayTime().format(MONTH_FMT);
        return null;
    }
}

