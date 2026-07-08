package com.socialretail.backend.service.product.impl;

import com.socialretail.backend.dto.request.product.ProductQueryDTO;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class ProductServiceImplTest {

    @Test
    void resolvesHomepageSortFieldsUsingCatalogStyleParameters() {
        assertEquals("sales_desc", resolve("soldCount", "desc"));
        assertEquals("sales_asc", resolve("sales", "asc"));
        assertEquals("price_asc", resolve("price", "asc"));
        assertEquals("price_desc", resolve("price", "desc"));
        assertEquals("newest", resolve("createTime", "desc"));
        assertEquals("time_asc", resolve("newest", "asc"));
    }

    @Test
    void keepsLegacySortParameterCompatibleAndHigherPriority() {
        ProductQueryDTO query = new ProductQueryDTO();
        query.setSort("price_asc");
        query.setSortField("soldCount");
        query.setSortOrder("desc");

        assertEquals("price_asc", ProductServiceImpl.resolveSortKey(query));
    }

    private String resolve(String field, String order) {
        ProductQueryDTO query = new ProductQueryDTO();
        query.setSortField(field);
        query.setSortOrder(order);
        return ProductServiceImpl.resolveSortKey(query);
    }
}
