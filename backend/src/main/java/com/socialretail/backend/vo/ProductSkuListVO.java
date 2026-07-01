package com.socialretail.backend.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProductSkuListVO {
    private Long productId;
    private List<ProductSkuVO> skuList;
}
