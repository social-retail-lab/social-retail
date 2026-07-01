package com.socialretail.backend.entity.order;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("`order`")
public class Order {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private String orderSn;

    private Long userId;

    private Long merchantId;

    private Long pickupPointId;

    private BigDecimal totalAmount;

    private BigDecimal payAmount;

    @TableField(value = "discount_amount")
    private BigDecimal discountAmount;

    private Integer deliveryType;

    private Integer status;

    private String pickupCode;

    private String remark;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;

    private LocalDateTime acceptTime;

    private LocalDateTime prepareTime;

    private LocalDateTime completeTime;
}
