package com.socialretail.backend.controller.admin;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.Result;
import com.socialretail.backend.entity.distribution.CommissionRecord;
import com.socialretail.backend.entity.distribution.Distributor;
import com.socialretail.backend.entity.distribution.DistributorApply;
import com.socialretail.backend.entity.distribution.DistributorProduct;
import com.socialretail.backend.entity.distribution.MerchantDistributionProduct;
import com.socialretail.backend.entity.product.Product;
import com.socialretail.backend.mapper.distribution.CommissionRecordMapper;
import com.socialretail.backend.mapper.distribution.DistributorApplyMapper;
import com.socialretail.backend.mapper.distribution.DistributorMapper;
import com.socialretail.backend.mapper.distribution.DistributorProductMapper;
import com.socialretail.backend.mapper.distribution.MerchantDistributionProductMapper;
import com.socialretail.backend.mapper.product.ProductMapper;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/distributor")
public class AdminDistributorController {

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(AdminDistributorController.class);

    private final DistributorApplyMapper applyMapper;
    private final DistributorMapper distributorMapper;
    private final CommissionRecordMapper commissionRecordMapper;
    private final DistributorProductMapper distributorProductMapper;
    private final MerchantDistributionProductMapper merchantDistProductMapper;
    private final ProductMapper productMapper;

    public AdminDistributorController(DistributorApplyMapper applyMapper,
                                       DistributorMapper distributorMapper,
                                       CommissionRecordMapper commissionRecordMapper,
                                       DistributorProductMapper distributorProductMapper,
                                       MerchantDistributionProductMapper merchantDistProductMapper,
                                       ProductMapper productMapper) {
        this.applyMapper = applyMapper;
        this.distributorMapper = distributorMapper;
        this.commissionRecordMapper = commissionRecordMapper;
        this.distributorProductMapper = distributorProductMapper;
        this.merchantDistProductMapper = merchantDistProductMapper;
        this.productMapper = productMapper;
    }

    /** 分销员申请列表 */
    @GetMapping("/applies")
    public Result listApplies(@RequestParam(required = false) Integer auditStatus,
                               @RequestParam(required = false) String keyword,
                               @RequestParam(defaultValue = "1") int pageNum,
                               @RequestParam(defaultValue = "10") int pageSize) {
        LambdaQueryWrapper<DistributorApply> wrapper = new LambdaQueryWrapper<>();
        if (auditStatus != null) {
            wrapper.eq(DistributorApply::getAuditStatus, auditStatus);
        }
        if (keyword != null && !keyword.isBlank()) {
            wrapper.like(DistributorApply::getRealName, keyword);
        }
        wrapper.orderByDesc(DistributorApply::getApplyTime);

        Page<DistributorApply> page = new Page<>(pageNum, pageSize);
        Page<DistributorApply> result = applyMapper.selectPage(page, wrapper);
        return Result.ok(PageResult.of(result.getRecords(), result.getTotal(), pageNum, pageSize));
    }

    /** 审核分销员申请 */
    @PostMapping("/applies/{applyId}/audit")
    public Result auditApply(@PathVariable Long applyId, @RequestBody Map<String, Object> body) {
        int auditStatus = ((Number) body.get("auditStatus")).intValue();
        String remark = (String) body.getOrDefault("auditRemark", "");

        DistributorApply apply = applyMapper.selectById(applyId);
        if (apply == null) {
            return Result.fail("申请记录不存在");
        }
        if (apply.getAuditStatus() != 0) {
            return Result.fail("该申请已审核过");
        }

        apply.setAuditStatus(auditStatus);
        apply.setAuditRemark(remark);
        apply.setAuditTime(LocalDateTime.now());
        applyMapper.updateById(apply);

        // 审核通过：创建分销员记录
        if (auditStatus == 1) {
            LambdaQueryWrapper<Distributor> exist = new LambdaQueryWrapper<>();
            exist.eq(Distributor::getUserId, apply.getUserId());
            if (distributorMapper.selectCount(exist) == 0) {
                Distributor dist = new Distributor();
                dist.setUserId(apply.getUserId());
                dist.setApplyId(apply.getId());
                dist.setTotalCommission(BigDecimal.ZERO);
                dist.setAvailableCommission(BigDecimal.ZERO);
                dist.setFrozenCommission(BigDecimal.ZERO);
                dist.setStatus(1);
                dist.setApplyTime(LocalDateTime.now());
                dist.setCreateTime(LocalDateTime.now());
                distributorMapper.insert(dist);
            }
        }

        log.info("[分销员审核] applyId={}, status={}, remark={}", applyId, auditStatus, remark);
        return Result.success(null);
    }

    /** 分销员列表（含姓名） */
    @GetMapping("/list")
    public Result listDistributors(@RequestParam(defaultValue = "1") int pageNum,
                                    @RequestParam(defaultValue = "10") int pageSize) {
        Page<Distributor> page = new Page<>(pageNum, pageSize);
        Page<Distributor> result = distributorMapper.selectPage(page, new LambdaQueryWrapper<Distributor>()
                .orderByDesc(Distributor::getCreateTime));

        // 补充姓名
        List<Map<String, Object>> records = new ArrayList<>();
        for (Distributor d : result.getRecords()) {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("id", d.getId());
            item.put("userId", d.getUserId());
            item.put("totalCommission", d.getTotalCommission());
            item.put("availableCommission", d.getAvailableCommission());
            item.put("frozenCommission", d.getFrozenCommission());
            item.put("status", d.getStatus());
            item.put("applyTime", d.getApplyTime());
            item.put("createTime", d.getCreateTime());

            DistributorApply apply = applyMapper.selectById(d.getApplyId());
            item.put("realName", apply != null ? apply.getRealName() : "");

            records.add(item);
        }

        return Result.ok(PageResult.of(records, result.getTotal(), pageNum, pageSize));
    }

    /** 分销管理 - 核心统计 */
    @GetMapping("/stats")
    public Result getStats() {
        // 分销员总数
        Long totalDistributors = distributorMapper.selectCount(
                new LambdaQueryWrapper<Distributor>().eq(Distributor::getStatus, 1));

        // 分销总佣金（已结算）
        BigDecimal totalCommission = BigDecimal.ZERO;
        List<CommissionRecord> settledRecords = commissionRecordMapper.selectList(
                new LambdaQueryWrapper<CommissionRecord>().eq(CommissionRecord::getStatus, 1));
        for (CommissionRecord r : settledRecords) {
            if (r.getCommissionAmount() != null) {
                totalCommission = totalCommission.add(r.getCommissionAmount());
            }
        }

        // 分销订单总数（去重 order_id）
        List<CommissionRecord> allRecords = commissionRecordMapper.selectList(
                new LambdaQueryWrapper<CommissionRecord>().select(CommissionRecord::getOrderId));
        long totalOrders = allRecords.stream().map(CommissionRecord::getOrderId).distinct().count();

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("totalDistributors", totalDistributors);
        data.put("totalCommission", totalCommission);
        data.put("totalOrders", totalOrders);
        return Result.ok(data);
    }

    /** 分销员详情：个人信息 + 推广商品列表 + 每商品订单数 */
    @GetMapping("/detail/{distributorId}")
    public Result getDetail(@PathVariable Long distributorId) {
        Distributor dist = distributorMapper.selectById(distributorId);
        if (dist == null) {
            return Result.fail("分销员不存在");
        }

        // 获取用户真实姓名
        String realName = "";
        DistributorApply apply = applyMapper.selectById(dist.getApplyId());
        if (apply != null) {
            realName = apply.getRealName();
        }

        // 分销员推广商品列表
        List<DistributorProduct> dpList = distributorProductMapper.selectList(
                new LambdaQueryWrapper<DistributorProduct>()
                        .eq(DistributorProduct::getDistributorId, distributorId));

        List<Map<String, Object>> products = new ArrayList<>();
        for (DistributorProduct dp : dpList) {
            MerchantDistributionProduct mdp = merchantDistProductMapper.selectById(dp.getDistributionProductId());
            if (mdp == null) continue;

            Product product = productMapper.selectById(mdp.getProductId());
            if (product == null) continue;

            // 该推广商品带来的订单数
            Long orderCount = commissionRecordMapper.selectCount(
                    new LambdaQueryWrapper<CommissionRecord>()
                            .eq(CommissionRecord::getDistributorProductId, dp.getId()));

            Map<String, Object> item = new LinkedHashMap<>();
            item.put("productId", product.getId());
            item.put("productTitle", product.getTitle());
            item.put("productImage", product.getMainImage());
            item.put("commissionRate", mdp.getCommissionRate());
            item.put("promotionCode", dp.getPromotionCode());
            item.put("orderCount", orderCount);
            products.add(item);
        }

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("distributorId", dist.getId());
        data.put("userId", dist.getUserId());
        data.put("realName", realName);
        data.put("totalCommission", dist.getTotalCommission());
        data.put("availableCommission", dist.getAvailableCommission());
        data.put("frozenCommission", dist.getFrozenCommission());
        data.put("status", dist.getStatus());
        data.put("applyTime", dist.getApplyTime());
        data.put("products", products);
        return Result.ok(data);
    }

    /** 审核结果回调给前端 */
    @PostMapping("/apply/notify")
    public Result notifyResult(@RequestBody Map<String, Object> body) {
        // 预留：通知前端审核完成
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("message", "审核完成");
        return Result.ok(data);
    }
}
