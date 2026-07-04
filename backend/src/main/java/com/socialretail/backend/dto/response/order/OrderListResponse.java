package com.socialretail.backend.dto.response.order;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrderListResponse {
    private List<OrderSummaryResponse> list;
    private Long total;
    private Integer pages;
    private Integer page;
    private Integer pageSize;
}
