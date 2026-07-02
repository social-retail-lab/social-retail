package com.socialretail.backend.vo;

import lombok.Data;
import lombok.experimental.Accessors;

@Data
@Accessors(chain = true)
public class MerchantInfoChangeVO {

    private Long changeId;

    private String requestType;

    private String requestTypeText;

    private String oldData;

    private String newData;

    private Integer auditStatus;

    private Integer auditStatusText;

    private String auditRemark;

    private String createTime;

    private String auditTime;
}
