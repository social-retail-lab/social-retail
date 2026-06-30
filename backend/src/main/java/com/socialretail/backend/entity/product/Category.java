package com.socialretail.backend.entity.product;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@Data
@TableName("category")
public class Category {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long parentId;

    private String name;

    private Integer level;

    private Integer sortOrder;
}
