package com.socialretail.backend.task;

import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.socialretail.backend.entity.promotion.Coupon;
import com.socialretail.backend.entity.promotion.SeckillActivity;
import com.socialretail.backend.mapper.promotion.CouponMapper;
import com.socialretail.backend.mapper.promotion.SeckillActivityMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
public class ActivityExpiryTask {

    private static final Logger log = LoggerFactory.getLogger(ActivityExpiryTask.class);

    private final SeckillActivityMapper seckillActivityMapper;
    private final CouponMapper couponMapper;

    public ActivityExpiryTask(SeckillActivityMapper seckillActivityMapper, CouponMapper couponMapper) {
        this.seckillActivityMapper = seckillActivityMapper;
        this.couponMapper = couponMapper;
    }

    /**
     * 每分钟检查一次：自动关闭已过期的秒杀活动，自动禁用已过期的固定时间优惠券
     */
    @Scheduled(initialDelay = 30000, fixedDelay = 60000)
    public void expireActivities() {
        LocalDateTime now = LocalDateTime.now();

        // 1. 秒杀活动：已发布(status=1) 且 endTime < now → 关闭(status=2)
        int seckillClosed = seckillActivityMapper.update(null,
            new LambdaUpdateWrapper<SeckillActivity>()
                .eq(SeckillActivity::getStatus, 1)
                .lt(SeckillActivity::getEndTime, now)
                .set(SeckillActivity::getStatus, 2)
        );
        if (seckillClosed > 0) {
            log.info("自动关闭过期秒杀活动 {} 个", seckillClosed);
        }

        // 2. 优惠券：已启用(status=1) 且 固定时间段(validityType=1) 且 validEnd < now → 禁用(status=0)
        int couponDisabled = couponMapper.update(null,
            new LambdaUpdateWrapper<Coupon>()
                .eq(Coupon::getStatus, 1)
                .eq(Coupon::getValidityType, 1)
                .lt(Coupon::getValidEnd, now)
                .set(Coupon::getStatus, 0)
        );
        if (couponDisabled > 0) {
            log.info("自动禁用过期优惠券 {} 个", couponDisabled);
        }
    }
}
