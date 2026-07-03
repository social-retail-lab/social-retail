package com.socialretail.backend.service.promotion.impl;

import com.socialretail.backend.common.ImageUrlResolver;
import com.socialretail.backend.dto.promotion.SeckillApiModels.ActivityInfo;
import com.socialretail.backend.dto.promotion.SeckillApiModels.ProductItem;
import com.socialretail.backend.dto.promotion.SeckillApiModels.ProductPage;
import com.socialretail.backend.dto.promotion.SeckillApiModels.Qualification;
import com.socialretail.backend.dto.promotion.SeckillProductView;
import com.socialretail.backend.entity.promotion.SeckillActivity;
import com.socialretail.backend.mapper.promotion.SeckillActivityMapper;
import com.socialretail.backend.mapper.promotion.SeckillProductMapper;
import com.socialretail.backend.service.promotion.SeckillService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.concurrent.TimeUnit;

@Service
public class SeckillServiceImpl implements SeckillService {
    private static final Logger log = LoggerFactory.getLogger(SeckillServiceImpl.class);
    private static final DateTimeFormatter DATE_TIME = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private static final int PREHEAT_DAYS = 3;
    private final SeckillActivityMapper activityMapper;
    private final SeckillProductMapper productMapper;
    private final StringRedisTemplate redisTemplate;
    private final ImageUrlResolver imageUrlResolver;

    public SeckillServiceImpl(SeckillActivityMapper activityMapper,
                              SeckillProductMapper productMapper,
                              StringRedisTemplate redisTemplate,
                              ImageUrlResolver imageUrlResolver) {
        this.activityMapper = activityMapper;
        this.productMapper = productMapper;
        this.redisTemplate = redisTemplate;
        this.imageUrlResolver = imageUrlResolver;
    }

    @Override
    @Transactional(readOnly = true)
    public ActivityInfo getCurrentActivity() {
        LocalDateTime now = LocalDateTime.now();
        return toActivityInfo(findCurrent(now), now);
    }

    @Override
    @Transactional(readOnly = true)
    public ProductPage getCurrentProducts(int page, int pageSize) {
        LocalDateTime now = LocalDateTime.now();
        SeckillActivity activity = findCurrent(now);
        ActivityInfo activityInfo = toActivityInfo(activity, now);
        if (activity == null) return new ProductPage(null, List.of(), 0L, 0L, page, pageSize);

        long total = productMapper.countEnabled(activity.getId());
        long pages = (total + pageSize - 1) / pageSize;
        long offset = (long) (page - 1) * pageSize;
        List<ProductItem> list = productMapper.selectPageView(activity.getId(), offset, pageSize)
                .stream().map(view -> toProductItem(view, activityInfo)).toList();
        return new ProductPage(activityInfo, list, total, pages, page, pageSize);
    }

    @Override
    @Transactional(readOnly = true)
    public Qualification checkQualification(Long userId, Long seckillProductId) {
        SeckillProductView view = productMapper.selectViewById(seckillProductId);
        if (view == null) return qualification(seckillProductId, false, "秒杀商品不存在", 0, 1, 0);

        int remaining = remainingStock(view);
        int limit = positive(view.getLimitQuantity(), 1);
        int bought = Math.max(productMapper.sumBoughtQuantity(userId, view.getSeckillProductId(), view.getSkuId()),
                reservedQuantity(view, userId));
        LocalDateTime now = LocalDateTime.now();
        if (view.getStartTime() == null || view.getEndTime() == null)
            return qualification(seckillProductId, false, "秒杀活动配置无效", remaining, limit, bought);
        if (now.isBefore(view.getStartTime()))
            return qualification(seckillProductId, false, "秒杀活动尚未开始", remaining, limit, bought);
        if (!now.isBefore(view.getEndTime()))
            return qualification(seckillProductId, false, "秒杀活动已结束", remaining, limit, bought);
        if (!Integer.valueOf(1).equals(view.getSeckillProductStatus())
                || !Integer.valueOf(1).equals(view.getProductStatus())
                || !Integer.valueOf(1).equals(view.getProductAuditStatus()))
            return qualification(seckillProductId, false, "秒杀商品不可用", remaining, limit, bought);
        if (remaining <= 0)
            return qualification(seckillProductId, false, "秒杀商品已售罄", 0, limit, bought);
        if (bought >= limit)
            return qualification(seckillProductId, false, "已达到每人限购数量", remaining, limit, bought);
        return qualification(seckillProductId, true, null, remaining, limit, bought);
    }

    @Override
    public void warmCurrentActivity() {
        LocalDateTime now = LocalDateTime.now();
        SeckillActivity activity = findCurrent(now);
        if (activity == null) return;
        for (SeckillProductView view : productMapper.selectAllEnabled(activity.getId())) {
            initializeStock(view);
        }
    }

    private SeckillActivity findCurrent(LocalDateTime now) {
        return activityMapper.selectCurrentDisplayable(now, now.plusDays(PREHEAT_DAYS));
    }

    private ActivityInfo toActivityInfo(SeckillActivity activity, LocalDateTime now) {
        if (activity == null) return null;
        LocalDateTime preheat = activity.getStartTime().minusDays(PREHEAT_DAYS);
        boolean ongoing = !now.isBefore(activity.getStartTime()) && now.isBefore(activity.getEndTime());
        long countdown = Math.max(0, Duration.between(now,
                ongoing ? activity.getEndTime() : activity.getStartTime()).getSeconds());
        return new ActivityInfo(activity.getId(), activity.getTitle(), format(preheat),
                format(activity.getStartTime()), format(activity.getEndTime()), ongoing ? 1 : 0,
                ongoing ? "进行中" : "预热中", ongoing, countdown);
    }

    private ProductItem toProductItem(SeckillProductView view, ActivityInfo activity) {
        int remaining = remainingStock(view);
        int status = !activity.canBuy() ? 0 : remaining <= 0 ? 2 : 1;
        String statusText = status == 0 ? "预热中" : status == 2 ? "已售罄" : "可抢购";
        String button = status == 0 ? "即将开始" : status == 2 ? "已售罄" : "立即抢购";
        boolean canBuy = status == 1;
        return new ProductItem(view.getSeckillProductId(), view.getActivityId(), view.getProductId(),
                view.getSkuId(), view.getProductName(), imageUrlResolver.resolve(view.getProductImage()),
                view.getSkuSpecs(), view.getOriginPrice(), view.getSeckillPrice(),
                value(view.getSeckillStock()), value(view.getSoldCount()), remaining,
                positive(view.getLimitQuantity(), 1), status, statusText, canBuy, button);
    }

    private int remainingStock(SeckillProductView view) {
        String key = stockKey(view.getActivityId(), view.getSkuId());
        try {
            initializeStock(view);
            String stock = redisTemplate.opsForValue().get(key);
            if (stock != null) return Math.max(0, Integer.parseInt(stock));
        } catch (RuntimeException exception) {
            log.warn("读取秒杀 Redis 库存失败，降级为数据库库存: key={}", key, exception);
        }
        return Math.max(0, value(view.getSeckillStock()) - value(view.getSoldCount()));
    }

    private void initializeStock(SeckillProductView view) {
        long ttl = Math.max(60, Duration.between(LocalDateTime.now(), view.getEndTime().plusDays(1)).getSeconds());
        int stock = Math.max(0, value(view.getSeckillStock()) - value(view.getSoldCount()));
        redisTemplate.opsForValue().setIfAbsent(stockKey(view.getActivityId(), view.getSkuId()),
                String.valueOf(stock), ttl, TimeUnit.SECONDS);
    }

    private int reservedQuantity(SeckillProductView view, Long userId) {
        try {
            Object value = redisTemplate.opsForHash().get(usersKey(view.getActivityId(), view.getSkuId()),
                    String.valueOf(userId));
            return value == null ? 0 : Integer.parseInt(value.toString());
        } catch (RuntimeException exception) {
            return 0;
        }
    }

    private Qualification qualification(Long id, boolean canBuy, String reason,
                                        int remaining, int limit, int bought) {
        return new Qualification(id, canBuy, reason, remaining, limit, bought);
    }

    private String stockKey(Long activityId, Long skuId) { return "seckill:stock:" + activityId + ":" + skuId; }
    private String usersKey(Long activityId, Long skuId) { return "seckill:users:" + activityId + ":" + skuId; }
    private int value(Integer number) { return number == null ? 0 : number; }
    private int positive(Integer number, int fallback) { return number == null || number <= 0 ? fallback : number; }
    private String format(LocalDateTime time) { return time == null ? null : time.format(DATE_TIME); }
}
