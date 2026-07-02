package com.socialretail.backend.service.product;

import com.socialretail.backend.dto.request.product.CatalogProductQueryDTO;
import com.socialretail.backend.vo.CategoryProductPageVO;
import com.socialretail.backend.vo.CategoryTreeResultVO;

public interface CategoryService {
    CategoryTreeResultVO getCategoryTree();

    CategoryProductPageVO listCategoryProducts(Long categoryId, CatalogProductQueryDTO query);
}
