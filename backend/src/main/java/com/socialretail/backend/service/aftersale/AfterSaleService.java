package com.socialretail.backend.service.aftersale;

import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.dto.request.aftersale.*;
import com.socialretail.backend.dto.response.aftersale.*;
import com.socialretail.backend.enums.aftersale.AfterSaleStatus;
import com.socialretail.backend.enums.aftersale.AuditStatus;

public interface AfterSaleService {
    AfterSaleCreateResponse createAfterSale(Long userId, AfterSaleCreateRequest request);
    PageResult<AfterSaleListItemResponse> list(Long userId, AfterSaleStatus status, int page, int pageSize);
    AfterSaleDetailResponse detail(Long userId, Long afterSaleId);
    AfterSaleStatusResponse cancel(Long userId, Long afterSaleId, AfterSaleCancelRequest request);
    AfterSaleImagesResponse appendImages(Long userId, Long afterSaleId, AfterSaleImagesRequest request);

    /** 系统内部审核入口；不得由用户 Controller 暴露。 */
    void handleAuditResult(Long afterSaleId, AuditStatus auditStatus, String remark);
}
