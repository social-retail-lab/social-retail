package com.socialretail.backend.service.product;

import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.dto.request.product.BrandQueryDTO;
import com.socialretail.backend.dto.request.product.CatalogProductQueryDTO;
import com.socialretail.backend.entity.product.Brand;
import com.socialretail.backend.entity.product.Category;
import com.socialretail.backend.entity.product.Product;
import com.socialretail.backend.entity.product.ProductCategoryRelation;
import com.socialretail.backend.entity.product.Sku;
import com.socialretail.backend.mapper.product.BrandMapper;
import com.socialretail.backend.mapper.product.CategoryMapper;
import com.socialretail.backend.mapper.product.ProductCategoryRelationMapper;
import com.socialretail.backend.mapper.product.ProductMapper;
import com.socialretail.backend.mapper.product.SkuMapper;
import com.socialretail.backend.service.product.impl.BrandServiceImpl;
import com.socialretail.backend.service.product.impl.CategoryServiceImpl;
import com.socialretail.backend.vo.BrandVO;
import com.socialretail.backend.vo.CategoryProductPageVO;
import com.socialretail.backend.vo.CategoryTreeResultVO;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class CatalogServiceTest {

    @Mock private BrandMapper brandMapper;
    @Mock private CategoryMapper categoryMapper;
    @Mock private ProductMapper productMapper;
    @Mock private ProductCategoryRelationMapper relationMapper;
    @Mock private SkuMapper skuMapper;

    private CategoryServiceImpl categoryService;
    private BrandServiceImpl brandService;

    @BeforeEach
    void setUp() {
        categoryService = new CategoryServiceImpl(categoryMapper, relationMapper, productMapper, skuMapper);
        brandService = new BrandServiceImpl(
                brandMapper, categoryMapper, productMapper, relationMapper, skuMapper
        );
    }

    @Test
    void categoryTreeBuildsParentChildRelationship() {
        Category root = category(1L, null, "水果", 1, 1);
        Category child = category(11L, 1L, "进口水果", 2, 1);
        when(categoryMapper.selectList(any())).thenReturn(List.of(root, child));

        CategoryTreeResultVO result = categoryService.getCategoryTree();

        assertEquals(1, result.getList().size());
        assertEquals(0L, result.getList().get(0).getParentId());
        assertEquals(11L, result.getList().get(0).getChildren().get(0).getCategoryId());
    }

    @Test
    void categoryProductsDerivePriceAndStockFromSkus() {
        when(categoryMapper.selectById(1L)).thenReturn(category(1L, null, "水果", 1, 1));
        when(relationMapper.selectList(any())).thenReturn(List.of(relation(6001L, 1L)));
        when(productMapper.selectList(any())).thenReturn(List.of(product(6001L, 5001L)));
        when(skuMapper.selectList(any())).thenReturn(List.of(
                sku(8001L, 6001L, "39.90", 200),
                sku(8002L, 6001L, "69.90", 100)
        ));

        CategoryProductPageVO result = categoryService.listCategoryProducts(
                1L, new CatalogProductQueryDTO()
        );

        assertEquals(new BigDecimal("39.90"), result.getList().get(0).getPrice());
        assertEquals(300, result.getList().get(0).getStock());
        assertEquals(568L, result.getList().get(0).getSoldCount());
        assertEquals(1L, result.getTotal());
    }

    @Test
    void missingCategoryAndBrandUseDocumentedCodes() {
        when(categoryMapper.selectById(999L)).thenReturn(null);
        BusinessException categoryException = assertThrows(
                BusinessException.class,
                () -> categoryService.listCategoryProducts(999L, new CatalogProductQueryDTO())
        );
        assertEquals(40403, categoryException.getCode());

        when(brandMapper.selectById(999L)).thenReturn(null);
        BusinessException brandException = assertThrows(
                BusinessException.class,
                () -> brandService.listBrandProducts(999L, new CatalogProductQueryDTO())
        );
        assertEquals(40404, brandException.getCode());
    }

    @Test
    void brandListUsesDefaultTwentyPageSize() {
        Brand brand = new Brand();
        brand.setId(5001L);
        brand.setName("优选生鲜");
        brand.setCreateTime(LocalDateTime.of(2026, 1, 1, 10, 0));
        when(brandMapper.selectList(any())).thenReturn(List.of(brand));

        PageResult<BrandVO> result = brandService.listBrands(new BrandQueryDTO());

        assertEquals(20, result.getPageSize());
        assertEquals(1, result.getList().get(0).getSort());
        assertEquals(1L, result.getTotal());
    }

    private Category category(Long id, Long parentId, String name, int level, int sort) {
        Category category = new Category();
        category.setId(id);
        category.setParentId(parentId);
        category.setName(name);
        category.setLevel(level);
        category.setSortOrder(sort);
        return category;
    }

    private ProductCategoryRelation relation(Long productId, Long categoryId) {
        ProductCategoryRelation relation = new ProductCategoryRelation();
        relation.setProductId(productId);
        relation.setCategoryId(categoryId);
        return relation;
    }

    private Product product(Long id, Long brandId) {
        Product product = new Product();
        product.setId(id);
        product.setBrandId(brandId);
        product.setTitle("测试商品");
        product.setMainImage("image.jpg");
        product.setStatus(1);
        product.setAuditStatus(1);
        product.setSoldCount(568L);
        product.setCreateTime(LocalDateTime.of(2026, 6, 1, 10, 0));
        return product;
    }

    private Sku sku(Long id, Long productId, String price, int stock) {
        Sku sku = new Sku();
        sku.setId(id);
        sku.setProductId(productId);
        sku.setPrice(new BigDecimal(price));
        sku.setStock(stock);
        return sku;
    }
}
