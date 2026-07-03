package com.socialretail.backend.controller.user;

import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.config.JwtInterceptor;
import com.socialretail.backend.dto.request.cart.CartAddDTO;
import com.socialretail.backend.dto.request.cart.CartBatchDeleteDTO;
import com.socialretail.backend.dto.request.cart.CartUpdateDTO;
import com.socialretail.backend.dto.request.cart.CartCheckoutPreviewDTO;
import com.socialretail.backend.service.order.CartService;
import com.socialretail.backend.vo.CartAddVO;
import com.socialretail.backend.vo.CartBatchDeleteVO;
import com.socialretail.backend.vo.CartListVO;
import com.socialretail.backend.vo.CartUpdateVO;
import com.socialretail.backend.vo.CartCheckoutPreviewVO;
import com.socialretail.backend.vo.CartInvalidItemListVO;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Positive;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Validated
@RestController
@RequestMapping("/api/cart")
public class CartController {

    private final CartService cartService;

    public CartController(CartService cartService) {
        this.cartService = cartService;
    }

    @GetMapping("/items")
    public Result<CartListVO> list(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId) {
        return Result.success(cartService.list(userId));
    }

    @GetMapping("/invalid-items")
    public Result<CartInvalidItemListVO> listInvalidItems(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId) {
        return Result.success(cartService.listInvalidItems(userId));
    }

    @PostMapping("/items")
    public Result<CartAddVO> add(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Valid @RequestBody CartAddDTO dto) {
        return Result.success("加入购物车成功", cartService.add(userId, dto));
    }

    @PutMapping("/items/{cartItemId}")
    public Result<CartUpdateVO> update(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Positive(message = "购物车商品ID必须大于0") @PathVariable Long cartItemId,
            @Valid @RequestBody CartUpdateDTO dto) {
        return Result.success("修改成功", cartService.update(userId, cartItemId, dto));
    }

    @DeleteMapping("/items/{cartItemId}")
    public Result<Void> delete(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Positive(message = "购物车商品ID必须大于0") @PathVariable Long cartItemId) {
        cartService.delete(userId, cartItemId);
        return Result.success("删除成功", null);
    }

    @DeleteMapping("/items")
    public Result<CartBatchDeleteVO> batchDelete(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Valid @RequestBody CartBatchDeleteDTO dto) {
        return Result.success("删除成功", cartService.batchDelete(userId, dto));
    }

    @PostMapping("/checkout-preview")
    public Result<CartCheckoutPreviewVO> checkoutPreview(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Valid @RequestBody CartCheckoutPreviewDTO dto) {
        return Result.success("结算预览成功", cartService.checkoutPreview(userId, dto));
    }
}
