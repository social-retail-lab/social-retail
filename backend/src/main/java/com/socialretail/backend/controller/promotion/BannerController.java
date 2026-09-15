package com.socialretail.backend.controller.promotion;

import com.socialretail.backend.common.ImageUrlResolver;
import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.entity.promotion.Banner;
import com.socialretail.backend.mapper.promotion.BannerMapper;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/promotion")
public class BannerController {

    private final BannerMapper bannerMapper;
    private final ImageUrlResolver imageUrlResolver;

    public BannerController(BannerMapper bannerMapper, ImageUrlResolver imageUrlResolver) {
        this.bannerMapper = bannerMapper;
        this.imageUrlResolver = imageUrlResolver;
    }

    @GetMapping("/banner-list")
    public Result<List<Map<String, Object>>> bannerList() {
        List<Banner> banners = bannerMapper.selectActiveBanners();
        List<Map<String, Object>> result = banners.stream().map(banner -> {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("id", banner.getId());
            item.put("image", imageUrlResolver.resolve(banner.getImageUrl()));
            item.put("type", banner.getType());
            item.put("target_id", banner.getTargetId());
            return item;
        }).toList();
        return Result.success(result);
    }
}
