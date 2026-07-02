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
    private Long addressId;
    private String consignee;
    private String phone;
    private String province;
    private String city;
    private String district;
    private String detailedAddress;
    private BigDecimal totalAmount;
    private BigDecimal payAmount;
    @TableField(value = "discount_amount")
    private BigDecimal discountAmount;
    private BigDecimal deliveryFee;
    private BigDecimal seckillDiscount;
    private BigDecimal bargainDiscount;
    private BigDecimal couponDiscount;
    private BigDecimal pointsDeduction;
    private Long couponUserId;
    private Long seckillId;
    private Long bargainId;
    private String promotionSnapshot;
    private Integer deliveryType;
    private Integer status;
    private String pickupCode;
    private String remark;
    private LocalDateTime createTime;
    private LocalDateTime payExpireTime;
    private LocalDateTime payTime;
    private LocalDateTime cancelTime;
    private LocalDateTime updateTime;
    private LocalDateTime acceptTime;
    private LocalDateTime prepareTime;
    private LocalDateTime completeTime;
}
