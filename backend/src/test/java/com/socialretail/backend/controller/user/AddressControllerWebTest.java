package com.socialretail.backend.controller.user;

import com.socialretail.backend.handler.GlobalExceptionHandler;
import com.socialretail.backend.config.JwtInterceptor;
import com.socialretail.backend.config.WebMvcConfig;
import com.socialretail.backend.service.address.AddressService;
import com.socialretail.backend.utils.JwtUtil;
import com.socialretail.backend.vo.AddressDefaultVO;
import com.socialretail.backend.vo.AddressVO;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.patch;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(AddressController.class)
@ContextConfiguration(classes = {
        AddressController.class,
        WebMvcConfig.class,
        JwtInterceptor.class,
        GlobalExceptionHandler.class
})
class AddressControllerWebTest {

    private static final String AUTHORIZATION = "Bearer valid-token";

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private AddressService addressService;

    @MockBean
    private JwtUtil jwtUtil;

    @BeforeEach
    void setUp() {
        when(jwtUtil.getUserId("valid-token")).thenReturn(10001L);
    }

    @Test
    void addressApiRequiresJwt() throws Exception {
        mockMvc.perform(get("/api/addresses"))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.code").value(40101));
    }

    @Test
    void addAddress() throws Exception {
        when(addressService.add(eq(10001L), any())).thenReturn(addressVO());

        mockMvc.perform(post("/api/addresses")
                        .header("Authorization", AUTHORIZATION)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(addressBody()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").value("新增成功"))
                .andExpect(jsonPath("$.data.addressId").value(1001))
                .andExpect(jsonPath("$.data.receiverPhone").value("138****8000"));
    }

    @Test
    void listAddressesUsesListWrapper() throws Exception {
        when(addressService.list(10001L)).thenReturn(List.of(addressVO()));

        mockMvc.perform(get("/api/addresses")
                        .header("Authorization", AUTHORIZATION))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.list[0].addressId").value(1001));
    }

    @Test
    void updateAddress() throws Exception {
        when(addressService.update(eq(10001L), eq(1001L), any())).thenReturn(addressVO());

        mockMvc.perform(put("/api/addresses/1001")
                        .header("Authorization", AUTHORIZATION)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(addressBody()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").value("修改成功"));
    }

    @Test
    void deleteAddress() throws Exception {
        mockMvc.perform(delete("/api/addresses/1001")
                        .header("Authorization", AUTHORIZATION))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").value("删除成功"))
                .andExpect(jsonPath("$.data").doesNotExist());

        verify(addressService).delete(10001L, 1001L);
    }

    @Test
    void setDefaultAddress() throws Exception {
        when(addressService.setDefault(10001L, 1001L))
                .thenReturn(new AddressDefaultVO(1001L, true));

        mockMvc.perform(patch("/api/addresses/1001/default")
                        .header("Authorization", AUTHORIZATION))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").value("设置成功"))
                .andExpect(jsonPath("$.data.isDefault").value(true));
    }

    @Test
    void noDefaultAddressReturnsSuccessWithNullData() throws Exception {
        when(addressService.getDefault(10001L)).thenReturn(null);

        mockMvc.perform(get("/api/addresses/default")
                        .header("Authorization", AUTHORIZATION))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(0))
                .andExpect(jsonPath("$.message").value("暂无默认地址"))
                .andExpect(jsonPath("$.data").doesNotExist());
    }

    private AddressVO addressVO() {
        return new AddressVO(
                1001L,
                "张三",
                "138****8000",
                "广东省",
                "广州市",
                "天河区",
                "天河路100号",
                true
        );
    }

    private String addressBody() {
        return """
                {
                  "receiverName": "张三",
                  "receiverPhone": "13800138000",
                  "province": "广东省",
                  "city": "广州市",
                  "district": "天河区",
                  "detailAddress": "天河路100号",
                  "isDefault": true
                }
                """;
    }
}
