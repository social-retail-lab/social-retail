package com.socialretail.backend.service.promotion.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.socialretail.backend.entity.promotion.Coupon;
import com.socialretail.backend.mapper.promotion.CouponMapper;
import com.socialretail.backend.service.promotion.CouponService;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class CouponServiceImpl implements CouponService {

    private final CouponMapper couponMapper;

    public CouponServiceImpl(CouponMapper couponMapper) {
        this.couponMapper = couponMapper;
    }

    @Override
    public List<Map<String, Object>> getCouponList(Integer pageNum, Integer pageSize, String keyword, String type, String status) {
        LambdaQueryWrapper<Coupon> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(keyword)) {
            wrapper.like(Coupon::getTitle, keyword);
        }
        if (StringUtils.hasText(type)) {
            wrapper.eq(Coupon::getType, Integer.parseInt(type));
        }
        if (StringUtils.hasText(status)) {
            wrapper.eq(Coupon::getStatus, Integer.parseInt(status));
        }
        wrapper.orderByDesc(Coupon::getCreateTime);

        Page<Coupon> page = new Page<>(pageNum != null ? pageNum : 1, pageSize != null ? pageSize : 10);
        Page<Coupon> result = couponMapper.selectPage(page, wrapper);

        return result.getRecords().stream().map(c -> {
            Map<String, Object> map = new LinkedHashMap<>();
            map.put("id", c.getId());
            map.put("title", c.getTitle());
            map.put("type", c.getType());
            map.put("minConsume", c.getMinConsume());
            map.put("discountAmount", c.getDiscountAmount());
            map.put("totalCount", c.getTotalCount());
            map.put("receivedCount", c.getReceivedCount());
            map.put("status", c.getStatus());
            map.put("validStart", c.getValidStart());
            map.put("validEnd", c.getValidEnd());
            map.put("createTime", c.getCreateTime());
            return map;
        }).collect(Collectors.toList());
    }

    @Override
    public void createCoupon(Map<String, Object> params) {
        Coupon coupon = new Coupon();
        coupon.setTitle((String) params.get("title"));
        if (params.get("type") != null) coupon.setType(toInt(params.get("type")));
        if (params.get("minConsume") != null) coupon.setMinConsume(toBigDecimal(params.get("minConsume")));
        if (params.get("discountAmount") != null) coupon.setDiscountAmount(toBigDecimal(params.get("discountAmount")));
        if (params.get("totalCount") != null) coupon.setTotalCount(toInt(params.get("totalCount")));
        coupon.setReceivedCount(0);
        coupon.setStatus(1);
        couponMapper.insert(coupon);
    }

    @Override
    public void updateCoupon(Long id, Map<String, Object> params) {
        Coupon coupon = couponMapper.selectById(id);
        if (coupon == null) return;
        if (params.containsKey("title")) coupon.setTitle((String) params.get("title"));
        if (params.containsKey("type")) coupon.setType(toInt(params.get("type")));
        if (params.containsKey("minConsume")) coupon.setMinConsume(toBigDecimal(params.get("minConsume")));
        if (params.containsKey("discountAmount")) coupon.setDiscountAmount(toBigDecimal(params.get("discountAmount")));
        if (params.containsKey("totalCount")) coupon.setTotalCount(toInt(params.get("totalCount")));
        couponMapper.updateById(coupon);
    }

    @Override
    public void enableCoupon(Long id) {
        LambdaUpdateWrapper<Coupon> wrapper = new LambdaUpdateWrapper<>();
        wrapper.eq(Coupon::getId, id).set(Coupon::getStatus, 1);
        couponMapper.update(null, wrapper);
    }

    @Override
    public void disableCoupon(Long id) {
        LambdaUpdateWrapper<Coupon> wrapper = new LambdaUpdateWrapper<>();
        wrapper.eq(Coupon::getId, id).set(Coupon::getStatus, 0);
        couponMapper.update(null, wrapper);
    }

    @Override
    public void deleteCoupon(Long id) {
        couponMapper.deleteById(id);
    }

    private Integer toInt(Object val) {
        return val != null ? Integer.parseInt(val.toString()) : null;
    }

    private BigDecimal toBigDecimal(Object val) {
        return val != null ? new BigDecimal(val.toString()) : null;
    }
}
