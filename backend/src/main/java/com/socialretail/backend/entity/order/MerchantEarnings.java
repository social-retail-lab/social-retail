package com.socialretail.backend.entity.order;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("merchant_earnings")
public class MerchantEarnings {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long merchantId;

    private Long orderId;

    private String orderSn;

    private BigDecimal amount;

    @TableField(value = "status")
    private Integer status;

    private LocalDateTime freezeTime;

    private LocalDateTime unfreezeTime;

    private LocalDateTime withdrawTime;

    private LocalDateTime createTime;
}
