package com.socialretail.backend.service.admin;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.entity.member.Merchant;
import com.socialretail.backend.entity.member.MerchantApply;
import com.socialretail.backend.entity.member.MerchantInfoChange;
import com.socialretail.backend.entity.member.MerchantQualification;
import com.socialretail.backend.entity.product.Category;
import com.socialretail.backend.entity.product.Product;
import com.socialretail.backend.entity.product.ProductCategoryRelation;
import com.socialretail.backend.entity.product.Sku;
import com.socialretail.backend.mapper.member.MerchantApplyMapper;
import com.socialretail.backend.mapper.member.MerchantInfoChangeMapper;
import com.socialretail.backend.mapper.member.MerchantMapper;
import com.socialretail.backend.mapper.member.MerchantQualificationMapper;
import com.socialretail.backend.mapper.member.UserMapper;
import com.socialretail.backend.mapper.product.BrandMapper;
import com.socialretail.backend.mapper.product.CategoryMapper;
import com.socialretail.backend.mapper.product.ProductCategoryRelationMapper;
import com.socialretail.backend.mapper.product.ProductMapper;
import com.socialretail.backend.mapper.product.SkuMapper;
import com.socialretail.backend.vo.AdminProductDetailVO;
import com.socialretail.backend.vo.AdminProductListVO;
import com.socialretail.backend.vo.AuditVO;
import com.socialretail.backend.vo.MerchantApplicationListVO;
import com.socialretail.backend.vo.MerchantListVO;
import com.socialretail.backend.vo.ProductAuditListVO;
import com.socialretail.backend.vo.QualificationVO;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
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
public class AuditService {

    @Resource
    private MerchantApplyMapper merchantApplyMapper;

    @Resource
    private MerchantMapper merchantMapper;

    @Resource
    private MerchantQualificationMapper merchantQualificationMapper;

    @Resource
    private ProductMapper productMapper;

    @Resource
    private UserMapper userMapper;

    @Resource
    private SkuMapper skuMapper;

    @Resource
    private ProductCategoryRelationMapper productCategoryRelationMapper;

    @Resource
    private BrandMapper brandMapper;

    @Resource
    private CategoryMapper categoryMapper;

    @Resource
    private MerchantInfoChangeMapper merchantInfoChangeMapper;

    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper().registerModule(new JavaTimeModule());

    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    // ==================== 1. 商家入驻申请列表 ====================

    public PageResult<MerchantApplicationListVO> getMerchantApplications(Integer auditStatus, String keyword,
            String startDate, String endDate, int page, int pageSize) {
        LambdaQueryWrapper<MerchantApply> wrapper = new LambdaQueryWrapper<>();

        if (auditStatus != null) {
            wrapper.eq(MerchantApply::getAuditStatus, auditStatus);
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            wrapper.and(w -> w.like(MerchantApply::getCompanyName, keyword)
                    .or().like(MerchantApply::getShopName, keyword)
                    .or().like(MerchantApply::getContactName, keyword));
        }
        if (startDate != null && !startDate.isEmpty()) {
            wrapper.ge(MerchantApply::getApplyTime, LocalDateTime.parse(startDate + "T00:00:00"));
        }
        if (endDate != null && !endDate.isEmpty()) {
            wrapper.le(MerchantApply::getApplyTime, LocalDateTime.parse(endDate + "T23:59:59"));
        }

        wrapper.orderByDesc(MerchantApply::getApplyTime);

        Page<MerchantApply> mpPage = new Page<>(page, pageSize);
        Page<MerchantApply> resultPage = merchantApplyMapper.selectPage(mpPage, wrapper);

        List<MerchantApplicationListVO> voList = new ArrayList<>();
        for (MerchantApply entity : resultPage.getRecords()) {
            MerchantApplicationListVO vo = new MerchantApplicationListVO();
            vo.setApplyId(entity.getId());
            vo.setApplyType(entity.getApplyType());
            vo.setApplyTypeText(applyTypeText(entity.getApplyType()));
            vo.setCompanyName(entity.getCompanyName());
            vo.setShopName(entity.getShopName());
            vo.setContactName(entity.getContactName());
            vo.setContactPhone(entity.getContactPhone());
            vo.setLicenseNumber(entity.getLicenseNumber());
            vo.setLicenseImage(entity.getLicenseImage());
            vo.setFoodPermitNumber(entity.getFoodPermitNumber());
            vo.setFoodPermitImage(entity.getFoodPermitImage());
            vo.setIdCardFront(entity.getIdCardFront());
            vo.setIdCardBack(entity.getIdCardBack());
            vo.setAuditStatus(entity.getAuditStatus());
            vo.setAuditStatusText(auditStatusText(entity.getAuditStatus()));
            vo.setApplyTime(entity.getApplyTime() != null ? entity.getApplyTime().format(FMT) : null);
            voList.add(vo);
        }

        return PageResult.of(voList, resultPage.getTotal(), page, pageSize);
    }

    // ==================== 2. 审核商家入驻申请 ====================

    @Transactional
    public AuditVO auditMerchantApplication(Long applyId, Integer auditStatus, String auditRemark) {
        MerchantApply application = merchantApplyMapper.selectById(applyId);
        if (application == null) {
            throw new RuntimeException("申请不存在");
        }
        if (application.getAuditStatus() != null && application.getAuditStatus() != 0) {
            throw new RuntimeException("该申请已审核过");
        }

        application.setAuditStatus(auditStatus);
        application.setAuditRemark(auditRemark);
        application.setAuditTime(LocalDateTime.now());
        merchantApplyMapper.updateById(application);

        AuditVO auditVO = new AuditVO();
        auditVO.setApplyId(applyId);
        auditVO.setAuditStatus(auditStatus);

        if (auditStatus == 1) {
            Merchant merchant = new Merchant();
            merchant.setUserId(application.getUserId());
            merchant.setMerchantName(application.getShopName());
            merchant.setContactName(application.getContactName());
            merchant.setContactPhone(application.getContactPhone());
            merchant.setShopAddress(application.getShopAddress());
            merchant.setStatus(1);
            merchant.setCreateTime(LocalDateTime.now());
            merchantMapper.insert(merchant);

            MerchantQualification qualification = new MerchantQualification();
            qualification.setMerchantId(merchant.getId());
            qualification.setLicenseNumber(application.getLicenseNumber());
            qualification.setLicenseImage(application.getLicenseImage());
            qualification.setFoodPermitNumber(application.getFoodPermitNumber());
            qualification.setFoodPermitImage(application.getFoodPermitImage());
            merchantQualificationMapper.insert(qualification);

            auditVO.setMerchantId(merchant.getId());
        }

        return auditVO;
    }

    // ==================== 3. 商品审核列表 ====================

    public PageResult<ProductAuditListVO> getProductAuditList(Integer auditStatus, String keyword,
            Long merchantId, int page, int pageSize) {
        LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<>();

        if (auditStatus != null) {
            wrapper.eq(Product::getAuditStatus, auditStatus);
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            wrapper.like(Product::getTitle, keyword);
        }
        if (merchantId != null) {
            wrapper.eq(Product::getMerchantId, merchantId);
        }

        wrapper.orderByDesc(Product::getCreateTime);

        Page<Product> mpPage = new Page<>(page, pageSize);
        Page<Product> resultPage = productMapper.selectPage(mpPage, wrapper);

        List<ProductAuditListVO> voList = new ArrayList<>();
        for (Product product : resultPage.getRecords()) {
            ProductAuditListVO vo = new ProductAuditListVO();
            vo.setProductId(product.getId());
            vo.setTitle(product.getTitle());
            vo.setMainImage(product.getMainImage());

            Merchant merchant = merchantMapper.selectById(product.getMerchantId());
            if (merchant != null) {
                vo.setMerchantName(merchant.getMerchantName());
            }

            LambdaQueryWrapper<Sku> skuWrapper = new LambdaQueryWrapper<>();
            skuWrapper.eq(Sku::getProductId, product.getId());
            skuWrapper.orderByAsc(Sku::getPrice);
            skuWrapper.last("LIMIT 1");
            Sku sku = skuMapper.selectOne(skuWrapper);
            if (sku != null) {
                vo.setMinPrice(sku.getPrice());
            }

            vo.setAuditStatus(product.getAuditStatus());
            vo.setAuditStatusText(auditStatusText(product.getAuditStatus()));
            vo.setSubmitTime(product.getCreateTime() != null ? product.getCreateTime().format(FMT) : null);
            voList.add(vo);
        }

        return PageResult.of(voList, resultPage.getTotal(), page, pageSize);
    }

    // ==================== 4. 审核商品 ====================

    public AuditVO auditProduct(Long productId, Integer auditStatus, String auditRemark) {
        Product product = productMapper.selectById(productId);
        if (product == null) {
            throw new RuntimeException("商品不存在");
        }
        if (product.getAuditStatus() != null && product.getAuditStatus() != 0) {
            throw new RuntimeException("该商品已审核过");
        }

        product.setAuditStatus(auditStatus);
        product.setAuditRemark(auditRemark);
        product.setAuditTime(LocalDateTime.now());
        productMapper.updateById(product);

        AuditVO auditVO = new AuditVO();
        auditVO.setProductId(productId);
        auditVO.setAuditStatus(auditStatus);
        return auditVO;
    }

    // ==================== 5. 商家列表 ====================

    public PageResult<MerchantListVO> getMerchantList(String keyword, Integer status, int page, int pageSize) {
        LambdaQueryWrapper<Merchant> wrapper = new LambdaQueryWrapper<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            // 按ID或名字搜索
            try {
                Long idQuery = Long.valueOf(keyword);
                wrapper.and(w -> w.eq(Merchant::getId, idQuery)
                        .or().like(Merchant::getMerchantName, keyword));
            } catch (NumberFormatException e) {
                wrapper.like(Merchant::getMerchantName, keyword);
            }
        }
        if (status != null) {
            wrapper.eq(Merchant::getStatus, status);
        }

        wrapper.orderByDesc(Merchant::getCreateTime);

        Page<Merchant> mpPage = new Page<>(page, pageSize);
        Page<Merchant> resultPage = merchantMapper.selectPage(mpPage, wrapper);

        List<MerchantListVO> voList = new ArrayList<>();
        for (Merchant entity : resultPage.getRecords()) {
            MerchantListVO vo = new MerchantListVO();
            vo.setMerchantId(entity.getId());
            vo.setMerchantName(entity.getMerchantName());
            vo.setLogo(entity.getLogo());
            vo.setContactName(entity.getContactName());
            vo.setContactPhone(entity.getContactPhone());
            vo.setShopAddress(entity.getShopAddress());
            vo.setStatus(entity.getStatus());
            vo.setStatusText(merchantStatusText(entity.getStatus()));

            LambdaQueryWrapper<Product> countWrapper = new LambdaQueryWrapper<>();
            countWrapper.eq(Product::getMerchantId, entity.getId());
            long productCount = productMapper.selectCount(countWrapper);
            vo.setProductCount((int) productCount);

            vo.setCreateTime(entity.getCreateTime() != null ? entity.getCreateTime().format(FMT) : null);
            voList.add(vo);
        }

        return PageResult.of(voList, resultPage.getTotal(), page, pageSize);
    }

    // ==================== 6. 商家详情 ====================

    public Map<String, Object> getMerchantDetail(Long merchantId) {
        Merchant merchant = merchantMapper.selectById(merchantId);
        if (merchant == null) {
            throw new RuntimeException("商家不存在");
        }

        Map<String, Object> detail = new HashMap<>();
        detail.put("merchantId", merchant.getId());
        detail.put("merchantName", merchant.getMerchantName());
        detail.put("logo", merchant.getLogo());
        detail.put("contactName", merchant.getContactName());
        detail.put("contactPhone", merchant.getContactPhone());
        detail.put("shopAddress", merchant.getShopAddress());
        detail.put("businessHours", merchant.getBusinessHours());
        detail.put("introduction", merchant.getIntroduction());
        detail.put("status", merchant.getStatus());
        detail.put("statusText", merchantStatusText(merchant.getStatus()));
        detail.put("createTime", merchant.getCreateTime() != null ? merchant.getCreateTime().format(FMT) : null);

        LambdaQueryWrapper<MerchantQualification> qualWrapper = new LambdaQueryWrapper<>();
        qualWrapper.eq(MerchantQualification::getMerchantId, merchantId);
        MerchantQualification qualification = merchantQualificationMapper.selectOne(qualWrapper);
        if (qualification != null) {
            QualificationVO qualVO = new QualificationVO();
            qualVO.setQualificationId(qualification.getId());
            qualVO.setLicenseNumber(qualification.getLicenseNumber());
            qualVO.setLicenseImage(qualification.getLicenseImage());
            qualVO.setFoodPermitNumber(qualification.getFoodPermitNumber());
            qualVO.setFoodPermitImage(qualification.getFoodPermitImage());
            detail.put("qualification", qualVO);
        }

        LambdaQueryWrapper<Product> productWrapper = new LambdaQueryWrapper<>();
        productWrapper.eq(Product::getMerchantId, merchantId);
        long productCount = productMapper.selectCount(productWrapper);

        Map<String, Object> stats = new HashMap<>();
        stats.put("productCount", productCount);
        detail.put("stats", stats);

        return detail;
    }

    // ==================== 7. 修改商家状态（封禁/解封） ====================

    @Transactional
    public Map<String, Object> updateMerchantStatus(Long merchantId, Integer status, String reason) {
        Merchant merchant = merchantMapper.selectById(merchantId);
        if (merchant == null) {
            throw new RuntimeException("商家不存在");
        }

        int oldStatus = merchant.getStatus() != null ? merchant.getStatus() : 1;
        merchant.setStatus(status);
        merchantMapper.updateById(merchant);

        String message = "商家状态已更新";

        // 封禁时自动下架该商家所有商品
        if (status != null && status == 4) {
            LambdaUpdateWrapper<Product> updateWrapper = new LambdaUpdateWrapper<>();
            updateWrapper.eq(Product::getMerchantId, merchantId)
                    .set(Product::getStatus, 0);
            int affected = productMapper.update(null, updateWrapper);
            message = "商家已封禁，已自动下架 " + affected + " 个商品";
        }

        Map<String, Object> result = new HashMap<>();
        result.put("merchantId", merchantId);
        result.put("status", status);
        result.put("statusText", merchantStatusText(status));
        result.put("reason", reason);
        result.put("message", message);
        return result;
    }

    // ==================== 8. 管理员商品列表 ====================

    public PageResult<AdminProductListVO> getAllProducts(String keyword, Long categoryId, Integer status,
            Integer auditStatus, int page, int pageSize) {
        LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<>();

        // 按ID或标题搜索
        if (keyword != null && !keyword.trim().isEmpty()) {
            try {
                Long idQuery = Long.valueOf(keyword);
                wrapper.and(w -> w.eq(Product::getId, idQuery)
                        .or().like(Product::getTitle, keyword));
            } catch (NumberFormatException e) {
                wrapper.like(Product::getTitle, keyword);
            }
        }

        // 分类筛选
        if (categoryId != null) {
            LambdaQueryWrapper<ProductCategoryRelation> relWrapper = new LambdaQueryWrapper<>();
            relWrapper.eq(ProductCategoryRelation::getCategoryId, categoryId);
            List<ProductCategoryRelation> relations = productCategoryRelationMapper.selectList(relWrapper);
            List<Long> productIds = relations.stream()
                    .map(ProductCategoryRelation::getProductId)
                    .distinct()
                    .collect(Collectors.toList());
            if (productIds.isEmpty()) {
                return PageResult.of(Collections.emptyList(), 0, page, pageSize);
            }
            wrapper.in(Product::getId, productIds);
        }

        if (status != null) wrapper.eq(Product::getStatus, status);
        if (auditStatus != null) wrapper.eq(Product::getAuditStatus, auditStatus);

        wrapper.orderByDesc(Product::getCreateTime);

        Page<Product> mpPage = new Page<>(page, pageSize);
        Page<Product> resultPage = productMapper.selectPage(mpPage, wrapper);

        List<AdminProductListVO> voList = new ArrayList<>();
        for (Product p : resultPage.getRecords()) {
            AdminProductListVO vo = new AdminProductListVO();
            vo.setProductId(p.getId());
            vo.setTitle(p.getTitle());
            vo.setMainImage(p.getMainImage());
            vo.setStatus(p.getStatus());
            vo.setStatusText(p.getStatus() != null && p.getStatus() == 1 ? "已上架" : "已下架");
            vo.setAuditStatus(p.getAuditStatus());
            vo.setAuditStatusText(auditStatusText(p.getAuditStatus()));
            vo.setGroupPurchase(false); // 拼团功能预留
            Merchant m = merchantMapper.selectById(p.getMerchantId());
            if (m != null) vo.setMerchantName(m.getMerchantName());
            voList.add(vo);
        }

        return PageResult.of(voList, resultPage.getTotal(), page, pageSize);
    }

    // ==================== 9. 管理员商品详情 ====================

    public AdminProductDetailVO getProductDetailForAdmin(Long productId) {
        Product product = productMapper.selectById(productId);
        if (product == null) {
            throw new RuntimeException("商品不存在");
        }

        AdminProductDetailVO vo = new AdminProductDetailVO();
        vo.setProductId(product.getId());
        vo.setTitle(product.getTitle());
        vo.setSubTitle(product.getSubTitle());
        vo.setMainImage(product.getMainImage());
        vo.setDetailDesc(product.getDetailDesc());
        vo.setSaleType(product.getSaleType());
        vo.setStatus(product.getStatus());
        vo.setStatusText(product.getStatus() != null && product.getStatus() == 1 ? "已上架" : "已下架");
        vo.setAuditStatus(product.getAuditStatus());
        vo.setAuditStatusText(auditStatusText(product.getAuditStatus()));
        vo.setAuditRemark(product.getAuditRemark());
        if (product.getAuditTime() != null) vo.setAuditTime(product.getAuditTime().format(FMT));
        if (product.getCreateTime() != null) vo.setCreateTime(product.getCreateTime().format(FMT));

        // 商家信息
        Merchant merchant = merchantMapper.selectById(product.getMerchantId());
        if (merchant != null) {
            vo.setMerchantId(merchant.getId());
            vo.setMerchantName(merchant.getMerchantName());
            vo.setMerchantPhone(merchant.getContactPhone());
        }

        // SKU
        LambdaQueryWrapper<Sku> skuW = new LambdaQueryWrapper<>();
        skuW.eq(Sku::getProductId, productId);
        List<Sku> skus = skuMapper.selectList(skuW);
        List<Map<String, Object>> skuList = new ArrayList<>();
        for (Sku s : skus) {
            Map<String, Object> sm = new HashMap<>();
            sm.put("skuId", s.getId());
            sm.put("specs", s.getSpecs());
            sm.put("price", s.getPrice());
            sm.put("stock", s.getStock());
            sm.put("skuCode", s.getSkuCode());
            skuList.add(sm);
        }
        vo.setSkuList(skuList);

        // 分类
        LambdaQueryWrapper<ProductCategoryRelation> relW = new LambdaQueryWrapper<>();
        relW.eq(ProductCategoryRelation::getProductId, productId);
        List<ProductCategoryRelation> rels = productCategoryRelationMapper.selectList(relW);
        List<String> catNames = new ArrayList<>();
        for (ProductCategoryRelation r : rels) {
            Category cat = categoryMapper.selectById(r.getCategoryId());
            if (cat != null) catNames.add(cat.getName());
        }
        vo.setCategoryNames(catNames);

        return vo;
    }

    // ==================== 10. 管理员强制下架商品 ====================

    public Map<String, Object> offShelfProduct(Long productId, String reason) {
        Product product = productMapper.selectById(productId);
        if (product == null) {
            throw new RuntimeException("商品不存在");
        }

        product.setStatus(0);
        product.setAuditStatus(2);  // 标记为审核拒绝，上架需重新审核
        product.setAuditRemark(reason != null ? reason : "管理员下架");
        product.setAuditTime(LocalDateTime.now());
        productMapper.updateById(product);

        Map<String, Object> result = new HashMap<>();
        result.put("productId", productId);
        result.put("status", 0);
        result.put("message", "商品已下架");
        return result;
    }

    // ==================== 11. 一级分类列表（供管理员筛选用） ====================

    public List<Map<String, Object>> getAdminCategories() {
        LambdaQueryWrapper<Category> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Category::getLevel, 1).orderByAsc(Category::getSortOrder);
        List<Category> cats = categoryMapper.selectList(wrapper);
        List<Map<String, Object>> result = new ArrayList<>();
        for (Category c : cats) {
            Map<String, Object> item = new HashMap<>();
            item.put("categoryId", c.getId());
            item.put("categoryName", c.getName());
            result.add(item);
        }
        return result;
    }

    // ==================== 商家信息变更审核 ====================

    public PageResult<Map<String, Object>> getInfoChanges(Integer auditStatus, String keyword,
                                                           int pageNum, int pageSize) {
        LambdaQueryWrapper<MerchantInfoChange> wrapper = new LambdaQueryWrapper<>();
        if (auditStatus != null) {
            wrapper.eq(MerchantInfoChange::getAuditStatus, auditStatus);
        }
        wrapper.orderByDesc(MerchantInfoChange::getCreateTime);

        Page<MerchantInfoChange> mpPage = new Page<>(pageNum, pageSize);
        Page<MerchantInfoChange> resultPage = merchantInfoChangeMapper.selectPage(mpPage, wrapper);

        List<Map<String, Object>> list = new ArrayList<>();
        for (MerchantInfoChange c : resultPage.getRecords()) {
            Merchant merchant = merchantMapper.selectById(c.getMerchantId());
            Map<String, Object> item = new HashMap<>();
            item.put("changeId", c.getId());
            item.put("merchantId", c.getMerchantId());
            item.put("merchantName", merchant != null ? merchant.getMerchantName() : "未知");
            item.put("requestType", c.getRequestType());
            item.put("requestTypeText", infoChangeRequestTypeText(c.getRequestType()));
            item.put("auditStatus", c.getAuditStatus());
            item.put("auditStatusText", auditStatusText(c.getAuditStatus()));
            item.put("auditRemark", c.getAuditRemark());
            item.put("createTime", c.getCreateTime() != null ? c.getCreateTime().format(FMT) : null);
            item.put("auditTime", c.getAuditTime() != null ? c.getAuditTime().format(FMT) : null);
            try {
                if (c.getOldData() != null) item.put("oldData", OBJECT_MAPPER.readValue(c.getOldData(), Map.class));
                if (c.getNewData() != null) item.put("newData", OBJECT_MAPPER.readValue(c.getNewData(), Map.class));
            } catch (JsonProcessingException ignored) {}
            keywordFilter(item, keyword);
            list.add(item);
        }

        // 如果有keyword，手动过滤
        if (keyword != null && !keyword.trim().isEmpty()) {
            list = list.stream().filter(m -> m.get("_match") != null && (Boolean) m.get("_match")).collect(Collectors.toList());
        }

        PageResult<Map<String, Object>> result = new PageResult<>();
        result.setList(list);
        result.setTotal(list.size());
        result.setPageNum(pageNum);
        result.setPageSize(pageSize);
        return result;
    }

    @Transactional
    public Map<String, Object> auditInfoChange(Long changeId, Integer auditStatus, String remark) {
        MerchantInfoChange change = merchantInfoChangeMapper.selectById(changeId);
        if (change == null) throw new RuntimeException("信息变更请求不存在");
        if (change.getAuditStatus() != null && change.getAuditStatus() != 0) {
            throw new RuntimeException("该请求已审核");
        }

        change.setAuditStatus(auditStatus);
        change.setAuditRemark(remark);
        change.setAuditTime(LocalDateTime.now());
        merchantInfoChangeMapper.updateById(change);

        // 如果审核通过，应用变更
        if (auditStatus == 1) {
            Merchant merchant = merchantMapper.selectById(change.getMerchantId());
            if (merchant == null) throw new RuntimeException("商家不存在");

            try {
                Map<String, Object> newData = OBJECT_MAPPER.readValue(change.getNewData(), Map.class);
                if ("INFO_CHANGE".equals(change.getRequestType())) {
                    if (newData.get("merchantName") != null) merchant.setMerchantName((String) newData.get("merchantName"));
                    if (newData.get("contactName") != null) merchant.setContactName((String) newData.get("contactName"));
                    if (newData.get("contactPhone") != null) merchant.setContactPhone((String) newData.get("contactPhone"));
                    if (newData.get("shopAddress") != null) merchant.setShopAddress((String) newData.get("shopAddress"));
                    if (newData.get("businessHours") != null) merchant.setBusinessHours((String) newData.get("businessHours"));
                    if (newData.get("introduction") != null) merchant.setIntroduction((String) newData.get("introduction"));
                    merchantMapper.updateById(merchant);
                } else if ("QUALIFICATION_UPGRADE".equals(change.getRequestType())) {
                    // 升级企业资质：更新入驻申请表的applyType
                    LambdaQueryWrapper<MerchantApply> applyWrapper = new LambdaQueryWrapper<>();
                    applyWrapper.eq(MerchantApply::getUserId, merchant.getUserId())
                            .eq(MerchantApply::getAuditStatus, 1)
                            .orderByDesc(MerchantApply::getApplyTime)
                            .last("LIMIT 1");
                    MerchantApply apply = merchantApplyMapper.selectOne(applyWrapper);
                    if (apply != null) {
                        apply.setApplyType(2);
                        apply.setLicenseNumber((String) newData.get("licenseNumber"));
                        apply.setLicenseImage((String) newData.get("licenseImage"));
                        merchantApplyMapper.updateById(apply);
                    }
                    // 同步更新资质表
                    LambdaQueryWrapper<MerchantQualification> qualWrapper = new LambdaQueryWrapper<>();
                    qualWrapper.eq(MerchantQualification::getMerchantId, merchant.getId());
                    MerchantQualification qualification = merchantQualificationMapper.selectOne(qualWrapper);
                    if (qualification == null) {
                        qualification = new MerchantQualification();
                        qualification.setMerchantId(merchant.getId());
                        qualification.setLicenseNumber((String) newData.get("licenseNumber"));
                        qualification.setLicenseImage((String) newData.get("licenseImage"));
                        merchantQualificationMapper.insert(qualification);
                    } else {
                        qualification.setLicenseNumber((String) newData.get("licenseNumber"));
                        qualification.setLicenseImage((String) newData.get("licenseImage"));
                        merchantQualificationMapper.updateById(qualification);
                    }
                }
            } catch (JsonProcessingException e) {
                throw new RuntimeException("数据解析失败");
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("changeId", changeId);
        result.put("auditStatus", auditStatus);
        result.put("auditStatusText", auditStatusText(auditStatus));
        result.put("message", auditStatus == 1 ? "审核通过，变更已生效" : "审核已处理");
        return result;
    }

    private void keywordFilter(Map<String, Object> item, String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            item.put("_match", true);
            return;
        }
        String merchantName = (String) item.getOrDefault("merchantName", "");
        String requestTypeText = (String) item.getOrDefault("requestTypeText", "");
        item.put("_match", merchantName.contains(keyword) || requestTypeText.contains(keyword));
    }

    // ==================== 工具方法 ====================

    private String auditStatusText(Integer status) {
        if (status == null) return "未知";
        switch (status) {
            case 0: return "待审核";
            case 1: return "审核通过";
            case 2: return "审核拒绝";
            default: return "未知";
        }
    }

    private String merchantStatusText(Integer status) {
        if (status == null) return "未知";
        switch (status) {
            case 1: return "营业中";
            case 2: return "休息中";
            case 3: return "已关店";
            case 4: return "已封禁";
            case 5: return "暂时歇业";
            default: return "未知";
        }
    }

    private String infoChangeRequestTypeText(String type) {
        if (type == null) return "未知";
        switch (type) {
            case "INFO_CHANGE": return "商家信息修改";
            case "QUALIFICATION_UPGRADE": return "升级企业资质";
            default: return "未知";
        }
    }

    private String applyTypeText(Integer type) {
        if (type == null) return "未知";
        switch (type) {
            case 1: return "个人";
            case 2: return "企业";
            default: return "未知";
        }
    }
}
