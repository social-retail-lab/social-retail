package com.socialretail.backend.service.product;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.socialretail.backend.common.ImageUrlResolver;
import com.socialretail.backend.entity.product.Product;
import com.socialretail.backend.mapper.member.MerchantMapper;
import com.socialretail.backend.mapper.product.BrandMapper;
import com.socialretail.backend.mapper.product.CategoryMapper;
import com.socialretail.backend.mapper.product.CommentViewRow;
import com.socialretail.backend.mapper.product.ProductCategoryRelationMapper;
import com.socialretail.backend.mapper.product.ProductCommentMapper;
import com.socialretail.backend.mapper.product.ProductCommentStatisticsRow;
import com.socialretail.backend.mapper.product.ProductMapper;
import com.socialretail.backend.mapper.product.SkuMapper;
import com.socialretail.backend.service.product.impl.ProductServiceImpl;
import com.socialretail.backend.service.social.DistributionAttributionService;
import com.socialretail.backend.vo.ProductDetailVO;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ProductServiceImplCommentSummaryTest {

    @Mock private ProductMapper productMapper;
    @Mock private ProductCommentMapper productCommentMapper;
    @Mock private SkuMapper skuMapper;
    @Mock private ProductCategoryRelationMapper productCategoryRelationMapper;
    @Mock private BrandMapper brandMapper;
    @Mock private CategoryMapper categoryMapper;
    @Mock private MerchantMapper merchantMapper;
    @Mock private DistributionAttributionService distributionAttributionService;
    @Mock private CurrentProductPriceService currentProductPriceService;

    private ProductServiceImpl service;

    @BeforeEach
    void setUp() {
        service = new ProductServiceImpl(
                productMapper,
                productCommentMapper,
                skuMapper,
                productCategoryRelationMapper,
                brandMapper,
                categoryMapper,
                merchantMapper,
                new ObjectMapper(),
                new ImageUrlResolver("./uploads", "http://localhost:8081"),
                distributionAttributionService,
                currentProductPriceService);
    }

    @Test
    void detailIncludesCommentStatisticsAndLatestAnonymousSafePreview() {
        Product product = new Product();
        product.setId(6001L);
        product.setTitle("测试商品");
        product.setStatus(1);
        product.setAuditStatus(1);
        when(productMapper.selectOne(any())).thenReturn(product);
        when(skuMapper.selectList(any())).thenReturn(List.of());
        when(currentProductPriceService.resolve(
                org.mockito.ArgumentMatchers.<com.socialretail.backend.entity.product.Sku>anyCollection()))
                .thenReturn(Map.of());

        ProductCommentStatisticsRow statistics = new ProductCommentStatisticsRow();
        statistics.setRatingScore(new BigDecimal("4.75"));
        statistics.setCommentCount(26L);
        when(productCommentMapper.selectProductCommentStatistics(6001L)).thenReturn(statistics);
        when(productCommentMapper.selectLatestProductComments(6001L, 2)).thenReturn(List.of(
                comment(9001L, 1007L, "陈三", "/uploads/avatar/1.jpg", 5,
                        "[\"/uploads/review/images/1.jpg\"]", 0,
                        LocalDateTime.of(2026, 7, 6, 16, 30)),
                comment(9002L, 1008L, "李四", "/uploads/avatar/2.jpg", 4,
                        "[]", 1, LocalDateTime.of(2026, 7, 5, 11, 20))));

        ProductDetailVO detail = service.getProductDetail(6001L, null);

        assertEquals(new BigDecimal("4.8"), detail.getRatingScore());
        assertEquals(26, detail.getCommentCount());
        assertEquals(2, detail.getLatestComments().size());
        assertEquals(1007L, detail.getLatestComments().get(0).userId());
        assertEquals(List.of("http://localhost:8081/uploads/review/images/1.jpg"),
                detail.getLatestComments().get(0).images());
        assertNull(detail.getLatestComments().get(1).userId());
        assertEquals("匿名用户", detail.getLatestComments().get(1).nickname());
        assertEquals("", detail.getLatestComments().get(1).avatar());
        assertEquals(1, detail.getLatestComments().get(1).anonymous());
    }

    private CommentViewRow comment(Long id, Long userId, String nickname, String avatar,
                                   int score, String images, int anonymous,
                                   LocalDateTime createTime) {
        CommentViewRow row = new CommentViewRow();
        row.setCommentId(id);
        row.setUserId(userId);
        row.setNickname(nickname);
        row.setAvatar(avatar);
        row.setScore(score);
        row.setContent("评价内容");
        row.setImages(images);
        row.setAnonymous(anonymous);
        row.setCreateTime(createTime);
        return row;
    }
}
