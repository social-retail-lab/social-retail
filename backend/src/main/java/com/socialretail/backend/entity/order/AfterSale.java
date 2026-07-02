package com.socialretail.backend.entity.order;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("after_sale")
public class AfterSale {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long orderId;

    private Long orderItemId;

    private String orderSn;

    private Integer type;

    private BigDecimal refundAmount;

    private BigDecimal actualRefundAmount;

    private String reason;

    private String evidenceImages;

    private String productName;

    private String skuSpecs;

    private Integer status;

    private String auditRemark;

    private LocalDateTime auditTime;

    @TableField(value = "return_received_status")
    private Integer returnReceivedStatus;

    @TableField(value = "return_received_time")
    private LocalDateTime returnReceivedTime;

    private String feedbackContent;

    private String feedbackImages;

    private LocalDateTime completeTime;

    private LocalDateTime applyTime;
}
