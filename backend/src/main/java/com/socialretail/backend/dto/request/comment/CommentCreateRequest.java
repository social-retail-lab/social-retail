package com.socialretail.backend.dto.request.comment;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.util.List;

@Data
public class CommentCreateRequest {

    @NotNull(message = "订单ID不能为空")
    @Positive(message = "订单ID必须大于0")
    private Long orderId;

    @NotNull(message = "订单明细ID不能为空")
    @Positive(message = "订单明细ID必须大于0")
    private Long orderItemId;

    @NotNull(message = "商品ID不能为空")
    @Positive(message = "商品ID必须大于0")
    private Long productId;

    @NotNull(message = "SKU ID不能为空")
    @Positive(message = "SKU ID必须大于0")
    private Long skuId;

    @NotNull(message = "评分不能为空")
    @Min(value = 1, message = "评分必须在1到5之间")
    @Max(value = 5, message = "评分必须在1到5之间")
    private Integer score;

    private String content;

    @Size(max = 9, message = "评价图片最多9张")
    private List<
            @NotBlank(message = "评价图片URL不能为空")
            @Size(max = 200, message = "评价图片URL不能超过200个字符") String> imageUrls;

    @Min(value = 0, message = "匿名标识只能为0或1")
    @Max(value = 1, message = "匿名标识只能为0或1")
    private Integer anonymous = 0;
}
