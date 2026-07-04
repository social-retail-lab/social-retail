package com.socialretail.backend.service.user;

import com.socialretail.backend.dto.request.user.UserLoginRequest;
import com.socialretail.backend.dto.request.user.UserPasswordUpdateRequest;
import com.socialretail.backend.dto.request.user.UserPhoneUpdateRequest;
import com.socialretail.backend.dto.request.user.UserRegisterRequest;
import com.socialretail.backend.dto.request.user.UserUpdateRequest;
import com.socialretail.backend.vo.UserInfoVO;
import com.socialretail.backend.vo.UserLoginVO;
import com.socialretail.backend.vo.UserPhoneVO;
import com.socialretail.backend.vo.UserRegisterVO;
import com.socialretail.backend.vo.UserUpdateVO;

public interface UserService {

    UserRegisterVO register(UserRegisterRequest request);

    UserLoginVO login(UserLoginRequest request);

    UserInfoVO getCurrentUser(Long userId);

    UserUpdateVO updateCurrentUser(Long userId, UserUpdateRequest request);

    UserPhoneVO updatePhone(Long userId, UserPhoneUpdateRequest request);

    void updatePassword(Long userId, UserPasswordUpdateRequest request);
}
