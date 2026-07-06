package com.socialretail.backend.controller.merchant;

import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.Result;
import com.socialretail.backend.service.merchant.MerchantService;
import com.socialretail.backend.vo.AuditRequestVO;
import com.socialretail.backend.vo.InfoChangeRequest;
import com.socialretail.backend.vo.LoginVO;
import com.socialretail.backend.vo.MerchantApplyRequest;
import com.socialretail.backend.vo.MerchantApplyVO;
import com.socialretail.backend.vo.MerchantInfoVO;
import com.socialretail.backend.vo.MerchantLoginRequest;
import com.socialretail.backend.vo.MerchantUpdateRequest;
import com.socialretail.backend.vo.QualificationRequest;
import com.socialretail.backend.vo.QualificationVO;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/merchant")
public class MerchantAuthController {

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(MerchantAuthController.class);

    @Resource
    private MerchantService merchantService;

    @PostMapping("/applications")
    public Result<MerchantApplyVO> submitApplication(HttpServletRequest request,
                                                     @RequestBody MerchantApplyRequest req) {
        Long userId = (Long) request.getAttribute("userId");
        log.info("[入驻申请] userId={}, 请求体: applyType={}, companyName={}, contactName={}, contactPhone={}, shopName={}",
                userId, req.getApplyType(), req.getCompanyName(), req.getContactName(), req.getContactPhone(), req.getShopName());
        try {
            MerchantApplyVO vo = merchantService.submitApplication(userId, req);
            log.info("[入驻申请] 成功, applyId={}, auditStatus={}", vo.getApplyId(), vo.getAuditStatus());
            return Result.ok(vo);
        } catch (RuntimeException e) {
            log.warn("[入驻申请] 失败, userId={}, 原因: {}", userId, e.getMessage());
            throw e;
        }
    }

    @GetMapping("/applications/status")
    public Result<MerchantApplyVO> getApplicationStatus(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        log.info("[查询申请状态] userId={}", userId);
        try {
            MerchantApplyVO vo = merchantService.getApplicationStatus(userId);
            if (vo != null) {
                log.info("[查询申请状态] 成功, applyId={}, auditStatus={}", vo.getApplyId(), vo.getAuditStatus());
            } else {
                log.info("[查询申请状态] 成功, 无申请记录");
            }
            return Result.ok(vo);
        } catch (RuntimeException e) {
            log.warn("[查询申请状态] 失败, userId={}, 原因: {}", userId, e.getMessage());
            throw e;
        }
    }

    @PostMapping("/auth/login")
    public Result<LoginVO> merchantLogin(@RequestBody MerchantLoginRequest req) {
        log.info("[商家登录] 请求体: phone={}, smsCode={}", req.getPhone(), req.getSmsCode());
        try {
            LoginVO vo = merchantService.merchantLogin(req.getPhone(), req.getPassword(), req.getSmsCode());
            log.info("[商家登录] 成功, phone={}, merchantStatus={}", req.getPhone(), vo.getMerchantStatus());
            return Result.ok(vo);
        } catch (RuntimeException e) {
            log.warn("[商家登录] 失败, phone={}, 原因: {}", req.getPhone(), e.getMessage());
            throw e;
        }
    }

    @PostMapping("/auth/logout")
    public Result<Void> logout() {
        log.info("[商家退出] 退出登录");
        return Result.ok("已退出登录", null);
    }

    @GetMapping("/info")
    public Result<MerchantInfoVO> getCurrentMerchant(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        log.info("[获取商家信息] userId={}", userId);
        try {
            MerchantInfoVO vo = merchantService.getCurrentMerchant(userId);
            log.info("[获取商家信息] 成功, merchantId={}, merchantName={}", vo.getMerchantId(), vo.getMerchantName());
            return Result.ok(vo);
        } catch (RuntimeException e) {
            log.warn("[获取商家信息] 失败, userId={}, 原因: {}", userId, e.getMessage());
            throw e;
        }
    }

    @PutMapping("/info")
    public Result<MerchantInfoVO> updateMerchantInfo(HttpServletRequest request,
                                                     @RequestBody MerchantUpdateRequest req) {
        Long userId = (Long) request.getAttribute("userId");
        log.info("[修改商家信息] userId={}, 请求体: merchantName={}, contactName={}, contactPhone={}, shopAddress={}",
                userId, req.getMerchantName(), req.getContactName(), req.getContactPhone(), req.getShopAddress());
        try {
            MerchantInfoVO vo = merchantService.updateMerchantInfo(userId, req);
            log.info("[修改商家信息] 成功, merchantId={}", vo.getMerchantId());
            return Result.ok(vo);
        } catch (RuntimeException e) {
            log.warn("[修改商家信息] 失败, userId={}, 原因: {}", userId, e.getMessage());
            throw e;
        }
    }

    @PostMapping("/qualifications")
    public Result<QualificationVO> uploadQualification(HttpServletRequest request,
                                                       @RequestBody QualificationRequest req) {
        Long userId = (Long) request.getAttribute("userId");
        log.info("[上传资质] userId={}, 请求体: businessCategory={}, licenseNumber={}, foodPermitNumber={}",
                userId, req.getBusinessCategory(), req.getLicenseNumber(), req.getFoodPermitNumber());
        try {
            QualificationVO vo = merchantService.uploadQualification(userId, req);
            log.info("[上传资质] 成功, qualificationId={}", vo.getQualificationId());
            return Result.ok(vo);
        } catch (RuntimeException e) {
            log.warn("[上传资质] 失败, userId={}, 原因: {}", userId, e.getMessage());
            throw e;
        }
    }

    @GetMapping("/qualifications")
    public Result<QualificationVO> getQualification(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        log.info("[查看资质] userId={}", userId);
        try {
            QualificationVO vo = merchantService.getQualification(userId);
            log.info("[查看资质] 成功, qualificationId={}", vo.getQualificationId());
            return Result.ok(vo);
        } catch (RuntimeException e) {
            log.warn("[查看资质] 失败, userId={}, 原因: {}", userId, e.getMessage());
            throw e;
        }
    }

    @GetMapping("/store")
    public Result<MerchantInfoVO> getCurrentMerchantStore(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        log.info("[获取店铺信息] userId={}", userId);
        try {
            MerchantInfoVO vo = merchantService.getCurrentMerchant(userId);
            log.info("[获取店铺信息] 成功, merchantId={}, merchantName={}", vo.getMerchantId(), vo.getMerchantName());
            return Result.ok(vo);
        } catch (RuntimeException e) {
            log.warn("[获取店铺信息] 失败, userId={}, 原因: {}", userId, e.getMessage());
            throw e;
        }
    }

    @PutMapping("/store")
    public Result<MerchantInfoVO> updateMerchantInfoStore(HttpServletRequest request,
                                                          @RequestBody MerchantUpdateRequest req) {
        Long userId = (Long) request.getAttribute("userId");
        log.info("[修改店铺信息] userId={}, 请求体: shopAddress={}, contactPhone={}, businessHours={}, introduction={}",
                userId, req.getShopAddress(), req.getContactPhone(), req.getBusinessHours(), req.getIntroduction());
        try {
            MerchantInfoVO vo = merchantService.updateMerchantInfo(userId, req);
            log.info("[修改店铺信息] 成功, merchantId={}", vo.getMerchantId());
            return Result.ok(vo);
        } catch (RuntimeException e) {
            log.warn("[修改店铺信息] 失败, userId={}, 原因: {}", userId, e.getMessage());
            throw e;
        }
    }

    @PostMapping("/auth/appeal")
    public Result<Map<String, Object>> appeal(HttpServletRequest request,
                                              @RequestBody Map<String, Object> body) {
        Long userId = (Long) request.getAttribute("userId");
        String reason = (String) body.get("reason");
        log.info("[商家申诉] userId={}, reason={}", userId, reason);
        try {
            Map<String, Object> result = merchantService.appeal(userId, reason);
            log.info("[商家申诉] 成功, userId={}, message={}", userId, result.get("message"));
            return Result.ok(result);
        } catch (RuntimeException e) {
            log.warn("[商家申诉] 失败, userId={}, 原因: {}", userId, e.getMessage());
            throw e;
        }
    }

    // ==================== 商家信息变更审核 ====================

    @PostMapping("/info/change")
    public Result<Map<String, Object>> requestInfoChange(HttpServletRequest request,
                                                         @RequestBody InfoChangeRequest req) {
        Long userId = (Long) request.getAttribute("userId");
        log.info("[信息修改申请] userId={}", userId);
        try {
            Map<String, Object> result = merchantService.requestInfoChange(userId, req);
            log.info("[信息修改申请] 成功, changeId={}", result.get("changeId"));
            return Result.ok(result);
        } catch (RuntimeException e) {
            log.warn("[信息修改申请] 失败, userId={}, 原因: {}", userId, e.getMessage());
            throw e;
        }
    }

    @PostMapping("/qualification/upgrade")
    public Result<Map<String, Object>> requestQualificationUpgrade(HttpServletRequest request,
                                                                    @RequestBody MerchantApplyRequest req) {
        Long userId = (Long) request.getAttribute("userId");
        log.info("[升级企业资质申请] userId={}", userId);
        try {
            Map<String, Object> result = merchantService.requestQualificationUpgrade(userId, req);
            log.info("[升级企业资质申请] 成功, changeId={}", result.get("changeId"));
            return Result.ok(result);
        } catch (RuntimeException e) {
            log.warn("[升级企业资质申请] 失败, userId={}, 原因: {}", userId, e.getMessage());
            throw e;
        }
    }

    @PatchMapping("/pause")
    public Result<Map<String, Object>> togglePause(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        log.info("[暂时歇业/重新营业] userId={}", userId);
        try {
            Map<String, Object> result = merchantService.togglePause(userId);
            log.info("[暂时歇业/重新营业] 成功, userId={}, newStatus={}", userId, result.get("status"));
            return Result.ok(result);
        } catch (RuntimeException e) {
            log.warn("[暂时歇业/重新营业] 失败, userId={}, 原因: {}", userId, e.getMessage());
            throw e;
        }
    }

    // ==================== 审核请求 ====================

    @GetMapping("/audit-requests")
    public Result<PageResult<AuditRequestVO>> getAuditRequests(
            HttpServletRequest request,
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "20") int pageSize) {
        Long userId = (Long) request.getAttribute("userId");
        log.info("[审核请求列表] userId={}, pageNum={}, pageSize={}", userId, pageNum, pageSize);
        try {
            PageResult<AuditRequestVO> pageResult = merchantService.getAuditRequests(userId, pageNum, pageSize);
            log.info("[审核请求列表] 成功, userId={}, total={}", userId, pageResult.getTotal());
            return Result.ok(pageResult);
        } catch (RuntimeException e) {
            log.warn("[审核请求列表] 失败, userId={}, 原因: {}", userId, e.getMessage());
            throw e;
        }
    }

    @GetMapping("/audit-requests/{id}/detail")
    public Result<Map<String, Object>> getAuditRequestDetail(
            HttpServletRequest request,
            @PathVariable Long id,
            @RequestParam String requestType) {
        Long userId = (Long) request.getAttribute("userId");
        log.info("[审核请求详情] userId={}, requestId={}, requestType={}", userId, id, requestType);
        try {
            Map<String, Object> detail = merchantService.getAuditRequestDetail(id, requestType);
            log.info("[审核请求详情] 成功, requestId={}", id);
            return Result.ok(detail);
        } catch (RuntimeException e) {
            log.warn("[审核请求详情] 失败, requestId={}, 原因: {}", id, e.getMessage());
            throw e;
        }
    }

    @PostMapping("/audit-requests/{id}/withdraw")
    public Result<Map<String, Object>> withdrawAuditRequest(
            HttpServletRequest request,
            @PathVariable Long id,
            @RequestBody Map<String, Object> body) {
        Long userId = (Long) request.getAttribute("userId");
        String requestType = (String) body.get("requestType");
        log.info("[撤回审核请求] userId={}, requestId={}, requestType={}", userId, id, requestType);
        try {
            Map<String, Object> result = merchantService.withdrawAuditRequest(userId, id, requestType);
            log.info("[撤回审核请求] 成功, requestId={}", id);
            return Result.ok(result);
        } catch (RuntimeException e) {
            log.warn("[撤回审核请求] 失败, requestId={}, 原因: {}", id, e.getMessage());
            throw e;
        }
    }
}

