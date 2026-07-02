package com.socialretail.backend.service.merchant;

import com.socialretail.backend.common.PageResult;

import java.util.Map;

public interface MerchantOrderService {

    PageResult<Map<String, Object>> getOrderList(Long merchantId, Integer status, Integer deliveryType,
                                                  String orderSn, String startDate, String endDate,
                                                  int pageNum, int pageSize);

    Map<String, Object> getOrderDetail(Long orderId, Long merchantId);

    Map<String, Object> acceptOrder(Long orderId, Long merchantId, String remark);

    Map<String, Object> prepareGoods(Long orderId, Long merchantId, String remark);

    Map<String, Object> shipOrder(Long orderId, Long merchantId, String remark);

    Map<String, Object> cancelOrder(Long orderId, Long merchantId, String reason);
}
