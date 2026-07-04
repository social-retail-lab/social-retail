package com.socialretail.backend.controller.user;

import com.socialretail.backend.common.JwtUtils;
import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.dto.merchant.MerchantHomeApiModels.MerchantBasic;
import com.socialretail.backend.dto.merchant.MerchantHomeApiModels.MerchantHome;
import com.socialretail.backend.dto.merchant.MerchantHomeApiModels.MerchantProductPage;
import com.socialretail.backend.dto.merchant.MerchantHomeApiModels.MerchantProductSearchPage;
import com.socialretail.backend.service.merchant.CustomerMerchantHomeService;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Positive;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Validated
@RestController
@RequestMapping("/api/merchants")
public class MerchantHomeController {
    private static final String BEARER_PREFIX = "Bearer ";

    private final CustomerMerchantHomeService merchantHomeService;
    private final JwtUtils jwtUtils;

    public MerchantHomeController(CustomerMerchantHomeService merchantHomeService, JwtUtils jwtUtils) {
        this.merchantHomeService = merchantHomeService;
        this.jwtUtils = jwtUtils;
    }

    @GetMapping("/{merchantId}/home")
    public Result<MerchantHome> home(
            @Positive(message = "merchantId必须大于0") @PathVariable Long merchantId,
            @RequestHeader(value = "Authorization", required = false) String authorization) {
        return Result.success(merchantHomeService.home(merchantId, optionalUserId(authorization)));
    }

    @GetMapping("/{merchantId}")
    public Result<MerchantBasic> basic(
            @Positive(message = "merchantId必须大于0") @PathVariable Long merchantId) {
        return Result.success(merchantHomeService.basic(merchantId));
    }

    @GetMapping("/{merchantId}/products")
    public Result<MerchantProductPage> products(
            @Positive(message = "merchantId必须大于0") @PathVariable Long merchantId,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer saleType,
            @RequestParam(defaultValue = "DEFAULT") String sort,
            @Min(value = 1, message = "page必须大于0") @RequestParam(defaultValue = "1") int page,
            @Min(value = 1, message = "pageSize必须大于0")
            @Max(value = 100, message = "pageSize不能超过100")
            @RequestParam(defaultValue = "10") int pageSize) {
        return Result.success(merchantHomeService.products(
                merchantId, keyword, saleType, sort, page, pageSize));
    }

    @GetMapping("/{merchantId}/products/search")
    public Result<MerchantProductSearchPage> search(
            @Positive(message = "merchantId必须大于0") @PathVariable Long merchantId,
            @RequestParam(required = false) String keyword,
            @Min(value = 1, message = "page必须大于0") @RequestParam(defaultValue = "1") int page,
            @Min(value = 1, message = "pageSize必须大于0")
            @Max(value = 100, message = "pageSize不能超过100")
            @RequestParam(defaultValue = "10") int pageSize) {
        return Result.success(merchantHomeService.search(merchantId, keyword, page, pageSize));
    }

    private Long optionalUserId(String authorization) {
        if (authorization == null || !authorization.startsWith(BEARER_PREFIX)) {
            return null;
        }
        String token = authorization.substring(BEARER_PREFIX.length()).trim();
        if (token.isEmpty() || !jwtUtils.validateToken(token)) {
            return null;
        }
        try {
            return jwtUtils.getUserId(token);
        } catch (RuntimeException ignored) {
            return null;
        }
    }
}
