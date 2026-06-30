package com.socialretail.backend.service.address;

import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.dto.request.address.AddressAddDTO;
import com.socialretail.backend.dto.request.address.AddressUpdateDTO;
import com.socialretail.backend.entity.address.Address;
import com.socialretail.backend.mapper.address.AddressMapper;
import com.socialretail.backend.service.address.impl.AddressServiceImpl;
import com.socialretail.backend.vo.AddressDefaultVO;
import com.socialretail.backend.vo.AddressVO;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AddressServiceImplTest {

    private static final Long USER_ID = 10001L;

    @Mock
    private AddressMapper addressMapper;

    private AddressServiceImpl addressService;

    @BeforeEach
    void setUp() {
        addressService = new AddressServiceImpl(addressMapper);
    }

    @Test
    void firstAddressIsAutomaticallyDefault() {
        when(addressMapper.countByUserId(USER_ID)).thenReturn(0);
        when(addressMapper.insert(any(Address.class))).thenAnswer(invocation -> {
            Address address = invocation.getArgument(0);
            address.setId(1001L);
            return 1;
        });

        AddressVO result = addressService.add(USER_ID, addDTO(false));

        verify(addressMapper).clearDefaultByUserId(USER_ID);
        assertEquals(1001L, result.getAddressId());
        assertTrue(result.getIsDefault());
        assertEquals("138****8000", result.getReceiverPhone());
    }

    @Test
    void listMapsDatabaseFieldsToApiFields() {
        Address address = address(1001L, 1);
        when(addressMapper.selectListByUserId(USER_ID)).thenReturn(List.of(address));

        List<AddressVO> result = addressService.list(USER_ID);

        assertEquals(1, result.size());
        assertEquals("张三", result.get(0).getReceiverName());
        assertEquals("天河路100号", result.get(0).getDetailAddress());
    }

    @Test
    void updateToDefaultClearsOtherDefaults() {
        Address address = address(1001L, 0);
        when(addressMapper.selectByIdAndUserId(1001L, USER_ID)).thenReturn(address);
        when(addressMapper.updateByIdAndUserId(address)).thenReturn(1);

        AddressVO result = addressService.update(USER_ID, 1001L, updateDTO(true));

        verify(addressMapper).clearDefaultByUserId(USER_ID);
        assertTrue(result.getIsDefault());
        assertEquals("李四", result.getReceiverName());
    }

    @Test
    void deleteDefaultPromotesLatestRemainingAddress() {
        Address deleted = address(1001L, 1);
        Address latest = address(1002L, 0);
        when(addressMapper.selectByIdAndUserId(1001L, USER_ID)).thenReturn(deleted);
        when(addressMapper.deleteByIdAndUserId(1001L, USER_ID)).thenReturn(1);
        when(addressMapper.selectLatestByUserId(USER_ID)).thenReturn(latest);
        when(addressMapper.setDefault(1002L, USER_ID)).thenReturn(1);

        addressService.delete(USER_ID, 1001L);

        verify(addressMapper).setDefault(1002L, USER_ID);
    }

    @Test
    void setDefaultClearsThenSetsTargetAddress() {
        when(addressMapper.selectByIdAndUserId(1001L, USER_ID)).thenReturn(address(1001L, 0));
        when(addressMapper.setDefault(1001L, USER_ID)).thenReturn(1);

        AddressDefaultVO result = addressService.setDefault(USER_ID, 1001L);

        verify(addressMapper).clearDefaultByUserId(USER_ID);
        verify(addressMapper).setDefault(1001L, USER_ID);
        assertTrue(result.getIsDefault());
    }

    @Test
    void missingOrForeignAddressReturns40401() {
        when(addressMapper.selectByIdAndUserId(9999L, USER_ID)).thenReturn(null);

        BusinessException exception = assertThrows(
                BusinessException.class,
                () -> addressService.update(USER_ID, 9999L, updateDTO(false))
        );

        assertEquals(40401, exception.getCode());
        verify(addressMapper, never()).updateByIdAndUserId(any());
    }

    @Test
    void noDefaultAddressReturnsNull() {
        when(addressMapper.selectDefaultByUserId(USER_ID)).thenReturn(null);

        assertNull(addressService.getDefault(USER_ID));
    }

    private AddressAddDTO addDTO(boolean isDefault) {
        AddressAddDTO dto = new AddressAddDTO();
        dto.setReceiverName("张三");
        dto.setReceiverPhone("13800138000");
        dto.setProvince("广东省");
        dto.setCity("广州市");
        dto.setDistrict("天河区");
        dto.setDetailAddress("天河路100号");
        dto.setIsDefault(isDefault);
        return dto;
    }

    private AddressUpdateDTO updateDTO(boolean isDefault) {
        AddressUpdateDTO dto = new AddressUpdateDTO();
        dto.setReceiverName("李四");
        dto.setReceiverPhone("13900139000");
        dto.setProvince("广东省");
        dto.setCity("深圳市");
        dto.setDistrict("南山区");
        dto.setDetailAddress("科技园1号");
        dto.setIsDefault(isDefault);
        return dto;
    }

    private Address address(Long id, int isDefault) {
        Address address = new Address();
        address.setId(id);
        address.setUserId(USER_ID);
        address.setConsignee("张三");
        address.setPhone("13800138000");
        address.setProvince("广东省");
        address.setCity("广州市");
        address.setDistrict("天河区");
        address.setDetailedAddress("天河路100号");
        address.setIsDefault(isDefault);
        return address;
    }
}
