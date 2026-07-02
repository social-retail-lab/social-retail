package com.socialretail.backend.dto.request.order;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import lombok.Data;

@Data
public class OrderQueryRequest {
    @Min(value = 0, message = "订单状态范围为0到5")
    @Max(value = 5, message = "订单状态范围为0到5")
    private Integer status;

    @Min(value = 1, message = "页码必须从1开始")
    private Integer page = 1;

    @Min(value = 1, message = "每页条数不能小于1")
    @Max(value = 100, message = "每页条数不能超过100")
    private Integer pageSize = 10;
}
