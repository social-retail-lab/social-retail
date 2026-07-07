package com.socialretail.backend.dto.response.comment;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.time.LocalDateTime;
import java.util.List;

public final class CommentResponses {

    private CommentResponses() {
    }

    public record CreateResponse(
            Long commentId,
            Long orderId,
            Long orderItemId,
            Long productId,
            Integer score,
            String status,
            @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime createTime) {
    }

    public record UserInfo(Long userId, String nickname, String avatar) {
    }

    public record MyCommentItem(
            Long commentId,
            Long productId,
            String productName,
            String productImage,
            Integer score,
            String content,
            List<String> imageUrls,
            String status,
            @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime createTime) {
    }

    public record ProductCommentItem(
            Long commentId,
            UserInfo userInfo,
            Integer score,
            String content,
            List<String> imageUrls,
            String skuSpecs,
            @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime createTime) {
    }

    public record DetailResponse(
            Long commentId,
            Long productId,
            String productName,
            String skuSpecs,
            UserInfo userInfo,
            Integer score,
            String content,
            List<String> imageUrls,
            String status,
            @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime createTime) {
    }

    public record PageResponse<T>(
            List<T> list,
            long total,
            long pages,
            long page,
            long pageSize) {
    }
}
