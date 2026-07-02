package com.socialretail.backend.service.product;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.ImageUrlResolver;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.dto.request.product.ProductQueryDTO;
import com.socialretail.backend.entity.product.Product;
import com.socialretail.backend.entity.product.Sku;
import com.socialretail.backend.entity.product.Brand;
import com.socialretail.backend.entity.product.Category;
import com.socialretail.backend.entity.product.ProductCategoryRelation;
import com.socialretail.backend.entity.member.Merchant;
import com.socialretail.backend.mapper.product.ProductCategoryRelationMapper;
import com.socialretail.backend.mapper.product.ProductMapper;
import com.socialretail.backend.mapper.product.SkuMapper;
import com.socialretail.backend.mapper.product.BrandMapper;
import com.socialretail.backend.mapper.product.CategoryMapper;
import com.socialretail.backend.mapper.member.MerchantMapper;
import com.socialretail.backend.service.product.impl.ProductServiceImpl;
import com.socialretail.backend.vo.ProductDetailVO;
import com.socialretail.backend.vo.ProductListVO;
import com.socialretail.backend.vo.ProductSkuListVO;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ProductServiceImplTest {

    @Mock
    private ProductMapper productMapper;

    @Mock
    private SkuMapper skuMapper;

    @Mock
    private ProductCategoryRelationMapper relationMapper;

    @Mock
    private BrandMapper brandMapper;

    @Mock
    private CategoryMapper categoryMapper;

    @Mock
    private MerchantMapper merchantMapper;

    private ProductServiceImpl productService;

    @BeforeEach
    void setUp() {
        productService = new ProductServiceImpl(
                productMapper,
                skuMapper,
                relationMapper,
                brandMapper,
                categoryMapper,
                merchantMapper,
                new ObjectMapper(),
                new ImageUrlResolver("./uploads", "http://backend.test:8081")
        );
    }

    @Test
    void listProductsUsesMinimumSkuPriceAndPagination() {
        Product apple = product(6001L, "苹果");
        apple.setSoldCount(568L);
        Product orange = product(6002L, "橙子");
        when(productMapper.selectList(any())).thenReturn(List.of(apple, orange));
        when(skuMapper.selectList(any())).thenReturn(List.of(
                sku(8001L, 6001L, "39.90"),
                sku(8002L, 6001L, "69.90"),
                sku(8003L, 6002L, "45.00")
        ));

        ProductQueryDTO dto = new ProductQueryDTO();
        dto.setSort("price_asc");
        PageResult<ProductListVO> result = productService.listProducts(dto);

        assertEquals(2L, result.getTotal());
        assertEquals(1, result.getPages());
        assertEquals(6001L, result.getList().get(0).getProductId());
        assertEquals(new BigDecimal("39.90"), result.getList().get(0).getPrice());
        assertEquals(568L, result.getList().get(0).getSales());
    }

    @Test
    void categoryWithoutProductsReturnsEmptyPage() {
        when(relationMapper.selectList(any())).thenReturn(List.of());
        ProductQueryDTO dto = new ProductQueryDTO();
        dto.setCategoryId(999L);

        PageResult<ProductListVO> result = productService.listProducts(dto);

        assertEquals(0L, result.getTotal());
        verify(productMapper, never()).selectList(any());
    }

    @Test
    void productDetailParsesImagesAndSkuSpecs() {
        Product product = product(6001L, "苹果");
        product.setMainImage("https://example.com/main.jpg");
        product.setDetailImages("[\"https://example.com/1.jpg\"]");
        product.setDetailDesc("商品详情");
        product.setSoldCount(1234L);
        product.setBrandId(2L);
        product.setMerchantId(5001L);
        when(productMapper.selectOne(any())).thenReturn(product);

        Brand brand = new Brand();
        brand.setId(2L);
        brand.setName("优选生鲜");
        when(brandMapper.selectById(2L)).thenReturn(brand);
        ProductCategoryRelation relation = new ProductCategoryRelation();
        relation.setCategoryId(1L);
        when(relationMapper.selectOne(any())).thenReturn(relation);
        Category category = new Category();
        category.setId(1L);
        category.setName("水果生鲜");
        when(categoryMapper.selectById(1L)).thenReturn(category);
        Merchant merchant = new Merchant();
        merchant.setId(5001L);
        merchant.setMerchantName("某某生鲜店");
        merchant.setLogo("https://example.com/logo.jpg");
        when(merchantMapper.selectById(5001L)).thenReturn(merchant);

        Sku sku = sku(8001L, 6001L, "39.90");
        sku.setSpecs("{\"规格\":\"5斤装\"}");
        when(skuMapper.selectList(any())).thenReturn(List.of(sku));

        ProductDetailVO result = productService.getProductDetail(6001L);

        assertEquals("https://example.com/main.jpg", result.getProductImage());
        assertEquals(1, result.getDetailImages().size());
        assertEquals("5斤装", result.getSkuList().get(0).getSpec().get("规格"));
        assertEquals(new BigDecimal("39.90"), result.getPrice());
        assertEquals(100, result.getStock());
        assertEquals("水果生鲜", result.getCategoryName());
        assertEquals("优选生鲜", result.getBrandName());
        assertEquals("某某生鲜店", result.getMerchantInfo().merchantName());
        assertEquals(1234L, result.getSoldCount());
    }

    @Test
    void unavailableProductReturns40402() {
        when(productMapper.selectOne(any())).thenReturn(null);

        BusinessException exception = assertThrows(
                BusinessException.class,
                () -> productService.getProductDetail(999L)
        );

        assertEquals(40402, exception.getCode());
    }

    @Test
    void listProductSkusBuildsCompatibilityFields() {
        when(productMapper.selectOne(any())).thenReturn(product(6001L, "苹果"));
        Sku sku = sku(8001L, 6001L, "39.90");
        sku.setSpecs("{\"规格\":\"5斤装\"}");
        sku.setSkuCode("APPLE-5J");
        when(skuMapper.selectList(any())).thenReturn(List.of(sku));

        ProductSkuListVO result = productService.listProductSkus(6001L);

        assertEquals("5斤装", result.getSkuList().get(0).getSkuName());
        assertEquals(new BigDecimal("39.90"), result.getSkuList().get(0).getOriginalPrice());
        assertEquals(0, result.getSkuList().get(0).getLockedStock());
        assertEquals("ON_SALE", result.getSkuList().get(0).getStatus());
    }

    private Product product(Long id, String title) {
        Product product = new Product();
        product.setId(id);
        product.setTitle(title);
        product.setMainImage("https://example.com/" + id + ".jpg");
        product.setStatus(1);
        product.setAuditStatus(1);
        return product;
    }

    private Sku sku(Long id, Long productId, String price) {
        Sku sku = new Sku();
        sku.setId(id);
        sku.setProductId(productId);
        sku.setPrice(new BigDecimal(price));
        sku.setStock(100);
        sku.setSpecs("{}");
        return sku;
    }
}
