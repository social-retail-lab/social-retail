package com.socialretail.backend.entity.member;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("merchant_coupon")
public class MerchantCoupon {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long merchantId;
    private String title;
    private Integer type;
    private BigDecimal minConsume;
    private BigDecimal discountAmount;
    private Integer totalCount;
    private Integer receivedCount;
    private Integer perUserLimit;
    private LocalDateTime validStart;
    private LocalDateTime validEnd;
    private Integer status;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
