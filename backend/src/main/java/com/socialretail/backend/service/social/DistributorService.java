package com.socialretail.backend.service.social;

import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.dto.request.social.DistributorApplyRequest;
import com.socialretail.backend.dto.response.social.DistributorResponses;

public interface DistributorService {
    DistributorResponses.Apply apply(Long userId, DistributorApplyRequest request);

    DistributorResponses.Status status(Long userId);

    DistributorResponses.Dashboard dashboard(Long userId);

    PageResult<DistributorResponses.AvailableProduct> products(
            Long userId, String keyword, Long merchantId, int page, int pageSize);

    DistributorResponses.Promote promote(Long userId, Long distributionProductId);

    DistributorResponses.ShareLink shareLink(Long userId, Long distributorProductId);

    PageResult<DistributorResponses.MyProduct> myProducts(
            Long userId, String keyword, Integer status, int page, int pageSize);

    DistributorResponses.MyProductDetail myProductDetail(Long userId, Long distributorProductId);

    DistributorResponses.PromotionStatus disablePromotion(Long userId, Long distributorProductId);

    DistributorResponses.PromotionStatus enablePromotion(Long userId, Long distributorProductId);
}
