package com.socialretail.backend.service.member.impl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.socialretail.backend.dto.member.MemberApiModels.LevelList;
import com.socialretail.backend.dto.member.MemberApiModels.LevelRule;
import com.socialretail.backend.dto.member.MemberApiModels.MemberInfo;
import com.socialretail.backend.dto.member.MemberApiModels.NextLevel;
import com.socialretail.backend.dto.member.MemberApiModels.UpgradeResult;
import com.socialretail.backend.entity.member.Member;
import com.socialretail.backend.mapper.member.MemberMapper;
import com.socialretail.backend.service.member.BenefitService;
import com.socialretail.backend.service.member.MemberLevelService;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class MemberLevelServiceImpl implements MemberLevelService {
    private final MemberMapper memberMapper;
    private final BenefitService benefitService;

    public MemberLevelServiceImpl(MemberMapper memberMapper, BenefitService benefitService) {
        this.memberMapper = memberMapper;
        this.benefitService = benefitService;
    }

    @Override
    @Transactional
    public MemberInfo getInfo(Long userId) {
        Member member = getOrCreate(userId);
        LevelRule current = benefitService.getRule(value(member.getMemberLevel(), 1));
        List<LevelRule> rules = benefitService.listRules();
        int growth = value(member.getGrowthValue(), 0);
        NextLevel next = rules.stream()
                .filter(rule -> rule.memberLevel() > current.memberLevel())
                .findFirst()
                .map(rule -> new NextLevel(rule.memberLevel(), rule.memberLevelName(),
                        rule.requiredGrowthValue(), Math.max(0, rule.requiredGrowthValue() - growth)))
                .orElse(null);
        return new MemberInfo(userId, current.memberLevel(), current.memberLevelName(),
                value(member.getPointsBalance(), 0), growth, next, current.benefits());
    }

    @Override
    @Transactional
    public LevelList listLevels(Long userId) {
        Member member = getOrCreate(userId);
        LevelRule current = benefitService.getRule(value(member.getMemberLevel(), 1));
        return new LevelList(current.memberLevel(), current.memberLevelName(),
                value(member.getGrowthValue(), 0), benefitService.listRules());
    }

    @Override
    @Transactional
    public UpgradeResult upgrade(Long userId) {
        List<Member> members = userId == null
                ? memberMapper.selectList(null)
                : memberMapper.selectList(Wrappers.<Member>lambdaQuery().eq(Member::getUserId, userId));
        int updated = 0;
        for (Member member : members) {
            int target = benefitService.calculateRule(value(member.getGrowthValue(), 0)).memberLevel();
            if (target > value(member.getMemberLevel(), 1)) {
                member.setMemberLevel(target);
                updated += memberMapper.updateById(member);
            }
        }
        return new UpgradeResult(updated);
    }

    public Member getOrCreate(Long userId) {
        Member member = memberMapper.selectOne(Wrappers.<Member>lambdaQuery()
                .eq(Member::getUserId, userId).last("LIMIT 1"));
        if (member != null) return member;
        Member created = new Member();
        created.setUserId(userId);
        created.setMemberLevel(1);
        created.setPointsBalance(0);
        created.setGrowthValue(0);
        try {
            memberMapper.insert(created);
            return created;
        } catch (DuplicateKeyException ignored) {
            return memberMapper.selectOne(Wrappers.<Member>lambdaQuery()
                    .eq(Member::getUserId, userId).last("LIMIT 1"));
        }
    }

    private int value(Integer number, int fallback) { return number == null ? fallback : number; }
}
