package com.socialretail.backend.vo;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.time.LocalDateTime;
import java.util.List;

public record ProductLatestCommentVO(
        Long commentId,
        Long userId,
        String nickname,
        String avatar,
        Integer score,
        String content,
        List<String> images,
        Integer anonymous,
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime createTime) {
}
