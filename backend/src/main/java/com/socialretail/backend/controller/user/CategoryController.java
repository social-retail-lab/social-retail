package com.socialretail.backend.controller.user;

import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.dto.request.product.CatalogProductQueryDTO;
import com.socialretail.backend.service.product.CategoryService;
import com.socialretail.backend.vo.CategoryProductPageVO;
import com.socialretail.backend.vo.CategoryTreeResultVO;
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
@RequestMapping("/api/categories")
public class CategoryController {

    private final CategoryService categoryService;

    public CategoryController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @GetMapping("/tree")
    public Result<CategoryTreeResultVO> getCategoryTree() {
        return Result.success(categoryService.getCategoryTree());
    }

    @GetMapping("/{categoryId}/products")
    public Result<CategoryProductPageVO> listCategoryProducts(
            @Positive(message = "分类ID必须大于0") @PathVariable Long categoryId,
            @Valid @ModelAttribute CatalogProductQueryDTO query) {
        return Result.success(categoryService.listCategoryProducts(categoryId, query));
    }
}
