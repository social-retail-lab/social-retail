package com.socialretail.backend.service.merchant;

import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.entity.member.Merchant;
import com.socialretail.backend.entity.product.Brand;
import com.socialretail.backend.entity.product.Category;
import com.socialretail.backend.entity.product.Product;
import com.socialretail.backend.entity.product.ProductCategoryRelation;
import com.socialretail.backend.entity.product.Sku;
import com.socialretail.backend.mapper.member.MerchantMapper;
import com.socialretail.backend.mapper.product.BrandMapper;
import com.socialretail.backend.mapper.product.CategoryMapper;
import com.socialretail.backend.mapper.product.ProductCategoryRelationMapper;
import com.socialretail.backend.mapper.product.ProductMapper;
import com.socialretail.backend.mapper.product.SkuMapper;
import com.socialretail.backend.vo.AuditVO;
import com.socialretail.backend.vo.PriceUpdateRequest;
import com.socialretail.backend.vo.PriceUpdateVO;
import com.socialretail.backend.vo.ProductAuditStatusVO;
import com.socialretail.backend.vo.ProductCreateRequest;
import com.socialretail.backend.vo.ProductListVO;
import com.socialretail.backend.vo.ProductQueryRequest;
import com.socialretail.backend.vo.ProductVO;
import com.socialretail.backend.vo.SkuRequest;
import com.socialretail.backend.vo.SkuVO;
import com.socialretail.backend.vo.StockUpdateRequest;
import com.socialretail.backend.vo.StockUpdateVO;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class MerchantProductService {

    @Resource
    private ProductMapper productMapper;

    @Resource
    private SkuMapper skuMapper;

    @Resource
    private BrandMapper brandMapper;

    @Resource
    private CategoryMapper categoryMapper;

    @Resource
    private ProductCategoryRelationMapper productCategoryRelationMapper;

    @Resource
    private MerchantMapper merchantMapper;

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();

    public PageResult<ProductListVO> getProductList(Long merchantId, ProductQueryRequest req, int page, int pageSize) {
        LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Product::getMerchantId, merchantId);

        // 关键词模糊搜索
        if (req.getKeyword() != null && !req.getKeyword().isEmpty()) {
            wrapper.like(Product::getTitle, req.getKeyword());
        }

        // 分类筛选：需要子查询product_category_relation
        if (req.getCategoryId() != null) {
            LambdaQueryWrapper<ProductCategoryRelation> relWrapper = new LambdaQueryWrapper<>();
            relWrapper.eq(ProductCategoryRelation::getCategoryId, req.getCategoryId())
                    .select(ProductCategoryRelation::getProductId);
            List<ProductCategoryRelation> relations = productCategoryRelationMapper.selectList(relWrapper);
            List<Long> productIds = relations.stream()
                    .map(ProductCategoryRelation::getProductId)
                    .distinct()
                    .collect(Collectors.toList());
            if (productIds.isEmpty()) {
                // 无匹配商品，返回空结果
                return PageResult.of(Collections.emptyList(), 0, page, pageSize);
            }
            wrapper.in(Product::getId, productIds);
        }

        // 状态筛选
        if (req.getStatus() != null) {
            wrapper.eq(Product::getStatus, req.getStatus());
        }

        // 审核状态筛选
        if (req.getAuditStatus() != null) {
            wrapper.eq(Product::getAuditStatus, req.getAuditStatus());
        }

        wrapper.orderByDesc(Product::getCreateTime);

        // 分页查询
        Page<Product> pageObj = new Page<>(page, pageSize);
        Page<Product> result = productMapper.selectPage(pageObj, wrapper);

        // 构建VO列表
        List<ProductListVO> voList = new ArrayList<>();
        for (Product product : result.getRecords()) {
            ProductListVO vo = new ProductListVO();
            vo.setProductId(product.getId());
            vo.setTitle(product.getTitle());
            vo.setMainImage(product.getMainImage());
            vo.setAuditStatus(product.getAuditStatus());
            vo.setAuditStatusText(getAuditStatusText(product.getAuditStatus()));
            vo.setStatus(product.getStatus());
            vo.setStatusText(getProductStatusText(product.getStatus()));
            if (product.getCreateTime() != null) {
                vo.setCreateTime(product.getCreateTime().format(FORMATTER));
            }

            // 查询SKU计算价格和库存
            LambdaQueryWrapper<Sku> skuWrapper = new LambdaQueryWrapper<>();
            skuWrapper.eq(Sku::getProductId, product.getId());
            List<Sku> skus = skuMapper.selectList(skuWrapper);
            if (!skus.isEmpty()) {
                BigDecimal minPrice = skus.stream()
                        .map(Sku::getPrice)
                        .filter(p -> p != null)
                        .min(BigDecimal::compareTo)
                        .orElse(BigDecimal.ZERO);
                BigDecimal maxPrice = skus.stream()
                        .map(Sku::getPrice)
                        .filter(p -> p != null)
                        .max(BigDecimal::compareTo)
                        .orElse(BigDecimal.ZERO);
                int totalStock = skus.stream()
                        .mapToInt(s -> s.getStock() != null ? s.getStock() : 0)
                        .sum();
                vo.setMinPrice(minPrice);
                vo.setMaxPrice(maxPrice);
                vo.setTotalStock(totalStock);
            } else {
                vo.setMinPrice(BigDecimal.ZERO);
                vo.setMaxPrice(BigDecimal.ZERO);
                vo.setTotalStock(0);
            }
            voList.add(vo);
        }

        return PageResult.of(voList, result.getTotal(), page, pageSize);
    }

    @Transactional
    public AuditVO createProduct(Long merchantId, ProductCreateRequest req) {
        // 验证商家存在
        Merchant merchant = merchantMapper.selectById(merchantId);
        if (merchant == null) {
            throw new RuntimeException("商家信息不存在");
        }

        Product product = new Product();
        product.setMerchantId(merchantId);
        product.setBrandId(req.getBrandId());
        product.setTitle(req.getTitle());
        product.setSubTitle(req.getSubTitle());
        product.setMainImage(req.getMainImage());
        product.setDetailDesc(req.getDetailDesc());
        product.setSaleType(req.getSaleType());
        product.setStatus(0);
        product.setAuditStatus(0);
        product.setCreateTime(LocalDateTime.now());
        product.setUpdateTime(LocalDateTime.now());

        // 序列化detailImages为JSON字符串
        if (req.getDetailImages() != null && !req.getDetailImages().isEmpty()) {
            try {
                product.setDetailImages(OBJECT_MAPPER.writeValueAsString(req.getDetailImages()));
            } catch (Exception e) {
                throw new RuntimeException("图片序列化失败", e);
            }
        }

        productMapper.insert(product);

        // 插入分类关联
        if (req.getCategoryIds() != null) {
            for (Long categoryId : req.getCategoryIds()) {
                ProductCategoryRelation relation = new ProductCategoryRelation();
                relation.setProductId(product.getId());
                relation.setCategoryId(categoryId);
                productCategoryRelationMapper.insert(relation);
            }
        }

        // 插入SKU列表
        if (req.getSkuList() != null) {
            for (SkuRequest skuReq : req.getSkuList()) {
                Sku sku = new Sku();
                sku.setProductId(product.getId());
                sku.setSpecs(skuReq.getSpecs());
                sku.setPrice(skuReq.getPrice());
                sku.setStock(skuReq.getStock());
                sku.setSkuCode(skuReq.getSkuCode());
                skuMapper.insert(sku);
            }
        }

        AuditVO auditVO = new AuditVO();
        auditVO.setProductId(product.getId());
        auditVO.setAuditStatus(0);
        return auditVO;
    }

    @Transactional
    public AuditVO updateProduct(Long merchantId, Long productId, ProductCreateRequest req) {
        Product product = productMapper.selectById(productId);
        if (product == null) {
            throw new RuntimeException("商品不存在");
        }
        if (!product.getMerchantId().equals(merchantId)) {
            throw new RuntimeException("无权操作该商品");
        }

        // 更新商品字段
        if (req.getBrandId() != null) {
            product.setBrandId(req.getBrandId());
        }
        if (req.getTitle() != null) {
            product.setTitle(req.getTitle());
        }
        if (req.getSubTitle() != null) {
            product.setSubTitle(req.getSubTitle());
        }
        if (req.getMainImage() != null) {
            product.setMainImage(req.getMainImage());
        }
        if (req.getDetailDesc() != null) {
            product.setDetailDesc(req.getDetailDesc());
        }
        if (req.getSaleType() != null) {
            product.setSaleType(req.getSaleType());
        }
        product.setAuditStatus(0);
        product.setAuditRemark(null);
        product.setAuditTime(null);
        product.setUpdateTime(LocalDateTime.now());

        // 序列化detailImages
        if (req.getDetailImages() != null) {
            try {
                product.setDetailImages(OBJECT_MAPPER.writeValueAsString(req.getDetailImages()));
            } catch (Exception e) {
                throw new RuntimeException("图片序列化失败", e);
            }
        }

        productMapper.updateById(product);

        // 更新分类关联：先删后增
        if (req.getCategoryIds() != null) {
            LambdaQueryWrapper<ProductCategoryRelation> relWrapper = new LambdaQueryWrapper<>();
            relWrapper.eq(ProductCategoryRelation::getProductId, productId);
            productCategoryRelationMapper.delete(relWrapper);

            for (Long categoryId : req.getCategoryIds()) {
                ProductCategoryRelation relation = new ProductCategoryRelation();
                relation.setProductId(productId);
                relation.setCategoryId(categoryId);
                productCategoryRelationMapper.insert(relation);
            }
        }

        // 更新SKU：先删后增
        if (req.getSkuList() != null) {
            LambdaQueryWrapper<Sku> skuWrapper = new LambdaQueryWrapper<>();
            skuWrapper.eq(Sku::getProductId, productId);
            skuMapper.delete(skuWrapper);

            for (SkuRequest skuReq : req.getSkuList()) {
                Sku sku = new Sku();
                sku.setProductId(productId);
                sku.setSpecs(skuReq.getSpecs());
                sku.setPrice(skuReq.getPrice());
                sku.setStock(skuReq.getStock());
                sku.setSkuCode(skuReq.getSkuCode());
                skuMapper.insert(sku);
            }
        }

        AuditVO auditVO = new AuditVO();
        auditVO.setProductId(productId);
        auditVO.setAuditStatus(0);
        return auditVO;
    }

    public ProductVO getProductDetail(Long merchantId, Long productId) {
        Product product = productMapper.selectById(productId);
        if (product == null) {
            throw new RuntimeException("商品不存在");
        }
        if (!product.getMerchantId().equals(merchantId)) {
            throw new RuntimeException("无权查看该商品");
        }

        ProductVO vo = new ProductVO();
        vo.setProductId(product.getId());
        vo.setTitle(product.getTitle());
        vo.setSubTitle(product.getSubTitle());
        vo.setMainImage(product.getMainImage());
        vo.setDetailDesc(product.getDetailDesc());
        vo.setSaleType(product.getSaleType());
        vo.setSaleTypeText(getSaleTypeText(product.getSaleType()));
        vo.setAuditStatus(product.getAuditStatus());
        vo.setAuditRemark(product.getAuditRemark());
        vo.setStatus(product.getStatus());
        if (product.getCreateTime() != null) {
            vo.setCreateTime(product.getCreateTime().format(FORMATTER));
        }
        if (product.getUpdateTime() != null) {
            vo.setUpdateTime(product.getUpdateTime().format(FORMATTER));
        }

        // 品牌名称
        if (product.getBrandId() != null) {
            vo.setBrandId(product.getBrandId());
            Brand brand = brandMapper.selectById(product.getBrandId());
            if (brand != null) {
                vo.setBrandName(brand.getName());
            }
        }

        // 分类信息
        LambdaQueryWrapper<ProductCategoryRelation> relWrapper = new LambdaQueryWrapper<>();
        relWrapper.eq(ProductCategoryRelation::getProductId, productId);
        List<ProductCategoryRelation> relations = productCategoryRelationMapper.selectList(relWrapper);
        List<Long> categoryIds = new ArrayList<>();
        List<String> categoryNames = new ArrayList<>();
        for (ProductCategoryRelation relation : relations) {
            categoryIds.add(relation.getCategoryId());
            Category category = categoryMapper.selectById(relation.getCategoryId());
            if (category != null) {
                categoryNames.add(category.getName());
            }
        }
        vo.setCategoryIds(categoryIds);
        vo.setCategoryNames(categoryNames);

        // SKU列表
        LambdaQueryWrapper<Sku> skuWrapper = new LambdaQueryWrapper<>();
        skuWrapper.eq(Sku::getProductId, productId);
        List<Sku> skus = skuMapper.selectList(skuWrapper);
        List<SkuVO> skuVOs = new ArrayList<>();
        for (Sku sku : skus) {
            SkuVO skuVO = new SkuVO();
            skuVO.setSkuId(sku.getId());
            skuVO.setSpecs(sku.getSpecs());
            skuVO.setPrice(sku.getPrice());
            skuVO.setStock(sku.getStock());
            skuVO.setSkuCode(sku.getSkuCode());
            skuVOs.add(skuVO);
        }
        vo.setSkuList(skuVOs);

        // 解析detailImages
        if (product.getDetailImages() != null && !product.getDetailImages().isEmpty()) {
            try {
                List<String> images = OBJECT_MAPPER.readValue(
                        product.getDetailImages(), new TypeReference<List<String>>() {});
                vo.setDetailImages(images);
            } catch (Exception e) {
                vo.setDetailImages(Collections.emptyList());
            }
        }

        return vo;
    }

    public String updateShelfStatus(Long merchantId, Long productId, Integer status) {
        Product product = productMapper.selectById(productId);
        if (product == null) {
            throw new RuntimeException("商品不存在");
        }
        if (!product.getMerchantId().equals(merchantId)) {
            throw new RuntimeException("无权操作该商品");
        }

        // 上架前检查审核状态
        if (status != null && status == 1) {
            if (product.getAuditStatus() == null || product.getAuditStatus() != 1) {
                throw new RuntimeException("商品审核未通过，无法上架");
            }
        }

        product.setStatus(status);
        productMapper.updateById(product);

        return status == 1 ? "上架成功" : "下架成功";
    }

    public StockUpdateVO updateStock(Long merchantId, Long skuId, StockUpdateRequest req) {
        Sku sku = skuMapper.selectById(skuId);
        if (sku == null) {
            throw new RuntimeException("SKU不存在");
        }

        Product product = productMapper.selectById(sku.getProductId());
        if (product == null || !product.getMerchantId().equals(merchantId)) {
            throw new RuntimeException("无权操作该SKU");
        }

        Integer oldStock = sku.getStock();
        sku.setStock(req.getStock());
        skuMapper.updateById(sku);

        StockUpdateVO vo = new StockUpdateVO();
        vo.setSkuId(skuId);
        vo.setProductName(product.getTitle());
        vo.setOldStock(oldStock);
        vo.setNewStock(req.getStock());
        return vo;
    }

    public PriceUpdateVO updatePrice(Long merchantId, Long skuId, PriceUpdateRequest req) {
        Sku sku = skuMapper.selectById(skuId);
        if (sku == null) {
            throw new RuntimeException("SKU不存在");
        }

        Product product = productMapper.selectById(sku.getProductId());
        if (product == null || !product.getMerchantId().equals(merchantId)) {
            throw new RuntimeException("无权操作该SKU");
        }

        BigDecimal oldPrice = sku.getPrice();
        sku.setPrice(req.getPrice());
        skuMapper.updateById(sku);

        PriceUpdateVO vo = new PriceUpdateVO();
        vo.setSkuId(skuId);
        vo.setOldPrice(oldPrice);
        vo.setNewPrice(req.getPrice());
        return vo;
    }

    public ProductAuditStatusVO getProductAuditStatus(Long merchantId, Long productId) {
        Product product = productMapper.selectById(productId);
        if (product == null) {
            throw new RuntimeException("商品不存在");
        }
        if (!product.getMerchantId().equals(merchantId)) {
            throw new RuntimeException("无权查看该商品");
        }

        ProductAuditStatusVO vo = new ProductAuditStatusVO();
        vo.setProductId(product.getId());
        vo.setTitle(product.getTitle());
        vo.setAuditStatus(product.getAuditStatus());
        vo.setAuditStatusText(getAuditStatusText(product.getAuditStatus()));
        vo.setAuditRemark(product.getAuditRemark());
        if (product.getAuditTime() != null) {
            vo.setAuditTime(product.getAuditTime().format(FORMATTER));
        }
        if (product.getCreateTime() != null) {
            vo.setSubmitTime(product.getCreateTime().format(FORMATTER));
        }
        return vo;
    }

    // ========== 品牌搜索 ==========
    public List<Map<String, Object>> searchBrands(String keyword) {
        LambdaQueryWrapper<Brand> wrapper = new LambdaQueryWrapper<>();
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.like(Brand::getName, keyword);
        }
        wrapper.orderByAsc(Brand::getId);
        wrapper.last("LIMIT 20");
        List<Brand> brands = brandMapper.selectList(wrapper);
        List<Map<String, Object>> result = new ArrayList<>();
        for (Brand b : brands) {
            Map<String, Object> item = new HashMap<>();
            item.put("brandId", b.getId());
            item.put("brandName", b.getName());
            result.add(item);
        }
        return result;
    }

    // ========== 一级分类列表 ==========
    public List<Map<String, Object>> getTopCategories() {
        LambdaQueryWrapper<Category> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Category::getLevel, 1)
                .orderByAsc(Category::getSortOrder);
        List<Category> categories = categoryMapper.selectList(wrapper);
        List<Map<String, Object>> result = new ArrayList<>();
        for (Category c : categories) {
            Map<String, Object> item = new HashMap<>();
            item.put("categoryId", c.getId());
            item.put("categoryName", c.getName());
            result.add(item);
        }
        return result;
    }

    // ========== 二级分类列表 ==========
    public List<Map<String, Object>> getSubCategories(Long parentId) {
        LambdaQueryWrapper<Category> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Category::getParentId, parentId)
                .eq(Category::getLevel, 2)
                .orderByAsc(Category::getSortOrder);
        List<Category> categories = categoryMapper.selectList(wrapper);
        List<Map<String, Object>> result = new ArrayList<>();
        for (Category c : categories) {
            Map<String, Object> item = new HashMap<>();
            item.put("categoryId", c.getId());
            item.put("categoryName", c.getName());
            result.add(item);
        }
        return result;
    }

    // Helper methods

    private String getProductStatusText(Integer status) {
        if (status == null) {
            return "未知";
        }
        switch (status) {
            case 0: return "已下架";
            case 1: return "已上架";
            default: return "未知";
        }
    }

    private String getAuditStatusText(Integer auditStatus) {
        if (auditStatus == null) {
            return "未知";
        }
        switch (auditStatus) {
            case 0: return "待审核";
            case 1: return "审核通过";
            case 2: return "审核拒绝";
            default: return "未知";
        }
    }

    private String getSaleTypeText(Integer saleType) {
        if (saleType == null) {
            return "未知";
        }
        switch (saleType) {
            case 1: return "仅自提";
            case 2: return "仅配送";
            case 3: return "自提+配送";
            default: return "未知";
        }
    }
}
