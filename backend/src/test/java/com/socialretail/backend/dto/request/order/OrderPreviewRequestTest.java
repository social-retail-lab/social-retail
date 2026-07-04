package com.socialretail.backend.dto.request.order;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertTrue;

class OrderPreviewRequestTest {

    @Test
    void couponsAreEnabledByDefaultWhenRequestOnlyProvidesNullCouponIds() {
        OrderPreviewRequest request = new OrderPreviewRequest();

        assertTrue(request.getUsePlatformCoupon());
        assertTrue(request.getUseMerchantCoupon());
        assertTrue(request.getUsePoints());
    }
}
