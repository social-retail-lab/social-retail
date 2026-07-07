package com.socialretail.backend.mapper.order;

import com.socialretail.backend.entity.order.Cart;
import com.socialretail.backend.vo.CartItemVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CartMapper {
    Cart selectByIdAndUserId(@Param("id") Long id, @Param("userId") Long userId);

    Cart selectByUserIdAndSkuId(@Param("userId") Long userId, @Param("skuId") Long skuId);

    List<CartItemVO> selectCartItemsByUserId(@Param("userId") Long userId);

    List<CartItemVO> selectCartItemsByIds(@Param("userId") Long userId,
                                          @Param("cartItemIds") List<Long> cartItemIds);

    int insert(Cart cart);

    int updateQuantity(@Param("id") Long id,
                       @Param("userId") Long userId,
                       @Param("quantity") Integer quantity);

    int updateQuantityAndAttribution(@Param("id") Long id,
                                     @Param("userId") Long userId,
                                     @Param("quantity") Integer quantity,
                                     @Param("distributorProductId") Long distributorProductId,
                                     @Param("attributionExpiresAt") java.time.LocalDateTime attributionExpiresAt);

    int deleteByIdAndUserId(@Param("id") Long id, @Param("userId") Long userId);

    int deleteByIdsAndUserId(@Param("userId") Long userId,
                             @Param("cartItemIds") List<Long> cartItemIds);
}
