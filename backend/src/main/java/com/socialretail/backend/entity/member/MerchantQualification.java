package com.socialretail.backend.entity.member;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@Data
@TableName("merchant_qualification")
public class MerchantQualification {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long merchantId;

    private String licenseNumber;

    private String licenseImage;

    private String foodPermitNumber;

    private String foodPermitImage;

    private String businessCategory;
}
