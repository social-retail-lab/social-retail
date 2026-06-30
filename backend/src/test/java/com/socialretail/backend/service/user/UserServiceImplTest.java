package com.socialretail.backend.service.user;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.socialretail.backend.dto.request.user.UserLoginRequest;
import com.socialretail.backend.dto.request.user.UserPasswordUpdateRequest;
import com.socialretail.backend.dto.request.user.UserPhoneUpdateRequest;
import com.socialretail.backend.dto.request.user.UserRegisterRequest;
import com.socialretail.backend.dto.request.user.UserUpdateRequest;
import com.socialretail.backend.entity.user.User;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.mapper.user.UserMapper;
import com.socialretail.backend.service.user.impl.UserServiceImpl;
import com.socialretail.backend.utils.JwtUtil;
import com.socialretail.backend.vo.UserLoginVO;
import com.socialretail.backend.vo.UserPhoneVO;
import com.socialretail.backend.vo.UserRegisterVO;
import com.socialretail.backend.vo.UserUpdateVO;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class UserServiceImplTest {

    private static final String JWT_SECRET = "unit-test-secret-must-have-at-least-32-bytes";

    @Mock
    private UserMapper userMapper;

    private PasswordEncoder passwordEncoder;
    private JwtUtil jwtUtil;
    private UserServiceImpl userService;

    @BeforeEach
    void setUp() {
        passwordEncoder = new BCryptPasswordEncoder();
        jwtUtil = new JwtUtil(JWT_SECRET, 604_800_000, new ObjectMapper());
        userService = new UserServiceImpl(userMapper, passwordEncoder, jwtUtil);
    }

    @Test
    void registerHashesPasswordAndMasksPhone() {
        when(userMapper.selectOne(any())).thenReturn(null);
        when(userMapper.insert(any(User.class))).thenAnswer(invocation -> {
            User user = invocation.getArgument(0);
            user.setId(10001L);
            return 1;
        });

        UserRegisterRequest request = new UserRegisterRequest();
        request.setPhone("13800138000");
        request.setCode("123456");
        request.setPassword("secret123");

        UserRegisterVO result = userService.register(request);

        ArgumentCaptor<User> userCaptor = ArgumentCaptor.forClass(User.class);
        verify(userMapper).insert(userCaptor.capture());
        User savedUser = userCaptor.getValue();
        assertNotEquals("secret123", savedUser.getPassword());
        assertTrue(passwordEncoder.matches("secret123", savedUser.getPassword()));
        assertEquals(1, savedUser.getStatus());
        assertTrue(savedUser.getNickname().matches("^用户[A-Za-z0-9]{8}$"));
        assertEquals("138****8000", result.getPhone());
        assertEquals(savedUser.getNickname(), result.getNickname());
        assertEquals("NORMAL", result.getStatus());
    }

    @Test
    void passwordLoginReturnsJwtContainingUserId() {
        User user = normalUser();
        user.setPassword(passwordEncoder.encode("secret123"));
        when(userMapper.selectOne(any())).thenReturn(user);

        UserLoginRequest request = new UserLoginRequest();
        request.setPhone(user.getPhone());
        request.setPassword("secret123");
        request.setLoginType("PASSWORD");

        UserLoginVO result = userService.login(request);

        assertEquals(user.getId(), jwtUtil.getUserId(result.getToken()));
        assertEquals(604800L, result.getExpireSeconds());
        assertEquals("138****8000", result.getUserInfo().getPhone());
    }

    @Test
    void updateChangesOnlyEditableProfileFields() {
        User user = normalUser();
        when(userMapper.selectById(10001L)).thenReturn(user);
        when(userMapper.updateById(any(User.class))).thenReturn(1);

        UserUpdateRequest request = new UserUpdateRequest();
        request.setNickname("新昵称");
        request.setAvatar("https://example.com/new-avatar.jpg");

        UserUpdateVO result = userService.updateCurrentUser(10001L, request);

        verify(userMapper).updateById(user);
        assertEquals("新昵称", result.getNickname());
        assertEquals("https://example.com/new-avatar.jpg", result.getAvatar());
        assertEquals("13800138000", user.getPhone());
    }

    @Test
    void updatePhoneChecksAvailabilityAndReturnsMaskedPhone() {
        User user = normalUser();
        when(userMapper.selectById(10001L)).thenReturn(user);
        when(userMapper.selectOne(any())).thenReturn(null);
        when(userMapper.updateById(user)).thenReturn(1);

        UserPhoneUpdateRequest request = new UserPhoneUpdateRequest();
        request.setNewPhone("13900139000");
        request.setCode("123456");

        UserPhoneVO result = userService.updatePhone(10001L, request);

        verify(userMapper).updateById(user);
        assertEquals("13900139000", user.getPhone());
        assertEquals("139****9000", result.getPhone());
    }

    @Test
    void updatePasswordVerifiesOldPasswordAndHashesNewPassword() {
        User user = normalUser();
        user.setPassword(passwordEncoder.encode("oldPassword"));
        when(userMapper.selectById(10001L)).thenReturn(user);
        when(userMapper.updateById(user)).thenReturn(1);

        UserPasswordUpdateRequest request = new UserPasswordUpdateRequest();
        request.setOldPassword("oldPassword");
        request.setNewPassword("newPassword");

        userService.updatePassword(10001L, request);

        verify(userMapper).updateById(user);
        assertTrue(passwordEncoder.matches("newPassword", user.getPassword()));
        assertNotEquals("newPassword", user.getPassword());
    }

    @Test
    void updatePasswordReturns40005WhenOldPasswordIsWrong() {
        User user = normalUser();
        user.setPassword(passwordEncoder.encode("oldPassword"));
        when(userMapper.selectById(10001L)).thenReturn(user);

        UserPasswordUpdateRequest request = new UserPasswordUpdateRequest();
        request.setOldPassword("wrongPassword");
        request.setNewPassword("newPassword");

        BusinessException exception = assertThrows(
                BusinessException.class,
                () -> userService.updatePassword(10001L, request)
        );

        assertEquals(40005, exception.getCode());
        assertEquals("原密码错误", exception.getMessage());
    }

    private User normalUser() {
        User user = new User();
        user.setId(10001L);
        user.setPhone("13800138000");
        user.setNickname("张三");
        user.setAvatar("https://example.com/avatar.jpg");
        user.setStatus(1);
        return user;
    }
}
