package com.socialretail.backend.controller.merchant;

import com.socialretail.backend.common.Result;
import com.socialretail.backend.service.merchant.MerchantService;
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
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/api/merchant")
public class MerchantAuthController {

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
            log.info("[查询申请状态] 成功, applyId={}, auditStatus={}", vo.getApplyId(), vo.getAuditStatus());
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
}
