package com.socialretail.backend.entity.order;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.time.LocalDateTime;

@TableName("order_status_log")
public class OrderStatusLog {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long orderId;

    private Integer fromStatus;

    private Integer toStatus;

    private String remark;

    private LocalDateTime createTime;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getOrderId() {
        return orderId;
    }

    public void setOrderId(Long orderId) {
        this.orderId = orderId;
    }

    public Integer getFromStatus() {
        return fromStatus;
    }

    public void setFromStatus(Integer fromStatus) {
        this.fromStatus = fromStatus;
    }

    public Integer getToStatus() {
        return toStatus;
    }

    public void setToStatus(Integer toStatus) {
        this.toStatus = toStatus;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public LocalDateTime getCreateTime() {
        return createTime;
    }

    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }

    @Override
    public String toString() {
        return "OrderStatusLog{" +
            ", id=" + id +
            ", orderId=" + orderId +
            ", fromStatus=" + fromStatus +
            ", toStatus=" + toStatus +
            ", remark=" + remark +
            ", createTime=" + createTime +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        OrderStatusLog that = (OrderStatusLog) o;
        return java.util.Objects.equals(id, that.id)
                && java.util.Objects.equals(orderId, that.orderId)
                && java.util.Objects.equals(fromStatus, that.fromStatus)
                && java.util.Objects.equals(toStatus, that.toStatus)
                && java.util.Objects.equals(remark, that.remark)
                && java.util.Objects.equals(createTime, that.createTime);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(id, orderId, fromStatus, toStatus, remark, createTime);
    }
}
