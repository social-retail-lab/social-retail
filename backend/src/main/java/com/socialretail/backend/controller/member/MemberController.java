package com.socialretail.backend.controller.member;

import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.config.JwtInterceptor;
import com.socialretail.backend.dto.member.MemberApiModels.LevelList;
import com.socialretail.backend.dto.member.MemberApiModels.MemberInfo;
import com.socialretail.backend.service.member.MemberLevelService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/member")
public class MemberController {
    private final MemberLevelService memberLevelService;
    public MemberController(MemberLevelService memberLevelService) { this.memberLevelService = memberLevelService; }

    @GetMapping("/info")
    public Result<MemberInfo> info(@RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId) {
        return Result.success(memberLevelService.getInfo(userId));
    }

    @GetMapping("/levels")
    public Result<LevelList> levels(@RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId) {
        return Result.success(memberLevelService.listLevels(userId));
    }
}
