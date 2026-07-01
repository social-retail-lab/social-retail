package com.socialretail.backend.service.product;

import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.dto.request.product.BrandQueryDTO;
import com.socialretail.backend.dto.request.product.CatalogProductQueryDTO;
import com.socialretail.backend.vo.BrandProductPageVO;
import com.socialretail.backend.vo.BrandVO;

public interface BrandService {
    PageResult<BrandVO> listBrands(BrandQueryDTO query);

    BrandProductPageVO listBrandProducts(Long brandId, CatalogProductQueryDTO query);
}
