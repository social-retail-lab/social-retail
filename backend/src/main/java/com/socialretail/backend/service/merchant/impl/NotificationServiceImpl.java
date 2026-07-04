package com.socialretail.backend.service.merchant.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.socialretail.backend.entity.notify.MerchantNotification;
import com.socialretail.backend.mapper.notify.MerchantNotificationMapper;
import com.socialretail.backend.service.merchant.NotificationService;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
public class NotificationServiceImpl implements NotificationService {

    @Resource
    private MerchantNotificationMapper notificationMapper;

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Override
    public void createNotification(Long merchantId, Integer type, String title, String content,
                                   Long refId, String refType) {
        MerchantNotification notification = new MerchantNotification();
        notification.setMerchantId(merchantId);
        notification.setType(type);
        notification.setTitle(title);
        notification.setContent(content);
        notification.setRefId(refId);
        notification.setRefType(refType);
        notification.setIsRead(0);
        notification.setCreateTime(LocalDateTime.now());
        notificationMapper.insert(notification);
        log.info("[通知] 创建成功, merchantId={}, type={}, title={}", merchantId, type, title);
    }

    @Override
    public int getUnreadCount(Long merchantId) {
        LambdaQueryWrapper<MerchantNotification> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(MerchantNotification::getMerchantId, merchantId);
        wrapper.eq(MerchantNotification::getIsRead, 0);
        return Math.toIntExact(notificationMapper.selectCount(wrapper));
    }

    @Override
    public List<Map<String, Object>> getNotificationList(Long merchantId, int pageNum, int pageSize) {
        LambdaQueryWrapper<MerchantNotification> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(MerchantNotification::getMerchantId, merchantId);
        wrapper.orderByDesc(MerchantNotification::getCreateTime);

        Page<MerchantNotification> page = new Page<>(pageNum, pageSize);
        Page<MerchantNotification> result = notificationMapper.selectPage(page, wrapper);

        return result.getRecords().stream().map(n -> {
            Map<String, Object> map = new HashMap<>();
            map.put("id", n.getId());
            map.put("type", n.getType());
            map.put("title", n.getTitle());
            map.put("content", n.getContent());
            map.put("refId", n.getRefId());
            map.put("refType", n.getRefType());
            map.put("isRead", n.getIsRead());
            map.put("createTime", format(n.getCreateTime()));
            return map;
        }).collect(Collectors.toList());
    }

    @Override
    public void markAsRead(Long notificationId, Long merchantId) {
        MerchantNotification notification = notificationMapper.selectById(notificationId);
        if (notification != null && notification.getMerchantId().equals(merchantId)) {
            notification.setIsRead(1);
            notification.setReadTime(LocalDateTime.now());
            notificationMapper.updateById(notification);
        }
    }

    @Override
    public void markAllAsRead(Long merchantId) {
        LambdaQueryWrapper<MerchantNotification> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(MerchantNotification::getMerchantId, merchantId);
        wrapper.eq(MerchantNotification::getIsRead, 0);
        List<MerchantNotification> list = notificationMapper.selectList(wrapper);
        for (MerchantNotification n : list) {
            n.setIsRead(1);
            n.setReadTime(LocalDateTime.now());
            notificationMapper.updateById(n);
        }
        log.info("[通知] 全部已读, merchantId={}, count={}", merchantId, list.size());
    }

    @Override
    public void markByRefType(Long merchantId, String refType) {
        LambdaQueryWrapper<MerchantNotification> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(MerchantNotification::getMerchantId, merchantId);
        wrapper.eq(MerchantNotification::getRefType, refType);
        wrapper.eq(MerchantNotification::getIsRead, 0);
        List<MerchantNotification> list = notificationMapper.selectList(wrapper);
        for (MerchantNotification n : list) {
            n.setIsRead(1);
            n.setReadTime(LocalDateTime.now());
            notificationMapper.updateById(n);
        }
        log.info("[通知] 按类型已读, merchantId={}, refType={}, count={}", merchantId, refType, list.size());
    }

    private String format(LocalDateTime dt) {
        if (dt == null) return null;
        return dt.format(FORMATTER);
    }
}
