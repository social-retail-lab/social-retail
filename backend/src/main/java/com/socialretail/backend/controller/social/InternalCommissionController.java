package com.socialretail.backend.controller.social;

import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.dto.request.social.CommissionCalcRequest;
import com.socialretail.backend.dto.response.social.DistributorResponses;
import com.socialretail.backend.service.social.CommissionService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

@RestController
@RequestMapping("/internal/commission")
public class InternalCommissionController {
    private final CommissionService commissionService;
    private final String internalToken;

    public InternalCommissionController(CommissionService commissionService,
                                        @Value("${internal.api-token:}") String internalToken) {
        this.commissionService = commissionService;
        this.internalToken = internalToken;
    }

    @PostMapping("/calc")
    public Result<DistributorResponses.CommissionCalc> calculate(
            @RequestHeader("X-Internal-Token") String token,
            @Valid @RequestBody CommissionCalcRequest request) {
        if (internalToken.isBlank() || !constantTimeEquals(internalToken, token)) {
            throw new BusinessException(40101, HttpStatus.UNAUTHORIZED, "内部服务认证失败");
        }
        return Result.success("commission calculated", commissionService.calculate(request));
    }

    private static boolean constantTimeEquals(String expected, String actual) {
        if (actual == null) return false;
        return MessageDigest.isEqual(expected.getBytes(StandardCharsets.UTF_8),
                actual.getBytes(StandardCharsets.UTF_8));
    }
}
