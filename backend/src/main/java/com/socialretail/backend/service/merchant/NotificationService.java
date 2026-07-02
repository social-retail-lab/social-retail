package com.socialretail.backend.service.merchant;

import com.socialretail.backend.entity.notify.MerchantNotification;

import java.util.List;
import java.util.Map;

public interface NotificationService {

    /** 创建通知 */
    void createNotification(Long merchantId, Integer type, String title, String content,
                            Long refId, String refType);

    /** 获取未读数量（小红点） */
    int getUnreadCount(Long merchantId);

    /** 获取通知列表 */
    List<Map<String, Object>> getNotificationList(Long merchantId, int pageNum, int pageSize);

    /** 标记单条已读 */
    void markAsRead(Long notificationId, Long merchantId);

    /** 全部已读 */
    void markAllAsRead(Long merchantId);

    /** 标记某类型已读（按业务操作消除红点） */
    void markByRefType(Long merchantId, String refType);
}
