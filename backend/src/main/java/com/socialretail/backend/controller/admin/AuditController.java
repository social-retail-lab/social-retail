package com.socialretail.backend.controller.admin;

import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.Result;
import com.socialretail.backend.service.admin.AuditService;
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

import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/admin/operation")
public class AuditController {

    @Resource
    private AuditService auditService;

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
}
