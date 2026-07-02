package com.socialretail.backend.entity.order;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;

@Data
@TableName("order_item")
public class OrderItem {
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;
    private Long orderId;
    private Long productId;
    private Long skuId;
    private String productName;
    private String productImage;
    private String skuSpecs;
    private BigDecimal originPrice;
    private BigDecimal finalPrice;
    private BigDecimal price;
    private Integer quantity;
    private BigDecimal itemOriginAmount;
    private BigDecimal itemFinalAmount;
    private String promotionType;
}
