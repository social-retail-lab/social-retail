package com.socialretail.backend.task;

import com.socialretail.backend.service.promotion.SeckillService;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class SeckillWarmupTask {
    private final SeckillService seckillService;
    public SeckillWarmupTask(SeckillService seckillService) { this.seckillService = seckillService; }

    @Scheduled(initialDelay = 5000, fixedDelay = 30000)
    public void warmup() { seckillService.warmCurrentActivity(); }
}
