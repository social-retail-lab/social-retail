package com.socialretail.backend.entity.member;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("merchant_info_change")
public class MerchantInfoChange {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long merchantId;

    private String requestType;

    private String oldData;

    private String newData;

    private Integer auditStatus;

    private String auditRemark;

    private LocalDateTime createTime;

    private LocalDateTime auditTime;
}
