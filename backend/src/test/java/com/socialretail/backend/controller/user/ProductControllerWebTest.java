package com.socialretail.backend.controller.user;

import com.socialretail.backend.common.GlobalExceptionHandler;
import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.dto.request.product.ProductQueryDTO;
import com.socialretail.backend.service.product.ProductService;
import com.socialretail.backend.utils.JwtUtil;
import com.socialretail.backend.vo.ProductDetailVO;
import com.socialretail.backend.vo.ProductListVO;
import com.socialretail.backend.vo.ProductSkuListVO;
import com.socialretail.backend.vo.ProductSkuVO;
import com.socialretail.backend.vo.SkuVO;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.context.ContextConfiguration;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(ProductController.class)
@ContextConfiguration(classes = {ProductController.class, GlobalExceptionHandler.class})
class ProductControllerWebTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private ProductService productService;

    @MockBean
    private JwtUtil jwtUtil;

    @Test
    void listProductsReturnsPagedStructure() throws Exception {
        when(productService.listProducts(any())).thenReturn(
                new PageResult<>(List.of(productListVO()), 21L, 3, 1, 10)
        );

        mockMvc.perform(get("/api/products")
                        .param("categoryId", "1")
                        .param("page", "1")
                        .param("size", "10")
                        .param("sort", "price_asc"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(0))
                .andExpect(jsonPath("$.data.list[0].productId").value(1001))
                .andExpect(jsonPath("$.data.total").value(21))
                .andExpect(jsonPath("$.data.pages").value(3))
                .andExpect(jsonPath("$.data.page").value(1))
                .andExpect(jsonPath("$.data.pageSize").value(10));
    }

    @Test
    void productDetailReturnsSkuList() throws Exception {
        ProductDetailVO detail = new ProductDetailVO();
        detail.setProductId(1001L);
        detail.setProductName("新疆阿克苏苹果");
        detail.setDescription("冰糖心苹果");
        detail.setProductImage("https://example.com/main.jpg");
        detail.setDetailImages(List.of("https://example.com/1.jpg"));
        detail.setPrice(new BigDecimal("39.90"));
        detail.setSkuList(List.of(new SkuVO(
                2001L,
                Map.of("重量", "5斤"),
                new BigDecimal("39.90"),
                100
        )));
        when(productService.getProductDetail(1001L)).thenReturn(detail);

        mockMvc.perform(get("/api/products/1001"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.productId").value(1001))
                .andExpect(jsonPath("$.data.productImage").value("https://example.com/main.jpg"))
                .andExpect(jsonPath("$.data.detailImages[0]").value("https://example.com/1.jpg"))
                .andExpect(jsonPath("$.data.skuList[0].skuId").value(2001))
                .andExpect(jsonPath("$.data.skuList[0].spec.重量").value("5斤"))
                .andExpect(jsonPath("$.data.skuList[0].stock").value(100));
    }

    @Test
    void productSkusReturnsCompleteStructure() throws Exception {
        when(productService.listProductSkus(1001L)).thenReturn(new ProductSkuListVO(
                1001L,
                List.of(new ProductSkuVO(
                        2001L, "5斤装", Map.of("重量", "5斤"),
                        new BigDecimal("99.90"), new BigDecimal("99.90"),
                        200, 0, "ON_SALE"
                ))
        ));

        mockMvc.perform(get("/api/products/1001/skus"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.productId").value(1001))
                .andExpect(jsonPath("$.data.skuList[0].skuName").value("5斤装"))
                .andExpect(jsonPath("$.data.skuList[0].specs.重量").value("5斤"))
                .andExpect(jsonPath("$.data.skuList[0].lockedStock").value(0))
                .andExpect(jsonPath("$.data.skuList[0].status").value("ON_SALE"));
    }

    @Test
    void searchProductsUsesSearchServiceMethod() throws Exception {
        when(productService.searchProducts(any())).thenReturn(
                new PageResult<>(List.of(productListVO()), 1L, 1, 1, 10)
        );

        mockMvc.perform(get("/api/products/search")
                        .param("keyword", "苹果")
                        .param("categoryId", "1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.list[0].title").value("新疆阿克苏苹果"));

        verify(productService).searchProducts(any(ProductQueryDTO.class));
    }

    @Test
    void pageSizeOver100Returns40001() throws Exception {
        mockMvc.perform(get("/api/products").param("size", "101"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value(40001));
    }

    private ProductListVO productListVO() {
        return new ProductListVO(
                1001L,
                "新疆阿克苏苹果",
                "https://example.com/main.jpg",
                new BigDecimal("39.90"),
                568L
        );
    }
}
