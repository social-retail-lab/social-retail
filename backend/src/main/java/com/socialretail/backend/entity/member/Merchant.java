package com.socialretail.backend.entity.member;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("merchant")
public class Merchant {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long userId;

    private String merchantName;

    private String logo;

    private String contactName;

    private String contactPhone;

    private String shopAddress;

    private String businessHours;

    private String introduction;

    private Integer status;

    private LocalDateTime createTime;
}
