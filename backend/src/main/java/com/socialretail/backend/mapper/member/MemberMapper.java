package com.socialretail.backend.mapper.member;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.socialretail.backend.entity.member.Member;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface MemberMapper extends BaseMapper<Member> {
    @Select("SELECT * FROM member WHERE user_id = #{userId} LIMIT 1 FOR UPDATE")
    Member selectByUserIdForUpdate(@Param("userId") Long userId);
}
