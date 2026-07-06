package com.socialretail.backend.controller.merchant;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.socialretail.backend.common.Result;
import com.socialretail.backend.entity.product.Product;
import com.socialretail.backend.entity.promotion.*;
import com.socialretail.backend.mapper.product.ProductMapper;
import com.socialretail.backend.mapper.promotion.*;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/merchant/seckill")
public class MerchantSeckillController {

    @Resource
    private SeckillActivityMapper seckillActivityMapper;
    @Resource
    private SeckillProductMapper seckillProductMapper;
    @Resource
    private ProductMapper productMapper;

    @GetMapping("/activities")
    public Result listActivities(HttpServletRequest request) {
        List<SeckillActivity> activities = seckillActivityMapper.selectList(
            new LambdaQueryWrapper<SeckillActivity>().eq(SeckillActivity::getStatus, 1)
                .orderByDesc(SeckillActivity::getId)
        );
        return Result.success(activities);
    }

    @GetMapping("/activities/{activityId}/products")
    public Result listMyProducts(@PathVariable Long activityId, HttpServletRequest request) {
        Long merchantId = getMerchantId(request);
        List<SeckillProduct> products = seckillProductMapper.selectList(
            new LambdaQueryWrapper<SeckillProduct>()
                .eq(SeckillProduct::getSeckillActivityId, activityId)
        );
        List<Map<String, Object>> result = products.stream()
            .filter(p -> {
                Product prod = productMapper.selectById(p.getProductId());
                return prod != null && prod.getMerchantId() != null && prod.getMerchantId().equals(merchantId);
            })
            .map(p -> {
                Map<String, Object> m = new HashMap<>();
                m.put("id", p.getId());
                m.put("activityId", p.getSeckillActivityId());
                m.put("productId", p.getProductId());
                m.put("skuId", p.getSkuId());
                m.put("seckillPrice", p.getSeckillPrice());
                m.put("seckillStock", p.getSeckillStock());
                m.put("soldCount", p.getSoldCount());
                m.put("limitQuantity", p.getLimitQuantity());
                m.put("status", p.getStatus());
                Product prod = productMapper.selectById(p.getProductId());
                m.put("productName", prod != null ? prod.getTitle() : "");
                return m;
            }).collect(Collectors.toList());
        return Result.success(result);
    }

    @PostMapping("/activities/{activityId}/products")
    public Result addProduct(@PathVariable Long activityId,
                              @RequestBody Map<String, Object> params,
                              HttpServletRequest request) {
        Long merchantId = getMerchantId(request);
        SeckillActivity activity = seckillActivityMapper.selectById(activityId);
        if (activity == null) return Result.fail("活动不存在");
        if (activity.getStatus() == null || activity.getStatus() != 1)
            return Result.fail("活动未发布");

        SeckillProduct sp = new SeckillProduct();
        sp.setSeckillActivityId(activityId);
        sp.setProductId(toLong(params.get("productId")));
        sp.setSkuId(params.get("skuId") != null ? params.get("skuId").toString() : null);
        Object price = params.get("seckillPrice");
        if (price != null) sp.setSeckillPrice(toBigDecimal(price));
        Object stock = params.get("seckillStock");
        if (stock != null) sp.setSeckillStock(toInt(stock));
        Object limit = params.get("limitQuantity");
        if (limit != null) sp.setLimitQuantity(toInt(limit));
        sp.setSoldCount(0);
        sp.setStatus(1);
        sp.setCreateTime(LocalDateTime.now());
        sp.setUpdateTime(LocalDateTime.now());
        seckillProductMapper.insert(sp);
        return Result.success(sp);
    }

    @PutMapping("/products/{productId}")
    public Result updateProduct(@PathVariable Long productId,
                                 @RequestBody Map<String, Object> params,
                                 HttpServletRequest request) {
        SeckillProduct sp = seckillProductMapper.selectById(productId);
        if (sp == null) return Result.fail("秒杀商品不存在");
        Object price = params.get("seckillPrice");
        if (price != null) sp.setSeckillPrice(toBigDecimal(price));
        Object stock = params.get("seckillStock");
        if (stock != null) sp.setSeckillStock(toInt(stock));
        Object limit = params.get("limitQuantity");
        if (limit != null) sp.setLimitQuantity(toInt(limit));
        sp.setUpdateTime(LocalDateTime.now());
        seckillProductMapper.updateById(sp);
        return Result.success(null);
    }

    @DeleteMapping("/products/{productId}")
    public Result removeProduct(@PathVariable Long productId, HttpServletRequest request) {
        seckillProductMapper.deleteById(productId);
        return Result.success(null);
    }

    private Long getMerchantId(HttpServletRequest request) {
        Object attr = request.getAttribute("merchantId");
        if (attr != null) return Long.parseLong(attr.toString());
        throw new RuntimeException("未登录");
    }

    private Long toLong(Object v) {
        if (v == null) return null;
        if (v instanceof Long) return (Long) v;
        if (v instanceof Number) return ((Number) v).longValue();
        return Long.parseLong(v.toString());
    }

    private BigDecimal toBigDecimal(Object v) {
        if (v == null) return null;
        if (v instanceof BigDecimal) return (BigDecimal) v;
        if (v instanceof Number) return BigDecimal.valueOf(((Number) v).doubleValue());
        return new BigDecimal(v.toString());
    }

    private Integer toInt(Object v) {
        if (v == null) return null;
        if (v instanceof Integer) return (Integer) v;
        if (v instanceof Number) return ((Number) v).intValue();
        return Integer.parseInt(v.toString());
    }
}
