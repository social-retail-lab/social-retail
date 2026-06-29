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
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

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
        PageResult<MerchantApplicationListVO> pageResult = auditService.getMerchantApplications(
                auditStatus, keyword, startDate, endDate, pageNum, pageSize);
        return Result.ok(pageResult);
    }

    @PostMapping("/merchant/applications/{applyId}/audit")
    public Result<AuditVO> auditMerchantApplication(@PathVariable Long applyId,
                                                    @RequestBody AuditRequest req) {
        AuditVO vo = auditService.auditMerchantApplication(applyId, req.getAuditStatus(), req.getAuditRemark());
        return Result.ok(vo);
    }

    @GetMapping("/merchants")
    public Result<PageResult<MerchantListVO>> getMerchantList(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize) {
        PageResult<MerchantListVO> pageResult = auditService.getMerchantList(keyword, status, pageNum, pageSize);
        return Result.ok(pageResult);
    }

    @GetMapping("/merchants/{merchantId}")
    public Result<Map<String, Object>> getMerchantDetail(@PathVariable Long merchantId) {
        Map<String, Object> detail = auditService.getMerchantDetail(merchantId);
        return Result.ok(detail);
    }

    @PatchMapping("/merchants/{merchantId}/status")
    public Result<Map<String, Object>> updateMerchantStatus(@PathVariable Long merchantId,
                                                            @RequestBody Map<String, Object> body) {
        Integer status = body.get("status") != null ? ((Number) body.get("status")).intValue() : null;
        String reason = (String) body.get("reason");
        Map<String, Object> result = auditService.updateMerchantStatus(merchantId, status, reason);
        return Result.ok(result);
    }

    @GetMapping("/products/audits")
    public Result<PageResult<ProductAuditListVO>> getProductAuditList(
            @RequestParam(required = false) Integer auditStatus,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Long merchantId,
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize) {
        PageResult<ProductAuditListVO> pageResult = auditService.getProductAuditList(
                auditStatus, keyword, merchantId, pageNum, pageSize);
        return Result.ok(pageResult);
    }

    @PostMapping("/products/{productId}/audit")
    public Result<AuditVO> auditProduct(@PathVariable Long productId,
                                        @RequestBody AuditRequest req) {
        AuditVO vo = auditService.auditProduct(productId, req.getAuditStatus(), req.getAuditRemark());
        return Result.ok(vo);
    }
}
