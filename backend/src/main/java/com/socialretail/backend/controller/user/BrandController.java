package com.socialretail.backend.controller.user;

import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.dto.request.product.BrandQueryDTO;
import com.socialretail.backend.dto.request.product.CatalogProductQueryDTO;
import com.socialretail.backend.service.product.BrandService;
import com.socialretail.backend.vo.BrandProductPageVO;
import com.socialretail.backend.vo.BrandVO;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Positive;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Validated
@RestController
@RequestMapping("/api/brands")
public class BrandController {

    private final BrandService brandService;

    public BrandController(BrandService brandService) {
        this.brandService = brandService;
    }

    @GetMapping
    public Result<PageResult<BrandVO>> listBrands(@Valid @ModelAttribute BrandQueryDTO query) {
        return Result.success(brandService.listBrands(query));
    }

    @GetMapping("/{brandId}/products")
    public Result<BrandProductPageVO> listBrandProducts(
            @Positive(message = "品牌ID必须大于0") @PathVariable Long brandId,
            @Valid @ModelAttribute CatalogProductQueryDTO query) {
        return Result.success(brandService.listBrandProducts(brandId, query));
    }
}
