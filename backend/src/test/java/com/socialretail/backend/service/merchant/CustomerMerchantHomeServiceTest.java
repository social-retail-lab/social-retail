package com.socialretail.backend.service.merchant;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.socialretail.backend.common.ImageUrlResolver;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.entity.member.Merchant;
import com.socialretail.backend.entity.member.MerchantCoupon;
import com.socialretail.backend.entity.member.MerchantCouponUser;
import com.socialretail.backend.entity.product.Product;
import com.socialretail.backend.entity.product.Sku;
import com.socialretail.backend.mapper.member.MerchantCouponMapper;
import com.socialretail.backend.mapper.member.MerchantCouponUserMapper;
import com.socialretail.backend.mapper.member.MerchantMapper;
import com.socialretail.backend.mapper.product.ProductMapper;
import com.socialretail.backend.mapper.product.SkuMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.mockito.Mockito.lenient;

@ExtendWith(MockitoExtension.class)
class CustomerMerchantHomeServiceTest {
    @Mock private MerchantMapper merchantMapper;
    @Mock private ProductMapper productMapper;
    @Mock private SkuMapper skuMapper;
    @Mock private MerchantCouponMapper couponMapper;
    @Mock private MerchantCouponUserMapper couponUserMapper;
    @Mock private ImageUrlResolver imageUrlResolver;

    private CustomerMerchantHomeService service;

    @BeforeEach
    void setUp() {
        service = new CustomerMerchantHomeService(merchantMapper, productMapper, skuMapper, couponMapper,
                couponUserMapper, imageUrlResolver);
        lenient().when(imageUrlResolver.resolve(any()))
                .thenAnswer(invocation -> invocation.getArgument(0));
    }

    @Test
    void homeAggregatesProductsCouponsAndLoginState() {
        Merchant merchant = merchant(1);
        when(merchantMapper.selectById(2001L)).thenReturn(merchant);

        Product first = product(6001L, 1200L);
        Product second = product(6002L, 860L);
        when(productMapper.selectList(any())).thenReturn(List.of(first, second));

        MerchantCoupon coupon = new MerchantCoupon();
        coupon.setId(7001L);
        coupon.setTitle("满100减15");
        coupon.setType(1);
        coupon.setMinConsume(new BigDecimal("100.00"));
        coupon.setDiscountAmount(new BigDecimal("15.00"));
        coupon.setTotalCount(100);
        coupon.setReceivedCount(20);
        coupon.setPerUserLimit(1);
        coupon.setValidStart(LocalDateTime.now().minusDays(1));
        coupon.setValidEnd(LocalDateTime.now().plusDays(1));
        when(couponMapper.selectList(any())).thenReturn(List.of(coupon));
        MerchantCouponUser owned = new MerchantCouponUser();
        owned.setCouponId(7001L);
        when(couponUserMapper.selectList(any())).thenReturn(List.of(owned));

        var result = service.home(2001L, 99L);

        assertEquals(2, result.statistics().productCount());
        assertEquals(2060L, result.statistics().totalSoldCount());
        assertEquals(2, result.recommendProducts().size());
        assertEquals(80, result.couponList().get(0).remainingCount());
        assertTrue(result.couponList().get(0).alreadyReceived());
        assertEquals("159****4216", result.contactPhone());
    }

    @Test
    void anonymousHomeDefaultsAlreadyReceivedToFalse() {
        when(merchantMapper.selectById(2001L)).thenReturn(merchant(1));
        when(productMapper.selectList(any())).thenReturn(List.of());
        MerchantCoupon coupon = new MerchantCoupon();
        coupon.setId(7001L);
        coupon.setTotalCount(1);
        coupon.setReceivedCount(0);
        when(couponMapper.selectList(any())).thenReturn(List.of(coupon));

        var result = service.home(2001L, null);

        assertFalse(result.couponList().get(0).alreadyReceived());
    }

    @Test
    void disabledMerchantHomeReturnsDocumentedConflict() {
        when(merchantMapper.selectById(2001L)).thenReturn(merchant(0));

        BusinessException exception = assertThrows(BusinessException.class,
                () -> service.home(2001L, null));

        assertEquals(40931, exception.getCode());
        assertEquals(409, exception.getHttpStatus().value());
    }

    @Test
    void missingMerchantReturnsDocumentedNotFound() {
        when(merchantMapper.selectById(2001L)).thenReturn(null);

        BusinessException exception = assertThrows(BusinessException.class,
                () -> service.basic(2001L));

        assertEquals(40431, exception.getCode());
    }

    @Test
    void blankSearchKeywordReturnsDocumentedError() {
        BusinessException exception = assertThrows(BusinessException.class,
                () -> service.search(2001L, "  ", 1, 10));

        assertEquals(40031, exception.getCode());
    }

    @Test
    void productListUsesMinimumSkuPriceAndReturnsEmptyTags() {
        Merchant merchant = merchant(1);
        when(merchantMapper.selectById(2001L)).thenReturn(merchant);
        Product product = product(6001L, 12L);
        Page<Product> dbPage = new Page<>(1, 10, 1);
        dbPage.setRecords(List.of(product));
        when(productMapper.selectPage(any(Page.class), any())).thenReturn(dbPage);

        Sku first = sku(6001L, "129.90", 8);
        Sku second = sku(6001L, "99.90", 12);
        when(skuMapper.selectList(any())).thenReturn(List.of(first, second));

        var item = service.products(2001L, null, null, "DEFAULT", 1, 10)
                .list().get(0);

        assertEquals(new BigDecimal("99.90"), item.price());
        assertEquals(new BigDecimal("99.90"), item.originalPrice());
        assertEquals(20, item.stock());
        assertTrue(item.tags().isEmpty());
        assertEquals("优选水果店", item.merchantName());
    }

    private Merchant merchant(int status) {
        Merchant merchant = new Merchant();
        merchant.setId(2001L);
        merchant.setMerchantName("优选水果店");
        merchant.setContactPhone("15912344216");
        merchant.setStatus(status);
        return merchant;
    }

    private Product product(long id, long soldCount) {
        Product product = new Product();
        product.setId(id);
        product.setMerchantId(2001L);
        product.setTitle("商品" + id);
        product.setSaleType(1);
        product.setStatus(1);
        product.setAuditStatus(1);
        product.setSoldCount(soldCount);
        return product;
    }

    private Sku sku(long productId, String price, int stock) {
        Sku sku = new Sku();
        sku.setProductId(productId);
        sku.setPrice(new BigDecimal(price));
        sku.setStock(stock);
        return sku;
    }
}
