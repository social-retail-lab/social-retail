package com.socialretail.backend.service.member;

import com.socialretail.backend.dto.member.MemberApiModels.LevelRule;
import java.util.List;

public interface BenefitService {
    List<LevelRule> listRules();
    LevelRule getRule(int level);
    LevelRule calculateRule(int growthValue);
}
