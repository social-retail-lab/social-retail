package com.socialretail.backend.service.merchant.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.socialretail.backend.common.JwtUtils;
import com.socialretail.backend.common.MD5Utils;
import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.entity.member.Merchant;
import com.socialretail.backend.entity.member.MerchantApply;
import com.socialretail.backend.entity.member.MerchantInfoChange;
import com.socialretail.backend.entity.member.MerchantQualification;
import com.socialretail.backend.entity.user.User;
import com.socialretail.backend.entity.product.Product;
import com.socialretail.backend.mapper.member.MerchantApplyMapper;
import com.socialretail.backend.mapper.member.MerchantInfoChangeMapper;
import com.socialretail.backend.mapper.member.MerchantMapper;
import com.socialretail.backend.mapper.member.MerchantQualificationMapper;
import com.socialretail.backend.mapper.member.MemberUserMapper;
import com.socialretail.backend.mapper.product.ProductMapper;
import com.socialretail.backend.service.merchant.MerchantService;
import com.socialretail.backend.vo.AuditRequestVO;
import com.socialretail.backend.vo.InfoChangeRequest;
import com.socialretail.backend.vo.LoginVO;
import com.socialretail.backend.vo.MerchantApplyRequest;
import com.socialretail.backend.vo.MerchantApplyVO;
import com.socialretail.backend.vo.MerchantInfoVO;
import com.socialretail.backend.vo.MerchantUpdateRequest;
import com.socialretail.backend.vo.QualificationRequest;
import com.socialretail.backend.vo.QualificationVO;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class MerchantServiceImpl implements MerchantService {

    @Resource
    private MemberUserMapper memberUserMapper;

    @Resource
    private MerchantMapper merchantMapper;

    @Resource
    private MerchantApplyMapper merchantApplyMapper;

    @Resource
    private MerchantQualificationMapper merchantQualificationMapper;

    @Resource
    private JwtUtils jwtUtils;

    @Resource
    private MerchantInfoChangeMapper merchantInfoChangeMapper;

    @Resource
    private ProductMapper productMapper;

    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper().registerModule(new JavaTimeModule());

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Override
    public MerchantApplyVO submitApplication(Long userId, MerchantApplyRequest req) {
        // 检查是否已有待审核的申请
        LambdaQueryWrapper<MerchantApply> applyWrapper = new LambdaQueryWrapper<>();
        applyWrapper.eq(MerchantApply::getUserId, userId)
                .eq(MerchantApply::getAuditStatus, 0);
        MerchantApply existingApply = merchantApplyMapper.selectOne(applyWrapper);
        if (existingApply != null) {
            throw new RuntimeException("您已有待审核的入驻申请");
        }

        // 检查是否已是平台商家
        LambdaQueryWrapper<Merchant> merchantWrapper = new LambdaQueryWrapper<>();
        merchantWrapper.eq(Merchant::getUserId, userId)
                .eq(Merchant::getStatus, 1);
        Merchant existingMerchant = merchantMapper.selectOne(merchantWrapper);
        if (existingMerchant != null) {
            throw new RuntimeException("您已是平台商家");
        }

        // 入驻类型校验：企业必须提供营业执照
        Integer applyType = req.getApplyType() != null ? req.getApplyType() : 1;
        if (applyType == 2) {
            if (req.getLicenseNumber() == null || req.getLicenseNumber().isEmpty()
                    || req.getLicenseImage() == null || req.getLicenseImage().isEmpty()) {
                throw new RuntimeException("企业入驻必须提供营业执照");
            }
        }

        // 创建申请记录
        MerchantApply apply = new MerchantApply();
        apply.setUserId(userId);
        apply.setApplyType(applyType);
        apply.setCompanyName(req.getCompanyName());
        apply.setIdCardFront(req.getIdCardFront());
        apply.setIdCardBack(req.getIdCardBack());
        apply.setLicenseNumber(req.getLicenseNumber());
        apply.setLicenseImage(req.getLicenseImage());
        apply.setFoodPermitNumber(req.getFoodPermitNumber());
        apply.setFoodPermitImage(req.getFoodPermitImage());
        apply.setContactName(req.getContactName());
        apply.setContactPhone(req.getContactPhone());
        apply.setShopAddress(req.getShopAddress());
        apply.setShopName(req.getShopName());
        apply.setAuditStatus(0);
        apply.setApplyTime(LocalDateTime.now());

        merchantApplyMapper.insert(apply);

        return buildMerchantApplyVO(apply);
    }

    @Override
    public MerchantApplyVO getApplicationStatus(Long userId) {
        LambdaQueryWrapper<MerchantApply> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(MerchantApply::getUserId, userId)
                .orderByDesc(MerchantApply::getApplyTime)
                .last("LIMIT 1");
        MerchantApply apply = merchantApplyMapper.selectOne(wrapper);
        if (apply == null) {
            return null;
        }
        return buildMerchantApplyVO(apply);
    }

    @Override
    public LoginVO merchantLogin(String phone, String password, String smsCode) {
        // 短信验证码校验（模拟：任意6位数字即通过）
        if (smsCode == null || !smsCode.matches("\\d{6}")) {
            throw new RuntimeException("短信验证码错误");
        }

        // 检查用户是否存在，不存在则自动注册
        LambdaQueryWrapper<User> userWrapper = new LambdaQueryWrapper<>();
        userWrapper.eq(User::getPhone, phone);
        User user = memberUserMapper.selectOne(userWrapper);

        if (user == null) {
            // 自动注册
            String randomSuffix = generateRandomString(8);
            String nickname = "用户" + randomSuffix;
            user = new User();
            user.setPhone(phone);
            user.setNickname(nickname);
            user.setPassword(MD5Utils.encrypt(password));
            user.setStatus(1);
            memberUserMapper.insert(user);
        } else {
            // 验证密码
            if (!MD5Utils.verify(password, user.getPassword())) {
                throw new RuntimeException("密码错误");
            }
        }

        // 检查是否为商家
        LambdaQueryWrapper<Merchant> merchantWrapper = new LambdaQueryWrapper<>();
        merchantWrapper.eq(Merchant::getUserId, user.getId());
        Merchant merchant = merchantMapper.selectOne(merchantWrapper);

        // 生成JWT令牌
        Long merchantId = (merchant != null && merchant.getStatus() != null && merchant.getStatus() >= 1) ? merchant.getId() : null;
        String token = jwtUtils.generateToken(user.getId(), merchantId, phone, "merchant");

        LoginVO loginVO = new LoginVO();
        loginVO.setToken(token);
        loginVO.setExpireTime(jwtUtils.getExpireTime());

        if (merchant == null) {
            loginVO.setMerchantStatus(0);
        } else if (merchant.getStatus() == null || merchant.getStatus() == 0) {
            loginVO.setMerchantStatus(1);
            loginVO.setMerchantInfo(buildMerchantInfoVO(merchant));
        } else if (merchant.getStatus() == 1) {
            loginVO.setMerchantStatus(1);
            loginVO.setMerchantInfo(buildMerchantInfoVO(merchant));
        } else {
            loginVO.setMerchantStatus(merchant.getStatus());
            loginVO.setMerchantInfo(buildMerchantInfoVO(merchant));
        }

        return loginVO;
    }

    @Override
    public MerchantInfoVO getCurrentMerchant(Long userId) {
        LambdaQueryWrapper<Merchant> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Merchant::getUserId, userId);
        Merchant merchant = merchantMapper.selectOne(wrapper);
        if (merchant == null) {
            throw new RuntimeException("商家信息不存在");
        }
        return buildMerchantInfoVO(merchant);
    }

    @Override
    public MerchantInfoVO updateMerchantInfo(Long userId, MerchantUpdateRequest req) {
        LambdaQueryWrapper<Merchant> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Merchant::getUserId, userId);
        Merchant merchant = merchantMapper.selectOne(wrapper);
        if (merchant == null) {
            throw new RuntimeException("商家信息不存在");
        }

        if (req.getMerchantName() != null) {
            merchant.setMerchantName(req.getMerchantName());
        }
        if (req.getLogo() != null) {
            merchant.setLogo(req.getLogo());
        }
        if (req.getContactName() != null) {
            merchant.setContactName(req.getContactName());
        }
        if (req.getContactPhone() != null) {
            merchant.setContactPhone(req.getContactPhone());
        }
        if (req.getShopAddress() != null) {
            merchant.setShopAddress(req.getShopAddress());
        }
        if (req.getBusinessHours() != null) {
            merchant.setBusinessHours(req.getBusinessHours());
        }
        if (req.getIntroduction() != null) {
            merchant.setIntroduction(req.getIntroduction());
        }

        merchantMapper.updateById(merchant);

        return buildMerchantInfoVO(merchant);
    }

    @Override
    public QualificationVO uploadQualification(Long userId, QualificationRequest req) {
        LambdaQueryWrapper<Merchant> merchantWrapper = new LambdaQueryWrapper<>();
        merchantWrapper.eq(Merchant::getUserId, userId);
        Merchant merchant = merchantMapper.selectOne(merchantWrapper);
        if (merchant == null) {
            throw new RuntimeException("商家信息不存在");
        }

        LambdaQueryWrapper<MerchantQualification> qualWrapper = new LambdaQueryWrapper<>();
        qualWrapper.eq(MerchantQualification::getMerchantId, merchant.getId());
        MerchantQualification qualification = merchantQualificationMapper.selectOne(qualWrapper);

        if (qualification != null) {
            qualification.setBusinessCategory(req.getBusinessCategory());
            qualification.setLicenseNumber(req.getLicenseNumber());
            qualification.setLicenseImage(req.getLicenseImage());
            qualification.setFoodPermitNumber(req.getFoodPermitNumber());
            qualification.setFoodPermitImage(req.getFoodPermitImage());
            merchantQualificationMapper.updateById(qualification);
        } else {
            qualification = new MerchantQualification();
            qualification.setMerchantId(merchant.getId());
            qualification.setBusinessCategory(req.getBusinessCategory());
            qualification.setLicenseNumber(req.getLicenseNumber());
            qualification.setLicenseImage(req.getLicenseImage());
            qualification.setFoodPermitNumber(req.getFoodPermitNumber());
            qualification.setFoodPermitImage(req.getFoodPermitImage());
            merchantQualificationMapper.insert(qualification);
        }

        return buildQualificationVO(qualification);
    }

    @Override
    public QualificationVO getQualification(Long userId) {
        LambdaQueryWrapper<Merchant> merchantWrapper = new LambdaQueryWrapper<>();
        merchantWrapper.eq(Merchant::getUserId, userId);
        Merchant merchant = merchantMapper.selectOne(merchantWrapper);
        if (merchant == null) {
            throw new RuntimeException("商家信息不存在");
        }

        LambdaQueryWrapper<MerchantQualification> qualWrapper = new LambdaQueryWrapper<>();
        qualWrapper.eq(MerchantQualification::getMerchantId, merchant.getId());
        MerchantQualification qualification = merchantQualificationMapper.selectOne(qualWrapper);
        if (qualification == null) {
            return null;
        }
        return buildQualificationVO(qualification);
    }

    @Override
    public Map<String, Object> appeal(Long userId, String reason) {
        LambdaQueryWrapper<Merchant> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Merchant::getUserId, userId);
        Merchant merchant = merchantMapper.selectOne(wrapper);
        if (merchant == null) {
            throw new RuntimeException("商家信息不存在");
        }
        if (merchant.getStatus() == null || merchant.getStatus() != 4) {
            throw new RuntimeException("当前账号未被封禁，无需申诉");
        }

        merchant.setStatus(1);
        merchantMapper.updateById(merchant);

        Map<String, Object> result = new HashMap<>();
        result.put("merchantId", merchant.getId());
        result.put("status", 1);
        result.put("statusText", "营业中");
        result.put("reason", reason);
        result.put("message", "申诉成功，账号已恢复");
        return result;
    }

    @Override
    public Map<String, Object> requestInfoChange(Long userId, InfoChangeRequest req) {
        Merchant merchant = getMerchantByUserId(userId);

        LambdaQueryWrapper<MerchantInfoChange> checkWrapper = new LambdaQueryWrapper<>();
        checkWrapper.eq(MerchantInfoChange::getMerchantId, merchant.getId())
                .eq(MerchantInfoChange::getRequestType, "INFO_CHANGE")
                .eq(MerchantInfoChange::getAuditStatus, 0);
        if (merchantInfoChangeMapper.selectOne(checkWrapper) != null) {
            throw new RuntimeException("已有待审核的信息修改申请");
        }

        try {
            Map<String, Object> oldData = new HashMap<>();
            oldData.put("merchantName", merchant.getMerchantName());
            oldData.put("contactName", merchant.getContactName());
            oldData.put("contactPhone", merchant.getContactPhone());
            oldData.put("shopAddress", merchant.getShopAddress());
            oldData.put("businessHours", merchant.getBusinessHours());
            oldData.put("introduction", merchant.getIntroduction());

            Map<String, Object> newData = new HashMap<>();
            newData.put("merchantName", req.getMerchantName());
            newData.put("contactName", req.getContactName());
            newData.put("contactPhone", req.getContactPhone());
            newData.put("shopAddress", req.getShopAddress());
            newData.put("businessHours", req.getBusinessHours());
            newData.put("introduction", req.getIntroduction());

            MerchantInfoChange change = new MerchantInfoChange();
            change.setMerchantId(merchant.getId());
            change.setRequestType("INFO_CHANGE");
            change.setOldData(OBJECT_MAPPER.writeValueAsString(oldData));
            change.setNewData(OBJECT_MAPPER.writeValueAsString(newData));
            change.setAuditStatus(0);
            change.setCreateTime(LocalDateTime.now());
            merchantInfoChangeMapper.insert(change);

            Map<String, Object> result = new HashMap<>();
            result.put("changeId", change.getId());
            result.put("requestType", "INFO_CHANGE");
            result.put("auditStatus", 0);
            result.put("message", "信息修改申请已提交，等待审核");
            return result;
        } catch (JsonProcessingException e) {
            throw new RuntimeException("数据序列化失败");
        }
    }

    @Override
    public Map<String, Object> requestQualificationUpgrade(Long userId, MerchantApplyRequest req) {
        Merchant merchant = getMerchantByUserId(userId);

        LambdaQueryWrapper<MerchantApply> applyWrapper = new LambdaQueryWrapper<>();
        applyWrapper.eq(MerchantApply::getUserId, userId)
                .eq(MerchantApply::getAuditStatus, 1)
                .orderByDesc(MerchantApply::getApplyTime)
                .last("LIMIT 1");
        MerchantApply lastApply = merchantApplyMapper.selectOne(applyWrapper);
        if (lastApply == null || (lastApply.getApplyType() != null && lastApply.getApplyType() != 1)) {
            throw new RuntimeException("仅个体商家可申请升级企业资质");
        }

        LambdaQueryWrapper<MerchantInfoChange> checkWrapper = new LambdaQueryWrapper<>();
        checkWrapper.eq(MerchantInfoChange::getMerchantId, merchant.getId())
                .eq(MerchantInfoChange::getRequestType, "QUALIFICATION_UPGRADE")
                .eq(MerchantInfoChange::getAuditStatus, 0);
        if (merchantInfoChangeMapper.selectOne(checkWrapper) != null) {
            throw new RuntimeException("已有待审核的升级企业资质申请");
        }

        if (req.getLicenseNumber() == null || req.getLicenseNumber().isEmpty()
                || req.getLicenseImage() == null || req.getLicenseImage().isEmpty()) {
            throw new RuntimeException("企业资质必须提供营业执照");
        }

        try {
            Map<String, Object> newData = new HashMap<>();
            newData.put("companyName", req.getCompanyName());
            newData.put("licenseNumber", req.getLicenseNumber());
            newData.put("licenseImage", req.getLicenseImage());
            newData.put("foodPermitNumber", req.getFoodPermitNumber());
            newData.put("foodPermitImage", req.getFoodPermitImage());
            newData.put("contactName", req.getContactName());
            newData.put("contactPhone", req.getContactPhone());
            newData.put("shopAddress", req.getShopAddress());
            newData.put("shopName", req.getShopName());

            MerchantInfoChange change = new MerchantInfoChange();
            change.setMerchantId(merchant.getId());
            change.setRequestType("QUALIFICATION_UPGRADE");
            change.setNewData(OBJECT_MAPPER.writeValueAsString(newData));
            change.setAuditStatus(0);
            change.setCreateTime(LocalDateTime.now());
            merchantInfoChangeMapper.insert(change);

            Map<String, Object> result = new HashMap<>();
            result.put("changeId", change.getId());
            result.put("requestType", "QUALIFICATION_UPGRADE");
            result.put("auditStatus", 0);
            result.put("message", "升级企业资质申请已提交，等待审核");
            return result;
        } catch (JsonProcessingException e) {
            throw new RuntimeException("数据序列化失败");
        }
    }

    @Override
    public Map<String, Object> togglePause(Long userId) {
        Merchant merchant = getMerchantByUserId(userId);

        if (merchant.getStatus() == null) {
            throw new RuntimeException("商家状态异常");
        }

        if (merchant.getStatus() == 5) {
            merchant.setStatus(1);
            merchantMapper.updateById(merchant);
            Map<String, Object> result = new HashMap<>();
            result.put("merchantId", merchant.getId());
            result.put("status", 1);
            result.put("statusText", "营业中");
            result.put("message", "已重新营业");
            return result;
        } else if (merchant.getStatus() == 1) {
            merchant.setStatus(5);
            merchantMapper.updateById(merchant);
            Map<String, Object> result = new HashMap<>();
            result.put("merchantId", merchant.getId());
            result.put("status", 5);
            result.put("statusText", "暂时歇业");
            result.put("message", "已暂时歇业");
            return result;
        } else {
            throw new RuntimeException("当前状态不支持此操作");
        }
    }

    @Override
    public PageResult<AuditRequestVO> getAuditRequests(Long userId, int pageNum, int pageSize) {
        Merchant merchant = getMerchantByUserId(userId);

        LambdaQueryWrapper<Product> productWrapper = new LambdaQueryWrapper<>();
        productWrapper.eq(Product::getMerchantId, merchant.getId())
                .isNotNull(Product::getAuditStatus)
                .orderByDesc(Product::getCreateTime);
        List<Product> products = productMapper.selectList(productWrapper);

        LambdaQueryWrapper<MerchantInfoChange> changeWrapper = new LambdaQueryWrapper<>();
        changeWrapper.eq(MerchantInfoChange::getMerchantId, merchant.getId())
                .orderByDesc(MerchantInfoChange::getCreateTime);
        List<MerchantInfoChange> changes = merchantInfoChangeMapper.selectList(changeWrapper);

        List<AuditRequestVO> allList = new ArrayList<>();

        for (Product p : products) {
            AuditRequestVO vo = new AuditRequestVO();
            vo.setRequestId(p.getId());
            vo.setRequestType("PRODUCT_PUBLISH");
            vo.setRequestTypeText("商品发布");
            vo.setProductId(p.getId());
            vo.setProductTitle(p.getTitle());
            vo.setImageUrl(p.getMainImage());
            vo.setAuditStatus(p.getAuditStatus());
            vo.setAuditStatusText(getAuditStatusText(p.getAuditStatus()));
            vo.setAuditRemark(p.getAuditRemark());
            vo.setCreateTime(p.getCreateTime() != null ? p.getCreateTime().format(FORMATTER) : null);
            vo.setAuditTime(p.getAuditTime() != null ? p.getAuditTime().format(FORMATTER) : null);
            vo.setWithdrawable(p.getAuditStatus() != null && p.getAuditStatus() == 0);
            allList.add(vo);
        }

        for (MerchantInfoChange c : changes) {
            AuditRequestVO vo = new AuditRequestVO();
            vo.setRequestId(c.getId());
            vo.setRequestType(c.getRequestType());
            vo.setRequestTypeText("INFO_CHANGE".equals(c.getRequestType()) ? "商家信息修改" : "升级企业资质");
            vo.setAuditStatus(c.getAuditStatus());
            vo.setAuditStatusText(getAuditStatusText(c.getAuditStatus()));
            vo.setAuditRemark(c.getAuditRemark());
            vo.setCreateTime(c.getCreateTime() != null ? c.getCreateTime().format(FORMATTER) : null);
            vo.setAuditTime(c.getAuditTime() != null ? c.getAuditTime().format(FORMATTER) : null);
            vo.setWithdrawable(c.getAuditStatus() != null && c.getAuditStatus() == 0);
            try {
                if (c.getOldData() != null) vo.setOldData(OBJECT_MAPPER.readValue(c.getOldData(), Map.class));
                if (c.getNewData() != null) vo.setNewData(OBJECT_MAPPER.readValue(c.getNewData(), Map.class));
            } catch (JsonProcessingException ignored) {}
            allList.add(vo);
        }

        allList.sort((a, b) -> {
            String t1 = a.getCreateTime() != null ? a.getCreateTime() : "";
            String t2 = b.getCreateTime() != null ? b.getCreateTime() : "";
            return t2.compareTo(t1);
        });

        int total = allList.size();
        int from = (pageNum - 1) * pageSize;
        int to = Math.min(from + pageSize, total);
        List<AuditRequestVO> pageList = from < total ? allList.subList(from, to) : new ArrayList<>();

        PageResult<AuditRequestVO> result = new PageResult<>();
        result.setList(pageList);
        result.setTotal((long) total);
        result.setPageNum(pageNum);
        result.setPageSize(pageSize);
        return result;
    }

    @Override
    public Map<String, Object> getAuditRequestDetail(Long requestId, String requestType) {
        if ("INFO_CHANGE".equals(requestType) || "QUALIFICATION_UPGRADE".equals(requestType)) {
            MerchantInfoChange change = merchantInfoChangeMapper.selectById(requestId);
            if (change == null) throw new RuntimeException("审核请求不存在");
            Map<String, Object> detail = new HashMap<>();
            detail.put("requestId", change.getId());
            detail.put("requestType", change.getRequestType());
            detail.put("requestTypeText", "INFO_CHANGE".equals(change.getRequestType()) ? "商家信息修改" : "升级企业资质");
            detail.put("auditStatus", change.getAuditStatus());
            detail.put("auditStatusText", getAuditStatusText(change.getAuditStatus()));
            detail.put("auditRemark", change.getAuditRemark());
            detail.put("createTime", change.getCreateTime() != null ? change.getCreateTime().format(FORMATTER) : null);
            detail.put("auditTime", change.getAuditTime() != null ? change.getAuditTime().format(FORMATTER) : null);
            try {
                if (change.getOldData() != null) detail.put("oldData", OBJECT_MAPPER.readValue(change.getOldData(), Map.class));
                if (change.getNewData() != null) detail.put("newData", OBJECT_MAPPER.readValue(change.getNewData(), Map.class));
            } catch (JsonProcessingException ignored) {}
            return detail;
        } else {
            Product product = productMapper.selectById(requestId);
            if (product == null) throw new RuntimeException("商品不存在");
            Map<String, Object> detail = new HashMap<>();
            detail.put("requestId", product.getId());
            detail.put("requestType", "PRODUCT_PUBLISH");
            detail.put("requestTypeText", "商品发布");
            detail.put("productId", product.getId());
            detail.put("productTitle", product.getTitle());
            detail.put("imageUrl", product.getMainImage());
            detail.put("auditStatus", product.getAuditStatus());
            detail.put("auditStatusText", getAuditStatusText(product.getAuditStatus()));
            detail.put("auditRemark", product.getAuditRemark());
            detail.put("createTime", product.getCreateTime() != null ? product.getCreateTime().format(FORMATTER) : null);
            detail.put("auditTime", product.getAuditTime() != null ? product.getAuditTime().format(FORMATTER) : null);
            detail.put("newData", product);
            return detail;
        }
    }

    @Override
    public Map<String, Object> withdrawAuditRequest(Long userId, Long requestId, String requestType) {
        if ("MERCHANT_APPLY".equals(requestType)) {
            // 撤回商家入驻申请
            MerchantApply apply = merchantApplyMapper.selectById(requestId);
            if (apply == null) throw new RuntimeException("入驻申请不存在");
            if (!apply.getUserId().equals(userId)) throw new RuntimeException("无权操作该申请");
            if (apply.getAuditStatus() != null && apply.getAuditStatus() != 0)
                throw new RuntimeException("只有待审核的入驻申请可以撤回");
            merchantApplyMapper.deleteById(requestId);
        } else if ("INFO_CHANGE".equals(requestType) || "QUALIFICATION_UPGRADE".equals(requestType)) {
            MerchantInfoChange change = merchantInfoChangeMapper.selectById(requestId);
            if (change == null) throw new RuntimeException("审核请求不存在");
            Merchant merchant = getMerchantByUserId(userId);
            if (!change.getMerchantId().equals(merchant.getId())) throw new RuntimeException("无权操作");
            if (change.getAuditStatus() != null && change.getAuditStatus() != 0) throw new RuntimeException("只有待审核的请求可以撤回");
            merchantInfoChangeMapper.deleteById(requestId);
        } else {
            Product product = productMapper.selectById(requestId);
            if (product == null) throw new RuntimeException("商品不存在");
            Merchant merchant = getMerchantByUserId(userId);
            if (!product.getMerchantId().equals(merchant.getId())) throw new RuntimeException("无权操作");
            if (product.getAuditStatus() == null || product.getAuditStatus() != 0) throw new RuntimeException("只有待审核的请求可以撤回");
            product.setAuditStatus(null);
            product.setAuditRemark(null);
            productMapper.updateById(product);
        }
        Map<String, Object> result = new HashMap<>();
        result.put("message", "撤回成功");
        return result;
    }

    // ==================== 辅助方法 ====================

    private Merchant getMerchantByUserId(Long userId) {
        LambdaQueryWrapper<Merchant> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Merchant::getUserId, userId);
        Merchant merchant = merchantMapper.selectOne(wrapper);
        if (merchant == null) throw new RuntimeException("商家信息不存在");
        return merchant;
    }

    private String generateRandomString(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            sb.append(chars.charAt((int) (Math.random() * chars.length())));
        }
        return sb.toString();
    }

    private MerchantInfoVO buildMerchantInfoVO(Merchant m) {
        MerchantInfoVO vo = new MerchantInfoVO();
        vo.setMerchantId(m.getId());
        vo.setMerchantName(m.getMerchantName());
        vo.setLogo(m.getLogo());
        vo.setContactName(m.getContactName());
        vo.setContactPhone(m.getContactPhone());
        vo.setShopAddress(m.getShopAddress());
        vo.setBusinessHours(m.getBusinessHours());
        vo.setIntroduction(m.getIntroduction());
        vo.setStatus(m.getStatus());
        vo.setStatusText(getStatusText(m.getStatus()));
        if (m.getCreateTime() != null) {
            vo.setCreateTime(m.getCreateTime().format(FORMATTER));
        }
        return vo;
    }

    private MerchantApplyVO buildMerchantApplyVO(MerchantApply apply) {
        MerchantApplyVO vo = new MerchantApplyVO();
        vo.setApplyId(apply.getId());
        vo.setApplyType(apply.getApplyType());
        vo.setApplyTypeText(getApplyTypeText(apply.getApplyType()));
        vo.setCompanyName(apply.getCompanyName());
        vo.setShopName(apply.getShopName());
        vo.setContactName(apply.getContactName());
        vo.setContactPhone(apply.getContactPhone());
        vo.setLicenseNumber(apply.getLicenseNumber());
        vo.setLicenseImage(apply.getLicenseImage());
        vo.setFoodPermitNumber(apply.getFoodPermitNumber());
        vo.setFoodPermitImage(apply.getFoodPermitImage());
        vo.setIdCardFront(apply.getIdCardFront());
        vo.setIdCardBack(apply.getIdCardBack());
        vo.setShopAddress(apply.getShopAddress());
        vo.setAuditStatus(apply.getAuditStatus());
        vo.setAuditStatusText(getAuditStatusText(apply.getAuditStatus()));
        vo.setAuditRemark(apply.getAuditRemark());
        if (apply.getApplyTime() != null) {
            vo.setApplyTime(apply.getApplyTime().format(FORMATTER));
        }
        if (apply.getAuditTime() != null) {
            vo.setAuditTime(apply.getAuditTime().format(FORMATTER));
        }
        return vo;
    }

    private QualificationVO buildQualificationVO(MerchantQualification q) {
        QualificationVO vo = new QualificationVO();
        vo.setQualificationId(q.getId());
        vo.setBusinessCategory(q.getBusinessCategory());
        vo.setLicenseNumber(q.getLicenseNumber());
        vo.setLicenseImage(q.getLicenseImage());
        vo.setFoodPermitNumber(q.getFoodPermitNumber());
        vo.setFoodPermitImage(q.getFoodPermitImage());
        return vo;
    }

    private String getStatusText(Integer status) {
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

    private String getAuditStatusText(Integer auditStatus) {
        if (auditStatus == null) return "未知";
        switch (auditStatus) {
            case 0: return "待审核";
            case 1: return "审核通过";
            case 2: return "审核拒绝";
            default: return "未知";
        }
    }

    private String getApplyTypeText(Integer applyType) {
        if (applyType == null) return "未知";
        switch (applyType) {
            case 1: return "个人";
            case 2: return "企业";
            default: return "未知";
        }
    }
}
