package com.socialretail.backend.controller;

import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.vo.UserInfoVO;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/test")
public class TestController {

    @GetMapping("/user-info")
    public Result<UserInfoVO> getUserInfo(
            @RequestHeader(value = "X-User-Id", required = false) Long userId
    ) {
        UserInfoVO userInfo = new UserInfoVO(
                userId == null ? 1L : userId,
                "test user",
                "13800138000",
                "normal member"
        );

        return Result.success("query success", userInfo);
    }
}
