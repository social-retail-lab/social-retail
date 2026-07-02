package com.socialretail.backend.dto.request.order;

import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class OrderCancelRequest {
    @Size(max = 500, message = "取消原因不能超过500个字符")
    private String reason;
}
