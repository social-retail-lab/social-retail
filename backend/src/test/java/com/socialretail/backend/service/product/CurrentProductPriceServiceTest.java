package com.socialretail.backend.service.product;

import com.socialretail.backend.dto.promotion.SeckillProductView;
import com.socialretail.backend.entity.product.Sku;
import com.socialretail.backend.mapper.promotion.SeckillProductMapper;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

class CurrentProductPriceServiceTest {

    @Test
    void resolvesLowestActiveSeckillPriceAndKeepsOriginalPrice() {
        SeckillProductMapper mapper = mock(SeckillProductMapper.class);
        CurrentProductPriceService service = new CurrentProductPriceService(mapper);
        Sku sku = sku(8001L, "69.90");

        when(mapper.selectCurrentViewsBySkuIds(eq(List.of(8001L)), any()))
                .thenReturn(List.of(view(9001L, 8001L, "59.90"), view(9002L, 8001L, "49.90")));

        CurrentProductPriceService.Price price = service.resolve(sku);

        assertEquals(new BigDecimal("69.90"), price.originalPrice());
        assertEquals(new BigDecimal("49.90"), price.finalPrice());
        assertEquals(9002L, price.seckillProductId());
    }

    @Test
    void ignoresSeckillPriceThatIsNotLowerThanOriginalPrice() {
        SeckillProductMapper mapper = mock(SeckillProductMapper.class);
        CurrentProductPriceService service = new CurrentProductPriceService(mapper);
        Sku sku = sku(8001L, "69.90");
        when(mapper.selectCurrentViewsBySkuIds(eq(List.of(8001L)), any()))
                .thenReturn(List.of(view(9001L, 8001L, "79.90")));

        CurrentProductPriceService.Price price = service.resolve(sku);

        assertEquals(new BigDecimal("69.90"), price.finalPrice());
        assertNull(price.seckillProductId());
    }

    private Sku sku(Long id, String price) {
        Sku sku = new Sku();
        sku.setId(id);
        sku.setPrice(new BigDecimal(price));
        return sku;
    }

    private SeckillProductView view(Long seckillProductId, Long skuId, String price) {
        SeckillProductView view = new SeckillProductView();
        view.setSeckillProductId(seckillProductId);
        view.setSkuId(skuId);
        view.setSeckillPrice(new BigDecimal(price));
        return view;
    }
}
