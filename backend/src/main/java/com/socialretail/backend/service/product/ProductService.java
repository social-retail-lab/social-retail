package com.socialretail.backend.service.product;

import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.dto.request.product.ProductQueryDTO;
import com.socialretail.backend.vo.ProductDetailVO;
import com.socialretail.backend.vo.ProductListVO;

public interface ProductService {

    PageResult<ProductListVO> listProducts(ProductQueryDTO dto);

    ProductDetailVO getProductDetail(Long productId);

    PageResult<ProductListVO> searchProducts(ProductQueryDTO dto);
}
