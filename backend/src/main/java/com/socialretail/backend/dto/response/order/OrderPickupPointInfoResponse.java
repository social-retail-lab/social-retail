package com.socialretail.backend.dto.response.order;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrderPickupPointInfoResponse {
    private Long pickupPointId;
    private String name;
    private String address;
    private String contactPhone;
    private String businessHours;
}
