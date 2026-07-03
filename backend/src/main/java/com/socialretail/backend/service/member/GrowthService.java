package com.socialretail.backend.service.member;

import com.socialretail.backend.dto.member.MemberApiModels.GrowthLogItem;
import com.socialretail.backend.dto.member.MemberApiModels.PageData;

public interface GrowthService {
    PageData<GrowthLogItem> listLogs(Long userId, Integer type, int page, int pageSize);
}
