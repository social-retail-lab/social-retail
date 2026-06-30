package com.socialretail.backend.vo;

import lombok.Data;

@Data
public class StockUpdateVO {

    private Long skuId;
    private String productName;
    private Integer oldStock;
    private Integer newStock;
}
