package com.socialretail.backend.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BrandVO {
    private Long brandId;
    private String brandName;
    private String logo;
    private String description;
    private Integer sort;
}
