package com.socialretail.backend.controller.admin;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.socialretail.backend.common.Result;
import com.socialretail.backend.entity.member.Merchant;
import com.socialretail.backend.entity.order.Order;
import com.socialretail.backend.entity.order.PlatformAccountSummary;
import com.socialretail.backend.entity.order.PlatformRevenueDetail;
import com.socialretail.backend.mapper.member.MerchantMapper;
import com.socialretail.backend.mapper.order.OrderMapper;
import com.socialretail.backend.mapper.order.PlatformAccountSummaryMapper;
import com.socialretail.backend.mapper.order.PlatformRevenueDetailMapper;
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

        long head = 0, waist = 0, tail = 0;
        for (BigDecimal sales : merchantSales.values()) {
            if (sales.compareTo(BigDecimal.valueOf(10000)) > 0) head++;
            else if (sales.compareTo(BigDecimal.valueOf(1000)) >= 0) waist++;
            else tail++;
        }

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("head", head);
        result.put("waist", waist);
        result.put("tail", tail);
        return Result.ok(result);
    }

    // ========== 平台抽成收入 ==========
    @GetMapping("/commission")
    public Result<Map<String, Object>> commission() {
        log.info("[运营看板] 平台抽成");
        PlatformAccountSummary summary = platformAccountSummaryMapper.selectById(1);
        List<PlatformRevenueDetail> details = platformRevenueDetailMapper.selectList(null);

        BigDecimal commissionTotal = details.stream()
                .filter(d -> "COMMISSION".equals(d.getType()))
                .map(d -> d.getAmount() != null ? d.getAmount() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal subsidyTotal = details.stream()
                .filter(d -> "SUBSIDY".equals(d.getType()))
                .map(d -> d.getAmount() != null ? d.getAmount().abs() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal netIncome = commissionTotal.subtract(subsidyTotal);

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("commission", commissionTotal.toString());
        result.put("subsidy", subsidyTotal.toString());
        result.put("netIncome", netIncome.toString());
        return Result.ok(result);
    }

    // ========== 类目销售额占比 ==========
    @GetMapping("/category-proportion")
    public Result<List<Map<String, Object>>> categoryProportion() {
        log.info("[运营看板] 类目占比");

        // 从PlatformRevenueDetail按类目聚合（简化：使用description字段或type）
        List<PlatformRevenueDetail> details = platformRevenueDetailMapper.selectList(
                new LambdaQueryWrapper<PlatformRevenueDetail>()
                        .eq(PlatformRevenueDetail::getType, "COMMISSION"));

        // 按description聚合
        Map<String, BigDecimal> catSales = new LinkedHashMap<>();
        for (PlatformRevenueDetail d : details) {
            String desc = d.getDescription() != null ? d.getDescription() : "其他";
            // 简化类目名
            String cat = extractCategory(desc);
            BigDecimal amt = d.getAmount() != null ? d.getAmount() : BigDecimal.ZERO;
            catSales.merge(cat, amt, BigDecimal::add);
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

    private String getMonthFromOrder(Order o) {
        if (o.getCreateTime() != null) return o.getCreateTime().format(MONTH_FMT);
        if (o.getPayTime() != null) return o.getPayTime().format(MONTH_FMT);
        return null;
    }

    private String extractCategory(String desc) {
        if (desc == null) return "其他";
        if (desc.contains("坚果") || desc.contains("零食")) return "坚果零食";
        if (desc.contains("水果") || desc.contains("生鲜") || desc.contains("脐橙") || desc.contains("苹果") || desc.contains("奇异果")) return "生鲜水果";
        if (desc.contains("饮料") || desc.contains("气泡") || desc.contains("酸奶") || desc.contains("果汁") || desc.contains("水")) return "饮料饮品";
        if (desc.contains("榨菜") || desc.contains("粉") || desc.contains("面") || desc.contains("米") || desc.contains("调味") || desc.contains("酱油")) return "粮油调味";
        if (desc.contains("鸭脖") || desc.contains("鸡爪") || desc.contains("凤爪") || desc.contains("卤") || desc.contains("牛肉")) return "卤味熟食";
        return "其他";
    }
}

