package com.socialretail.backend.controller.admin;

import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.Result;
import com.socialretail.backend.service.admin.AuditService;
import com.socialretail.backend.service.merchant.PickupPointService;
import com.socialretail.backend.vo.AdminProductDetailVO;
import com.socialretail.backend.vo.AdminProductListVO;
import com.socialretail.backend.vo.AuditRequest;
import com.socialretail.backend.vo.AuditVO;
import com.socialretail.backend.vo.MerchantApplicationListVO;
import com.socialretail.backend.vo.MerchantListVO;
import com.socialretail.backend.vo.ProductAuditListVO;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/admin/operation")
public class AuditController {

    @Resource
    private AuditService auditService;

    @Resource
    private PickupPointService pickupPointService;

    // ==================== 商家审核 ====================

    @GetMapping("/merchant/applications")
    public Result<PageResult<MerchantApplicationListVO>> getMerchantApplications(
            @RequestParam(required = false) Integer auditStatus,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize) {
        log.info("[入驻申请列表] auditStatus={}, keyword={}, startDate={}, endDate={}, pageNum={}, pageSize={}",
                auditStatus, keyword, startDate, endDate, pageNum, pageSize);
        try {
            PageResult<MerchantApplicationListVO> pageResult = auditService.getMerchantApplications(
                    auditStatus, keyword, startDate, endDate, pageNum, pageSize);
            log.info("[入驻申请列表] 成功, total={}, pageSize={}", pageResult.getTotal(), pageResult.getList().size());
            return Result.ok(pageResult);
        } catch (RuntimeException e) {
            log.warn("[入驻申请列表] 失败, 原因: {}", e.getMessage());
            throw e;
        }
    }

    @PostMapping("/merchant/applications/{applyId}/audit")
    public Result<AuditVO> auditMerchantApplication(@PathVariable Long applyId,
                                                    @RequestBody AuditRequest req) {
        log.info("[入驻审核] applyId={}, 请求体: auditStatus={}, auditRemark={}", applyId, req.getAuditStatus(), req.getAuditRemark());
        try {
            AuditVO vo = auditService.auditMerchantApplication(applyId, req.getAuditStatus(), req.getAuditRemark());
            log.info("[入驻审核] 成功, applyId={}, result={}", applyId, vo.getAuditStatus());
            return Result.ok(vo);
        } catch (RuntimeException e) {
            log.warn("[入驻审核] 失败, applyId={}, 原因: {}", applyId, e.getMessage());
            throw e;
        }
    }

    // ==================== 商家管理 ====================

    @GetMapping("/merchants")
    public Result<PageResult<MerchantListVO>> getMerchantList(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize) {
        log.info("[商家列表] keyword={}, status={}, pageNum={}, pageSize={}", keyword, status, pageNum, pageSize);
        try {
            PageResult<MerchantListVO> pageResult = auditService.getMerchantList(keyword, status, pageNum, pageSize);
            log.info("[商家列表] 成功, total={}, pageSize={}", pageResult.getTotal(), pageResult.getList().size());
            return Result.ok(pageResult);
        } catch (RuntimeException e) {
            log.warn("[商家列表] 失败, 原因: {}", e.getMessage());
            throw e;
        }
    }

    @GetMapping("/merchants/{merchantId}")
    public Result<Map<String, Object>> getMerchantDetail(@PathVariable Long merchantId) {
        log.info("[商家详情] merchantId={}", merchantId);
        try {
            Map<String, Object> detail = auditService.getMerchantDetail(merchantId);
            log.info("[商家详情] 成功, merchantId={}, merchantName={}", merchantId, detail.get("merchantName"));
            return Result.ok(detail);
        } catch (RuntimeException e) {
            log.warn("[商家详情] 失败, merchantId={}, 原因: {}", merchantId, e.getMessage());
            throw e;
        }
    }

    @PatchMapping("/merchants/{merchantId}/status")
    public Result<Map<String, Object>> updateMerchantStatus(@PathVariable Long merchantId,
                                                            @RequestBody Map<String, Object> body) {
        Integer status = body.get("status") != null ? ((Number) body.get("status")).intValue() : null;
        String reason = (String) body.get("reason");
        log.info("[修改商家状态] merchantId={}, 请求体: status={}, reason={}", merchantId, status, reason);
        try {
            Map<String, Object> result = auditService.updateMerchantStatus(merchantId, status, reason);
            log.info("[修改商家状态] 成功, merchantId={}, newStatus={}", merchantId, result.get("status"));
            return Result.ok(result);
        } catch (RuntimeException e) {
            log.warn("[修改商家状态] 失败, merchantId={}, 原因: {}", merchantId, e.getMessage());
            throw e;
        }
    }

    // ==================== 商品审核 ====================

    @GetMapping("/products/audits")
    public Result<PageResult<ProductAuditListVO>> getProductAuditList(
            @RequestParam(required = false) Integer auditStatus,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Long merchantId,
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize) {
        log.info("[商品审核列表] auditStatus={}, keyword={}, merchantId={}, pageNum={}, pageSize={}",
                auditStatus, keyword, merchantId, pageNum, pageSize);
        try {
            PageResult<ProductAuditListVO> pageResult = auditService.getProductAuditList(
                    auditStatus, keyword, merchantId, pageNum, pageSize);
            log.info("[商品审核列表] 成功, total={}, pageSize={}", pageResult.getTotal(), pageResult.getList().size());
            return Result.ok(pageResult);
        } catch (RuntimeException e) {
            log.warn("[商品审核列表] 失败, 原因: {}", e.getMessage());
            throw e;
        }
    }

    @PostMapping("/products/{productId}/audit")
    public Result<AuditVO> auditProduct(@PathVariable Long productId,
                                        @RequestBody AuditRequest req) {
        log.info("[商品审核] productId={}, 请求体: auditStatus={}, auditRemark={}", productId, req.getAuditStatus(), req.getAuditRemark());
        try {
            AuditVO vo = auditService.auditProduct(productId, req.getAuditStatus(), req.getAuditRemark());
            log.info("[商品审核] 成功, productId={}, result={}", productId, vo.getAuditStatus());
            return Result.ok(vo);
        } catch (RuntimeException e) {
            log.warn("[商品审核] 失败, productId={}, 原因: {}", productId, e.getMessage());
            throw e;
        }
    }

    // ==================== 商品管理 ====================

    @GetMapping("/products")
    public Result<PageResult<AdminProductListVO>> getAllProducts(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) Integer auditStatus,
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize) {
        log.info("[商品管理列表] keyword={}, categoryId={}, status={}, auditStatus={}, pageNum={}, pageSize={}",
                keyword, categoryId, status, auditStatus, pageNum, pageSize);
        try {
            PageResult<AdminProductListVO> pageResult = auditService.getAllProducts(
                    keyword, categoryId, status, auditStatus, pageNum, pageSize);
            log.info("[商品管理列表] 成功, total={}, pageSize={}", pageResult.getTotal(), pageResult.getList().size());
            return Result.ok(pageResult);
        } catch (RuntimeException e) {
            log.warn("[商品管理列表] 失败, 原因: {}", e.getMessage());
            throw e;
        }
    }

    @GetMapping("/products/{productId}")
    public Result<AdminProductDetailVO> getProductDetailForAdmin(@PathVariable Long productId) {
        log.info("[商品管理详情] productId={}", productId);
        try {
            AdminProductDetailVO vo = auditService.getProductDetailForAdmin(productId);
            log.info("[商品管理详情] 成功, productId={}, title={}, merchantName={}", productId, vo.getTitle(), vo.getMerchantName());
            return Result.ok(vo);
        } catch (RuntimeException e) {
            log.warn("[商品管理详情] 失败, productId={}, 原因: {}", productId, e.getMessage());
            throw e;
        }
    }

    @PatchMapping("/products/{productId}/off-shelf")
    public Result<Map<String, Object>> offShelfProduct(@PathVariable Long productId,
                                                        @RequestBody Map<String, Object> body) {
        String reason = (String) body.get("reason");
        log.info("[强制下架] productId={}, reason={}", productId, reason);
        try {
            Map<String, Object> result = auditService.offShelfProduct(productId, reason);
            log.info("[强制下架] 成功, productId={}, message={}", productId, result.get("message"));
            return Result.ok(result);
        } catch (RuntimeException e) {
            log.warn("[强制下架] 失败, productId={}, 原因: {}", productId, e.getMessage());
            throw e;
        }
    }

    @GetMapping("/categories")
    public Result<List<Map<String, Object>>> getAdminCategories() {
        log.info("[管理端分类列表]");
        try {
            List<Map<String, Object>> categories = auditService.getAdminCategories();
            log.info("[管理端分类列表] 成功, count={}", categories.size());
            return Result.ok(categories);
        } catch (RuntimeException e) {
            log.warn("[管理端分类列表] 失败, 原因: {}", e.getMessage());
            throw e;
        }
    }

    // ==================== 商家信息变更审核 ====================

    @GetMapping("/info-changes")
    public Result<PageResult<Map<String, Object>>> getInfoChanges(
            @RequestParam(required = false) Integer auditStatus,
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize) {
        log.info("[信息变更列表] auditStatus={}, keyword={}, pageNum={}, pageSize={}", auditStatus, keyword, pageNum, pageSize);
        try {
            PageResult<Map<String, Object>> pageResult = auditService.getInfoChanges(auditStatus, keyword, pageNum, pageSize);
            log.info("[信息变更列表] 成功, total={}", pageResult.getTotal());
            return Result.ok(pageResult);
        } catch (RuntimeException e) {
            log.warn("[信息变更列表] 失败, 原因: {}", e.getMessage());
            throw e;
        }
    }

    @PostMapping("/info-changes/{changeId}/audit")
    public Result<Map<String, Object>> auditInfoChange(@PathVariable Long changeId,
                                                        @RequestBody AuditRequest req) {
        log.info("[信息变更审核] changeId={}, 请求体: auditStatus={}, auditRemark={}", changeId, req.getAuditStatus(), req.getAuditRemark());
        try {
            Map<String, Object> result = auditService.auditInfoChange(changeId, req.getAuditStatus(), req.getAuditRemark());
            log.info("[信息变更审核] 成功, changeId={}, result={}", changeId, result.get("auditStatus"));
            return Result.ok(result);
        } catch (RuntimeException e) {
            log.warn("[信息变更审核] 失败, changeId={}, 原因: {}", changeId, e.getMessage());
            throw e;
        }
    }

    // ==================== 自提点审核 ====================

    @GetMapping("/pickup-points")
    public Result<PageResult<Map<String, Object>>> getPendingPickupPoints(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize) {
        log.info("[自提点审核列表] pageNum={}, pageSize={}", pageNum, pageSize);
        try {
            PageResult<Map<String, Object>> result = pickupPointService.getPendingPoints(pageNum, pageSize);
            log.info("[自提点审核列表] 成功, total={}", result.getTotal());
            return Result.ok(result);
        } catch (RuntimeException e) {
            log.warn("[自提点审核列表] 失败, 原因: {}", e.getMessage());
            throw e;
        }
    }

    @PostMapping("/pickup-points/{pointId}/audit")
    public Result<Map<String, Object>> auditPickupPoint(
            @PathVariable Long pointId,
            @RequestBody Map<String, Object> body) {
        Integer auditStatus = (Integer) body.get("auditStatus");
        String auditRemark = (String) body.get("auditRemark");
        log.info("[自提点审核] pointId={}, auditStatus={}, auditRemark={}", pointId, auditStatus, auditRemark);
        try {
            Map<String, Object> result = pickupPointService.auditPickupPoint(pointId, auditStatus, auditRemark);
            log.info("[自提点审核] 成功, pointId={}, auditedStatus={}", pointId, auditStatus);
            return Result.ok(result);
        } catch (RuntimeException e) {
            log.warn("[自提点审核] 失败, pointId={}, 原因: {}", pointId, e.getMessage());
            throw e;
        }
    }
}
