package com.socialretail.backend.mapper.member;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.socialretail.backend.entity.user.User;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MemberUserMapper extends BaseMapper<User> {
}
