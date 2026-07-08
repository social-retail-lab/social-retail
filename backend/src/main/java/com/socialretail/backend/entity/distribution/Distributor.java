package com.socialretail.backend.entity.distribution;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@TableName("distributor")
public class Distributor {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long userId;

    private Long applyId;

    private BigDecimal totalCommission;

    private BigDecimal availableCommission;

    private BigDecimal frozenCommission;

    private Integer status;

    private LocalDateTime applyTime;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public Long getApplyId() { return applyId; }
    public void setApplyId(Long applyId) { this.applyId = applyId; }
    public BigDecimal getTotalCommission() { return totalCommission; }
    public void setTotalCommission(BigDecimal totalCommission) { this.totalCommission = totalCommission; }
    public BigDecimal getAvailableCommission() { return availableCommission; }
    public void setAvailableCommission(BigDecimal availableCommission) { this.availableCommission = availableCommission; }
    public BigDecimal getFrozenCommission() { return frozenCommission; }
    public void setFrozenCommission(BigDecimal frozenCommission) { this.frozenCommission = frozenCommission; }
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
    public LocalDateTime getApplyTime() { return applyTime; }
    public void setApplyTime(LocalDateTime applyTime) { this.applyTime = applyTime; }
    public LocalDateTime getCreateTime() { return createTime; }
    public void setCreateTime(LocalDateTime createTime) { this.createTime = createTime; }
    public LocalDateTime getUpdateTime() { return updateTime; }
    public void setUpdateTime(LocalDateTime updateTime) { this.updateTime = updateTime; }
}
