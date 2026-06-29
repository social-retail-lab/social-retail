package com.socialretail.backend.service.merchant;

import com.socialretail.backend.common.JwtUtils;
import com.socialretail.backend.common.MD5Utils;
import com.socialretail.backend.entity.member.Merchant;
import com.socialretail.backend.entity.member.MerchantApply;
import com.socialretail.backend.entity.member.MerchantQualification;
import com.socialretail.backend.entity.member.User;
import com.socialretail.backend.mapper.member.MerchantApplyMapper;
import com.socialretail.backend.mapper.member.MerchantMapper;
import com.socialretail.backend.mapper.member.MerchantQualificationMapper;
import com.socialretail.backend.mapper.member.UserMapper;
import com.socialretail.backend.vo.LoginVO;
import com.socialretail.backend.vo.MerchantApplyRequest;
import com.socialretail.backend.vo.MerchantApplyVO;
import com.socialretail.backend.vo.MerchantInfoVO;
import com.socialretail.backend.vo.MerchantUpdateRequest;
import com.socialretail.backend.vo.QualificationRequest;
import com.socialretail.backend.vo.QualificationVO;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Service
public class MerchantService {

    @Resource
    private UserMapper userMapper;

    @Resource
    private MerchantMapper merchantMapper;

    @Resource
    private MerchantApplyMapper merchantApplyMapper;

    @Resource
    private MerchantQualificationMapper merchantQualificationMapper;

    @Resource
    private JwtUtils jwtUtils;

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

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

    public LoginVO merchantLogin(String phone, String password, String smsCode) {
        // 短信验证码校验（模拟：任意6位数字即通过）
        if (smsCode == null || !smsCode.matches("\\d{6}")) {
            throw new RuntimeException("短信验证码错误");
        }

        // 检查用户是否存在，不存在则自动注册
        LambdaQueryWrapper<User> userWrapper = new LambdaQueryWrapper<>();
        userWrapper.eq(User::getPhone, phone);
        User user = userMapper.selectOne(userWrapper);

        if (user == null) {
            // 自动注册，生成随机用户名: 用户 + 8位随机字符
            String randomSuffix = generateRandomString(8);
            String nickname = "用户" + randomSuffix;
            user = new User();
            user.setPhone(phone);
            user.setNickname(nickname);
            user.setPassword(MD5Utils.encrypt(password));
            user.setStatus(1);
            userMapper.insert(user);
        } else {
            // 验证密码
            if (!MD5Utils.verify(password, user.getPassword())) {
                throw new RuntimeException("密码错误");
            }
        }

        // 生成JWT令牌
        String token = jwtUtils.generateToken(user.getId(), phone, "user");

        LoginVO loginVO = new LoginVO();
        loginVO.setToken(token);
        loginVO.setExpireTime(jwtUtils.getExpireTime());

        // 检查是否为商家
        LambdaQueryWrapper<Merchant> merchantWrapper = new LambdaQueryWrapper<>();
        merchantWrapper.eq(Merchant::getUserId, user.getId());
        Merchant merchant = merchantMapper.selectOne(merchantWrapper);

        if (merchant == null || merchant.getStatus() == null || merchant.getStatus() == 0) {
            // 非商家用户，跳转到入驻申请页
            loginVO.setMerchantStatus(0);
        } else if (merchant.getStatus() == 1) {
            // 正常商家
            loginVO.setMerchantStatus(1);
            loginVO.setMerchantInfo(buildMerchantInfoVO(merchant));
        } else {
            // 商家账号被禁用/关店
            loginVO.setMerchantStatus(merchant.getStatus());
            loginVO.setMerchantInfo(buildMerchantInfoVO(merchant));
        }

        return loginVO;
    }

    private String generateRandomString(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            sb.append(chars.charAt((int) (Math.random() * chars.length())));
        }
        return sb.toString();
    }

    public MerchantInfoVO getCurrentMerchant(Long userId) {
        LambdaQueryWrapper<Merchant> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Merchant::getUserId, userId);
        Merchant merchant = merchantMapper.selectOne(wrapper);
        if (merchant == null) {
            throw new RuntimeException("商家信息不存在");
        }
        return buildMerchantInfoVO(merchant);
    }

    public MerchantInfoVO updateMerchantInfo(Long userId, MerchantUpdateRequest req) {
        LambdaQueryWrapper<Merchant> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Merchant::getUserId, userId);
        Merchant merchant = merchantMapper.selectOne(wrapper);
        if (merchant == null) {
            throw new RuntimeException("商家信息不存在");
        }

        // 仅更新非空字段
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
            // 更新
            qualification.setBusinessCategory(req.getBusinessCategory());
            qualification.setLicenseNumber(req.getLicenseNumber());
            qualification.setLicenseImage(req.getLicenseImage());
            qualification.setFoodPermitNumber(req.getFoodPermitNumber());
            qualification.setFoodPermitImage(req.getFoodPermitImage());
            merchantQualificationMapper.updateById(qualification);
        } else {
            // 新增
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

    // Helper methods

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
        if (status == null) {
            return "未知";
        }
        switch (status) {
            case 1: return "营业中";
            case 2: return "休息中";
            case 3: return "已关店";
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

    private String getRejectReasonText(Integer reason) {
        if (reason == null) {
            return "未知";
        }
        switch (reason) {
            case 1: return "信息不符";
            case 2: return "证件不清晰";
            case 3: return "店铺不合规";
            default: return "其他";
        }
    }

    private String getApplyTypeText(Integer applyType) {
        if (applyType == null) {
            return "未知";
        }
        switch (applyType) {
            case 1: return "个人";
            case 2: return "企业";
            default: return "未知";
        }
    }
}
