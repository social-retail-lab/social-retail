package com.socialretail.backend.service.product;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.socialretail.backend.common.OrderStatus;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.dto.request.comment.CommentCreateRequest;
import com.socialretail.backend.dto.response.comment.CommentResponses;
import com.socialretail.backend.entity.order.Order;
import com.socialretail.backend.entity.order.OrderItem;
import com.socialretail.backend.entity.product.ProductComment;
import com.socialretail.backend.mapper.order.OrderItemMapper;
import com.socialretail.backend.mapper.order.OrderMapper;
import com.socialretail.backend.mapper.product.CommentViewRow;
import com.socialretail.backend.mapper.product.ProductCommentMapper;
import com.socialretail.backend.service.product.impl.ProductCommentServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;

import java.time.LocalDateTime;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ProductCommentServiceImplTest {

    @Mock
    private ProductCommentMapper commentMapper;
    @Mock
    private OrderMapper orderMapper;
    @Mock
    private OrderItemMapper orderItemMapper;

    private ProductCommentServiceImpl service;

    @BeforeEach
    void setUp() {
        service = new ProductCommentServiceImpl(
                commentMapper, orderMapper, orderItemMapper, new ObjectMapper());
    }

    @Test
    void createPersistsCommentForCompletedOwnedOrder() {
        CommentCreateRequest request = request();
        Order order = order(5001L, 10001L, OrderStatus.COMPLETED);
        OrderItem item = orderItem(7001L, 5001L, 3001L, 2001L);
        when(orderMapper.selectByIdAndUserId(5001L, 10001L)).thenReturn(order);
        when(orderItemMapper.selectById(7001L)).thenReturn(item);
        when(commentMapper.selectCount(any())).thenReturn(0L);
        when(commentMapper.insert(any())).thenAnswer(invocation -> {
            ProductComment comment = invocation.getArgument(0);
            comment.setId(9001L);
            return 1;
        });

        CommentResponses.CreateResponse response = service.create(10001L, request);

        assertEquals(9001L, response.commentId());
        assertEquals("SHOW", response.status());
        assertEquals(5, response.score());
        verify(commentMapper).insert(any(ProductComment.class));
    }

    @Test
    void createRejectsOrderThatIsNotCompleted() {
        CommentCreateRequest request = request();
        when(orderMapper.selectByIdAndUserId(5001L, 10001L))
                .thenReturn(order(5001L, 10001L, OrderStatus.IN_PROGRESS));

        BusinessException exception = assertThrows(
                BusinessException.class, () -> service.create(10001L, request));

        assertEquals(40941, exception.getCode());
        assertEquals(HttpStatus.CONFLICT, exception.getHttpStatus());
        assertTrue(exception.getData() instanceof java.util.Map);
        verify(commentMapper, never()).insert(any());
    }

    @Test
    void detailHidesNonDisplayedCommentFromOtherUsers() {
        CommentViewRow row = detailRow(9001L, 10001L, 0);
        when(commentMapper.selectCommentDetail(9001L)).thenReturn(row);

        BusinessException exception = assertThrows(
                BusinessException.class, () -> service.detail(9001L, 20002L));

        assertEquals(40441, exception.getCode());
    }

    @Test
    void detailAllowsOwnerToReadHiddenComment() {
        CommentViewRow row = detailRow(9001L, 10001L, 0);
        when(commentMapper.selectCommentDetail(9001L)).thenReturn(row);

        CommentResponses.DetailResponse response = service.detail(9001L, 10001L);

        assertEquals("HIDE", response.status());
        assertEquals(10001L, response.userInfo().userId());
    }

    @Test
    void deleteRejectsAnotherUser() {
        ProductComment comment = new ProductComment();
        comment.setId(9001L);
        comment.setUserId(10001L);
        comment.setStatus(1);
        when(commentMapper.selectById(9001L)).thenReturn(comment);

        BusinessException exception = assertThrows(
                BusinessException.class, () -> service.delete(9001L, 20002L));

        assertEquals(40304, exception.getCode());
        verify(commentMapper, never()).update(any(), any());
    }

    private CommentCreateRequest request() {
        CommentCreateRequest request = new CommentCreateRequest();
        request.setOrderId(5001L);
        request.setOrderItemId(7001L);
        request.setProductId(3001L);
        request.setSkuId(2001L);
        request.setScore(5);
        request.setContent("商品质量很好，配送也很快。");
        request.setImageUrls(List.of("https://example.com/comment/1.jpg"));
        return request;
    }

    private Order order(Long id, Long userId, int status) {
        Order order = new Order();
        order.setId(id);
        order.setUserId(userId);
        order.setStatus(status);
        return order;
    }

    private OrderItem orderItem(Long id, Long orderId, Long productId, Long skuId) {
        OrderItem item = new OrderItem();
        item.setId(id);
        item.setOrderId(orderId);
        item.setProductId(productId);
        item.setSkuId(skuId);
        return item;
    }

    private CommentViewRow detailRow(Long id, Long userId, int status) {
        CommentViewRow row = new CommentViewRow();
        row.setCommentId(id);
        row.setProductId(3001L);
        row.setUserId(userId);
        row.setNickname("张三");
        row.setScore(5);
        row.setStatus(status);
        row.setImages("[]");
        row.setCreateTime(LocalDateTime.of(2026, 6, 26, 16, 0));
        return row;
    }
}
