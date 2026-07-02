package com.socialretail.backend.entity.order;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("payment")
public class Payment {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long orderId;

    private String paySn;

    private Integer payPlatform;

    private BigDecimal amount;

    private Integer status;

    private LocalDateTime payTime;

    @TableField(value = "refund_status")
    private Integer refundStatus;

    private BigDecimal refundAmount;

    private LocalDateTime refundTime;
}
