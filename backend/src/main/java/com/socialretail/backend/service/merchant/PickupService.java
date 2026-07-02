package com.socialretail.backend.service.merchant;

import com.socialretail.backend.common.PageResult;

import java.util.Map;

public interface PickupService {

    Map<String, Object> verifyPickup(Long merchantId, String pickupCode);

    PageResult<Map<String, Object>> getPickupRecords(Long merchantId, String startDate, String endDate,
                                                      int pageNum, int pageSize);
}
