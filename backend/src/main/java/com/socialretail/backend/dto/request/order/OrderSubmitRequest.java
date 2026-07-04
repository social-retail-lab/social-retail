package com.socialretail.backend.dto.request.order;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class OrderSubmitRequest {
    @NotBlank(message = "订单预览令牌不能为空")
    @Size(max = 64, message = "订单预览令牌格式错误")
    private String previewToken;
}
