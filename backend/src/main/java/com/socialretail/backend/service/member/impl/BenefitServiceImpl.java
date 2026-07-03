package com.socialretail.backend.service.member.impl;

import com.socialretail.backend.dto.member.MemberApiModels.Benefit;
import com.socialretail.backend.dto.member.MemberApiModels.LevelRule;
import com.socialretail.backend.service.member.BenefitService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BenefitServiceImpl implements BenefitService {
    private static final List<LevelRule> RULES = List.of(
            new LevelRule(1, "普通会员", 0, "注册后默认成为普通会员", List.of(
                    new Benefit("BASIC_POINTS", "基础积分", "消费后可按规则获得积分"))),
            new LevelRule(2, "银卡会员", 1000, "成长值达到1000后自动升级", List.of(
                    new Benefit("POINTS_ACCELERATE", "积分加速", "消费积分按1.2倍累计"),
                    new Benefit("COUPON_GIFT", "专属优惠券", "每月可领取会员专属优惠券"))),
            new LevelRule(3, "金卡会员", 5000, "成长值达到5000后自动升级", List.of(
                    new Benefit("POINTS_ACCELERATE", "积分加速", "消费积分按1.5倍累计"),
                    new Benefit("MEMBER_DISCOUNT", "会员折扣", "部分商品享受会员专属折扣"),
                    new Benefit("COUPON_GIFT", "专属优惠券", "每月可领取金卡会员专属优惠券"))),
            new LevelRule(4, "钻石会员", 10000, "成长值达到10000后自动升级", List.of(
                    new Benefit("POINTS_ACCELERATE", "积分加速", "消费积分按2倍累计"),
                    new Benefit("MEMBER_DISCOUNT", "会员折扣", "部分商品享受更高等级会员折扣"),
                    new Benefit("FREE_SHIPPING", "包邮权益", "部分订单享受会员包邮权益"),
                    new Benefit("BIRTHDAY_GIFT", "生日礼包", "生日当月可领取专属礼包")))
    );

    @Override public List<LevelRule> listRules() { return RULES; }

    @Override
    public LevelRule getRule(int level) {
        return RULES.stream().filter(rule -> rule.memberLevel() == level).findFirst().orElse(RULES.get(0));
    }

    @Override
    public LevelRule calculateRule(int growthValue) {
        LevelRule result = RULES.get(0);
        for (LevelRule rule : RULES) {
            if (growthValue >= rule.requiredGrowthValue()) result = rule;
        }
        return result;
    }
}
