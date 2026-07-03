package com.socialretail.backend.mapper.promotion;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.socialretail.backend.entity.promotion.SeckillActivity;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import java.time.LocalDateTime;

@Mapper
public interface SeckillActivityMapper extends BaseMapper<SeckillActivity> {
    @Select("""
            SELECT id, title, start_time, end_time, status
            FROM seckill_activity
            WHERE start_time <= #{latestStart}
              AND end_time > #{now}
              AND COALESCE(status, 0) IN (0, 1)
            ORDER BY CASE WHEN start_time <= #{now} THEN 0 ELSE 1 END, start_time ASC, id ASC
            LIMIT 1
            """)
    SeckillActivity selectCurrentDisplayable(@Param("now") LocalDateTime now,
                                              @Param("latestStart") LocalDateTime latestStart);
}
