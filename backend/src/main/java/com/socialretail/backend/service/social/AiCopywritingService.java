package com.socialretail.backend.service.social;

/**
 * AI 营销文案生成服务。
 */
public interface AiCopywritingService {

    /**
     * 根据分销员推广商品生成营销推广文案。
     *
     * @param userId              当前登录用户 ID
     * @param distributorProductId 分销员推广商品记录 ID
     * @return AI 生成的推广文案
     */
    String generateCopywriting(Long userId, Long distributorProductId);
}
