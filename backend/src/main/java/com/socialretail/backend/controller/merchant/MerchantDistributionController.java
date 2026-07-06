package com.socialretail.backend.controller.merchant;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.socialretail.backend.common.Result;
import com.socialretail.backend.entity.distribution.MerchantDistributionProduct;
import com.socialretail.backend.entity.product.Product;
import com.socialretail.backend.mapper.distribution.MerchantDistributionProductMapper;
import com.socialretail.backend.mapper.product.ProductMapper;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;

@RestController
@RequestMapping("/api/merchant/distribution")
public class MerchantDistributionController {

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(MerchantDistributionController.class);

    private final MerchantDistributionProductMapper distributionProductMapper;
    private final ProductMapper productMapper;

    public MerchantDistributionController(MerchantDistributionProductMapper distributionProductMapper,
                                           ProductMapper productMapper) {
        this.distributionProductMapper = distributionProductMapper;
        this.productMapper = productMapper;
    }

    /** 查询商家已设置的分销商品列表 */
    @GetMapping("/products")
    public Result getProducts(HttpServletRequest request) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        LambdaQueryWrapper<MerchantDistributionProduct> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(MerchantDistributionProduct::getMerchantId, merchantId);
        List<MerchantDistributionProduct> list = distributionProductMapper.selectList(wrapper);

        List<Map<String, Object>> result = new ArrayList<>();
        for (MerchantDistributionProduct dp : list) {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("id", dp.getId());
            item.put("productId", dp.getProductId());
            item.put("commissionRate", dp.getCommissionRate());
            item.put("status", dp.getStatus());

            Product p = productMapper.selectById(dp.getProductId());
            item.put("productName", p != null ? p.getTitle() : "未知商品");
            result.add(item);
        }
        return Result.ok(result);
    }

    /** 添加分销商品（含佣金比例） */
    @PostMapping("/products")
    public Result addProduct(HttpServletRequest request, @RequestBody Map<String, Object> body) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        Long productId = ((Number) body.get("productId")).longValue();
        BigDecimal rate = new BigDecimal(body.get("commissionRate").toString());

        if (rate.compareTo(BigDecimal.ZERO) <= 0 || rate.compareTo(new BigDecimal("50")) > 0) {
            return Result.fail("佣金比例必须在1-50之间");
        }

        // 检查商品是否存在且属于该商家
        Product product = productMapper.selectById(productId);
        if (product == null) {
            return Result.fail("商品不存在");
        }
        if (!merchantId.equals(product.getMerchantId())) {
            return Result.fail("只能设置自己的商品");
        }

        // 检查是否已添加
        LambdaQueryWrapper<MerchantDistributionProduct> existWrapper = new LambdaQueryWrapper<>();
        existWrapper.eq(MerchantDistributionProduct::getMerchantId, merchantId)
                    .eq(MerchantDistributionProduct::getProductId, productId);
        if (distributionProductMapper.selectCount(existWrapper) > 0) {
            return Result.fail("该商品已在分销列表中");
        }

        MerchantDistributionProduct dp = new MerchantDistributionProduct();
        dp.setMerchantId(merchantId);
        dp.setProductId(productId);
        dp.setCommissionRate(rate);
        dp.setStatus(1);
        dp.setCreateTime(LocalDateTime.now());
        distributionProductMapper.insert(dp);

        log.info("[商家分销] merchantId={}, productId={}, rate={}%", merchantId, productId, rate);
        return Result.success(null);
    }

    /** 修改分销商品佣金比例 */
    @PutMapping("/products/{id}")
    public Result updateProduct(HttpServletRequest request, @PathVariable Long id,
                                 @RequestBody Map<String, Object> body) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        MerchantDistributionProduct dp = distributionProductMapper.selectById(id);
        if (dp == null || !merchantId.equals(dp.getMerchantId())) {
            return Result.fail("记录不存在");
        }

        BigDecimal rate = new BigDecimal(body.get("commissionRate").toString());
        if (rate.compareTo(BigDecimal.ZERO) <= 0 || rate.compareTo(new BigDecimal("50")) > 0) {
            return Result.fail("佣金比例必须在1-50之间");
        }

        dp.setCommissionRate(rate);
        dp.setUpdateTime(LocalDateTime.now());
        if (body.containsKey("status")) {
            dp.setStatus(((Number) body.get("status")).intValue());
        }
        distributionProductMapper.updateById(dp);
        return Result.success(null);
    }

    /** 删除分销商品 */
    @DeleteMapping("/products/{id}")
    public Result deleteProduct(HttpServletRequest request, @PathVariable Long id) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        MerchantDistributionProduct dp = distributionProductMapper.selectById(id);
        if (dp == null || !merchantId.equals(dp.getMerchantId())) {
            return Result.fail("记录不存在");
        }
        distributionProductMapper.deleteById(id);
        return Result.success(null);
    }

    /** 根据商品ID查询商品信息 */
    @GetMapping("/product-info/{productId}")
    public Result getProductInfo(HttpServletRequest request, @PathVariable Long productId) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        Product product = productMapper.selectById(productId);
        if (product == null || !merchantId.equals(product.getMerchantId())) {
            return Result.fail("商品不存在或不属于当前商家");
        }
        Map<String, Object> info = new LinkedHashMap<>();
        info.put("id", product.getId());
        info.put("title", product.getTitle());
        info.put("mainImage", product.getMainImage());
        return Result.ok(info);
    }
}
