package com.socialretail.backend.service.promotion;

import java.util.List;
import java.util.Map;

public interface CouponService {
    List<Map<String, Object>> getCouponList(Integer pageNum, Integer pageSize, String keyword, String type, String status);
    void createCoupon(Map<String, Object> params);
    void updateCoupon(Long id, Map<String, Object> params);
    void enableCoupon(Long id);
    void disableCoupon(Long id);
    void deleteCoupon(Long id);
}