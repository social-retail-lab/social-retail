package com.socialretail.backend.mapper.member;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.socialretail.backend.entity.member.Coupon;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface CouponMapper extends BaseMapper<Coupon> {
    @Select("SELECT * FROM coupon WHERE id = #{couponId} FOR UPDATE")
    Coupon selectByIdForUpdate(@Param("couponId") Long couponId);
}
