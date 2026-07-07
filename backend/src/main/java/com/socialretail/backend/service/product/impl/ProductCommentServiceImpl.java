package com.socialretail.backend.service.product.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.socialretail.backend.common.OrderStatus;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.dto.request.comment.CommentCreateRequest;
import com.socialretail.backend.dto.request.comment.CommentPageRequest;
import com.socialretail.backend.dto.request.comment.ProductCommentQueryRequest;
import com.socialretail.backend.dto.response.comment.CommentResponses;
import com.socialretail.backend.entity.order.Order;
import com.socialretail.backend.entity.order.OrderItem;
import com.socialretail.backend.entity.product.ProductComment;
import com.socialretail.backend.mapper.order.OrderItemMapper;
import com.socialretail.backend.mapper.order.OrderMapper;
import com.socialretail.backend.mapper.product.CommentViewRow;
import com.socialretail.backend.mapper.product.ProductCommentMapper;
import com.socialretail.backend.service.product.ProductCommentService;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Service
public class ProductCommentServiceImpl implements ProductCommentService {

    private static final int STATUS_HIDE = 0;
    private static final int STATUS_SHOW = 1;
    private static final int STATUS_DELETED = 2;
    private static final int STATUS_BLOCKED = 3;
    private static final int IMAGES_COLUMN_MAX_LENGTH = 500;

    private final ProductCommentMapper commentMapper;
    private final OrderMapper orderMapper;
    private final OrderItemMapper orderItemMapper;
    private final ObjectMapper objectMapper;

    public ProductCommentServiceImpl(ProductCommentMapper commentMapper,
                                     OrderMapper orderMapper,
                                     OrderItemMapper orderItemMapper,
                                     ObjectMapper objectMapper) {
        this.commentMapper = commentMapper;
        this.orderMapper = orderMapper;
        this.orderItemMapper = orderItemMapper;
        this.objectMapper = objectMapper;
    }

    @Override
    @Transactional
    public CommentResponses.CreateResponse create(Long userId, CommentCreateRequest request) {
        Order order = orderMapper.selectByIdAndUserId(request.getOrderId(), userId);
        if (order == null) {
            throw new BusinessException(40421, HttpStatus.NOT_FOUND, "订单不存在");
        }
        if (!Objects.equals(order.getStatus(), OrderStatus.COMPLETED)) {
            Map<String, Object> data = new LinkedHashMap<>();
            data.put("orderId", order.getId());
            data.put("status", OrderStatus.userStatusCode(order.getStatus()));
            throw new BusinessException(40941, HttpStatus.CONFLICT,
                    "当前订单状态不允许评价", data);
        }

        OrderItem item = orderItemMapper.selectById(request.getOrderItemId());
        if (item == null
                || !Objects.equals(item.getOrderId(), request.getOrderId())
                || !Objects.equals(item.getProductId(), request.getProductId())
                || !Objects.equals(item.getSkuId(), request.getSkuId())) {
            throw new BusinessException(40041, HttpStatus.BAD_REQUEST,
                    "订单明细与订单、商品或SKU不匹配");
        }

        Long duplicateCount = commentMapper.selectCount(new LambdaQueryWrapper<ProductComment>()
                .eq(ProductComment::getOrderItemId, request.getOrderItemId())
                .eq(ProductComment::getUserId, userId));
        if (duplicateCount != null && duplicateCount > 0) {
            throw duplicateComment();
        }

        LocalDateTime now = LocalDateTime.now();
        ProductComment comment = new ProductComment();
        comment.setOrderId(request.getOrderId());
        comment.setOrderItemId(request.getOrderItemId());
        comment.setProductId(request.getProductId());
        comment.setSkuId(request.getSkuId());
        comment.setUserId(userId);
        comment.setScore(request.getScore());
        comment.setContent(request.getContent());
        comment.setImages(serializeImages(request.getImageUrls()));
        comment.setAnonymous(request.getAnonymous() == null ? 0 : request.getAnonymous());
        comment.setStatus(STATUS_SHOW);
        comment.setCreateTime(now);
        comment.setUpdateTime(now);

        try {
            commentMapper.insert(comment);
        } catch (DuplicateKeyException exception) {
            throw duplicateComment();
        }

        return new CommentResponses.CreateResponse(
                comment.getId(), comment.getOrderId(), comment.getOrderItemId(),
                comment.getProductId(), comment.getScore(), statusName(comment.getStatus()),
                comment.getAnonymous(), comment.getCreateTime());
    }

    @Override
    public CommentResponses.PageResponse<CommentResponses.MyCommentItem> listMine(
            Long userId, CommentPageRequest request) {
        IPage<CommentViewRow> result = commentMapper.selectMyComments(
                new Page<>(request.getPage(), request.getPageSize()), userId);
        List<CommentResponses.MyCommentItem> list = result.getRecords().stream()
                .map(row -> new CommentResponses.MyCommentItem(
                        row.getCommentId(), row.getProductId(), row.getProductName(),
                        row.getProductImage(), row.getScore(), row.getContent(),
                        deserializeImages(row.getImages()), statusName(row.getStatus()),
                        row.getCreateTime()))
                .toList();
        return pageResponse(result, list);
    }

    @Override
    public CommentResponses.PageResponse<CommentResponses.ProductCommentItem> listByProduct(
            Long productId, ProductCommentQueryRequest request) {
        IPage<CommentViewRow> result = commentMapper.selectProductComments(
                new Page<>(request.getPage(), request.getPageSize()), productId, request.getScore());
        List<CommentResponses.ProductCommentItem> list = result.getRecords().stream()
                .map(row -> new CommentResponses.ProductCommentItem(
                        row.getCommentId(), userInfo(row), row.getScore(), row.getContent(),
                        deserializeImages(row.getImages()), row.getSkuSpecs(),
                        anonymousValue(row.getAnonymous()), row.getCreateTime()))
                .toList();
        return pageResponse(result, list);
    }

    @Override
    public CommentResponses.DetailResponse detail(Long commentId, Long currentUserId) {
        CommentViewRow row = commentMapper.selectCommentDetail(commentId);
        if (row == null) {
            throw commentNotFound();
        }
        boolean owner = currentUserId != null && Objects.equals(currentUserId, row.getUserId());
        if (!owner && !Objects.equals(row.getStatus(), STATUS_SHOW)) {
            throw commentNotFound();
        }
        return new CommentResponses.DetailResponse(
                row.getCommentId(), row.getProductId(), row.getProductName(), row.getSkuSpecs(),
                userInfo(row), row.getScore(), row.getContent(),
                deserializeImages(row.getImages()), anonymousValue(row.getAnonymous()),
                statusName(row.getStatus()), row.getCreateTime());
    }

    @Override
    @Transactional
    public void delete(Long commentId, Long userId) {
        ProductComment comment = commentMapper.selectById(commentId);
        if (comment == null || Objects.equals(comment.getStatus(), STATUS_DELETED)
                || comment.getDeleteTime() != null) {
            throw commentNotFound();
        }
        if (!Objects.equals(comment.getUserId(), userId)) {
            throw new BusinessException(40304, HttpStatus.FORBIDDEN, "无权限删除该评价");
        }

        LocalDateTime now = LocalDateTime.now();
        int affected = commentMapper.update(null, new LambdaUpdateWrapper<ProductComment>()
                .eq(ProductComment::getId, commentId)
                .eq(ProductComment::getUserId, userId)
                .ne(ProductComment::getStatus, STATUS_DELETED)
                .set(ProductComment::getStatus, STATUS_DELETED)
                .set(ProductComment::getDeleteTime, now)
                .set(ProductComment::getUpdateTime, now));
        if (affected == 0) {
            throw commentNotFound();
        }
    }

    private String serializeImages(List<String> imageUrls) {
        List<String> images = imageUrls == null ? List.of() : imageUrls;
        try {
            String json = objectMapper.writeValueAsString(images);
            if (json.length() > IMAGES_COLUMN_MAX_LENGTH) {
                throw new BusinessException(40042, HttpStatus.BAD_REQUEST,
                        "评价图片URL总长度不能超过数据库字段限制");
            }
            return json;
        } catch (JsonProcessingException exception) {
            throw new IllegalStateException("评价图片序列化失败", exception);
        }
    }

    private List<String> deserializeImages(String images) {
        if (images == null || images.isBlank()) {
            return List.of();
        }
        try {
            return objectMapper.readValue(images, new TypeReference<List<String>>() { });
        } catch (JsonProcessingException ignored) {
            // 兼容历史数据中以逗号分隔、而非 JSON 数组保存的图片地址。
            List<String> result = new ArrayList<>();
            for (String image : images.split(",")) {
                if (!image.isBlank()) {
                    result.add(image.trim());
                }
            }
            return result;
        }
    }

    private CommentResponses.UserInfo userInfo(CommentViewRow row) {
        if (Objects.equals(row.getAnonymous(), 1)) {
            return new CommentResponses.UserInfo(null, "匿名用户", "");
        }
        return new CommentResponses.UserInfo(row.getUserId(), row.getNickname(), row.getAvatar());
    }

    private int anonymousValue(Integer anonymous) {
        return Objects.equals(anonymous, 1) ? 1 : 0;
    }

    private <T> CommentResponses.PageResponse<T> pageResponse(IPage<?> page, List<T> list) {
        return new CommentResponses.PageResponse<>(
                list, page.getTotal(), page.getPages(), page.getCurrent(), page.getSize());
    }

    private String statusName(Integer status) {
        if (status == null) {
            return "UNKNOWN";
        }
        return switch (status) {
            case STATUS_HIDE -> "HIDE";
            case STATUS_SHOW -> "SHOW";
            case STATUS_DELETED -> "DELETED";
            case STATUS_BLOCKED -> "BLOCKED";
            default -> "UNKNOWN";
        };
    }

    private BusinessException duplicateComment() {
        return new BusinessException(40942, HttpStatus.CONFLICT, "该订单明细已评价");
    }

    private BusinessException commentNotFound() {
        return new BusinessException(40441, HttpStatus.NOT_FOUND, "评价不存在");
    }
}
