package com.socialretail.backend.mapper.promotion;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.socialretail.backend.entity.promotion.Banner;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface BannerMapper extends BaseMapper<Banner> {

    @Select("""
            SELECT id, title, image_url, type, target_id, sort_order, status, created_at, updated_at
            FROM banner
            WHERE status = 1
            ORDER BY sort_order ASC, id ASC
            """)
    List<Banner> selectActiveBanners();
}
