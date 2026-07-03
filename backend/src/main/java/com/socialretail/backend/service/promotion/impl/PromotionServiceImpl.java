package com.socialretail.backend.service.promotion.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.socialretail.backend.entity.promotion.PlatformPromotion;
import com.socialretail.backend.entity.promotion.PlatformPromotionTier;
import com.socialretail.backend.entity.promotion.MerchantPromotionParticipation;
import com.socialretail.backend.mapper.promotion.PlatformPromotionMapper;
import com.socialretail.backend.mapper.promotion.PlatformPromotionTierMapper;
import com.socialretail.backend.mapper.promotion.MerchantPromotionParticipationMapper;
import com.socialretail.backend.service.promotion.PromotionService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.stream.Collectors;

@Service
public class PromotionServiceImpl implements PromotionService {

    private final PlatformPromotionMapper platformPromotionMapper;
    private final PlatformPromotionTierMapper platformPromotionTierMapper;
    private final MerchantPromotionParticipationMapper merchantPromotionParticipationMapper;

    public PromotionServiceImpl(PlatformPromotionMapper platformPromotionMapper,
                                PlatformPromotionTierMapper platformPromotionTierMapper,
                                MerchantPromotionParticipationMapper merchantPromotionParticipationMapper) {
        this.platformPromotionMapper = platformPromotionMapper;
        this.platformPromotionTierMapper = platformPromotionTierMapper;
        this.merchantPromotionParticipationMapper = merchantPromotionParticipationMapper;
    }

    @Override
    @Transactional
    public PlatformPromotion createPromotion(PlatformPromotion promotion, List<Map<String, BigDecimal>> tiers) {
        // status=0 草稿，需发布后才生效
        promotion.setStatus(0);
        promotion.setCreateTime(LocalDateTime.now());
        promotion.setUpdateTime(LocalDateTime.now());
        platformPromotionMapper.insert(promotion);

        if (tiers != null && !tiers.isEmpty()) {
            for (int i = 0; i < tiers.size(); i++) {
                Map<String, BigDecimal> tier = tiers.get(i);
                PlatformPromotionTier t = new PlatformPromotionTier();
                t.setPromotionId(promotion.getId());
                t.setMinAmount(tier.get("minAmount"));
                t.setDiscountAmount(tier.get("discountAmount"));
                t.setSortOrder(i + 1);
                platformPromotionTierMapper.insert(t);
            }
        }
        return promotion;
    }

    @Override
    public List<PlatformPromotion> listPromotions(Integer status) {
        LambdaQueryWrapper<PlatformPromotion> wrapper = new LambdaQueryWrapper<>();
        if (status != null) {
            wrapper.eq(PlatformPromotion::getStatus, status);
        }
        wrapper.orderByDesc(PlatformPromotion::getCreateTime);
        List<PlatformPromotion> promotions = platformPromotionMapper.selectList(wrapper);

        for (PlatformPromotion promotion : promotions) {
            LambdaQueryWrapper<PlatformPromotionTier> tierWrapper = new LambdaQueryWrapper<>();
            tierWrapper.eq(PlatformPromotionTier::getPromotionId, promotion.getId());
            tierWrapper.orderByAsc(PlatformPromotionTier::getMinAmount);
            List<PlatformPromotionTier> tiers = platformPromotionTierMapper.selectList(tierWrapper);
            promotion.setTiers(tiers);
        }
        return promotions;
    }

    @Override
    @Transactional
    public PlatformPromotion updatePromotion(Long id, PlatformPromotion promotion, List<Map<String, BigDecimal>> tiers) {
        PlatformPromotion existing = platformPromotionMapper.selectById(id);
        if (existing == null) {
            throw new RuntimeException("活动不存在");
        }
        // 已发布后不允许编辑
        if (existing.getStatus() != null && existing.getStatus() != 0) {
            throw new RuntimeException("已发布或已关闭的活动不可编辑");
        }
        promotion.setId(id);
        promotion.setUpdateTime(LocalDateTime.now());
        platformPromotionMapper.updateById(promotion);

        if (tiers != null) {
            LambdaQueryWrapper<PlatformPromotionTier> deleteWrapper = new LambdaQueryWrapper<>();
            deleteWrapper.eq(PlatformPromotionTier::getPromotionId, id);
            platformPromotionTierMapper.delete(deleteWrapper);

            for (int i = 0; i < tiers.size(); i++) {
                Map<String, BigDecimal> tier = tiers.get(i);
                PlatformPromotionTier t = new PlatformPromotionTier();
                t.setPromotionId(id);
                t.setMinAmount(tier.get("minAmount"));
                t.setDiscountAmount(tier.get("discountAmount"));
                t.setSortOrder(i + 1);
                platformPromotionTierMapper.insert(t);
            }
        }

        return platformPromotionMapper.selectById(id);
    }

    @Override
    @Transactional
    public void closePromotion(Long id) {
        PlatformPromotion existing = platformPromotionMapper.selectById(id);
        if (existing == null) {
            throw new RuntimeException("活动不存在");
        }
        PlatformPromotion promotion = new PlatformPromotion();
        promotion.setId(id);
        promotion.setStatus(2);
        promotion.setUpdateTime(LocalDateTime.now());
        platformPromotionMapper.updateById(promotion);
    }

    @Override
    @Transactional
    public void publishPromotion(Long id) {
        PlatformPromotion existing = platformPromotionMapper.selectById(id);
        if (existing == null) {
            throw new RuntimeException("活动不存在");
        }
        if (existing.getStatus() != null && existing.getStatus() != 0) {
            throw new RuntimeException("只有草稿状态的活动可以发布");
        }
        // 开始时间不可早于发布时间
        LocalDateTime now = LocalDateTime.now();
        if (existing.getStartTime() != null && existing.getStartTime().isBefore(now)) {
            throw new RuntimeException("开始时间不可早于发布时间");
        }
        PlatformPromotion promotion = new PlatformPromotion();
        promotion.setId(id);
        promotion.setStatus(1);
        promotion.setUpdateTime(LocalDateTime.now());
        platformPromotionMapper.updateById(promotion);
    }

    @Override
    @Transactional
    public void deletePromotion(Long id) {
        PlatformPromotion existing = platformPromotionMapper.selectById(id);
        if (existing == null) {
            throw new RuntimeException("活动不存在");
        }
        if (existing.getStatus() == null || existing.getStatus() != 2) {
            throw new RuntimeException("只有已关闭的活动可以删除");
        }
        // 删除梯度
        LambdaQueryWrapper<PlatformPromotionTier> tierWrapper = new LambdaQueryWrapper<>();
        tierWrapper.eq(PlatformPromotionTier::getPromotionId, id);
        platformPromotionTierMapper.delete(tierWrapper);
        // 删除活动
        platformPromotionMapper.deleteById(id);
    }

    @Override
    public List<Map<String, Object>> getMerchantPromotions(Long merchantId) {
        // 只查询已发布（status=1）且未过期的活动（商家可提前查看并参与）
        LambdaQueryWrapper<PlatformPromotion> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(PlatformPromotion::getStatus, 1);
        wrapper.ge(PlatformPromotion::getEndTime, LocalDateTime.now());
        wrapper.orderByDesc(PlatformPromotion::getCreateTime);
        List<PlatformPromotion> promotions = platformPromotionMapper.selectList(wrapper);

        LambdaQueryWrapper<MerchantPromotionParticipation> partWrapper = new LambdaQueryWrapper<>();
        partWrapper.eq(MerchantPromotionParticipation::getMerchantId, merchantId);
        List<MerchantPromotionParticipation> participations = merchantPromotionParticipationMapper.selectList(partWrapper);
        Map<Long, Integer> participationMap = new HashMap<>();
        for (MerchantPromotionParticipation p : participations) {
            participationMap.put(p.getPromotionId(), p.getStatus());
        }

        List<Map<String, Object>> result = new ArrayList<>();
        for (PlatformPromotion promotion : promotions) {
            LambdaQueryWrapper<PlatformPromotionTier> tierWrapper = new LambdaQueryWrapper<>();
            tierWrapper.eq(PlatformPromotionTier::getPromotionId, promotion.getId());
            tierWrapper.orderByAsc(PlatformPromotionTier::getMinAmount);
            List<PlatformPromotionTier> tiers = platformPromotionTierMapper.selectList(tierWrapper);

            Map<String, Object> item = new HashMap<>();
            item.put("id", promotion.getId());
            item.put("promotionId", promotion.getId());
            item.put("title", promotion.getTitle());
            item.put("startTime", promotion.getStartTime());
            item.put("endTime", promotion.getEndTime());
            item.put("status", promotion.getStatus());
            item.put("tiers", tiers);
            Integer participated = participationMap.getOrDefault(promotion.getId(), 0);
            item.put("participated", participated);
            // 前端兼容：joined 同 participated
            item.put("joined", participated == 1);

            result.add(item);
        }
        return result;
    }

    @Override
    @Transactional
    public void participatePromotion(Long merchantId, Long promotionId) {
        LambdaQueryWrapper<MerchantPromotionParticipation> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(MerchantPromotionParticipation::getMerchantId, merchantId);
        wrapper.eq(MerchantPromotionParticipation::getPromotionId, promotionId);
        MerchantPromotionParticipation existing = merchantPromotionParticipationMapper.selectOne(wrapper);

        if (existing != null) {
            existing.setStatus(1);
            existing.setUpdateTime(LocalDateTime.now());
            merchantPromotionParticipationMapper.updateById(existing);
        } else {
            MerchantPromotionParticipation participation = new MerchantPromotionParticipation();
            participation.setMerchantId(merchantId);
            participation.setPromotionId(promotionId);
            participation.setStatus(1);
            participation.setCreateTime(LocalDateTime.now());
            participation.setUpdateTime(LocalDateTime.now());
            merchantPromotionParticipationMapper.insert(participation);
        }
    }

    @Override
    @Transactional
    public void quitPromotion(Long merchantId, Long promotionId) {
        LambdaUpdateWrapper<MerchantPromotionParticipation> wrapper = new LambdaUpdateWrapper<>();
        wrapper.eq(MerchantPromotionParticipation::getMerchantId, merchantId);
        wrapper.eq(MerchantPromotionParticipation::getPromotionId, promotionId);
        wrapper.set(MerchantPromotionParticipation::getStatus, 0);
        wrapper.set(MerchantPromotionParticipation::getUpdateTime, LocalDateTime.now());
        merchantPromotionParticipationMapper.update(null, wrapper);
    }
}
