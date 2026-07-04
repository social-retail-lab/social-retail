package com.socialretail.backend.service.address.impl;

import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.dto.request.address.AddressAddDTO;
import com.socialretail.backend.dto.request.address.AddressUpdateDTO;
import com.socialretail.backend.entity.address.Address;
import com.socialretail.backend.mapper.address.AddressMapper;
import com.socialretail.backend.service.address.AddressService;
import com.socialretail.backend.utils.PhoneUtil;
import com.socialretail.backend.vo.AddressDefaultVO;
import com.socialretail.backend.vo.AddressVO;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class AddressServiceImpl implements AddressService {

    private static final int DEFAULT = 1;
    private static final int NOT_DEFAULT = 0;

    private final AddressMapper addressMapper;

    public AddressServiceImpl(AddressMapper addressMapper) {
        this.addressMapper = addressMapper;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public AddressVO add(Long userId, AddressAddDTO dto) {
        boolean shouldBeDefault = Boolean.TRUE.equals(dto.getIsDefault())
                || addressMapper.countByUserId(userId) == 0;
        if (shouldBeDefault) {
            addressMapper.clearDefaultByUserId(userId);
        }

        Address address = new Address();
        address.setUserId(userId);
        copyAddFields(dto, address);
        address.setIsDefault(shouldBeDefault ? DEFAULT : NOT_DEFAULT);
        if (addressMapper.insert(address) != 1 || address.getId() == null) {
            throw new IllegalStateException("新增地址失败");
        }
        return toVO(address);
    }

    @Override
    public List<AddressVO> list(Long userId) {
        return addressMapper.selectListByUserId(userId).stream()
                .map(this::toVO)
                .toList();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public AddressVO update(Long userId, Long addressId, AddressUpdateDTO dto) {
        Address address = getRequiredAddress(userId, addressId);
        if (Boolean.TRUE.equals(dto.getIsDefault())) {
            addressMapper.clearDefaultByUserId(userId);
        }

        copyUpdateFields(dto, address);
        if (dto.getIsDefault() != null) {
            address.setIsDefault(dto.getIsDefault() ? DEFAULT : NOT_DEFAULT);
        }
        if (addressMapper.updateByIdAndUserId(address) != 1) {
            throw addressNotFound();
        }
        return toVO(address);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void delete(Long userId, Long addressId) {
        Address address = getRequiredAddress(userId, addressId);
        if (addressMapper.deleteByIdAndUserId(addressId, userId) != 1) {
            throw addressNotFound();
        }

        if (isDefault(address)) {
            Address latestAddress = addressMapper.selectLatestByUserId(userId);
            if (latestAddress != null && addressMapper.setDefault(latestAddress.getId(), userId) != 1) {
                throw new IllegalStateException("默认地址转移失败");
            }
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public AddressDefaultVO setDefault(Long userId, Long addressId) {
        getRequiredAddress(userId, addressId);
        addressMapper.clearDefaultByUserId(userId);
        if (addressMapper.setDefault(addressId, userId) != 1) {
            throw addressNotFound();
        }
        return new AddressDefaultVO(addressId, true);
    }

    @Override
    public AddressVO getDefault(Long userId) {
        Address address = addressMapper.selectDefaultByUserId(userId);
        return address == null ? null : toVO(address);
    }

    private Address getRequiredAddress(Long userId, Long addressId) {
        Address address = addressMapper.selectByIdAndUserId(addressId, userId);
        if (address == null) {
            throw addressNotFound();
        }
        return address;
    }

    private void copyAddFields(AddressAddDTO dto, Address address) {
        address.setConsignee(dto.getReceiverName().trim());
        address.setPhone(dto.getReceiverPhone());
        address.setProvince(dto.getProvince().trim());
        address.setCity(dto.getCity().trim());
        address.setDistrict(dto.getDistrict().trim());
        address.setDetailedAddress(dto.getDetailAddress().trim());
    }

    private void copyUpdateFields(AddressUpdateDTO dto, Address address) {
        address.setConsignee(dto.getReceiverName().trim());
        address.setPhone(dto.getReceiverPhone());
        address.setProvince(dto.getProvince().trim());
        address.setCity(dto.getCity().trim());
        address.setDistrict(dto.getDistrict().trim());
        address.setDetailedAddress(dto.getDetailAddress().trim());
    }

    private AddressVO toVO(Address address) {
        return new AddressVO(
                address.getId(),
                address.getConsignee(),
                PhoneUtil.mask(address.getPhone()),
                address.getProvince(),
                address.getCity(),
                address.getDistrict(),
                address.getDetailedAddress(),
                isDefault(address)
        );
    }

    private boolean isDefault(Address address) {
        return Integer.valueOf(DEFAULT).equals(address.getIsDefault());
    }

    private BusinessException addressNotFound() {
        return new BusinessException(40401, HttpStatus.NOT_FOUND, "地址不存在");
    }
}
