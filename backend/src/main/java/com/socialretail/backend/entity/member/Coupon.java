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
    private LocalDateTime validStart;
    private LocalDateTime validEnd;

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
    public LocalDateTime getValidStart() { return validStart; }
    public void setValidStart(LocalDateTime validStart) { this.validStart = validStart; }
    public LocalDateTime getValidEnd() { return validEnd; }
    public void setValidEnd(LocalDateTime validEnd) { this.validEnd = validEnd; }
}
