package com.socialretail.backend.service.social;

import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.dto.request.social.CommissionCalcRequest;
import com.socialretail.backend.dto.request.social.DistributorWithdrawRequest;
import com.socialretail.backend.dto.response.social.DistributorResponses;
import com.socialretail.backend.entity.order.Order;
import com.socialretail.backend.entity.order.OrderItem;
import java.time.LocalDateTime;
import java.util.List;

public interface CommissionService {
    PageResult<DistributorResponses.PromotionOrder> orders(
            Long userId, Integer status, String keyword, int page, int pageSize);

    DistributorResponses.SimplePage<DistributorResponses.CommissionDetail> details(
            Long userId, Integer status, int page, int size);

    DistributorResponses.Withdraw withdraw(Long userId, DistributorWithdrawRequest request);

    DistributorResponses.SimplePage<DistributorResponses.WithdrawRecord> withdrawRecords(
            Long userId, Integer status, int page, int size);

    DistributorResponses.CommissionCalc calculate(CommissionCalcRequest request);

    void createForPaidOrder(Order order, List<OrderItem> items, LocalDateTime payTime);

    int settleDueCommissions();
}
