package com.socialretail.backend.service.order;

import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.dto.request.cart.CartAddDTO;
import com.socialretail.backend.dto.request.cart.CartBatchDeleteDTO;
import com.socialretail.backend.dto.request.cart.CartUpdateDTO;
import com.socialretail.backend.dto.request.cart.CartCheckoutPreviewDTO;
import com.socialretail.backend.entity.order.Cart;
import com.socialretail.backend.entity.product.Product;
import com.socialretail.backend.entity.product.Sku;
import com.socialretail.backend.mapper.order.CartMapper;
import com.socialretail.backend.mapper.product.ProductMapper;
import com.socialretail.backend.mapper.product.SkuMapper;
import com.socialretail.backend.service.order.impl.CartServiceImpl;
import com.socialretail.backend.vo.CartAddVO;
import com.socialretail.backend.vo.CartItemVO;
import com.socialretail.backend.vo.CartListVO;
import com.socialretail.backend.vo.CartUpdateVO;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class CartServiceImplTest {

    @Mock private CartMapper cartMapper;
    @Mock private SkuMapper skuMapper;
    @Mock private ProductMapper productMapper;

    private CartServiceImpl cartService;

    @BeforeEach
    void setUp() {
        cartService = new CartServiceImpl(cartMapper, skuMapper, productMapper);
    }

    @Test
    void emptyCartReturnsZeroAmounts() {
        when(cartMapper.selectCartItemsByUserId(10001L)).thenReturn(List.of());

        CartListVO result = cartService.list(10001L);

        assertEquals(0, result.getTotalQuantity());
        assertEquals(new BigDecimal("0.00"), result.getTotalAmount());
        assertEquals(List.of(), result.getList());
    }

    @Test
    void listOnlyTotalsValidItems() {
        CartItemVO valid = item(1L, 8001L, 2, 10, 1, 1, "39.90");
        CartItemVO insufficient = item(2L, 8002L, 5, 1, 1, 1, "10.00");
        when(cartMapper.selectCartItemsByUserId(10001L)).thenReturn(List.of(valid, insufficient));

        CartListVO result = cartService.list(10001L);

        assertEquals(2, result.getTotalQuantity());
        assertEquals(new BigDecimal("79.80"), result.getTotalAmount());
        assertFalse(result.getList().get(1).getIsValid());
        assertEquals("库存不足", result.getList().get(1).getInvalidReason());
    }

    @Test
    void addNewSkuCreatesCartItem() {
        when(skuMapper.selectById(8001L)).thenReturn(sku(8001L, 6001L, 10));
        when(productMapper.selectById(6001L)).thenReturn(product(6001L));
        when(cartMapper.selectByUserIdAndSkuId(10001L, 8001L)).thenReturn(null);
        when(cartMapper.insert(any())).thenAnswer(invocation -> {
            Cart cart = invocation.getArgument(0);
            cart.setId(9001L);
            return 1;
        });

        CartAddVO result = cartService.add(10001L, addDto(8001L, 2));

        assertEquals(9001L, result.getCartItemId());
        assertEquals(2, result.getQuantity());
    }

    @Test
    void repeatedAddAccumulatesQuantity() {
        when(skuMapper.selectById(8001L)).thenReturn(sku(8001L, 6001L, 10));
        when(productMapper.selectById(6001L)).thenReturn(product(6001L));
        Cart existing = cart(9001L, 10001L, 8001L, 3);
        when(cartMapper.selectByUserIdAndSkuId(10001L, 8001L)).thenReturn(existing);
        when(cartMapper.updateQuantity(9001L, 10001L, 5)).thenReturn(1);

        CartAddVO result = cartService.add(10001L, addDto(8001L, 2));

        assertEquals(5, result.getQuantity());
        verify(cartMapper).updateQuantity(9001L, 10001L, 5);
    }

    @Test
    void insufficientStockIncludesSkuAndStock() {
        when(skuMapper.selectById(8001L)).thenReturn(sku(8001L, 6001L, 1));
        when(productMapper.selectById(6001L)).thenReturn(product(6001L));
        when(cartMapper.selectByUserIdAndSkuId(10001L, 8001L)).thenReturn(null);

        BusinessException exception = assertThrows(
                BusinessException.class,
                () -> cartService.add(10001L, addDto(8001L, 2))
        );

        assertEquals(40911, exception.getCode());
        assertEquals(Map.of("skuId", 8001L, "stock", 1), exception.getData());
    }

    @Test
    void updateAndDeleteCannotOperateAnotherUsersItem() {
        when(cartMapper.selectByIdAndUserId(9001L, 10001L)).thenReturn(null);
        BusinessException updateException = assertThrows(
                BusinessException.class,
                () -> cartService.update(10001L, 9001L, updateDto(2))
        );
        assertEquals(40411, updateException.getCode());

        when(cartMapper.deleteByIdAndUserId(9001L, 10001L)).thenReturn(0);
        BusinessException deleteException = assertThrows(
                BusinessException.class,
                () -> cartService.delete(10001L, 9001L)
        );
        assertEquals(40411, deleteException.getCode());
    }

    @Test
    void batchDeleteUsesJwtUserAndDeduplicatesSelectedIds() {
        CartBatchDeleteDTO dto = new CartBatchDeleteDTO();
        dto.setCartItemIds(List.of(9001L, 9001L, 9002L));
        when(cartMapper.deleteByIdsAndUserId(10001L, List.of(9001L, 9002L))).thenReturn(2);

        assertEquals(2, cartService.batchDelete(10001L, dto).getDeletedCount());
        verify(cartMapper).deleteByIdsAndUserId(10001L, List.of(9001L, 9002L));
    }

    @Test
    void updateReturnsCurrentPriceAndAmount() {
        when(cartMapper.selectByIdAndUserId(9001L, 10001L))
                .thenReturn(cart(9001L, 10001L, 8001L, 1));
        when(skuMapper.selectById(8001L)).thenReturn(sku(8001L, 6001L, 10));
        when(productMapper.selectById(6001L)).thenReturn(product(6001L));
        when(cartMapper.updateQuantity(9001L, 10001L, 3)).thenReturn(1);

        CartUpdateVO result = cartService.update(10001L, 9001L, updateDto(3));

        assertEquals(new BigDecimal("39.90"), result.getPrice());
        assertEquals(new BigDecimal("119.70"), result.getItemAmount());
    }

    @Test
    void checkoutPreviewReusesCalculateAndBuildsPromotionReadyStructure() {
        CartCheckoutPreviewDTO dto = new CartCheckoutPreviewDTO();
        dto.setCartItemIds(List.of(1L));
        dto.setUsePoints(false);
        dto.setActivityContext(Map.of("promotionIds", List.of()));
        CartItemVO valid = item(1L, 8001L, 2, 10, 1, 1, "39.90");
        valid.setProductName("苹果");
        when(cartMapper.selectCartItemsByIds(10001L, List.of(1L))).thenReturn(List.of(valid));

        var result = cartService.checkoutPreview(10001L, dto);

        assertEquals(1, result.getItems().size());
        assertEquals(new BigDecimal("39.90"), result.getItems().get(0).getOriginalPrice());
        assertEquals(new BigDecimal("79.80"), result.getItems().get(0).getItemPayableAmount());
        assertEquals(new BigDecimal("79.80"), result.getPriceDetail().getOriginalAmount());
        assertEquals(new BigDecimal("0.00"), result.getPriceDetail().getPromotionDiscount());
        assertEquals(2, result.getTotalQuantity());
        assertEquals(List.of(), result.getAvailablePromotions());
        assertEquals(List.of(), result.getAvailableCoupons());
        assertEquals(List.of(), result.getPromotionDetail());
        assertEquals(List.of(), result.getActivityInfo().getPromotionIds());
    }

    private CartAddDTO addDto(Long skuId, int quantity) {
        CartAddDTO dto = new CartAddDTO();
        dto.setSkuId(skuId);
        dto.setQuantity(quantity);
        return dto;
    }

    private CartUpdateDTO updateDto(int quantity) {
        CartUpdateDTO dto = new CartUpdateDTO();
        dto.setQuantity(quantity);
        return dto;
    }

    private Cart cart(Long id, Long userId, Long skuId, int quantity) {
        Cart cart = new Cart();
        cart.setId(id);
        cart.setUserId(userId);
        cart.setSkuId(skuId);
        cart.setQuantity(quantity);
        return cart;
    }

    private Sku sku(Long id, Long productId, int stock) {
        Sku sku = new Sku();
        sku.setId(id);
        sku.setProductId(productId);
        sku.setPrice(new BigDecimal("39.90"));
        sku.setStock(stock);
        return sku;
    }

    private Product product(Long id) {
        Product product = new Product();
        product.setId(id);
        product.setStatus(1);
        product.setAuditStatus(1);
        return product;
    }

    private CartItemVO item(Long cartId, Long skuId, int quantity, int stock,
                            int status, int auditStatus, String price) {
        CartItemVO item = new CartItemVO();
        item.setCartId(cartId);
        item.setSkuId(skuId);
        item.setProductId(6001L);
        item.setQuantity(quantity);
        item.setStock(stock);
        item.setPrice(new BigDecimal(price));
        item.setProductStatus(status);
        item.setProductAuditStatus(auditStatus);
        return item;
    }
}
