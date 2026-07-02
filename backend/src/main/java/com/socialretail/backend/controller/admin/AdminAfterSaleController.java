package com.socialretail.backend.controller.admin;

import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.service.merchant.impl.AfterSaleServiceImpl;
import jakarta.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/admin")
public class AdminAfterSaleController {

    private static final Logger log = LoggerFactory.getLogger(AdminAfterSaleController.class);

    @Resource
    private AfterSaleServiceImpl afterSaleService;

    /** 申诉列表（平台介入） */
    @GetMapping("/after-sales/appealed")
    public Result<PageResult<Map<String, Object>>> getAppealedList(
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize) {
        log.info("[管理员售后-申诉列表] keyword={}, pageNum={}, pageSize={}", keyword, pageNum, pageSize);
        try {
            PageResult<Map<String, Object>> pageResult = afterSaleService.getAppealedList(keyword, pageNum, pageSize);
            log.info("[管理员售后-申诉列表] 成功, total={}", pageResult.getTotal());
            return Result.success(pageResult);
        } catch (RuntimeException e) {
            log.warn("[管理员售后-申诉列表] 失败, 原因: {}", e.getMessage());
            throw e;
        }
    }

    /** 管理员介入处理 */
    @PostMapping("/after-sales/{afterSaleId}/intervene")
    public Result<Map<String, Object>> intervene(
            @PathVariable Long afterSaleId,
            @RequestBody Map<String, Object> body) {
        Integer action = (Integer) body.get("action");
        String remark = (String) body.get("remark");
        log.info("[管理员售后-介入] afterSaleId={}, action={}, remark={}", afterSaleId, action, remark);
        try {
            Map<String, Object> result = afterSaleService.adminIntervene(afterSaleId, action, remark);
            log.info("[管理员售后-介入] 成功, afterSaleId={}, newStatus={}", afterSaleId, result.get("newStatus"));
            return Result.success(result);
        } catch (RuntimeException e) {
            log.warn("[管理员售后-介入] 失败, afterSaleId={}, 原因: {}", afterSaleId, e.getMessage());
            throw e;
        }
    }
}
