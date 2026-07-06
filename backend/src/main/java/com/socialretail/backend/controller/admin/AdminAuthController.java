package com.socialretail.backend.controller.admin;

import com.socialretail.backend.common.Result;
import com.socialretail.backend.service.admin.AdminService;
import com.socialretail.backend.vo.AdminLoginRequest;
import com.socialretail.backend.vo.AdminInfoVO;
import com.socialretail.backend.vo.LoginVO;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/admin/operation")
public class AdminAuthController {

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(AdminAuthController.class);

    @Resource
    private AdminService adminService;

    @PostMapping("/auth/login")
    public Result<LoginVO> adminLogin(@RequestBody AdminLoginRequest req) {
        log.info("[管理员登录] 请求体: username={}", req.getUsername());
        try {
            LoginVO vo = adminService.adminLogin(req.getUsername(), req.getPassword());
            log.info("[管理员登录] 成功, username={}, adminId={}", req.getUsername(),
                    vo.getAdminInfo() != null ? vo.getAdminInfo().getAdminId() : null);
            return Result.ok(vo);
        } catch (RuntimeException e) {
            log.warn("[管理员登录] 失败, username={}, 原因: {}", req.getUsername(), e.getMessage());
            throw e;
        }
    }

    @PostMapping("/auth/logout")
    public Result<Void> logout() {
        log.info("[管理员退出] 退出登录");
        return Result.ok("已退出登录", null);
    }

    @GetMapping("/info")
    public Result<AdminInfoVO> getCurrentAdmin(HttpServletRequest request) {
        Long adminId = (Long) request.getAttribute("adminId");
        log.info("[获取管理员信息] adminId={}", adminId);
        try {
            AdminInfoVO vo = adminService.getCurrentAdmin(adminId);
            log.info("[获取管理员信息] 成功, adminId={}, username={}", adminId, vo.getUsername());
            return Result.ok(vo);
        } catch (RuntimeException e) {
            log.warn("[获取管理员信息] 失败, adminId={}, 原因: {}", adminId, e.getMessage());
            throw e;
        }
    }
}

