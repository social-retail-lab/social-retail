package com.socialretail.backend.entity.system;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.time.LocalDateTime;

@TableName("notification")
public class Notification {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long userId;

    private String type;

    private String title;

    private String content;

    private Integer isRead;

    private Long relatedId;

    private LocalDateTime createTime;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Integer getIsRead() {
        return isRead;
    }

    public void setIsRead(Integer isRead) {
        this.isRead = isRead;
    }

    public Long getRelatedId() {
        return relatedId;
    }

    public void setRelatedId(Long relatedId) {
        this.relatedId = relatedId;
    }

    public LocalDateTime getCreateTime() {
        return createTime;
    }

    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }

    @Override
    public String toString() {
        return "Notification{" +
            ", id=" + id +
            ", userId=" + userId +
            ", type=" + type +
            ", title=" + title +
            ", content=" + content +
            ", isRead=" + isRead +
            ", relatedId=" + relatedId +
            ", createTime=" + createTime +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Notification that = (Notification) o;
        return java.util.Objects.equals(id, that.id)
                && java.util.Objects.equals(userId, that.userId)
                && java.util.Objects.equals(type, that.type)
                && java.util.Objects.equals(title, that.title)
                && java.util.Objects.equals(content, that.content)
                && java.util.Objects.equals(isRead, that.isRead)
                && java.util.Objects.equals(relatedId, that.relatedId)
                && java.util.Objects.equals(createTime, that.createTime);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(id, userId, type, title, content, isRead, relatedId, createTime);
    }
}
