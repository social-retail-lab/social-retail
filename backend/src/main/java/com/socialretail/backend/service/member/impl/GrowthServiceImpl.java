package com.socialretail.backend.service.member.impl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.socialretail.backend.dto.member.MemberApiModels.GrowthLogItem;
import com.socialretail.backend.dto.member.MemberApiModels.PageData;
import com.socialretail.backend.entity.member.GrowthLog;
import com.socialretail.backend.mapper.member.GrowthLogMapper;
import com.socialretail.backend.service.member.GrowthService;
import org.springframework.stereotype.Service;

import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
public class GrowthServiceImpl implements GrowthService {
    private static final DateTimeFormatter DATE_TIME = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private final GrowthLogMapper growthLogMapper;

    public GrowthServiceImpl(GrowthLogMapper growthLogMapper) { this.growthLogMapper = growthLogMapper; }

    @Override
    public PageData<GrowthLogItem> listLogs(Long userId, Integer type, int page, int pageSize) {
        Page<GrowthLog> result = growthLogMapper.selectPage(new Page<>(page, pageSize),
                Wrappers.<GrowthLog>lambdaQuery().eq(GrowthLog::getUserId, userId)
                        .eq(type != null, GrowthLog::getType, type)
                        .orderByDesc(GrowthLog::getCreateTime, GrowthLog::getId));
        List<GrowthLogItem> items = result.getRecords().stream().map(log -> new GrowthLogItem(
                log.getId(), log.getType(), typeText(log.getType()), log.getChangeGrowth(),
                log.getCurrentGrowth(), log.getRemark(),
                log.getCreateTime() == null ? null : log.getCreateTime().format(DATE_TIME))).toList();
        return new PageData<>(items, result.getTotal(), result.getPages(), page, pageSize);
    }

    private String typeText(Integer type) {
        if (type == null) return "未知";
        return switch (type) { case 1 -> "消费获得"; case 2 -> "售后扣回";
            case 3 -> "系统调整"; case 4 -> "活动奖励"; default -> "未知"; };
    }
}
