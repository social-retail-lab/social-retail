package com.socialretail.backend.controller.merchant;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.Result;
import com.socialretail.backend.entity.order.AfterSale;
import com.socialretail.backend.mapper.order.AfterSaleMapper;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Map;

@RestController
@RequestMapping("/api/merchant/after-sales")
public class MerchantAfterSaleController {

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(MerchantAfterSaleController.class);

    private final AfterSaleMapper afterSaleMapper;

    public MerchantAfterSaleController(AfterSaleMapper afterSaleMapper) {
        this.afterSaleMapper = afterSaleMapper;
    }

    @GetMapping
    public Result list(HttpServletRequest request,
                       @RequestParam(required = false) Integer type,
                       @RequestParam(required = false) Integer status,
                       @RequestParam(required = false) String orderSn,
                       @RequestParam(defaultValue = "1") int pageNum,
                       @RequestParam(defaultValue = "10") int pageSize) {
        Long merchantId = (Long) request.getAttribute("merchantId");

        LambdaQueryWrapper<AfterSale> wrapper = new LambdaQueryWrapper<>();
        if (type != null) {
            wrapper.eq(AfterSale::getType, type);
        }
        if (status != null) {
            wrapper.eq(AfterSale::getStatus, status);
        }
        if (StringUtils.hasText(orderSn)) {
            wrapper.like(AfterSale::getOrderSn, orderSn);
        }
        wrapper.orderByDesc(AfterSale::getApplyTime);

        Page<AfterSale> page = new Page<>(pageNum, pageSize);
        Page<AfterSale> result = afterSaleMapper.selectPage(page, wrapper);

        return Result.ok(PageResult.of(result.getRecords(), result.getTotal(), pageNum, pageSize));
    }

    @GetMapping("/{afterSaleId}")
    public Result detail(@PathVariable Long afterSaleId) {
        AfterSale afterSale = afterSaleMapper.selectById(afterSaleId);
        if (afterSale == null) {
            return Result.fail("售后记录不存在");
        }
        return Result.ok(afterSale);
    }

    @PostMapping("/{afterSaleId}/audit")
    public Result audit(@PathVariable Long afterSaleId, @RequestBody Map<String, Object> body) {
        int action = ((Number) body.get("action")).intValue();
        String remark = (String) body.getOrDefault("remark", "");
        BigDecimal actualRefundAmount = body.get("actualRefundAmount") != null
                ? new BigDecimal(String.valueOf(body.get("actualRefundAmount"))) : null;

        AfterSale afterSale = afterSaleMapper.selectById(afterSaleId);
        if (afterSale == null) {
            return Result.fail("售后记录不存在");
        }

        if (action == 1) {
            // 同意
            afterSale.setStatus(2);
            afterSale.setAuditRemark(remark);
            if (actualRefundAmount != null) {
                afterSale.setActualRefundAmount(actualRefundAmount);
            }
        } else {
            // 拒绝
            afterSale.setStatus(-1);
            afterSale.setRejectReason(remark);
        }
        afterSale.setAuditTime(LocalDateTime.now());
        afterSaleMapper.updateById(afterSale);

        log.info("[售后审核] afterSaleId={}, action={}, remark={}", afterSaleId, action, remark);
        return Result.success(null);
    }

    @PostMapping("/{afterSaleId}/return-confirm")
    public Result returnConfirm(@PathVariable Long afterSaleId, @RequestBody Map<String, Object> body) {
        int receivedStatus = ((Number) body.get("receivedStatus")).intValue();
        String remark = (String) body.getOrDefault("remark", "");

        AfterSale afterSale = afterSaleMapper.selectById(afterSaleId);
        if (afterSale == null) {
            return Result.fail("售后记录不存在");
        }

        afterSale.setReturnReceivedStatus(receivedStatus);
        afterSale.setReturnReceivedTime(LocalDateTime.now());
        afterSale.setAuditRemark(remark);
        afterSaleMapper.updateById(afterSale);

        log.info("[退货收货确认] afterSaleId={}, receivedStatus={}", afterSaleId, receivedStatus);
        return Result.success(null);
    }

    @PostMapping("/{afterSaleId}/feedback")
    public Result feedback(@PathVariable Long afterSaleId, @RequestBody Map<String, Object> body) {
        String content = (String) body.get("content");

        AfterSale afterSale = afterSaleMapper.selectById(afterSaleId);
        if (afterSale == null) {
            return Result.fail("售后记录不存在");
        }

        afterSale.setFeedbackContent(content);
        afterSaleMapper.updateById(afterSale);

        log.info("[售后反馈] afterSaleId={}", afterSaleId);
        return Result.success(null);
    }
}
