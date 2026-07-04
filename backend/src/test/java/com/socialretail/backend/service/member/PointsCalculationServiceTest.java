package com.socialretail.backend.service.member;

import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.entity.member.Member;
import com.socialretail.backend.mapper.member.MemberMapper;
import com.socialretail.backend.vo.PointsInfoVO;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

class PointsCalculationServiceTest {

    private PointsCalculationService service;

    @BeforeEach
    void setUp() {
        MemberMapper memberMapper = mock(MemberMapper.class);
        Member member = new Member();
        member.setPointsBalance(5000);
        when(memberMapper.selectOne(any())).thenReturn(member);
        service = new PointsCalculationService(memberMapper);
    }

    @Test
    void defaultCalculationUsesExactTenPercentLimitWithoutRoundingToHundreds() {
        PointsInfoVO result = service.calculateDefault(1001L, new BigDecimal("99.80"));

        assertEquals(998, result.getMaxUsablePoints());
        assertEquals(998, result.getUsedPoints());
        assertEquals(new BigDecimal("9.98"), result.getMaxDeductionAmount());
        assertEquals(new BigDecimal("9.98"), result.getDeductionAmount());
    }

    @Test
    void requestedPointsAboveTenPercentLimitReturns40952WithContractData() {
        BusinessException exception = assertThrows(BusinessException.class,
                () -> service.calculate(1001L, new BigDecimal("99.80"), true, 1000));

        assertEquals(40952, exception.getCode());
        assertEquals("积分抵扣超过本单可用上限", exception.getMessage());
        @SuppressWarnings("unchecked")
        Map<String, Object> data = (Map<String, Object>) exception.getData();
        assertEquals(998, data.get("maxUsablePoints"));
        assertEquals(1000, data.get("requestedPoints"));
        assertEquals(new BigDecimal("9.98"), data.get("maxDeductionAmount"));
    }
}
