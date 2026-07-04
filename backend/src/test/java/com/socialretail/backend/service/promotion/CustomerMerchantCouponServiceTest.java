package com.socialretail.backend.service.promotion;

import com.socialretail.backend.dto.promotion.PromotionApiModels.MerchantCouponReceive;
import com.socialretail.backend.entity.member.Merchant;
import com.socialretail.backend.entity.member.MerchantCoupon;
import com.socialretail.backend.entity.member.MerchantCouponUser;
import com.socialretail.backend.mapper.member.MerchantCouponMapper;
import com.socialretail.backend.mapper.member.MerchantCouponUserMapper;
import com.socialretail.backend.mapper.member.MerchantMapper;
import org.junit.jupiter.api.Test;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doAnswer;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

class CustomerMerchantCouponServiceTest {

    @Test
    void receiveWritesMerchantCouponUserAndCachesSuccessfulIdempotentResult() {
        MerchantCouponMapper couponMapper = mock(MerchantCouponMapper.class);
        MerchantCouponUserMapper couponUserMapper = mock(MerchantCouponUserMapper.class);
        MerchantMapper merchantMapper = mock(MerchantMapper.class);
        TransactionTemplate transactionTemplate = mock(TransactionTemplate.class);
        when(transactionTemplate.execute(any())).thenAnswer(invocation -> {
            TransactionCallback<?> callback = invocation.getArgument(0);
            return callback.doInTransaction(mock(TransactionStatus.class));
        });

        LocalDateTime now = LocalDateTime.now();
        MerchantCoupon coupon = new MerchantCoupon();
        coupon.setId(6001L);
        coupon.setMerchantId(2001L);
        coupon.setTitle("店铺满100减15优惠券");
        coupon.setType(1);
        coupon.setStatus(1);
        coupon.setMinConsume(new BigDecimal("100.00"));
        coupon.setDiscountAmount(new BigDecimal("15.00"));
        coupon.setTotalCount(100);
        coupon.setReceivedCount(20);
        coupon.setPerUserLimit(1);
        coupon.setValidStart(now.minusDays(1));
        coupon.setValidEnd(now.plusDays(1));
        when(couponMapper.selectByIdForUpdate(6001L)).thenReturn(coupon);
        when(couponMapper.incrementReceivedCount(6001L)).thenReturn(1);
        when(couponUserMapper.selectCount(any())).thenReturn(0L);
        doAnswer(invocation -> {
            invocation.<MerchantCouponUser>getArgument(0).setId(7001L);
            return 1;
        }).when(couponUserMapper).insert(any());
        Merchant merchant = new Merchant();
        merchant.setId(2001L);
        merchant.setMerchantName("优选水果店");
        when(merchantMapper.selectById(2001L)).thenReturn(merchant);

        CustomerMerchantCouponService service = new CustomerMerchantCouponService(
                couponMapper, couponUserMapper, merchantMapper, transactionTemplate);
        MerchantCouponReceive first = service.receive(10007L, 6001L, "receive-key");
        MerchantCouponReceive repeated = service.receive(10007L, 6001L, "receive-key");

        assertSame(first, repeated);
        assertEquals(7001L, first.couponUserId());
        assertEquals(6001L, first.couponId());
        verify(couponUserMapper).insert(any(MerchantCouponUser.class));
        verify(couponMapper).incrementReceivedCount(6001L);
    }
}
