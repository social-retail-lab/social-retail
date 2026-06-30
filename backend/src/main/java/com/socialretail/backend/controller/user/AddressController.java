package com.socialretail.backend.controller.user;

import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.config.JwtInterceptor;
import com.socialretail.backend.dto.request.address.AddressAddDTO;
import com.socialretail.backend.dto.request.address.AddressUpdateDTO;
import com.socialretail.backend.service.address.AddressService;
import com.socialretail.backend.vo.AddressDefaultVO;
import com.socialretail.backend.vo.AddressVO;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Positive;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@Validated
@RestController
@RequestMapping("/api/addresses")
public class AddressController {

    private final AddressService addressService;

    public AddressController(AddressService addressService) {
        this.addressService = addressService;
    }

    @PostMapping
    public Result<AddressVO> add(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Valid @RequestBody AddressAddDTO dto) {
        return Result.success("新增成功", addressService.add(userId, dto));
    }

    @GetMapping
    public Result<Map<String, List<AddressVO>>> list(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId) {
        return Result.success(Map.of("list", addressService.list(userId)));
    }

    @PutMapping("/{addressId}")
    public Result<AddressVO> update(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Positive(message = "地址ID必须大于0") @PathVariable Long addressId,
            @Valid @RequestBody AddressUpdateDTO dto) {
        return Result.success("修改成功", addressService.update(userId, addressId, dto));
    }

    @DeleteMapping("/{addressId}")
    public Result<Void> delete(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Positive(message = "地址ID必须大于0") @PathVariable Long addressId) {
        addressService.delete(userId, addressId);
        return Result.success("删除成功", null);
    }

    @PatchMapping("/{addressId}/default")
    public Result<AddressDefaultVO> setDefault(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Positive(message = "地址ID必须大于0") @PathVariable Long addressId) {
        return Result.success("设置成功", addressService.setDefault(userId, addressId));
    }

    @GetMapping("/default")
    public Result<AddressVO> getDefault(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId) {
        AddressVO address = addressService.getDefault(userId);
        return address == null
                ? Result.success("暂无默认地址", null)
                : Result.success(address);
    }
}
