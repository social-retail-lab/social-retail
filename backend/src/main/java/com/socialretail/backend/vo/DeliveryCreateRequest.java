package com.socialretail.backend.vo;

import lombok.Data;

@Data
public class DeliveryCreateRequest {
    private String dispatcherName;
    private String dispatcherPhone;
    private String remark;
}
