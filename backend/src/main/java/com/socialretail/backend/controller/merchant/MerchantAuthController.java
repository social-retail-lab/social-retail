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
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/merchant")
public class MerchantAuthController {

    @Resource
    private MerchantService merchantService;

    @PostMapping("/applications")
    public Result<MerchantApplyVO> submitApplication(HttpServletRequest request,
                                                     @RequestBody MerchantApplyRequest req) {
        Long userId = (Long) request.getAttribute("userId");
        MerchantApplyVO vo = merchantService.submitApplication(userId, req);
        return Result.ok(vo);
    }

    @GetMapping("/applications/status")
    public Result<MerchantApplyVO> getApplicationStatus(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        MerchantApplyVO vo = merchantService.getApplicationStatus(userId);
        return Result.ok(vo);
    }

    @PostMapping("/auth/login")
    public Result<LoginVO> merchantLogin(@RequestBody MerchantLoginRequest req) {
        LoginVO vo = merchantService.merchantLogin(req.getPhone(), req.getPassword(), req.getSmsCode());
        return Result.ok(vo);
    }

    @PostMapping("/auth/logout")
    public Result<Void> logout() {
        return Result.ok("已退出登录", null);
    }

    @GetMapping("/info")
    public Result<MerchantInfoVO> getCurrentMerchant(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        MerchantInfoVO vo = merchantService.getCurrentMerchant(userId);
        return Result.ok(vo);
    }

    @PutMapping("/info")
    public Result<MerchantInfoVO> updateMerchantInfo(HttpServletRequest request,
                                                     @RequestBody MerchantUpdateRequest req) {
        Long userId = (Long) request.getAttribute("userId");
        MerchantInfoVO vo = merchantService.updateMerchantInfo(userId, req);
        return Result.ok(vo);
    }

    @PostMapping("/qualifications")
    public Result<QualificationVO> uploadQualification(HttpServletRequest request,
                                                       @RequestBody QualificationRequest req) {
        Long userId = (Long) request.getAttribute("userId");
        QualificationVO vo = merchantService.uploadQualification(userId, req);
        return Result.ok(vo);
    }

    @GetMapping("/qualifications")
    public Result<QualificationVO> getQualification(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        QualificationVO vo = merchantService.getQualification(userId);
        return Result.ok(vo);
    }

    @GetMapping("/store")
    public Result<MerchantInfoVO> getCurrentMerchantStore(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        MerchantInfoVO vo = merchantService.getCurrentMerchant(userId);
        return Result.ok(vo);
    }

    @PutMapping("/store")
    public Result<MerchantInfoVO> updateMerchantInfoStore(HttpServletRequest request,
                                                          @RequestBody MerchantUpdateRequest req) {
        Long userId = (Long) request.getAttribute("userId");
        MerchantInfoVO vo = merchantService.updateMerchantInfo(userId, req);
        return Result.ok(vo);
    }
}
