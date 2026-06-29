package com.socialretail.backend.entity.product;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;

@Data
@TableName("sku")
public class Sku {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long productId;

    private String specs;

    private BigDecimal price;

    private Integer stock;

    private String skuCode;
}
