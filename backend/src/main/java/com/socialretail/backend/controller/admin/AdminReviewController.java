package com.socialretail.backend.controller.admin;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.socialretail.backend.common.Result;
import com.socialretail.backend.entity.member.Merchant;
import com.socialretail.backend.entity.review.OrderReview;
import com.socialretail.backend.mapper.member.MerchantMapper;
import com.socialretail.backend.mapper.review.OrderReviewMapper;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.*;

@RestController
@RequestMapping("/api/admin/reviews")
public class AdminReviewController {

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(AdminReviewController.class);

    @Resource
    private OrderReviewMapper orderReviewMapper;

    @Resource
    private MerchantMapper merchantMapper;

    @GetMapping("/appeals")
    public Result appeals(@RequestParam(defaultValue = "1") int page,
                          @RequestParam(defaultValue = "10") int pageSize) {
        LambdaQueryWrapper<OrderReview> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(OrderReview::getAppealStatus, 1);
        wrapper.orderByDesc(OrderReview::getAppealTime);

        Page<OrderReview> pageResult = new Page<>(page, pageSize);
        Page<OrderReview> result = orderReviewMapper.selectPage(pageResult, wrapper);

        List<Map<String, Object>> list = new ArrayList<>();
        for (OrderReview review : result.getRecords()) {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("id", review.getId());
            item.put("orderSn", review.getOrderSn());
            item.put("merchantId", review.getMerchantId());
            item.put("userId", review.getUserId());
            item.put("rating", review.getRating());
            item.put("stars", review.getRating());
            item.put("status", review.getAppealStatus());
            item.put("evidence", review.getAppealEvidence());
            item.put("content", review.getContent());
            item.put("appealReason", review.getAppealReason());
            item.put("appealEvidence", review.getAppealEvidence());
            item.put("appealTime", review.getAppealTime());
            item.put("createTime", review.getCreateTime());

            // 获取商家名称
            if (review.getMerchantId() != null) {
                Merchant merchant = merchantMapper.selectById(review.getMerchantId());
                if (merchant != null) {
                    item.put("merchantName", merchant.getMerchantName());
                } else {
                    item.put("merchantName", "商家" + review.getMerchantId());
                }
            } else {
                item.put("merchantName", "未知商家");
            }

            list.add(item);
        }

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("total", result.getTotal());
        data.put("pages", result.getPages());
        data.put("current", (int) result.getCurrent());
        data.put("list", list);

        return Result.ok(data);
    }

    @PostMapping("/appeals/{id}/audit")
    public Result audit(@PathVariable Long id, @RequestBody Map<String, Object> body) {
        String action = (String) body.get("action");
        String auditResult = (String) body.get("result");

        OrderReview review = orderReviewMapper.selectById(id);
        if (review == null) {
            return Result.fail("评价不存在");
        }

        if (review.getAppealStatus() == null || review.getAppealStatus() != 1) {
            return Result.fail("该评价当前不在申诉状态");
        }

        if ("block".equals(action)) {
            review.setAppealStatus(2);
        } else if ("reject".equals(action)) {
            review.setAppealStatus(3);
        } else {
            return Result.fail("无效的审核操作");
        }

        review.setAuditResult(auditResult);
        review.setAuditTime(LocalDateTime.now());
        orderReviewMapper.updateById(review);

        log.info("[平台审核评价申诉] reviewId={}, action={}, result={}", id, action, auditResult);

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("code", 0);
        data.put("msg", "审核完成");
        return Result.ok(data);
    }
}
