package com.socialretail.backend.entity.order;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("delivery_status_log")
public class DeliveryStatusLog {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long deliveryId;

    private Integer fromStatus;

    private Integer toStatus;

    private String statusText;

    private String remark;

    private LocalDateTime createTime;
}
