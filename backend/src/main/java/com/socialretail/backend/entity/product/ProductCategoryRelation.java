package com.socialretail.backend.entity.product;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@Data
@TableName("product_category_relation")
public class ProductCategoryRelation {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long productId;

    private Long categoryId;
}
