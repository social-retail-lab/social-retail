package com.socialretail.backend.service.merchant;

import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.vo.AuditRequestVO;
import com.socialretail.backend.vo.InfoChangeRequest;
import com.socialretail.backend.vo.LoginVO;
import com.socialretail.backend.vo.MerchantApplyRequest;
import com.socialretail.backend.vo.MerchantApplyVO;
import com.socialretail.backend.vo.MerchantInfoVO;
import com.socialretail.backend.vo.MerchantUpdateRequest;
import com.socialretail.backend.vo.QualificationRequest;
import com.socialretail.backend.vo.QualificationVO;

import java.util.Map;

public interface MerchantService {

    MerchantApplyVO submitApplication(Long userId, MerchantApplyRequest req);

    MerchantApplyVO getApplicationStatus(Long userId);

    LoginVO merchantLogin(String phone, String password, String smsCode);

    MerchantInfoVO getCurrentMerchant(Long userId);

    MerchantInfoVO updateMerchantInfo(Long userId, MerchantUpdateRequest req);

    QualificationVO uploadQualification(Long userId, QualificationRequest req);

    QualificationVO getQualification(Long userId);

    Map<String, Object> appeal(Long userId, String reason);

    Map<String, Object> requestInfoChange(Long userId, InfoChangeRequest req);

    Map<String, Object> requestQualificationUpgrade(Long userId, MerchantApplyRequest req);

    Map<String, Object> togglePause(Long userId);

    PageResult<AuditRequestVO> getAuditRequests(Long userId, int pageNum, int pageSize);

    Map<String, Object> getAuditRequestDetail(Long requestId, String requestType);

    Map<String, Object> withdrawAuditRequest(Long userId, Long requestId, String requestType);
}
