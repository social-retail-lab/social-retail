package com.socialretail.backend.dto.request.order;

import jakarta.validation.constraints.Positive;
import lombok.Data;
import com.fasterxml.jackson.annotation.JsonAlias;

import java.util.ArrayList;
import java.util.List;

@Data
public class OrderActivityContextRequest {
    @Positive(message = "秒杀活动ID必须大于0")
    @JsonAlias("seckillId")
    private Long seckillProductId;

    @Positive(message = "砍价活动ID必须大于0")
    @JsonAlias("bargainId")
    private Long bargainRecordId;

    @Positive(message = "拼团活动ID必须大于0")
    private Long groupId;

    private List<@Positive(message = "促销活动ID必须大于0") Long> promotionIds = new ArrayList<>();
}
