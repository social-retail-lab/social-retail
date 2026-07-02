package com.socialretail.backend.controller.user;

import com.socialretail.backend.common.GlobalExceptionHandler;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.config.JwtInterceptor;
import com.socialretail.backend.config.WebMvcConfig;
import com.socialretail.backend.service.order.CartService;
import com.socialretail.backend.utils.JwtUtil;
import com.socialretail.backend.vo.CartAddVO;
import com.socialretail.backend.vo.CartBatchDeleteVO;
import com.socialretail.backend.vo.CartItemVO;
import com.socialretail.backend.vo.CartListVO;
import com.socialretail.backend.vo.CartUpdateVO;
import com.socialretail.backend.vo.CartCheckoutItemVO;
import com.socialretail.backend.vo.CartCheckoutPreviewVO;
import com.socialretail.backend.vo.CartCheckoutPriceDetailVO;
import com.socialretail.backend.vo.CartActivityInfoVO;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.web.servlet.MockMvc;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(CartController.class)
@ContextConfiguration(classes = {
        CartController.class, WebMvcConfig.class, JwtInterceptor.class, GlobalExceptionHandler.class
})
class CartControllerWebTest {

    private static final String AUTHORIZATION = "Bearer valid-token";

    @Autowired private MockMvc mockMvc;
    @MockBean private CartService cartService;
    @MockBean private JwtUtil jwtUtil;

    @BeforeEach
    void setUp() {
        when(jwtUtil.getUserId("valid-token")).thenReturn(10001L);
    }

    @Test
    void allCartApisRequireJwt() throws Exception {
        mockMvc.perform(get("/api/cart/items"))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.code").value(40101));
    }

    @Test
    void listUsesJwtUserId() throws Exception {
        when(cartService.list(10001L)).thenReturn(
                new CartListVO(List.of(item()), 2, new BigDecimal("79.80"), new BigDecimal("79.80"))
        );

        mockMvc.perform(get("/api/cart/items").header("Authorization", AUTHORIZATION))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.list[0].cartId").value(9001))
                .andExpect(jsonPath("$.data.list[0].isValid").value(true))
                .andExpect(jsonPath("$.data.totalAmount").value(79.80));

        verify(cartService).list(10001L);
    }

    @Test
    void addUsesDocumentedPathAndMessage() throws Exception {
        when(cartService.add(eq(10001L), any())).thenReturn(new CartAddVO(9001L, 8001L, 2));

        mockMvc.perform(post("/api/cart/items")
                        .header("Authorization", AUTHORIZATION)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"skuId\":8001,\"quantity\":2}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").value("加入购物车成功"))
                .andExpect(jsonPath("$.data.cartItemId").value(9001));
    }

    @Test
    void invalidQuantityReturns40001() throws Exception {
        mockMvc.perform(post("/api/cart/items")
                        .header("Authorization", AUTHORIZATION)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"skuId\":8001,\"quantity\":1000}"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value(40001));
    }

    @Test
    void updateAndDeleteReturnMessages() throws Exception {
        when(cartService.update(eq(10001L), eq(9001L), any())).thenReturn(
                new CartUpdateVO(9001L, 8001L, 3, new BigDecimal("39.90"), new BigDecimal("119.70"))
        );

        mockMvc.perform(put("/api/cart/items/9001")
                        .header("Authorization", AUTHORIZATION)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"quantity\":3}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").value("修改成功"))
                .andExpect(jsonPath("$.data.itemAmount").value(119.70));

        mockMvc.perform(delete("/api/cart/items/9001")
                        .header("Authorization", AUTHORIZATION))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").value("删除成功"))
                .andExpect(jsonPath("$.data").doesNotExist());

        verify(cartService).delete(10001L, 9001L);
    }

    @Test
    void batchDeleteSelectedItems() throws Exception {
        when(cartService.batchDelete(eq(10001L), any())).thenReturn(new CartBatchDeleteVO(2));

        mockMvc.perform(delete("/api/cart/items")
                        .header("Authorization", AUTHORIZATION)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"cartItemIds\":[9001,9002]}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").value("删除成功"))
                .andExpect(jsonPath("$.data.deletedCount").value(2));
    }

    @Test
    void emptyBatchDeleteReturns40001() throws Exception {
        mockMvc.perform(delete("/api/cart/items")
                        .header("Authorization", AUTHORIZATION)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"cartItemIds\":[]}"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value(40001))
                .andExpect(jsonPath("$.message").value("请选择要删除的商品"));
    }

    @Test
    void checkoutPreviewReturnsDocumentedStructure() throws Exception {
        BigDecimal total = new BigDecimal("79.80");
        CartCheckoutItemVO checkoutItem = new CartCheckoutItemVO(
                9001L, 8001L, 6001L, "新疆苹果", "image.jpg",
                "{\"规格\":\"5斤装\"}", new BigDecimal("39.90"), new BigDecimal("39.90"),
                2, 100, total, total, null, new BigDecimal("0.00"), true, null
        );
        when(cartService.checkoutPreview(eq(10001L), any())).thenReturn(
                new CartCheckoutPreviewVO(
                        List.of(checkoutItem),
                        new CartCheckoutPriceDetailVO(
                                total, new BigDecimal("0.00"), new BigDecimal("0.00"),
                                new BigDecimal("0.00"), new BigDecimal("0.00"),
                                new BigDecimal("0.00"), new BigDecimal("0.00"), total
                        ),
                        List.of(),
                        null,
                        new CartActivityInfoVO(null, null, null, List.of()),
                        List.of(),
                        List.of(),
                        2
                )
        );

        mockMvc.perform(post("/api/cart/checkout-preview")
                        .header("Authorization", AUTHORIZATION)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"cartItemIds\":[9001],\"couponUserId\":null,\"usePoints\":false,"
                                + "\"activityContext\":{\"seckillId\":null,\"bargainId\":null,"
                                + "\"groupId\":null,\"promotionIds\":[]}}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").value("结算预览成功"))
                .andExpect(jsonPath("$.data.items[0].cartItemId").value(9001))
                .andExpect(jsonPath("$.data.items[0].isValid").value(true))
                .andExpect(jsonPath("$.data.items[0].originalPrice").value(39.90))
                .andExpect(jsonPath("$.data.priceDetail.promotionDiscount").value(0.00))
                .andExpect(jsonPath("$.data.priceDetail.payableAmount").value(79.80))
                .andExpect(jsonPath("$.data.promotionDetail").isArray())
                .andExpect(jsonPath("$.data.activityInfo.promotionIds").isArray())
                .andExpect(jsonPath("$.data.availablePromotions").isArray())
                .andExpect(jsonPath("$.data.availableCoupons").isArray())
                .andExpect(jsonPath("$.data.totalQuantity").value(2));
    }

    @Test
    void stockConflictReturnsAvailableStockData() throws Exception {
        when(cartService.add(eq(10001L), any())).thenThrow(new BusinessException(
                40911, HttpStatus.CONFLICT, "商品库存不足",
                Map.of("skuId", 8001L, "stock", 1)
        ));

        mockMvc.perform(post("/api/cart/items")
                        .header("Authorization", AUTHORIZATION)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"skuId\":8001,\"quantity\":2}"))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.code").value(40911))
                .andExpect(jsonPath("$.data.skuId").value(8001))
                .andExpect(jsonPath("$.data.stock").value(1));
    }

    private CartItemVO item() {
        CartItemVO item = new CartItemVO();
        item.setCartId(9001L);
        item.setSkuId(8001L);
        item.setProductId(6001L);
        item.setProductName("新疆苹果");
        item.setSkuSpec("{\"规格\":\"5斤装\"}");
        item.setPrice(new BigDecimal("39.90"));
        item.setQuantity(2);
        item.setStock(100);
        item.setSelected(true);
        item.setIsValid(true);
        item.setItemAmount(new BigDecimal("79.80"));
        return item;
    }
}
