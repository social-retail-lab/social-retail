package com.socialretail.backend.controller.member;

import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.config.JwtInterceptor;
import com.socialretail.backend.dto.member.MemberApiModels.GrowthLogItem;
import com.socialretail.backend.dto.member.MemberApiModels.PageData;
import com.socialretail.backend.service.member.GrowthService;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@Validated
@RestController
@RequestMapping("/api/growth")
public class GrowthController {
    private final GrowthService growthService;
    public GrowthController(GrowthService growthService) { this.growthService = growthService; }

    @GetMapping("/logs")
    public Result<PageData<GrowthLogItem>> logs(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @RequestParam(required = false) Integer type,
            @RequestParam(defaultValue = "1") @Min(1) Integer page,
            @RequestParam(defaultValue = "10") @Min(1) @Max(100) Integer pageSize) {
        return Result.success(growthService.listLogs(userId, type, page, pageSize));
    }
}
