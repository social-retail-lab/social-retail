package com.socialretail.backend.controller.user;

import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.dto.request.product.ProductQueryDTO;
import com.socialretail.backend.service.product.ProductService;
import com.socialretail.backend.vo.ProductDetailVO;
import com.socialretail.backend.vo.ProductCardVO;
import com.socialretail.backend.vo.ProductSkuListVO;
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
@RequestMapping("/api/products")
public class ProductController {

    private final ProductService productService;

    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping
    public Result<PageResult<ProductCardVO>> listProducts(
            @Valid @ModelAttribute ProductQueryDTO dto) {
        return Result.success(productService.listProducts(dto));
    }

    @GetMapping("/{productId}")
    public Result<ProductDetailVO> getProductDetail(
            @Positive(message = "商品ID必须大于0") @PathVariable Long productId) {
        return Result.success(productService.getProductDetail(productId));
    }

    @GetMapping("/{productId}/skus")
    public Result<ProductSkuListVO> listProductSkus(
            @Positive(message = "商品ID必须大于0") @PathVariable Long productId) {
        return Result.success(productService.listProductSkus(productId));
    }

    @GetMapping("/search")
    public Result<PageResult<ProductCardVO>> searchProducts(
            @Valid @ModelAttribute ProductQueryDTO dto) {
        return Result.success(productService.searchProducts(dto));
    }
}
