package com.socialretail.backend.vo;

import lombok.Data;

@Data
public class WithdrawRequest {
    private String bankCardNumber;
    private String accountName;
    private String bankName;
}
