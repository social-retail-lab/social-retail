package com.socialretail.backend.service.admin;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.entity.member.Merchant;
import com.socialretail.backend.entity.member.MerchantApply;
import com.socialretail.backend.entity.member.MerchantQualification;
import com.socialretail.backend.entity.product.Product;
import com.socialretail.backend.entity.product.Sku;
import com.socialretail.backend.mapper.member.MerchantApplyMapper;
import com.socialretail.backend.mapper.member.MerchantMapper;
import com.socialretail.backend.mapper.member.MerchantQualificationMapper;
import com.socialretail.backend.mapper.member.UserMapper;
import com.socialretail.backend.mapper.product.BrandMapper;
import com.socialretail.backend.mapper.product.CategoryMapper;
import com.socialretail.backend.mapper.product.ProductCategoryRelationMapper;
import com.socialretail.backend.mapper.product.ProductMapper;
import com.socialretail.backend.mapper.product.SkuMapper;
import com.socialretail.backend.vo.AuditVO;
import com.socialretail.backend.vo.MerchantApplicationListVO;
import com.socialretail.backend.vo.MerchantListVO;
import com.socialretail.backend.vo.ProductAuditListVO;
import com.socialretail.backend.vo.QualificationVO;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
            // 审核通过 - 创建商家
            Merchant merchant = new Merchant();
            merchant.setUserId(application.getUserId());
            merchant.setMerchantName(application.getShopName());
            merchant.setContactName(application.getContactName());
            merchant.setContactPhone(application.getContactPhone());
            merchant.setShopAddress(application.getShopAddress());
            merchant.setStatus(1);
            merchant.setCreateTime(LocalDateTime.now());
            merchantMapper.insert(merchant);

            // 创建商家资质
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

            // 查询商家名称
            Merchant merchant = merchantMapper.selectById(product.getMerchantId());
            if (merchant != null) {
                vo.setMerchantName(merchant.getMerchantName());
            }

            // 查询最低价格
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
            wrapper.like(Merchant::getMerchantName, keyword);
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

            // 统计商品数量
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

        // 资质信息
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

        // 统计信息
        LambdaQueryWrapper<Product> productWrapper = new LambdaQueryWrapper<>();
        productWrapper.eq(Product::getMerchantId, merchantId);
        long productCount = productMapper.selectCount(productWrapper);

        Map<String, Object> stats = new HashMap<>();
        stats.put("productCount", productCount);
        detail.put("stats", stats);

        return detail;
    }

    // ==================== 7. 强制修改商家状态 ====================

    public Map<String, Object> updateMerchantStatus(Long merchantId, Integer status, String reason) {
        Merchant merchant = merchantMapper.selectById(merchantId);
        if (merchant == null) {
            throw new RuntimeException("商家不存在");
        }

        merchant.setStatus(status);
        merchantMapper.updateById(merchant);

        Map<String, Object> result = new HashMap<>();
        result.put("merchantId", merchantId);
        result.put("status", status);
        result.put("statusText", merchantStatusText(status));
        result.put("reason", reason);
        result.put("message", "商家状态已更新");
        return result;
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
