package com.socialretail.backend.controller.admin;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.Result;
import com.socialretail.backend.entity.order.AfterSale;
import com.socialretail.backend.mapper.order.AfterSaleMapper;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/after-sales")
public class AdminAfterSaleController {

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(AdminAfterSaleController.class);

    private final AfterSaleMapper afterSaleMapper;

    public AdminAfterSaleController(AfterSaleMapper afterSaleMapper) {
        this.afterSaleMapper = afterSaleMapper;
    }

    @GetMapping("/appealed")
    public Result listAppealed(@RequestParam(required = false) String keyword,
                                @RequestParam(defaultValue = "1") int pageNum,
                                @RequestParam(defaultValue = "10") int pageSize) {
        LambdaQueryWrapper<AfterSale> wrapper = new LambdaQueryWrapper<>();
        // appealStatus > 0 表示商家已申诉
        wrapper.eq(AfterSale::getAppealStatus, 1);
        if (keyword != null && !keyword.isBlank()) {
            wrapper.like(AfterSale::getOrderSn, keyword);
        }
        wrapper.orderByDesc(AfterSale::getAppealTime);

        Page<AfterSale> page = new Page<>(pageNum, pageSize);
        Page<AfterSale> result = afterSaleMapper.selectPage(page, wrapper);

        return Result.ok(PageResult.of(result.getRecords(), result.getTotal(), pageNum, pageSize));
    }

    @PostMapping("/{afterSaleId}/intervene")
    public Result intervene(@PathVariable Long afterSaleId, @RequestBody Map<String, Object> body) {
        int action = ((Number) body.get("action")).intValue();
        String remark = (String) body.getOrDefault("remark", "");

        AfterSale afterSale = afterSaleMapper.selectById(afterSaleId);
        if (afterSale == null) {
            return Result.fail("售后记录不存在");
        }

        afterSale.setInterveneResult(action);
        afterSale.setInterveneRemark(remark);
        afterSale.setInterveneTime(LocalDateTime.now());
        afterSaleMapper.updateById(afterSale);

        log.info("[平台介入售后] afterSaleId={}, action={}", afterSaleId, action);
        return Result.success(null);
    }
}
