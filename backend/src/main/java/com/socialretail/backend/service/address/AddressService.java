package com.socialretail.backend.service.address;

import com.socialretail.backend.dto.request.address.AddressAddDTO;
import com.socialretail.backend.dto.request.address.AddressUpdateDTO;
import com.socialretail.backend.vo.AddressDefaultVO;
import com.socialretail.backend.vo.AddressVO;

import java.util.List;

public interface AddressService {

    AddressVO add(Long userId, AddressAddDTO dto);

    List<AddressVO> list(Long userId);

    AddressVO update(Long userId, Long addressId, AddressUpdateDTO dto);

    void delete(Long userId, Long addressId);

    AddressDefaultVO setDefault(Long userId, Long addressId);

    AddressVO getDefault(Long userId);
}
