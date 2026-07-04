package com.socialretail.backend.service.admin;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.socialretail.backend.common.JwtUtils;
import com.socialretail.backend.common.MD5Utils;
import com.socialretail.backend.entity.member.OperationAdmin;
import com.socialretail.backend.entity.member.SystemAdmin;
import com.socialretail.backend.mapper.member.OperationAdminMapper;
import com.socialretail.backend.mapper.member.SystemAdminMapper;
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
    private SystemAdminMapper systemAdminMapper;

    @Resource
    private JwtUtils jwtUtils;

    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    // ==================== 1. 统一管理员登录 ====================

    public LoginVO adminLogin(String username, String password) {
        // 先查运营管理员
        OperationAdmin opAdmin = findOperationAdmin(username);
        if (opAdmin != null) {
            if (!MD5Utils.verify(password, opAdmin.getPassword())) {
                throw new RuntimeException("密码错误");
            }
            if (opAdmin.getStatus() == null || opAdmin.getStatus() != 1) {
                throw new RuntimeException("账号已被禁用");
            }
            opAdmin.setLastLoginTime(LocalDateTime.now());
            operationAdminMapper.updateById(opAdmin);

            String token = jwtUtils.generateAdminToken(opAdmin.getId(), username, opAdmin.getRole());
            AdminInfoVO adminInfo = buildOpAdminInfo(opAdmin);
            adminInfo.setAdminType("operation");

            LoginVO loginVO = new LoginVO();
            loginVO.setToken(token);
            loginVO.setExpireTime(jwtUtils.getExpireTime());
            loginVO.setAdminInfo(adminInfo);
            return loginVO;
        }

        // 再查系统管理员
        SystemAdmin sysAdmin = findSystemAdmin(username);
        if (sysAdmin != null) {
            if (!MD5Utils.verify(password, sysAdmin.getPassword())) {
                throw new RuntimeException("密码错误");
            }
            if (sysAdmin.getStatus() == null || sysAdmin.getStatus() != 1) {
                throw new RuntimeException("账号已被禁用");
            }
            sysAdmin.setLastLoginTime(LocalDateTime.now());
            systemAdminMapper.updateById(sysAdmin);

            String token = jwtUtils.generateAdminToken(sysAdmin.getId(), username, sysAdmin.getRole());
            AdminInfoVO adminInfo = buildSysAdminInfo(sysAdmin);
            adminInfo.setAdminType("system");

            LoginVO loginVO = new LoginVO();
            loginVO.setToken(token);
            loginVO.setExpireTime(jwtUtils.getExpireTime());
            loginVO.setAdminInfo(adminInfo);
            return loginVO;
        }

        throw new RuntimeException("账号不存在");
    }

    private OperationAdmin findOperationAdmin(String username) {
        LambdaQueryWrapper<OperationAdmin> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(OperationAdmin::getUsername, username);
        return operationAdminMapper.selectOne(wrapper);
    }

    private SystemAdmin findSystemAdmin(String username) {
        LambdaQueryWrapper<SystemAdmin> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SystemAdmin::getUsername, username);
        return systemAdminMapper.selectOne(wrapper);
    }

    private AdminInfoVO buildOpAdminInfo(OperationAdmin admin) {
        AdminInfoVO vo = new AdminInfoVO();
        vo.setAdminId(admin.getId());
        vo.setUsername(admin.getUsername());
        vo.setRealName(admin.getRealName());
        vo.setPhone(admin.getPhone());
        vo.setEmail(admin.getEmail());
        vo.setRole(admin.getRole());
        vo.setStatus(admin.getStatus());
        vo.setLastLoginTime(admin.getLastLoginTime() != null ? admin.getLastLoginTime().format(FMT) : null);
        return vo;
    }

    private AdminInfoVO buildSysAdminInfo(SystemAdmin admin) {
        AdminInfoVO vo = new AdminInfoVO();
        vo.setAdminId(admin.getId());
        vo.setUsername(admin.getUsername());
        vo.setRealName(admin.getRealName());
        vo.setPhone(admin.getPhone());
        vo.setEmail(admin.getEmail());
        vo.setRole(admin.getRole());
        vo.setStatus(admin.getStatus());
        vo.setLastLoginTime(admin.getLastLoginTime() != null ? admin.getLastLoginTime().format(FMT) : null);
        return vo;
    }

    // ==================== 2. 获取当前管理员信息 ====================

    public AdminInfoVO getCurrentAdmin(Long adminId) {
        // 从 JWT 中 userType 无法直接获取，优先尝试运营，再尝试系统
        OperationAdmin opAdmin = operationAdminMapper.selectById(adminId);
        if (opAdmin != null) {
            AdminInfoVO vo = buildOpAdminInfo(opAdmin);
            vo.setAdminType("operation");
            return vo;
        }

        SystemAdmin sysAdmin = systemAdminMapper.selectById(adminId);
        if (sysAdmin != null) {
            AdminInfoVO vo = buildSysAdminInfo(sysAdmin);
            vo.setAdminType("system");
            return vo;
        }

        throw new RuntimeException("管理员不存在");
    }
}
