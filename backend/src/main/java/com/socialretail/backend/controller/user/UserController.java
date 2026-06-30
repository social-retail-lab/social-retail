package com.socialretail.backend.controller.user;

import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.config.JwtInterceptor;
import com.socialretail.backend.dto.request.user.UserPasswordUpdateRequest;
import com.socialretail.backend.dto.request.user.UserPhoneUpdateRequest;
import com.socialretail.backend.dto.request.user.UserUpdateRequest;
import com.socialretail.backend.service.user.UserService;
import com.socialretail.backend.vo.UserInfoVO;
import com.socialretail.backend.vo.UserPhoneVO;
import com.socialretail.backend.vo.UserUpdateVO;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/user")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/info")
    public Result<UserInfoVO> getCurrentUser(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId) {
        return Result.success(userService.getCurrentUser(userId));
    }

    @PutMapping("/info")
    public Result<UserUpdateVO> updateCurrentUser(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Valid @RequestBody UserUpdateRequest request) {
        return Result.success("修改成功", userService.updateCurrentUser(userId, request));
    }

    @PutMapping("/phone")
    public Result<UserPhoneVO> updatePhone(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Valid @RequestBody UserPhoneUpdateRequest request) {
        return Result.success("手机号修改成功", userService.updatePhone(userId, request));
    }

    @PutMapping("/password")
    public Result<Void> updatePassword(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Valid @RequestBody UserPasswordUpdateRequest request) {
        userService.updatePassword(userId, request);
        return Result.success("密码修改成功", null);
    }
}
