package com.socialretail.backend.controller.user;

import com.socialretail.backend.handler.GlobalExceptionHandler;
import com.socialretail.backend.config.JwtInterceptor;
import com.socialretail.backend.config.WebMvcConfig;
import com.socialretail.backend.service.user.UserService;
import com.socialretail.backend.utils.JwtUtil;
import com.socialretail.backend.vo.UserInfoVO;
import com.socialretail.backend.vo.UserPhoneVO;
import com.socialretail.backend.vo.UserRegisterVO;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(controllers = {AuthController.class, UserController.class})
@Import({WebMvcConfig.class, JwtInterceptor.class, GlobalExceptionHandler.class})
class UserControllerWebTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private UserService userService;

    @MockBean
    private JwtUtil jwtUtil;

    @Test
    void registerIsPublic() throws Exception {
        when(userService.register(any())).thenReturn(
                new UserRegisterVO(10001L, "138****8000", "张三", "NORMAL")
        );

        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "phone": "13800138000",
                                  "code": "123456",
                                  "password": "secret123"
                                }
                                """))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(0))
                .andExpect(jsonPath("$.message").value("注册成功"))
                .andExpect(jsonPath("$.data.phone").value("138****8000"))
                .andExpect(jsonPath("$.timestamp").isNumber())
                .andExpect(jsonPath("$.requestId").isString());
    }

    @Test
    void currentUserRequiresBearerToken() throws Exception {
        mockMvc.perform(get("/api/user/info"))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.code").value(40101))
                .andExpect(jsonPath("$.data").doesNotExist());
    }

    @Test
    void currentUserUsesUserIdFromToken() throws Exception {
        when(jwtUtil.getUserId("valid-token")).thenReturn(10001L);
        when(userService.getCurrentUser(10001L)).thenReturn(
                new UserInfoVO(
                        10001L,
                        "138****8000",
                        "张三",
                        null,
                        "NORMAL",
                        null,
                        null
                )
        );

        mockMvc.perform(get("/api/user/info")
                        .header("Authorization", "Bearer valid-token"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(0))
                .andExpect(jsonPath("$.data.userId").value(10001))
                .andExpect(jsonPath("$.data.phone").value("138****8000"))
                .andExpect(jsonPath("$.data.memberInfo").doesNotExist())
                .andExpect(jsonPath("$.data.distributorInfo").doesNotExist());
    }

    @Test
    void updatePhoneRequiresTokenAndReturnsMaskedPhone() throws Exception {
        when(jwtUtil.getUserId("valid-token")).thenReturn(10001L);
        when(userService.updatePhone(any(), any())).thenReturn(new UserPhoneVO("139****9000"));

        mockMvc.perform(put("/api/user/phone")
                        .header("Authorization", "Bearer valid-token")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "newPhone": "13900139000",
                                  "code": "123456"
                                }
                                """))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(0))
                .andExpect(jsonPath("$.message").value("手机号修改成功"))
                .andExpect(jsonPath("$.data.phone").value("139****9000"));
    }

    @Test
    void updatePasswordReturnsNullData() throws Exception {
        when(jwtUtil.getUserId("valid-token")).thenReturn(10001L);

        mockMvc.perform(put("/api/user/password")
                        .header("Authorization", "Bearer valid-token")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "oldPassword": "oldPassword",
                                  "newPassword": "newPassword"
                                }
                                """))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(0))
                .andExpect(jsonPath("$.message").value("密码修改成功"))
                .andExpect(jsonPath("$.data").doesNotExist());
    }
}
