package com.socialretail.backend.vo;

import lombok.Data;

@Data
public class AfterSaleReturnConfirmRequest {
    private Integer receivedStatus;
    private String remark;
}
