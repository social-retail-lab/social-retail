package com.socialretail.backend.entity.distribution;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.time.LocalDateTime;

@TableName("distributor_product")
public class DistributorProduct {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long distributorId;

    private Long distributionProductId;

    private String promotionCode;

    private String promotionUrl;

    private String qrCode;

    private Integer status;

    private LocalDateTime createTime;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getDistributorId() { return distributorId; }
    public void setDistributorId(Long distributorId) { this.distributorId = distributorId; }
    public Long getDistributionProductId() { return distributionProductId; }
    public void setDistributionProductId(Long distributionProductId) { this.distributionProductId = distributionProductId; }
    public String getPromotionCode() { return promotionCode; }
    public void setPromotionCode(String promotionCode) { this.promotionCode = promotionCode; }
    public String getPromotionUrl() { return promotionUrl; }
    public void setPromotionUrl(String promotionUrl) { this.promotionUrl = promotionUrl; }
    public String getQrCode() { return qrCode; }
    public void setQrCode(String qrCode) { this.qrCode = qrCode; }
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
    public LocalDateTime getCreateTime() { return createTime; }
    public void setCreateTime(LocalDateTime createTime) { this.createTime = createTime; }
}
