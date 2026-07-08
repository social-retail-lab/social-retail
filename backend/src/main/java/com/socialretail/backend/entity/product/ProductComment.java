package com.socialretail.backend.entity.product;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("product_comment")
public class ProductComment {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;
    private Long orderId;
    private Long orderItemId;
    private Long productId;
    private Long skuId;
    private Long userId;
    private Integer score;
    private String content;
    private String images;
    private Integer anonymous;
    private Integer status;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    private LocalDateTime deleteTime;
}
