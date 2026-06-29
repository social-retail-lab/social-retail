package com.socialretail.backend.controller.merchant;

import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.Result;
import com.socialretail.backend.service.merchant.MerchantProductService;
import com.socialretail.backend.vo.AuditVO;
import com.socialretail.backend.vo.PriceUpdateRequest;
import com.socialretail.backend.vo.PriceUpdateVO;
import com.socialretail.backend.vo.ProductAuditStatusVO;
import com.socialretail.backend.vo.ProductCreateRequest;
import com.socialretail.backend.vo.ProductListVO;
import com.socialretail.backend.vo.ProductQueryRequest;
import com.socialretail.backend.vo.ProductVO;
import com.socialretail.backend.vo.ShelfStatusRequest;
import com.socialretail.backend.vo.StockUpdateRequest;
import com.socialretail.backend.vo.StockUpdateVO;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/merchant")
public class MerchantGoodsController {

    @Resource
    private MerchantProductService merchantProductService;

    @GetMapping("/products")
    public Result<PageResult<ProductListVO>> getProductList(HttpServletRequest request,
                                                            @RequestParam(required = false) String keyword,
                                                            @RequestParam(required = false) Long categoryId,
                                                            @RequestParam(required = false) Integer status,
                                                            @RequestParam(required = false) Integer auditStatus,
                                                            @RequestParam(defaultValue = "1") int pageNum,
                                                            @RequestParam(defaultValue = "10") int pageSize) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        ProductQueryRequest req = new ProductQueryRequest();
        req.setKeyword(keyword);
        req.setCategoryId(categoryId);
        req.setStatus(status);
        req.setAuditStatus(auditStatus);
        PageResult<ProductListVO> pageResult = merchantProductService.getProductList(merchantId, req, pageNum, pageSize);
        return Result.ok(pageResult);
    }

    @PostMapping("/products")
    public Result<AuditVO> createProduct(HttpServletRequest request,
                                         @RequestBody ProductCreateRequest req) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        AuditVO vo = merchantProductService.createProduct(merchantId, req);
        return Result.ok("商品发布成功，等待审核", vo);
    }

    @PutMapping("/products/{productId}")
    public Result<AuditVO> updateProduct(HttpServletRequest request,
                                         @PathVariable Long productId,
                                         @RequestBody ProductCreateRequest req) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        AuditVO vo = merchantProductService.updateProduct(merchantId, productId, req);
        return Result.ok("商品修改成功，等待审核", vo);
    }

    @GetMapping("/products/{productId}")
    public Result<ProductVO> getProductDetail(HttpServletRequest request,
                                              @PathVariable Long productId) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        ProductVO vo = merchantProductService.getProductDetail(merchantId, productId);
        return Result.ok(vo);
    }

    @PatchMapping("/products/{productId}/status")
    public Result<Void> updateShelfStatus(HttpServletRequest request,
                                          @PathVariable Long productId,
                                          @RequestBody ShelfStatusRequest req) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        String message = merchantProductService.updateShelfStatus(merchantId, productId, req.getStatus());
        return Result.ok(message, null);
    }

    @PatchMapping("/skus/{skuId}/stock")
    public Result<StockUpdateVO> updateStock(HttpServletRequest request,
                                             @PathVariable Long skuId,
                                             @RequestBody StockUpdateRequest req) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        StockUpdateVO vo = merchantProductService.updateStock(merchantId, skuId, req);
        return Result.ok("库存更新成功", vo);
    }

    @PatchMapping("/skus/{skuId}/price")
    public Result<PriceUpdateVO> updatePrice(HttpServletRequest request,
                                             @PathVariable Long skuId,
                                             @RequestBody PriceUpdateRequest req) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        PriceUpdateVO vo = merchantProductService.updatePrice(merchantId, skuId, req);
        return Result.ok("价格更新成功", vo);
    }

    @GetMapping("/products/{productId}/audit-status")
    public Result<ProductAuditStatusVO> getProductAuditStatus(HttpServletRequest request,
                                                               @PathVariable Long productId) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        ProductAuditStatusVO vo = merchantProductService.getProductAuditStatus(merchantId, productId);
        return Result.ok(vo);
    }
}
