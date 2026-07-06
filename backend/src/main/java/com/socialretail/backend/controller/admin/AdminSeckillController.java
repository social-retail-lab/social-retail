package com.socialretail.backend.controller.admin;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.socialretail.backend.common.Result;
import com.socialretail.backend.entity.product.Product;
import com.socialretail.backend.entity.promotion.*;
import com.socialretail.backend.mapper.product.ProductMapper;
import com.socialretail.backend.mapper.promotion.*;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/admin/seckill-activities")
public class AdminSeckillController {

    @Resource
    private SeckillActivityMapper seckillActivityMapper;
    @Resource
    private SeckillProductMapper seckillProductMapper;
    @Resource
    private ProductMapper productMapper;

    @GetMapping
    public Result list(@RequestParam(defaultValue = "1") Integer page,
                       @RequestParam(defaultValue = "10") Integer pageSize,
                       @RequestParam(required = false) Integer status) {
        LambdaQueryWrapper<SeckillActivity> wrapper = new LambdaQueryWrapper<>();
        if (status != null) wrapper.eq(SeckillActivity::getStatus, status);
        wrapper.orderByDesc(SeckillActivity::getId);
        Page<SeckillActivity> pg = seckillActivityMapper.selectPage(new Page<>(page, pageSize), wrapper);
        List<Map<String, Object>> list = pg.getRecords().stream().map(a -> {
            Map<String, Object> m = new HashMap<>();
            m.put("id", a.getId());
            m.put("title", a.getTitle());
            m.put("startTime", a.getStartTime());
            m.put("endTime", a.getEndTime());
            m.put("status", a.getStatus());
            return m;
        }).collect(Collectors.toList());
        Map<String, Object> result = new HashMap<>();
        result.put("total", pg.getTotal());
        result.put("list", list);
        return Result.success(result);
    }

    @GetMapping("/{id}")
    public Result detail(@PathVariable Long id) {
        SeckillActivity a = seckillActivityMapper.selectById(id);
        if (a == null) return Result.fail("活动不存在");
        List<SeckillProduct> products = seckillProductMapper.selectList(
            new LambdaQueryWrapper<SeckillProduct>().eq(SeckillProduct::getSeckillActivityId, id)
        );
        Map<String, Object> result = new HashMap<>();
        result.put("id", a.getId());
        result.put("title", a.getTitle());
        result.put("startTime", a.getStartTime());
        result.put("endTime", a.getEndTime());
        result.put("status", a.getStatus());
        result.put("products", products);
        return Result.success(result);
    }

    @PostMapping
    public Result create(@RequestBody Map<String, Object> params) {
        String timeErr = validateSeckillTime(params);
        if (timeErr != null) return Result.fail(timeErr);

        SeckillActivity a = new SeckillActivity();
        a.setTitle((String) params.get("title"));
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String st = (String) params.get("startTime");
        if (st != null && !st.isEmpty()) a.setStartTime(LocalDateTime.parse(st, fmt));
        String et = (String) params.get("endTime");
        if (et != null && !et.isEmpty()) a.setEndTime(LocalDateTime.parse(et, fmt));
        a.setStatus(0);
        seckillActivityMapper.insert(a);
        return Result.success(a);
    }

    @PutMapping("/{id}")
    public Result update(@PathVariable Long id, @RequestBody Map<String, Object> params) {
        SeckillActivity a = seckillActivityMapper.selectById(id);
        if (a == null) return Result.fail("活动不存在");
        if (a.getStatus() != null && a.getStatus() != 0) return Result.fail("仅草稿状态可编辑");

        // 构建最终时间用于校验
        String startTime = params.containsKey("startTime") ? (String) params.get("startTime") : null;
        String endTime = params.containsKey("endTime") ? (String) params.get("endTime") : null;
        if (startTime != null || endTime != null) {
            DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            String st = startTime != null ? startTime : (a.getStartTime() != null ? a.getStartTime().format(fmt) : null);
            String et = endTime != null ? endTime : (a.getEndTime() != null ? a.getEndTime().format(fmt) : null);
            if (st != null && et != null && st.compareTo(et) >= 0) {
                return Result.fail("结束时间必须晚于开始时间");
            }
        }

        if (params.containsKey("title")) a.setTitle((String) params.get("title"));
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        if (params.containsKey("startTime")) {
            String st = (String) params.get("startTime");
            if (st != null && !st.isEmpty()) a.setStartTime(LocalDateTime.parse(st, fmt));
        }
        if (params.containsKey("endTime")) {
            String et = (String) params.get("endTime");
            if (et != null && !et.isEmpty()) a.setEndTime(LocalDateTime.parse(et, fmt));
        }
        seckillActivityMapper.updateById(a);
        return Result.success(null);
    }

    @PostMapping("/{id}/publish")
    public Result publish(@PathVariable Long id) {
        SeckillActivity a = seckillActivityMapper.selectById(id);
        if (a == null) return Result.fail("活动不存在");
        if (a.getStatus() != null && a.getStatus() != 0) return Result.fail("仅草稿可发布");
        if (a.getStartTime() != null && a.getStartTime().isBefore(LocalDateTime.now()))
            return Result.fail("开始时间不可早于发布时间");
        a.setStatus(1);
        seckillActivityMapper.updateById(a);
        return Result.success(null);
    }

    @PostMapping("/{id}/close")
    public Result close(@PathVariable Long id) {
        SeckillActivity a = seckillActivityMapper.selectById(id);
        if (a == null) return Result.fail("活动不存在");
        a.setStatus(2);
        seckillActivityMapper.updateById(a);
        return Result.success(null);
    }

    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Long id) {
        SeckillActivity a = seckillActivityMapper.selectById(id);
        if (a == null) return Result.fail("活动不存在");
        if (a.getStatus() == null || a.getStatus() != 2) return Result.fail("仅已关闭的活动可删除");
        seckillProductMapper.delete(
            new LambdaQueryWrapper<SeckillProduct>().eq(SeckillProduct::getSeckillActivityId, id)
        );
        seckillActivityMapper.deleteById(id);
        return Result.success(null);
    }

    @GetMapping("/{id}/products")
    public Result listProducts(@PathVariable Long id) {
        List<SeckillProduct> products = seckillProductMapper.selectList(
            new LambdaQueryWrapper<SeckillProduct>().eq(SeckillProduct::getSeckillActivityId, id)
        );
        List<Map<String, Object>> list = new ArrayList<>();
        for (SeckillProduct sp : products) {
            Map<String, Object> m = new HashMap<>();
            m.put("id", sp.getId());
            m.put("productId", sp.getProductId());
            m.put("skuId", sp.getSkuId());
            m.put("seckillPrice", sp.getSeckillPrice());
            m.put("seckillStock", sp.getSeckillStock());
            m.put("soldCount", sp.getSoldCount());
            m.put("limitQuantity", sp.getLimitQuantity());
            m.put("status", sp.getStatus());
            Product prod = productMapper.selectById(sp.getProductId());
            m.put("productName", prod != null ? prod.getTitle() : "");
            list.add(m);
        }
        return Result.success(list);
    }

    private String validateSeckillTime(Map<String, Object> params) {
        Object startObj = params.get("startTime");
        Object endObj = params.get("endTime");
        if (startObj == null || endObj == null) return null;
        if (!(startObj instanceof String) || !(endObj instanceof String)) return null;
        String s1 = (String) startObj, s2 = (String) endObj;
        if (s1.isEmpty() || s2.isEmpty()) return null;
        if (s1.compareTo(s2) >= 0) return "结束时间必须晚于开始时间";
        return null;
    }
}
