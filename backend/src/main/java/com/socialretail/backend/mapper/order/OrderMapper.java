package com.socialretail.backend.mapper.order;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.socialretail.backend.entity.order.Order;
import com.socialretail.backend.entity.order.OrderItem;
import com.socialretail.backend.entity.order.OrderStatusLog;
import com.socialretail.backend.entity.order.PickupPoint;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface OrderMapper extends BaseMapper<Order> {
    int insertOrder(Order order);

    int insertOrderItem(OrderItem item);

    int insertStatusLog(OrderStatusLog log);

    Order selectByIdAndUserId(@Param("orderId") Long orderId, @Param("userId") Long userId);

    Order selectByUserIdAndIdempotentKey(@Param("userId") Long userId,
                                         @Param("idempotentKey") String idempotentKey);

    Order selectById(@Param("orderId") Long orderId);

    Order selectByIdForUpdate(@Param("orderId") Long orderId);

    Order selectByIdAndUserIdForUpdate(@Param("orderId") Long orderId,
                                       @Param("userId") Long userId);

    List<OrderItem> selectItemsByOrderId(@Param("orderId") Long orderId);

    List<Order> selectOrdersByUserId(@Param("userId") Long userId,
                                     @Param("status") Integer status,
                                     @Param("offset") int offset,
                                     @Param("pageSize") int pageSize);

    long countOrdersByUserId(@Param("userId") Long userId, @Param("status") Integer status);

    int decrementStock(@Param("skuId") Long skuId, @Param("quantity") Integer quantity);

    int incrementStock(@Param("skuId") Long skuId, @Param("quantity") Integer quantity);

    int cancelWaitPayOrder(@Param("orderId") Long orderId, @Param("userId") Long userId);

    int completeOrder(@Param("orderId") Long orderId, @Param("userId") Long userId);

    PickupPoint selectPickupPointById(@Param("pickupPointId") Long pickupPointId);

    List<Long> selectExpiredWaitPayOrderIds(@Param("limit") int limit);

    int expireWaitPayOrder(@Param("orderId") Long orderId);

    int updateStatusAfterPay(@Param("orderId") Long orderId,
                             @Param("status") Integer status,
                             @Param("payTime") java.time.LocalDateTime payTime,
                             @Param("updateTime") java.time.LocalDateTime updateTime);

    int updatePickupCodeIfAbsent(@Param("orderId") Long orderId,
                                 @Param("pickupCode") String pickupCode,
                                 @Param("updateTime") java.time.LocalDateTime updateTime);

    int updateStatus(@Param("orderId") Long orderId,
                     @Param("status") Integer status,
                     @Param("updateTime") java.time.LocalDateTime updateTime);

    int updatePointsStatus(@Param("orderId") Long orderId,
                           @Param("fromStatus") Integer fromStatus,
                           @Param("toStatus") Integer toStatus);
}
