package com.socialretail.backend.service.promotion;

import com.socialretail.backend.dto.promotion.SeckillApiModels.ActivityInfo;
import com.socialretail.backend.dto.promotion.SeckillApiModels.ProductPage;
import com.socialretail.backend.dto.promotion.SeckillApiModels.Qualification;

public interface SeckillService {
    ActivityInfo getCurrentActivity();
    ProductPage getCurrentProducts(int page, int pageSize);
    Qualification checkQualification(Long userId, Long seckillProductId);
    void warmCurrentActivity();
}
