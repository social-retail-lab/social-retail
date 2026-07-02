package com.socialretail.backend.controller.payment;

import com.socialretail.backend.common.GlobalExceptionHandler;
import com.socialretail.backend.config.JwtInterceptor;
import com.socialretail.backend.config.WebMvcConfig;
import com.socialretail.backend.service.pay.PayService;
import com.socialretail.backend.utils.JwtUtil;
import com.socialretail.backend.vo.payment.MockPayResultVO;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.web.servlet.MockMvc;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(PayController.class)
@ContextConfiguration(classes = {
        PayController.class, WebMvcConfig.class, JwtInterceptor.class, GlobalExceptionHandler.class
})
class PayControllerWebTest {

    @Autowired private MockMvc mockMvc;
    @MockBean private PayService payService;
    @MockBean private JwtUtil jwtUtil;

    @BeforeEach
    void setUp() {
        when(jwtUtil.getUserId("valid-token")).thenReturn(10001L);
    }

    @Test
    void protectedPaymentApiRequiresJwt() throws Exception {
        mockMvc.perform(get("/api/pay/orders/20/status"))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.code").value(40101));
    }

    @Test
    void alipayNotifyIsPublicAndReturnsPlainText() throws Exception {
        when(payService.handleAlipayNotify(any())).thenReturn(true);

        mockMvc.perform(post("/api/pay/alipay/notify")
                        .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                        .param("out_trade_no", "PAY-20")
                        .param("trade_status", "TRADE_SUCCESS"))
                .andExpect(status().isOk())
                .andExpect(content().contentTypeCompatibleWith(MediaType.TEXT_PLAIN))
                .andExpect(content().string("success"));
    }

    @Test
    void mockSuccessUsesJwtUser() throws Exception {
        MockPayResultVO result = new MockPayResultVO();
        result.setOrderId(20L);
        result.setPayStatus("PAID");
        when(payService.mockPaySuccess(eq(10001L), any())).thenReturn(result);

        mockMvc.perform(post("/api/pay/mock/success")
                        .header("Authorization", "Bearer valid-token")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"orderId\":20,\"payAmount\":39.90}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(0))
                .andExpect(jsonPath("$.data.payStatus").value("PAID"));
    }
}
