package com.socialretail.backend.mapper.member;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.socialretail.backend.entity.member.MerchantCoupon;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface MerchantCouponMapper extends BaseMapper<MerchantCoupon> {
    @Select("SELECT * FROM merchant_coupon WHERE id = #{couponId} FOR UPDATE")
    MerchantCoupon selectByIdForUpdate(@Param("couponId") Long couponId);

    @Update("UPDATE merchant_coupon SET received_count = received_count + 1, update_time = CURRENT_TIMESTAMP " +
            "WHERE id = #{couponId} AND status = 1 AND received_count < total_count")
    int incrementReceivedCount(@Param("couponId") Long couponId);
}
