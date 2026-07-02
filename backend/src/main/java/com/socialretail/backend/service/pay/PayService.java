package com.socialretail.backend.service.pay;

import com.socialretail.backend.dto.request.payment.AlipayCreatePayDTO;
import com.socialretail.backend.dto.request.payment.MockPayFailDTO;
import com.socialretail.backend.dto.request.payment.MockPaySuccessDTO;
import com.socialretail.backend.vo.payment.AlipayCreatePayVO;
import com.socialretail.backend.vo.payment.MockPayResultVO;
import com.socialretail.backend.vo.payment.PayOrderStatusVO;
import com.socialretail.backend.vo.payment.PaymentDetailVO;

import java.util.Map;

public interface PayService {
    AlipayCreatePayVO createAlipayPayment(Long userId, AlipayCreatePayDTO dto);

    boolean handleAlipayNotify(Map<String, String> parameters);

    PayOrderStatusVO getOrderPayStatus(Long userId, Long orderId);

    MockPayResultVO mockPaySuccess(Long userId, MockPaySuccessDTO dto);

    MockPayResultVO mockPayFail(Long userId, MockPayFailDTO dto);

    PaymentDetailVO getPaymentDetail(Long userId, Long paymentId);
}
