package com.socialretail.backend.controller.merchant;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.socialretail.backend.common.Result;
import com.socialretail.backend.entity.member.User;
import com.socialretail.backend.entity.review.OrderReview;
import com.socialretail.backend.mapper.member.UserMapper;
import com.socialretail.backend.mapper.review.OrderReviewMapper;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.*;

@RestController
@RequestMapping("/api/merchant/reviews")
public class MerchantReviewController {

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(MerchantReviewController.class);

    private final OrderReviewMapper orderReviewMapper;
    private final UserMapper userMapper;

    public MerchantReviewController(OrderReviewMapper orderReviewMapper, UserMapper userMapper) {
        this.orderReviewMapper = orderReviewMapper;
        this.userMapper = userMapper;
    }

    @GetMapping("/list")
    public Result list(HttpServletRequest request,
                       @RequestParam(required = false) String rating,
                       @RequestParam(defaultValue = "1") int page,
                       @RequestParam(defaultValue = "10") int pageSize) {
        Long merchantId = (Long) request.getAttribute("merchantId");

        LambdaQueryWrapper<OrderReview> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(OrderReview::getMerchantId, merchantId);

        if (rating != null) {
            if ("good".equals(rating)) {
                wrapper.eq(OrderReview::getRating, 5);
            } else if ("middle".equals(rating)) {
                wrapper.between(OrderReview::getRating, 3, 4);
            } else if ("bad".equals(rating)) {
                wrapper.between(OrderReview::getRating, 1, 2);
            }
        }

        wrapper.orderByDesc(OrderReview::getCreateTime);

        Page<OrderReview> pageResult = new Page<>(page, pageSize);
        Page<OrderReview> result = orderReviewMapper.selectPage(pageResult, wrapper);

        List<Map<String, Object>> list = new ArrayList<>();
        for (OrderReview review : result.getRecords()) {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("id", review.getId());
            item.put("orderSn", review.getOrderSn());
            item.put("userId", review.getUserId());
            item.put("rating", review.getRating());
            item.put("content", review.getContent());
            item.put("images", review.getImages());
            item.put("isAnonymous", review.getIsAnonymous());
            item.put("appealStatus", review.getAppealStatus());
            item.put("createTime", review.getCreateTime());

            // 获取用户昵称
            if (review.getUserId() != null) {
                User user = userMapper.selectById(review.getUserId());
                if (user != null) {
                    item.put("nickname", user.getNickname());
                } else {
                    item.put("nickname", "用户" + review.getUserId());
                }
            } else {
                item.put("nickname", "匿名用户");
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

    @GetMapping("/stats")
    public Result stats(HttpServletRequest request) {
        Long merchantId = (Long) request.getAttribute("merchantId");

        LambdaQueryWrapper<OrderReview> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(OrderReview::getMerchantId, merchantId);
        List<OrderReview> reviews = orderReviewMapper.selectList(wrapper);

        long totalReviews = reviews.size();
        long goodCount = 0;
        long midCount = 0;
        long badCount = 0;
        long sumRating = 0;

        for (OrderReview review : reviews) {
            if (review.getRating() == null) continue;
            int r = review.getRating();
            sumRating += r;
            if (r == 5) {
                goodCount++;
            } else if (r >= 3 && r <= 4) {
                midCount++;
            } else if (r >= 1 && r <= 2) {
                badCount++;
            }
        }

        double avgRating = totalReviews > 0
                ? new BigDecimal(sumRating).divide(new BigDecimal(totalReviews), 1, RoundingMode.HALF_UP).doubleValue()
                : 0.0;

        double bayesianRating = totalReviews > 0
                ? new BigDecimal(sumRating + 40).divide(new BigDecimal(totalReviews + 10), 1, RoundingMode.HALF_UP).doubleValue()
                : 0.0;

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("totalReviews", totalReviews);
        data.put("avgRating", avgRating);
        data.put("bayesianRating", bayesianRating);
        data.put("goodCount", goodCount);
        data.put("midCount", midCount);
        data.put("badCount", badCount);

        return Result.ok(data);
    }

    @PostMapping("/{id}/appeal")
    public Result appeal(@PathVariable Long id, @RequestBody Map<String, Object> body, HttpServletRequest request) {
        Long merchantId = (Long) request.getAttribute("merchantId");

        OrderReview review = orderReviewMapper.selectById(id);
        if (review == null || !merchantId.equals(review.getMerchantId())) {
            return Result.fail("评价不存在");
        }

        if (review.getAppealStatus() != null && review.getAppealStatus() != 0) {
            return Result.fail("该评价已申诉或已处理");
        }

        String reason = (String) body.get("reason");
        String evidence = (String) body.get("evidence");

        review.setAppealStatus(1);
        review.setAppealReason(reason);
        review.setAppealEvidence(evidence);
        review.setAppealTime(LocalDateTime.now());
        orderReviewMapper.updateById(review);

        log.info("[商家申诉] reviewId={}, merchantId={}, reason={}", id, merchantId, reason);

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("code", 0);
        data.put("msg", "申诉已提交，等待平台审核");
        return Result.ok(data);
    }
}
