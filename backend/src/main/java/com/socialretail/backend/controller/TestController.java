package com.socialretail.backend.controller;

import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.vo.UserInfoVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.sql.DataSource;
import java.sql.Connection;

@RestController
@RequestMapping("/api/test")
public class TestController {
    @RestController
    @RequestMapping("/api/test")
    public class DbTestController {

        @Autowired
        private DataSource dataSource;

        @GetMapping("/db")
        public String testDb() {
            try (Connection conn = dataSource.getConnection()) {
                return "数据库连接成功: " + conn.getMetaData().getURL();
            } catch (Exception e) {
                return "数据库连接失败: " + e.getMessage();
            }
        }
    }
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
