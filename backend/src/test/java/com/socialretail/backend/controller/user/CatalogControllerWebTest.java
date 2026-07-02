package com.socialretail.backend.controller.user;

import com.socialretail.backend.common.GlobalExceptionHandler;
import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.service.product.BrandService;
import com.socialretail.backend.service.product.CategoryService;
import com.socialretail.backend.vo.BrandProductPageVO;
import com.socialretail.backend.vo.BrandVO;
import com.socialretail.backend.vo.CatalogProductVO;
import com.socialretail.backend.vo.CategoryProductPageVO;
import com.socialretail.backend.vo.CategoryTreeResultVO;
import com.socialretail.backend.vo.CategoryTreeVO;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.HttpStatus;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.web.servlet.MockMvc;

import java.math.BigDecimal;
import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest({CategoryController.class, BrandController.class})
@ContextConfiguration(classes = {
        CategoryController.class, BrandController.class, GlobalExceptionHandler.class
})
class CatalogControllerWebTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private CategoryService categoryService;

    @MockBean
    private BrandService brandService;

    @Test
    void categoryTreeUsesListWrapper() throws Exception {
        CategoryTreeVO child = new CategoryTreeVO(11L, "进口水果", 1L, 2, 1, List.of());
        CategoryTreeVO root = new CategoryTreeVO(1L, "水果生鲜", 0L, 1, 1, List.of(child));
        when(categoryService.getCategoryTree()).thenReturn(new CategoryTreeResultVO(List.of(root)));

        mockMvc.perform(get("/api/categories/tree"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.list[0].categoryName").value("水果生鲜"))
                .andExpect(jsonPath("$.data.list[0].children[0].categoryId").value(11));
    }

    @Test
    void categoryProductsReturnsDocumentedPage() throws Exception {
        when(categoryService.listCategoryProducts(eq(1L), any())).thenReturn(
                new CategoryProductPageVO(
                        1L, "水果生鲜", List.of(product()), 1L, 1, 1, 10
                )
        );

        mockMvc.perform(get("/api/categories/1/products").param("pageSize", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.categoryName").value("水果生鲜"))
                .andExpect(jsonPath("$.data.list[0].productName").value("进口车厘子"))
                .andExpect(jsonPath("$.data.pageSize").value(10));
    }

    @Test
    void brandsAndBrandProductsReturnCompleteStructures() throws Exception {
        when(brandService.listBrands(any())).thenReturn(PageResult.of(
                List.of(new BrandVO(2L, "优选生鲜", "logo.jpg", "优质生鲜品牌", 1)),
                1L, 1, 20
        ));
        when(brandService.listBrandProducts(eq(2L), any())).thenReturn(
                new BrandProductPageVO(2L, "优选生鲜", List.of(product()), 1L, 1, 1, 10)
        );

        mockMvc.perform(get("/api/brands"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.list[0].brandName").value("优选生鲜"))
                .andExpect(jsonPath("$.data.pageSize").value(20));

        mockMvc.perform(get("/api/brands/2/products"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.brandId").value(2))
                .andExpect(jsonPath("$.data.list[0].stock").value(200));
    }

    @Test
    void missingBrandReturns40404() throws Exception {
        when(brandService.listBrandProducts(eq(999L), any())).thenThrow(
                new BusinessException(40404, HttpStatus.NOT_FOUND, "品牌不存在")
        );

        mockMvc.perform(get("/api/brands/999/products"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.code").value(40404))
                .andExpect(jsonPath("$.message").value("品牌不存在"));
    }

    private CatalogProductVO product() {
        return new CatalogProductVO(
                1001L, "进口车厘子", "image.jpg",
                new BigDecimal("99.90"), new BigDecimal("99.90"),
                0L, 200, List.of()
        );
    }
}
