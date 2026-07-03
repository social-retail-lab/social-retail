package com.socialretail.backend.entity.promotion;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("seckill_product")
public class SeckillProduct {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long seckillActivityId;
    private Long productId;
    private String skuId;
    private BigDecimal seckillPrice;
    private Integer seckillStock;
    private Integer soldCount;
    private Integer limitQuantity;
    private Integer status;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
