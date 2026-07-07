package com.socialretail.backend.service.order.pricing;

import com.socialretail.backend.service.member.PointsCalculationService;
import com.socialretail.backend.vo.CartItemVO;
import com.socialretail.backend.vo.CouponOptionVO;
import com.socialretail.backend.vo.PointsInfoVO;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

class DefaultOrderPricingServiceTest {

    @Test
    void orderPreviewWithEmptyActivityContextAutoSelectsSeckillBeforePoints() {
        PointsCalculationService points = mock(PointsCalculationService.class);
        PlatformCouponPricingService platform = mock(PlatformCouponPricingService.class);
        MerchantCouponPricingService merchant = mock(MerchantCouponPricingService.class);
        SeckillOrderPricingService seckill = mock(SeckillOrderPricingService.class);
        BargainOrderPricingService bargain = mock(BargainOrderPricingService.class);
        PromotionPricingService promotion = mock(PromotionPricingService.class);
        DefaultOrderPricingService service = new DefaultOrderPricingService(
                points, platform, merchant, seckill, bargain, promotion);

        CartItemVO item = new CartItemVO();
        item.setCartId(24L);
        item.setSkuId(8002L);
        item.setProductId(6001L);
        item.setPrice(new BigDecimal("59.90"));
        item.setOriginalPrice(new BigDecimal("69.90"));
        item.setQuantity(2);
        List<CartItemVO> items = List.of(item);

        when(seckill.quoteBest(1001L, items)).thenReturn(new SeckillOrderPricingService.Quote(
                9001L, 9000L, 8002L, 2, new BigDecimal("69.90"), new BigDecimal("59.90"),
                new BigDecimal("139.80"), new BigDecimal("119.80"), new BigDecimal("20.00")));
        when(bargain.quote(1001L, null, items, false)).thenReturn(BargainOrderPricingService.Quote.none());
        when(promotion.resolve(2001L, new BigDecimal("119.80"), List.of(), true))
                .thenReturn(new PromotionPricingService.Pricing(null, BigDecimal.ZERO, List.of(), List.of()));

        CouponOptionVO platformInfo = new CouponOptionVO(1L, 3003L, null, null,
                "平台满50减5优惠券", "PLATFORM", "平台券", new BigDecimal("50.00"),
                new BigDecimal("5.00"), true, true, null);
        CouponOptionVO merchantInfo = new CouponOptionVO(7001L, 6001L, 2001L, "优选水果店",
                "店铺满100减15优惠券", "MERCHANT", "商家券", new BigDecimal("100.00"),
                new BigDecimal("15.00"), true, true, null);
        when(platform.resolve(1001L, null, new BigDecimal("119.80"), true, true))
                .thenReturn(new PlatformCouponPricingService.Pricing(
                        platformInfo, new BigDecimal("5.00"), List.of(), 1L));
        when(merchant.resolve(1001L, 2001L, null, new BigDecimal("119.80"), true, true))
                .thenReturn(new MerchantCouponPricingService.Pricing(
                        merchantInfo, new BigDecimal("15.00"), List.of(), 7001L));
        PointsInfoVO pointsInfo = new PointsInfoVO(5000, true, 998, 998,
                new BigDecimal("9.98"), "100积分抵扣1元", new BigDecimal("9.98"));
        when(points.calculate(1001L, new BigDecimal("99.80"), true, null)).thenReturn(pointsInfo);

        OrderPricingResult result = service.calculate(new OrderPricingCommand(
                1001L, 2001L, items, true, null, true, null,
                true, null, null, false, true));

        assertEquals(new BigDecimal("15.00"), result.getMerchantCouponDiscount());
        assertEquals(new BigDecimal("5.00"), result.getCouponDiscount());
        assertEquals(new BigDecimal("9.98"), result.getPointsDeduction());
        assertEquals(new BigDecimal("89.82"), result.getPayableAmount());
        verify(points).calculate(eq(1001L), eq(new BigDecimal("99.80")), eq(true), eq(null));
    }
}
