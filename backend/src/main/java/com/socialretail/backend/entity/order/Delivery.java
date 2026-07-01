package com.socialretail.backend.entity.order;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("delivery")
public class Delivery {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long orderId;

    private String deliverySn;

    private String dispatcherName;

    private String dispatcherPhone;

    private Integer status;

    private String remark;

    private LocalDateTime startTime;

    private LocalDateTime endTime;

    @TableField(value = "simulate_complete_time")
    private LocalDateTime simulateCompleteTime;
}
