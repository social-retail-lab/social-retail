package com.socialretail.backend.dto.request.address;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class AddressUpdateDTO {

    @NotBlank(message = "收货人姓名不能为空")
    @Size(max = 50, message = "收货人姓名不能超过50位")
    private String receiverName;

    @NotBlank(message = "收货人电话不能为空")
    @Pattern(regexp = "^1\\d{10}$", message = "收货人电话格式错误")
    private String receiverPhone;

    @NotBlank(message = "省份不能为空")
    @Size(max = 50, message = "省份不能超过50位")
    private String province;

    @NotBlank(message = "城市不能为空")
    @Size(max = 50, message = "城市不能超过50位")
    private String city;

    @NotBlank(message = "区县不能为空")
    @Size(max = 50, message = "区县不能超过50位")
    private String district;

    @NotBlank(message = "详细地址不能为空")
    @Size(max = 200, message = "详细地址不能超过200位")
    private String detailAddress;

    private Boolean isDefault;
}
