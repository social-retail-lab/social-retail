package com.socialretail.backend.mapper.address;

import com.socialretail.backend.entity.address.Address;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface AddressMapper {

    Address selectByIdAndUserId(@Param("id") Long id, @Param("userId") Long userId);

    List<Address> selectListByUserId(@Param("userId") Long userId);

    Address selectDefaultByUserId(@Param("userId") Long userId);

    int insert(Address address);

    int updateByIdAndUserId(Address address);

    int deleteByIdAndUserId(@Param("id") Long id, @Param("userId") Long userId);

    int clearDefaultByUserId(@Param("userId") Long userId);

    int setDefault(@Param("id") Long id, @Param("userId") Long userId);

    int countByUserId(@Param("userId") Long userId);

    Address selectLatestByUserId(@Param("userId") Long userId);
}
