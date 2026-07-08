package com.socialretail.backend.task;

import com.socialretail.backend.service.social.CommissionService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class CommissionSettleTask {
    private static final Logger log = LoggerFactory.getLogger(CommissionSettleTask.class);
    private final CommissionService commissionService;

    public CommissionSettleTask(CommissionService commissionService) {
        this.commissionService = commissionService;
    }

    @Scheduled(initialDelay = 60_000, fixedDelayString = "${commission.settle-delay-ms:60000}")
    public void settle() {
        int count = commissionService.settleDueCommissions();
        if (count > 0) log.info("Settled {} distributor commission records", count);
    }
}
