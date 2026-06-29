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

    @Resource
    private AdminService adminService;

    @PostMapping("/auth/login")
    public Result<LoginVO> adminLogin(@RequestBody AdminLoginRequest req) {
        LoginVO vo = adminService.adminLogin(req.getUsername(), req.getPassword());
        return Result.ok(vo);
    }

    @PostMapping("/auth/logout")
    public Result<Void> logout() {
        return Result.ok("已退出登录", null);
    }

    @GetMapping("/info")
    public Result<AdminInfoVO> getCurrentAdmin(HttpServletRequest request) {
        Long adminId = (Long) request.getAttribute("adminId");
        AdminInfoVO vo = adminService.getCurrentAdmin(adminId);
        return Result.ok(vo);
    }
}
