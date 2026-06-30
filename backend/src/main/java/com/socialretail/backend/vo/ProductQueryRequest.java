package com.socialretail.backend.vo;

import lombok.Data;

@Data
public class ProductQueryRequest {

    private String keyword;
    private Long categoryId;
    private Integer status;
    private Integer auditStatus;
}
