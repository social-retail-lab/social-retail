package com.socialretail.backend.entity.member;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@TableName("coupon")
public class Coupon {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String title;
    private Integer type;
    private BigDecimal minConsume;
    private BigDecimal discountAmount;
    private Integer totalCount;
    private Integer receivedCount;
    private Integer perUserLimit;
    private Integer exchangePoints;
    private LocalDateTime validStart;
    private LocalDateTime validEnd;
    private Integer status;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public Integer getType() { return type; }
    public void setType(Integer type) { this.type = type; }
    public BigDecimal getMinConsume() { return minConsume; }
    public void setMinConsume(BigDecimal minConsume) { this.minConsume = minConsume; }
    public BigDecimal getDiscountAmount() { return discountAmount; }
    public void setDiscountAmount(BigDecimal discountAmount) { this.discountAmount = discountAmount; }
    public Integer getTotalCount() { return totalCount; }
    public void setTotalCount(Integer totalCount) { this.totalCount = totalCount; }
    public Integer getReceivedCount() { return receivedCount; }
    public void setReceivedCount(Integer receivedCount) { this.receivedCount = receivedCount; }
    public Integer getPerUserLimit() { return perUserLimit; }
    public void setPerUserLimit(Integer perUserLimit) { this.perUserLimit = perUserLimit; }
    public Integer getExchangePoints() { return exchangePoints; }
    public void setExchangePoints(Integer exchangePoints) { this.exchangePoints = exchangePoints; }
    public LocalDateTime getValidStart() { return validStart; }
    public void setValidStart(LocalDateTime validStart) { this.validStart = validStart; }
    public LocalDateTime getValidEnd() { return validEnd; }
    public void setValidEnd(LocalDateTime validEnd) { this.validEnd = validEnd; }
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
    public LocalDateTime getCreateTime() { return createTime; }
    public void setCreateTime(LocalDateTime createTime) { this.createTime = createTime; }
    public LocalDateTime getUpdateTime() { return updateTime; }
    public void setUpdateTime(LocalDateTime updateTime) { this.updateTime = updateTime; }
}
