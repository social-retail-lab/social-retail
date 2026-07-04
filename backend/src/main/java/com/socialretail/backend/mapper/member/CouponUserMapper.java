package com.socialretail.backend.mapper.member;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.socialretail.backend.entity.member.CouponUser;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Update;
import java.time.LocalDateTime;

@Mapper
public interface CouponUserMapper extends BaseMapper<CouponUser> {
    @Update("UPDATE coupon_user SET status=1, order_id=#{orderId}, use_time=#{useTime} " +
            "WHERE id=#{couponUserId} AND user_id=#{userId} AND status=0")
    int markUsed(@Param("couponUserId") Long couponUserId, @Param("userId") Long userId,
                 @Param("orderId") Long orderId, @Param("useTime") LocalDateTime useTime);

    @Update("UPDATE coupon_user SET status=0, order_id=NULL, use_time=NULL " +
            "WHERE order_id=#{orderId} AND status=1")
    int restoreByOrderId(@Param("orderId") Long orderId);
}
