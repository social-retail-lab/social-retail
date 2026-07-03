package com.socialretail.backend.service.order;

import com.socialretail.backend.dto.request.cart.CartAddDTO;
import com.socialretail.backend.dto.request.cart.CartBatchDeleteDTO;
import com.socialretail.backend.dto.request.cart.CartUpdateDTO;
import com.socialretail.backend.dto.request.cart.CartCheckoutPreviewDTO;
import com.socialretail.backend.vo.CartAddVO;
import com.socialretail.backend.vo.CartBatchDeleteVO;
import com.socialretail.backend.vo.CartListVO;
import com.socialretail.backend.vo.CartUpdateVO;
import com.socialretail.backend.vo.CartCheckoutPreviewVO;
import com.socialretail.backend.vo.CartInvalidItemListVO;

public interface CartService {
    CartListVO list(Long userId);

    CartInvalidItemListVO listInvalidItems(Long userId);

    CartAddVO add(Long userId, CartAddDTO dto);

    CartUpdateVO update(Long userId, Long cartItemId, CartUpdateDTO dto);

    void delete(Long userId, Long cartItemId);

    CartBatchDeleteVO batchDelete(Long userId, CartBatchDeleteDTO dto);

    CartCheckoutPreviewVO checkoutPreview(Long userId, CartCheckoutPreviewDTO dto);
}
