package com.socialretail.backend.service.member;

import com.socialretail.backend.dto.member.MemberApiModels.LevelList;
import com.socialretail.backend.dto.member.MemberApiModels.MemberInfo;
import com.socialretail.backend.dto.member.MemberApiModels.UpgradeResult;

public interface MemberLevelService {
    MemberInfo getInfo(Long userId);
    LevelList listLevels(Long userId);
    UpgradeResult upgrade(Long userId);
}
