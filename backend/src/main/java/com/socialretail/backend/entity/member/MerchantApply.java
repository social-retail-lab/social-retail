package com.socialretail.backend.entity.member;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("merchant_apply")
public class MerchantApply {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long userId;

    private Integer applyType;

    private String companyName;

    private String idCardFront;

    private String idCardBack;

    private String licenseNumber;

    private String licenseImage;

    private String foodPermitNumber;

    private String foodPermitImage;

    private String contactName;

    private String contactPhone;

    private String shopAddress;

    private String shopName;

    private Integer auditStatus;

    private String auditRemark;

    private LocalDateTime auditTime;

    private LocalDateTime applyTime;
}
