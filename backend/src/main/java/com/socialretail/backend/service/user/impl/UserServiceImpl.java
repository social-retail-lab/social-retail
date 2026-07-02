package com.socialretail.backend.service.user.impl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.dto.request.user.UserLoginRequest;
import com.socialretail.backend.dto.request.user.UserPasswordUpdateRequest;
import com.socialretail.backend.dto.request.user.UserPhoneUpdateRequest;
import com.socialretail.backend.dto.request.user.UserRegisterRequest;
import com.socialretail.backend.dto.request.user.UserUpdateRequest;
import com.socialretail.backend.entity.user.User;
import com.socialretail.backend.enums.UserStatusEnum;
import com.socialretail.backend.mapper.user.UserMapper;
import com.socialretail.backend.service.user.UserService;
import com.socialretail.backend.common.JwtUtils;
import com.socialretail.backend.utils.PhoneUtil;
import com.socialretail.backend.vo.UserInfoVO;
import com.socialretail.backend.vo.UserLoginVO;
import com.socialretail.backend.vo.UserPhoneVO;
import com.socialretail.backend.vo.UserRegisterVO;
import com.socialretail.backend.vo.UserUpdateVO;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.security.SecureRandom;
import java.util.Locale;

@Service
public class UserServiceImpl implements UserService {

    private static final int NORMAL_STATUS = 1;
    private static final int RANDOM_NICKNAME_LENGTH = 8;
    private static final char[] NICKNAME_CHARACTERS =
            "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789".toCharArray();
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    private final UserMapper userMapper;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtils jwtUtils;

    public UserServiceImpl(UserMapper userMapper,
                           PasswordEncoder passwordEncoder,
                           JwtUtils jwtUtils) {
        this.userMapper = userMapper;
        this.passwordEncoder = passwordEncoder;
        this.jwtUtils = jwtUtils;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public UserRegisterVO register(UserRegisterRequest request) {
        if (findByPhone(request.getPhone()) != null) {
            throw new BusinessException(40905, HttpStatus.CONFLICT, "手机号已注册");
        }

        User user = new User();
        user.setPhone(request.getPhone());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setNickname(generateRandomNickname());
        user.setStatus(NORMAL_STATUS);

        if (userMapper.insert(user) != 1 || user.getId() == null) {
            throw new IllegalStateException("用户注册写入失败");
        }

        return new UserRegisterVO(
                user.getId(),
                PhoneUtil.mask(user.getPhone()),
                user.getNickname(),
                UserStatusEnum.NORMAL.name()
        );
    }

    @Override
    public UserLoginVO login(UserLoginRequest request) {
        User user = findByPhone(request.getPhone());
        if (user == null) {
            throw authenticationFailed();
        }
        if (!isNormal(user)) {
            throw new BusinessException(40301, HttpStatus.FORBIDDEN, "账号已禁用");
        }

        String loginType = request.getLoginType().trim().toUpperCase(Locale.ROOT);
        switch (loginType) {
            case "CODE" -> validateCodeLogin(request);
            case "PASSWORD" -> validatePasswordLogin(request, user);
            default -> throw new BusinessException(40001, HttpStatus.BAD_REQUEST, "loginType仅支持CODE或PASSWORD");
        }

        String token = jwtUtils.generateToken(user.getId(), user.getPhone(), "user");
        return new UserLoginVO(token, jwtUtils.getExpireTime() / 1000, toUserInfo(user));
    }

    @Override
    public UserInfoVO getCurrentUser(Long userId) {
        return toUserInfo(getRequiredUser(userId));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public UserUpdateVO updateCurrentUser(Long userId, UserUpdateRequest request) {
        if (request.getNickname() == null && request.getAvatar() == null) {
            throw new BusinessException(40001, HttpStatus.BAD_REQUEST, "nickname和avatar不能同时为空");
        }
        if (request.getNickname() != null && !StringUtils.hasText(request.getNickname())) {
            throw new BusinessException(40001, HttpStatus.BAD_REQUEST, "昵称不能为空白字符");
        }

        User user = getRequiredUser(userId);
        if (request.getNickname() != null) {
            user.setNickname(request.getNickname().trim());
        }
        if (request.getAvatar() != null) {
            user.setAvatar(request.getAvatar().trim());
        }
        if (userMapper.updateById(user) != 1) {
            throw new IllegalStateException("用户资料更新失败");
        }
        return new UserUpdateVO(user.getId(), user.getNickname(), user.getAvatar());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public UserPhoneVO updatePhone(Long userId, UserPhoneUpdateRequest request) {
        User user = getRequiredUser(userId);
        User phoneOwner = findByPhone(request.getNewPhone());
        if (phoneOwner != null && !phoneOwner.getId().equals(userId)) {
            throw new BusinessException(40905, HttpStatus.CONFLICT, "手机号已注册");
        }

        // 当前阶段模拟短信验证码校验通过，DTO 已保证验证码为6位数字。
        if (!StringUtils.hasText(request.getCode()) || !request.getCode().matches("^\\d{6}$")) {
            throw new BusinessException(40001, HttpStatus.BAD_REQUEST, "验证码格式错误");
        }

        if (!request.getNewPhone().equals(user.getPhone())) {
            user.setPhone(request.getNewPhone());
            if (userMapper.updateById(user) != 1) {
                throw new IllegalStateException("手机号修改失败");
            }
        }
        return new UserPhoneVO(PhoneUtil.mask(user.getPhone()));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updatePassword(Long userId, UserPasswordUpdateRequest request) {
        User user = getRequiredUser(userId);
        if (!StringUtils.hasText(user.getPassword())
                || !passwordEncoder.matches(request.getOldPassword(), user.getPassword())) {
            throw new BusinessException(40005, HttpStatus.BAD_REQUEST, "原密码错误");
        }

        user.setPassword(passwordEncoder.encode(request.getNewPassword()));
        if (userMapper.updateById(user) != 1) {
            throw new IllegalStateException("密码修改失败");
        }
    }

    private User findByPhone(String phone) {
        return userMapper.selectOne(
                Wrappers.<User>lambdaQuery()
                        .eq(User::getPhone, phone)
                        .last("LIMIT 1")
        );
    }

    private String generateRandomNickname() {
        StringBuilder nickname = new StringBuilder("用户");
        for (int index = 0; index < RANDOM_NICKNAME_LENGTH; index++) {
            nickname.append(NICKNAME_CHARACTERS[
                    SECURE_RANDOM.nextInt(NICKNAME_CHARACTERS.length)
            ]);
        }
        return nickname.toString();
    }

    private User getRequiredUser(Long userId) {
        if (userId == null) {
            throw new BusinessException(40101, HttpStatus.UNAUTHORIZED, "未登录");
        }
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException(40401, HttpStatus.NOT_FOUND, "用户不存在");
        }
        return user;
    }

    private void validateCodeLogin(UserLoginRequest request) {
        // 当前阶段按需求模拟验证码校验通过，但仍要求请求携带合法的6位验证码。
        if (!StringUtils.hasText(request.getCode()) || !request.getCode().matches("^\\d{6}$")) {
            throw new BusinessException(40102, HttpStatus.UNAUTHORIZED, "验证码错误或已过期");
        }
    }

    private void validatePasswordLogin(UserLoginRequest request, User user) {
        if (!StringUtils.hasText(request.getPassword())
                || !StringUtils.hasText(user.getPassword())
                || !passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw authenticationFailed();
        }
    }

    private BusinessException authenticationFailed() {
        return new BusinessException(40102, HttpStatus.UNAUTHORIZED, "手机号或登录凭证错误");
    }

    private boolean isNormal(User user) {
        return user.getStatus() == null || user.getStatus() == NORMAL_STATUS;
    }

    private UserInfoVO toUserInfo(User user) {
        return new UserInfoVO(
                user.getId(),
                PhoneUtil.mask(user.getPhone()),
                user.getNickname(),
                user.getAvatar(),
                UserStatusEnum.nameOf(user.getStatus()),
                null,
                null
        );
    }
}
