package com.socialretail.backend.service.admin;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.socialretail.backend.common.JwtUtils;
import com.socialretail.backend.common.MD5Utils;
import com.socialretail.backend.entity.member.OperationAdmin;
import com.socialretail.backend.mapper.member.OperationAdminMapper;
import com.socialretail.backend.vo.AdminInfoVO;
import com.socialretail.backend.vo.LoginVO;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Service
public class AdminService {

    @Resource
    private OperationAdminMapper operationAdminMapper;

    @Resource
    private JwtUtils jwtUtils;

    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    // ==================== 1. 运营后台登录 ====================

    public LoginVO adminLogin(String username, String password) {
        LambdaQueryWrapper<OperationAdmin> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(OperationAdmin::getUsername, username);
        OperationAdmin admin = operationAdminMapper.selectOne(wrapper);

        if (admin == null) {
            throw new RuntimeException("账号不存在");
        }
        if (!MD5Utils.verify(password, admin.getPassword())) {
            throw new RuntimeException("密码错误");
        }
        if (admin.getStatus() == null || admin.getStatus() != 1) {
            throw new RuntimeException("账号已被禁用");
        }

        // 更新最后登录时间
        admin.setLastLoginTime(LocalDateTime.now());
        operationAdminMapper.updateById(admin);

        // 生成JWT
        String token = jwtUtils.generateAdminToken(admin.getId(), username, admin.getRole());
        long expireTime = jwtUtils.getExpireTime();

        // 构建管理员信息
        AdminInfoVO adminInfo = new AdminInfoVO();
        adminInfo.setAdminId(admin.getId());
        adminInfo.setUsername(admin.getUsername());
        adminInfo.setRealName(admin.getRealName());
        adminInfo.setPhone(admin.getPhone());
        adminInfo.setEmail(admin.getEmail());
        adminInfo.setRole(admin.getRole());
        adminInfo.setStatus(admin.getStatus());
        adminInfo.setLastLoginTime(admin.getLastLoginTime() != null
                ? admin.getLastLoginTime().format(FMT) : null);

        LoginVO loginVO = new LoginVO();
        loginVO.setToken(token);
        loginVO.setExpireTime(expireTime);
        loginVO.setAdminInfo(adminInfo);
        return loginVO;
    }

    // ==================== 2. 获取当前管理员信息 ====================

    public AdminInfoVO getCurrentAdmin(Long adminId) {
        OperationAdmin admin = operationAdminMapper.selectById(adminId);
        if (admin == null) {
            throw new RuntimeException("管理员不存在");
        }

        AdminInfoVO adminInfo = new AdminInfoVO();
        adminInfo.setAdminId(admin.getId());
        adminInfo.setUsername(admin.getUsername());
        adminInfo.setRealName(admin.getRealName());
        adminInfo.setPhone(admin.getPhone());
        adminInfo.setEmail(admin.getEmail());
        adminInfo.setRole(admin.getRole());
        adminInfo.setStatus(admin.getStatus());
        adminInfo.setLastLoginTime(admin.getLastLoginTime() != null
                ? admin.getLastLoginTime().format(FMT) : null);
        return adminInfo;
    }
}
