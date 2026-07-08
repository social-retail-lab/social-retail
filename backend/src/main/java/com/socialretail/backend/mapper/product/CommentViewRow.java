package com.socialretail.backend.mapper.product;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class CommentViewRow {
    private Long commentId;
    private Long orderId;
    private Long orderItemId;
    private Long productId;
    private Long skuId;
    private Long userId;
    private Integer score;
    private String content;
    private String images;
    private Integer anonymous;
    private Integer status;
    private LocalDateTime createTime;
    private String productName;
    private String productImage;
    private String skuSpecs;
    private String nickname;
    private String avatar;
}
