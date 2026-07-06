package com.socialretail.backend.entity.distribution;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@TableName("commission_record")
public class CommissionRecord {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long distributorId;

    private Long distributorProductId;

    private Long orderId;

    private BigDecimal commissionAmount;

    private Integer status;

    private LocalDateTime settlementTime;

    private LocalDateTime createTime;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getDistributorId() { return distributorId; }
    public void setDistributorId(Long distributorId) { this.distributorId = distributorId; }
    public Long getDistributorProductId() { return distributorProductId; }
    public void setDistributorProductId(Long distributorProductId) { this.distributorProductId = distributorProductId; }
    public Long getOrderId() { return orderId; }
    public void setOrderId(Long orderId) { this.orderId = orderId; }
    public BigDecimal getCommissionAmount() { return commissionAmount; }
    public void setCommissionAmount(BigDecimal commissionAmount) { this.commissionAmount = commissionAmount; }
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
    public LocalDateTime getSettlementTime() { return settlementTime; }
    public void setSettlementTime(LocalDateTime settlementTime) { this.settlementTime = settlementTime; }
    public LocalDateTime getCreateTime() { return createTime; }
    public void setCreateTime(LocalDateTime createTime) { this.createTime = createTime; }
}
