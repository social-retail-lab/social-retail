package com.socialretail.backend.controller.merchant;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.socialretail.backend.common.Result;
import com.socialretail.backend.entity.pickup.PickupPoint;
import com.socialretail.backend.mapper.pickup.PickupPointMapper;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/api/merchant")
public class PickupController {

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(PickupController.class);

    private final PickupPointMapper pickupPointMapper;

    public PickupController(PickupPointMapper pickupPointMapper) {
        this.pickupPointMapper = pickupPointMapper;
    }

    // ================= 自提点管理 =================

    @GetMapping("/pickup-points")
    public Result listPickupPoints(HttpServletRequest request) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        LambdaQueryWrapper<PickupPoint> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(PickupPoint::getMerchantId, merchantId)
               .eq(PickupPoint::getStatus, 1)
               .orderByDesc(PickupPoint::getCreateTime);
        return Result.ok(pickupPointMapper.selectList(wrapper));
    }

    @PostMapping("/pickup-points")
    public Result createPickupPoint(@RequestBody Map<String, Object> body, HttpServletRequest request) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        PickupPoint point = new PickupPoint();
        point.setMerchantId(merchantId);
        point.setName((String) body.get("name"));
        point.setAddress((String) body.get("address"));
        if (body.get("contactPhone") != null) {
            point.setContactPhone((String) body.get("contactPhone"));
        }
        if (body.get("image") != null) {
            point.setImage((String) body.get("image"));
        }
        point.setStatus(1);
        pickupPointMapper.insert(point);
        return Result.ok(point);
    }

    @DeleteMapping("/pickup-points/{pointId}")
    public Result deletePickupPoint(@PathVariable Long pointId, HttpServletRequest request) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        PickupPoint point = pickupPointMapper.selectById(pointId);
        if (point == null || !merchantId.equals(point.getMerchantId())) {
            return Result.fail("自提点不存在");
        }
        pickupPointMapper.deleteById(pointId);
        return Result.success(null);
    }

    // ================= 自提核销 =================

    @PostMapping("/pickup/verify")
    public Result verifyPickup(@RequestBody Map<String, Object> body, HttpServletRequest request) {
        String pickupCode = (String) body.get("pickupCode");
        log.info("[自提核销验证] code={}", pickupCode);
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("valid", true);
        result.put("orderSn", "SIM-" + pickupCode);
        result.put("customerInfo", "模拟用户");
        return Result.ok(result);
    }

    @PostMapping("/pickup/confirm/{orderId}")
    public Result confirmPickup(@PathVariable Long orderId, @RequestBody Map<String, Object> body, HttpServletRequest request) {
        String pickupCode = (String) body.get("pickupCode");
        log.info("[确认自提] orderId={}, code={}", orderId, pickupCode);
        return Result.success(null);
    }

    @GetMapping("/pickup/records")
    public Result pickupRecords(@RequestParam(defaultValue = "1") int pageNum,
                                @RequestParam(defaultValue = "10") int pageSize,
                                HttpServletRequest request) {
        return Result.ok(Collections.emptyList());
    }
}
