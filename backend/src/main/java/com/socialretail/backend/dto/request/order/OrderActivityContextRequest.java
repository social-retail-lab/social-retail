package com.socialretail.backend.dto.request.order;

import jakarta.validation.constraints.Positive;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class OrderActivityContextRequest {
    @Positive(message = "秒杀活动ID必须大于0")
    private Long seckillId;

    @Positive(message = "砍价活动ID必须大于0")
    private Long bargainId;

    @Positive(message = "拼团活动ID必须大于0")
    private Long groupId;

    private List<@Positive(message = "促销活动ID必须大于0") Long> promotionIds = new ArrayList<>();
}
