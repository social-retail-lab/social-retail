package com.socialretail.backend.dto.request.aftersale;
import jakarta.validation.constraints.Size;
public record AfterSaleCancelRequest(@Size(max = 500) String cancelReason) { }
