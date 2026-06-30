package com.socialretail.backend.controller.user;

import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.dto.request.product.ProductQueryDTO;
import com.socialretail.backend.service.product.ProductService;
import com.socialretail.backend.vo.ProductDetailVO;
import com.socialretail.backend.vo.ProductListVO;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Positive;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Optional;

@Validated
@RestController
@RequestMapping("/api/products")
public class ProductController {

    private final Optional<ProductService> productService;

    public ProductController(Optional<ProductService> productService) {
        this.productService = productService;
    }

    @GetMapping
    public Result<PageResult<ProductListVO>> listProducts(
            @Valid @ModelAttribute ProductQueryDTO dto) {
        PageResult<ProductListVO> result = productService
                .map(service -> service.listProducts(dto))
                .orElseGet(() -> PageResult.empty(dto.getPage(), dto.getSize()));
        return Result.success(result);
    }

    @GetMapping("/{productId}")
    public Result<ProductDetailVO> getProductDetail(
            @Positive(message = "商品ID必须大于0") @PathVariable Long productId) {
        ProductDetailVO result = productService
                .map(service -> service.getProductDetail(productId))
                .orElseGet(() -> emptyDetail(productId));
        return Result.success(result);
    }

    @GetMapping("/search")
    public Result<PageResult<ProductListVO>> searchProducts(
            @Valid @ModelAttribute ProductQueryDTO dto) {
        PageResult<ProductListVO> result = productService
                .map(service -> service.searchProducts(dto))
                .orElseGet(() -> PageResult.empty(dto.getPage(), dto.getSize()));
        return Result.success(result);
    }

    private ProductDetailVO emptyDetail(Long productId) {
        return new ProductDetailVO(productId, null, null, List.of(), null, List.of());
    }
}
