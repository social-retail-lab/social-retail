package com.socialretail.backend.controller.member;

import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.config.JwtInterceptor;
import com.socialretail.backend.dto.member.MemberApiModels.UpgradeRequest;
import com.socialretail.backend.dto.member.MemberApiModels.UpgradeResult;
import com.socialretail.backend.service.member.MemberLevelService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/internal/member")
public class InternalMemberController {
    private final MemberLevelService memberLevelService;
    public InternalMemberController(MemberLevelService memberLevelService) { this.memberLevelService = memberLevelService; }

    @PostMapping("/level-upgrade")
    public Result<UpgradeResult> upgrade(
            @RequestAttribute(JwtInterceptor.USER_TYPE_ATTRIBUTE) String userType,
            @Valid @RequestBody(required = false) UpgradeRequest request) {
        if (!"admin".equals(userType)) {
            throw new BusinessException(40301, HttpStatus.FORBIDDEN, "无内部任务权限");
        }
        Long userId = request == null ? null : request.userId();
        return Result.success("会员等级升级处理完成", memberLevelService.upgrade(userId));
    }
}
