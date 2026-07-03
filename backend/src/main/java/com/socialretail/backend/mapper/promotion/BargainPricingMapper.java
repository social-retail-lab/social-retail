package com.socialretail.backend.mapper.promotion;

import com.socialretail.backend.dto.promotion.BargainRecordView;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface BargainPricingMapper {
    @Select("SELECT id bargain_record_id,user_id,product_id,sku_id,current_price,end_time,status " +
            "FROM bargain_activity WHERE user_id=#{userId} AND status=1 AND end_time>#{now}")
    List<BargainRecordView> selectActiveByUser(@Param("userId") Long userId,
                                               @Param("now") LocalDateTime now);

    @Select("SELECT id bargain_record_id,user_id,product_id,sku_id,current_price,end_time,status " +
            "FROM bargain_activity WHERE id=#{recordId} LIMIT 1")
    BargainRecordView selectViewById(@Param("recordId") Long recordId);
}
