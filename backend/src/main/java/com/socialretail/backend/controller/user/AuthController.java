package com.socialretail.backend.controller.user;

import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.dto.request.user.UserLoginRequest;
import com.socialretail.backend.dto.request.user.UserRegisterRequest;
import com.socialretail.backend.service.user.UserService;
import com.socialretail.backend.vo.UserLoginVO;
import com.socialretail.backend.vo.UserRegisterVO;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final UserService userService;

    public AuthController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/register")
    public Result<UserRegisterVO> register(@Valid @RequestBody UserRegisterRequest request) {
        return Result.success("注册成功", userService.register(request));
    }

    @PostMapping("/login")
    public Result<UserLoginVO> login(@Valid @RequestBody UserLoginRequest request) {
        return Result.success(userService.login(request));
    }
}
