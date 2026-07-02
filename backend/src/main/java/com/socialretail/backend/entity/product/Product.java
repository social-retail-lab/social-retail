package com.socialretail.backend.entity.product;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("product")
public class Product {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long brandId;

    private Long merchantId;

    private String title;

    private String subTitle;

    private String mainImage;

    private String detailDesc;

    private String detailImages;

    private Integer saleType;

    private Integer status;

    private Integer auditStatus;

    private String auditRemark;

    private LocalDateTime auditTime;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;

    private Long soldCount;
}
