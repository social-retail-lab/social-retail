package com.socialretail.backend.entity.order;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("withdrawal_record")
public class WithdrawalRecord {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long merchantId;

    private BigDecimal amount;

    private String bankCardNumber;

    private String accountName;

    private String bankName;

    @TableField(value = "status")
    private Integer status;

    private String remark;

    private LocalDateTime applyTime;

    private LocalDateTime processTime;
}
