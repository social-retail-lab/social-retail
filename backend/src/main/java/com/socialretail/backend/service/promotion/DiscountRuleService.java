package com.socialretail.backend.service.promotion;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.socialretail.backend.dto.promotion.PromotionApiModels.DiscountRuleAvailable;
import com.socialretail.backend.dto.promotion.PromotionApiModels.DiscountRuleItem;
import com.socialretail.backend.entity.member.DiscountRule;
import com.socialretail.backend.mapper.member.DiscountRuleMapper;
import com.socialretail.backend.common.exception.BusinessException;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Locale;

@Service
public class DiscountRuleService {
    private final DiscountRuleMapper discountRuleMapper;

    public DiscountRuleService(DiscountRuleMapper discountRuleMapper) {
        this.discountRuleMapper = discountRuleMapper;
    }

    public DiscountRuleAvailable available(BigDecimal orderAmount, Long merchantId, String requestedScene) {
        String scene = normalizeScene(requestedScene, orderAmount);
        boolean calculateAmount = !"PRODUCT".equals(scene) && orderAmount != null;
        LocalDateTime now = LocalDateTime.now();
        List<DiscountRule> rules = discountRuleMapper.selectList(
                Wrappers.<DiscountRule>lambdaQuery()
                        .eq(DiscountRule::getStatus, 1)
                        .eq(DiscountRule::getType, 1)
                        .le(DiscountRule::getStartTime, now)
                        .ge(DiscountRule::getEndTime, now)
                        .orderByAsc(DiscountRule::getMinAmount)
                        .orderByDesc(DiscountRule::getDiscountAmount));
        List<DiscountRuleItem> items = rules.stream().map(rule -> {
            BigDecimal minimum = money(rule.getMinAmount());
            Boolean usable = calculateAmount ? orderAmount.compareTo(minimum) >= 0 : null;
            BigDecimal need = !calculateAmount ? null
                    : Boolean.TRUE.equals(usable) ? money(BigDecimal.ZERO)
                    : money(minimum.subtract(orderAmount));
            String label = rule.getTitle() == null || rule.getTitle().isBlank()
                    ? "满" + minimum.stripTrailingZeros().toPlainString()
                    + "减" + money(rule.getDiscountAmount()).stripTrailingZeros().toPlainString()
                    : rule.getTitle();
            return new DiscountRuleItem(rule.getId(), rule.getTitle(), rule.getType(), "满减",
                    minimum, money(rule.getDiscountAmount()), null, usable, need,
                    label, "FULL_REDUCTION",
                    rule.getStartTime(), rule.getEndTime());
        }).toList();
        return new DiscountRuleAvailable(merchantId, scene,
                orderAmount == null ? null : money(orderAmount), items);
    }

    private String normalizeScene(String requestedScene, BigDecimal orderAmount) {
        if (requestedScene == null || requestedScene.isBlank()) {
            return orderAmount == null ? "PRODUCT" : "CART";
        }
        String scene = requestedScene.trim().toUpperCase(Locale.ROOT);
        if (!scene.equals("PRODUCT") && !scene.equals("CART") && !scene.equals("CHECKOUT")) {
            throw new BusinessException(40001, HttpStatus.BAD_REQUEST,
                    "scene仅支持PRODUCT、CART或CHECKOUT");
        }
        return scene;
    }

    private BigDecimal money(BigDecimal value) {
        return value == null ? new BigDecimal("0.00") : value.setScale(2, RoundingMode.HALF_UP);
    }
}
