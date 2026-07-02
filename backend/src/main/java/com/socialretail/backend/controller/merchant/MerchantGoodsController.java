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
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Slf4j
@RestController
@RequestMapping("/api/merchant")
public class MerchantGoodsController {

    @Resource
    private MerchantProductService merchantProductService;

    @Value("${upload.path:}")
    private String uploadPath;

    @Value("${upload.base-url:http://192.168.0.179:8080}")
    private String baseUrl;

    // ========== 品牌搜索（支持模糊匹配） ==========
    @GetMapping("/brands")
    public Result<List<Map<String, Object>>> searchBrands(@RequestParam(required = false) String keyword) {
        log.info("[品牌搜索] keyword={}", keyword);
        try {
            List<Map<String, Object>> brands = merchantProductService.searchBrands(keyword);
            log.info("[品牌搜索] 成功, count={}", brands.size());
            return Result.ok(brands);
        } catch (RuntimeException e) {
            log.warn("[品牌搜索] 失败, 原因: {}", e.getMessage());
            throw e;
        }
    }

    // ========== 分类列表（一级分类 / 二级分类，通过 parentId 区分） ==========
    @GetMapping("/categories")
    public Result<List<Map<String, Object>>> getCategories(@RequestParam(required = false) Long parentId) {
        log.info("[分类列表] parentId={}", parentId);
        try {
            List<Map<String, Object>> categories;
            if (parentId != null) {
                categories = merchantProductService.getSubCategories(parentId);
            } else {
                categories = merchantProductService.getTopCategories();
            }
            log.info("[分类列表] 成功, count={}", categories.size());
            return Result.ok(categories);
        } catch (RuntimeException e) {
            log.warn("[分类列表] 失败, 原因: {}", e.getMessage());
            throw e;
        }
    }

    // ========== 图片上传（支持分文件夹保存） ==========
    // folder可选值: product(默认), id_card, business_license, food_permit, avatar, evidence
    @PostMapping("/upload/image")
    public Result<Map<String, String>> uploadImage(@RequestParam("file") MultipartFile file,
                                                    @RequestParam(defaultValue = "product") String folder) {
        log.info("[图片上传] fileName={}, size={}, folder={}", file.getOriginalFilename(), file.getSize(), folder);
        try {
            if (file.isEmpty()) {
                throw new RuntimeException("上传文件为空");
            }
            String originalName = file.getOriginalFilename();
            String ext = "";
            if (originalName != null && originalName.contains(".")) {
                ext = originalName.substring(originalName.lastIndexOf("."));
            }
            String newFileName = UUID.randomUUID().toString().replace("-", "") + ext;
            String dateDir = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));

            // 解析上传目录：优先使用配置的绝对路径，否则使用 user.dir
            Path basePath;
            if (uploadPath != null && !uploadPath.isEmpty()) {
                basePath = Paths.get(uploadPath).toAbsolutePath();
            } else {
                basePath = Paths.get(System.getProperty("user.dir"), "static").toAbsolutePath();
            }
            Path dirPath = basePath.resolve(folder).resolve(dateDir);
            Files.createDirectories(dirPath);

            File dest = dirPath.resolve(newFileName).toFile();
            file.transferTo(dest);

            String url = baseUrl + "/static/" + folder + "/" + dateDir + "/" + newFileName;
            Map<String, String> result = Map.of("url", url, "fileName", newFileName);
            log.info("[图片上传] 成功, url={}", url);
            return Result.ok("上传成功", result);
        } catch (IOException e) {
            log.error("[图片上传] 失败, 原因: {}", e.getMessage());
            throw new RuntimeException("图片上传失败: " + e.getMessage());
        }
    }

    // ========== 商品管理 API ==========
    @GetMapping("/products")
    public Result<PageResult<ProductListVO>> getProductList(HttpServletRequest request,
                                                            @RequestParam(required = false) String keyword,
                                                            @RequestParam(required = false) Long categoryId,
                                                            @RequestParam(required = false) Integer status,
                                                            @RequestParam(required = false) Integer auditStatus,
                                                            @RequestParam(defaultValue = "1") int pageNum,
                                                            @RequestParam(defaultValue = "10") int pageSize) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        log.info("[商品列表] merchantId={}, keyword={}, categoryId={}, status={}, auditStatus={}, pageNum={}, pageSize={}",
                merchantId, keyword, categoryId, status, auditStatus, pageNum, pageSize);
        try {
            ProductQueryRequest req = new ProductQueryRequest();
            req.setKeyword(keyword);
            req.setCategoryId(categoryId);
            req.setStatus(status);
            req.setAuditStatus(auditStatus);
            PageResult<ProductListVO> pageResult = merchantProductService.getProductList(merchantId, req, pageNum, pageSize);
            log.info("[商品列表] 成功, merchantId={}, total={}, pageSize={}", merchantId, pageResult.getTotal(), pageResult.getList().size());
            return Result.ok(pageResult);
        } catch (RuntimeException e) {
            log.warn("[商品列表] 失败, merchantId={}, 原因: {}", merchantId, e.getMessage());
            throw e;
        }
    }

    @PostMapping("/products")
    public Result<AuditVO> createProduct(HttpServletRequest request,
                                         @RequestBody ProductCreateRequest req) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        log.info("[发布商品] merchantId={}, 请求体: title={}, saleType={}, skuCount={}, brandId={}",
                merchantId, req.getTitle(), req.getSaleType(),
                req.getSkuList() != null ? req.getSkuList().size() : 0, req.getBrandId());
        try {
            AuditVO vo = merchantProductService.createProduct(merchantId, req);
            log.info("[发布商品] 成功, merchantId={}, productId={}, auditStatus={}", merchantId, vo.getProductId(), vo.getAuditStatus());
            return Result.ok("商品发布成功，等待审核", vo);
        } catch (RuntimeException e) {
            log.warn("[发布商品] 失败, merchantId={}, 原因: {}", merchantId, e.getMessage());
            throw e;
        }
    }

    @PutMapping("/products/{productId}")
    public Result<AuditVO> updateProduct(HttpServletRequest request,
                                         @PathVariable Long productId,
                                         @RequestBody ProductCreateRequest req) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        log.info("[编辑商品] merchantId={}, productId={}, 请求体: title={}, saleType={}, skuCount={}",
                merchantId, productId, req.getTitle(), req.getSaleType(),
                req.getSkuList() != null ? req.getSkuList().size() : 0);
        try {
            AuditVO vo = merchantProductService.updateProduct(merchantId, productId, req);
            log.info("[编辑商品] 成功, productId={}, auditStatus reset to 0", productId);
            return Result.ok("商品修改成功，等待审核", vo);
        } catch (RuntimeException e) {
            log.warn("[编辑商品] 失败, merchantId={}, productId={}, 原因: {}", merchantId, productId, e.getMessage());
            throw e;
        }
    }

    @GetMapping("/products/{productId}")
    public Result<ProductVO> getProductDetail(HttpServletRequest request,
                                              @PathVariable Long productId) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        log.info("[商品详情] merchantId={}, productId={}", merchantId, productId);
        try {
            ProductVO vo = merchantProductService.getProductDetail(merchantId, productId);
            log.info("[商品详情] 成功, productId={}, title={}", productId, vo.getTitle());
            return Result.ok(vo);
        } catch (RuntimeException e) {
            log.warn("[商品详情] 失败, merchantId={}, productId={}, 原因: {}", merchantId, productId, e.getMessage());
            throw e;
        }
    }

    @PatchMapping("/products/{productId}/status")
    public Result<Void> updateShelfStatus(HttpServletRequest request,
                                          @PathVariable Long productId,
                                          @RequestBody ShelfStatusRequest req) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        log.info("[上下架] merchantId={}, productId={}, targetStatus={}", merchantId, productId, req.getStatus());
        try {
            String message = merchantProductService.updateShelfStatus(merchantId, productId, req.getStatus());
            log.info("[上下架] 成功, productId={}, message={}", productId, message);
            return Result.ok(message, null);
        } catch (RuntimeException e) {
            log.warn("[上下架] 失败, merchantId={}, productId={}, 原因: {}", merchantId, productId, e.getMessage());
            throw e;
        }
    }

    @PatchMapping("/skus/{skuId}/stock")
    public Result<StockUpdateVO> updateStock(HttpServletRequest request,
                                             @PathVariable Long skuId,
                                             @RequestBody StockUpdateRequest req) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        log.info("[库存维护] merchantId={}, skuId={}, 请求体: stock={}, remark={}", merchantId, skuId, req.getStock(), req.getRemark());
        try {
            StockUpdateVO vo = merchantProductService.updateStock(merchantId, skuId, req);
            log.info("[库存维护] 成功, skuId={}, oldStock={}, newStock={}", skuId, vo.getOldStock(), vo.getNewStock());
            return Result.ok("库存更新成功", vo);
        } catch (RuntimeException e) {
            log.warn("[库存维护] 失败, merchantId={}, skuId={}, 原因: {}", merchantId, skuId, e.getMessage());
            throw e;
        }
    }

    @PatchMapping("/skus/{skuId}/price")
    public Result<PriceUpdateVO> updatePrice(HttpServletRequest request,
                                             @PathVariable Long skuId,
                                             @RequestBody PriceUpdateRequest req) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        log.info("[价格维护] merchantId={}, skuId={}, 请求体: price={}", merchantId, skuId, req.getPrice());
        try {
            PriceUpdateVO vo = merchantProductService.updatePrice(merchantId, skuId, req);
            log.info("[价格维护] 成功, skuId={}, oldPrice={}, newPrice={}", skuId, vo.getOldPrice(), vo.getNewPrice());
            return Result.ok("价格更新成功", vo);
        } catch (RuntimeException e) {
            log.warn("[价格维护] 失败, merchantId={}, skuId={}, 原因: {}", merchantId, skuId, e.getMessage());
            throw e;
        }
    }

    @GetMapping("/products/{productId}/audit-status")
    public Result<ProductAuditStatusVO> getProductAuditStatus(HttpServletRequest request,
                                                               @PathVariable Long productId) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        log.info("[查询商品审核状态] merchantId={}, productId={}", merchantId, productId);
        try {
            ProductAuditStatusVO vo = merchantProductService.getProductAuditStatus(merchantId, productId);
            log.info("[查询商品审核状态] 成功, productId={}, auditStatus={}", productId, vo.getAuditStatus());
            return Result.ok(vo);
        } catch (RuntimeException e) {
            log.warn("[查询商品审核状态] 失败, merchantId={}, productId={}, 原因: {}", merchantId, productId, e.getMessage());
            throw e;
        }
    }
}
