package com.socialretail.backend.service.order;

import com.socialretail.backend.common.PageResult;

import java.math.BigDecimal;
import java.util.Map;

public interface AfterSaleService {

    PageResult<Map<String, Object>> getAfterSaleList(Long merchantId, Integer type, Integer status,
                                                      String orderSn, int pageNum, int pageSize);

    Map<String, Object> getAfterSaleDetail(Long merchantId, Long afterSaleId);

    Map<String, Object> auditAfterSale(Long merchantId, Long afterSaleId, Integer action,
                                        String remark, BigDecimal actualRefundAmount);

    Map<String, Object> returnConfirm(Long merchantId, Long afterSaleId, Integer receivedStatus, String remark);

    void addFeedback(Long merchantId, Long afterSaleId, String content, String images);
}
