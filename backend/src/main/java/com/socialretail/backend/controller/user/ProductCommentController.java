package com.socialretail.backend.controller.user;

import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.config.JwtInterceptor;
import com.socialretail.backend.dto.request.comment.CommentCreateRequest;
import com.socialretail.backend.dto.request.comment.CommentPageRequest;
import com.socialretail.backend.dto.request.comment.ProductCommentQueryRequest;
import com.socialretail.backend.dto.response.comment.CommentResponses;
import com.socialretail.backend.service.product.ProductCommentService;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Positive;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@Validated
@RestController
public class ProductCommentController {

    private final ProductCommentService commentService;

    public ProductCommentController(ProductCommentService commentService) {
        this.commentService = commentService;
    }

    @PostMapping("/api/comments")
    public Result<CommentResponses.CreateResponse> create(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Valid @RequestBody CommentCreateRequest request) {
        return Result.success("评价发布成功", commentService.create(userId, request));
    }

    @GetMapping("/api/comments/my")
    public Result<CommentResponses.PageResponse<CommentResponses.MyCommentItem>> listMine(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Valid @ModelAttribute CommentPageRequest request) {
        return Result.success(commentService.listMine(userId, request));
    }

    @GetMapping("/api/products/{productId}/comments")
    public Result<CommentResponses.PageResponse<CommentResponses.ProductCommentItem>> listByProduct(
            @Positive(message = "商品ID必须大于0") @PathVariable Long productId,
            @Valid @ModelAttribute ProductCommentQueryRequest request) {
        return Result.success(commentService.listByProduct(productId, request));
    }

    @GetMapping("/api/comments/{commentId}")
    public Result<CommentResponses.DetailResponse> detail(
            @Positive(message = "评价ID必须大于0") @PathVariable Long commentId,
            @RequestAttribute(value = JwtInterceptor.USER_ID_ATTRIBUTE, required = false)
            Long currentUserId) {
        return Result.success(commentService.detail(commentId, currentUserId));
    }

    @DeleteMapping("/api/comments/{commentId}")
    public Result<Void> delete(
            @Positive(message = "评价ID必须大于0") @PathVariable Long commentId,
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId) {
        commentService.delete(commentId, userId);
        return Result.success("删除成功", null);
    }
}
