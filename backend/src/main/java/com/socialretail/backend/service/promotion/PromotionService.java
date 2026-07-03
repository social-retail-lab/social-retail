package com.socialretail.backend.service.promotion;

import com.socialretail.backend.entity.promotion.PlatformPromotion;
import java.util.List;
import java.util.Map;
import java.math.BigDecimal;

public interface PromotionService {
    // 平台促销活动CRUD
    PlatformPromotion createPromotion(PlatformPromotion promotion, List<Map<String, BigDecimal>> tiers);
    List<PlatformPromotion> listPromotions(Integer status);
    PlatformPromotion updatePromotion(Long id, PlatformPromotion promotion, List<Map<String, BigDecimal>> tiers);
    void closePromotion(Long id);
    void publishPromotion(Long id);
    void deletePromotion(Long id);

    // 商家端-查看平台促销活动
    List<Map<String, Object>> getMerchantPromotions(Long merchantId);

    // 商家参与/不参与促销
    void participatePromotion(Long merchantId, Long promotionId);
    void quitPromotion(Long merchantId, Long promotionId);
}
