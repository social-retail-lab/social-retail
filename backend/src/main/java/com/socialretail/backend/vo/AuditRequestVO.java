package com.socialretail.backend.vo;

import lombok.Data;

import java.util.List;

@Data
public class AuditRequestVO {

    private Long requestId;

    private String requestType;       // PRODUCT_PUBLISH, PRODUCT_EDIT, INFO_CHANGE, QUALIFICATION_UPGRADE

    private String requestTypeText;

    private Long productId;           // 商品相关时填充

    private String productTitle;      // 商品标题

    private String imageUrl;          // 主图

    private Integer auditStatus;      // 0-待审核, 1-通过, 2-驳回

    private String auditStatusText;

    private String auditRemark;

    private String createTime;

    private String auditTime;

    private Boolean withdrawable;     // 是否可撤回

    // 详情用：新旧对照
    private Object oldData;

    private Object newData;
}
