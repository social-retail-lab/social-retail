package com.socialretail.backend.service.member;

import com.socialretail.backend.dto.member.MemberApiModels.Balance;
import com.socialretail.backend.dto.member.MemberApiModels.Deduction;
import com.socialretail.backend.dto.member.MemberApiModels.DeductionRequest;
import com.socialretail.backend.dto.member.MemberApiModels.Exchange;
import com.socialretail.backend.dto.member.MemberApiModels.ExchangeRequest;
import com.socialretail.backend.dto.member.MemberApiModels.ExchangeCouponPage;
import com.socialretail.backend.dto.member.MemberApiModels.PageData;
import com.socialretail.backend.dto.member.MemberApiModels.PointsLogItem;
import com.socialretail.backend.dto.member.MemberApiModels.SignIn;
import com.socialretail.backend.dto.member.MemberApiModels.SignInStatus;

public interface PointsService {
    Balance getBalance(Long userId);
    PageData<PointsLogItem> listLogs(Long userId, Integer type, int page, int pageSize);
    Deduction calculateDeduction(Long userId, DeductionRequest request);
    ExchangeCouponPage listExchangeCoupons(Long userId, int page, int pageSize);
    Exchange exchangeCoupon(Long userId, ExchangeRequest request);
    SignIn signIn(Long userId);
    SignInStatus getSignInStatus(Long userId);
}
