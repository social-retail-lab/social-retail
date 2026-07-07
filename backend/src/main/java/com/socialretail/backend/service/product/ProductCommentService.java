package com.socialretail.backend.service.product;

import com.socialretail.backend.dto.request.comment.CommentCreateRequest;
import com.socialretail.backend.dto.request.comment.CommentPageRequest;
import com.socialretail.backend.dto.request.comment.ProductCommentQueryRequest;
import com.socialretail.backend.dto.response.comment.CommentResponses;

public interface ProductCommentService {

    CommentResponses.CreateResponse create(Long userId, CommentCreateRequest request);

    CommentResponses.PageResponse<CommentResponses.MyCommentItem> listMine(
            Long userId, CommentPageRequest request);

    CommentResponses.PageResponse<CommentResponses.ProductCommentItem> listByProduct(
            Long productId, ProductCommentQueryRequest request);

    CommentResponses.DetailResponse detail(Long commentId, Long currentUserId);

    void delete(Long commentId, Long userId);
}
