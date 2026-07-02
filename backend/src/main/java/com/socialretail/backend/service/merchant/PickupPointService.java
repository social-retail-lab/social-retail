package com.socialretail.backend.service.merchant;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.entity.member.Merchant;
import com.socialretail.backend.entity.order.Order;
import com.socialretail.backend.entity.order.PickupPoint;
import com.socialretail.backend.mapper.member.MerchantMapper;
import com.socialretail.backend.mapper.order.OrderMapper;
import com.socialretail.backend.mapper.order.PickupPointMapper;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Slf4j
@Service
public class PickupPointService {

    @Resource
    private PickupPointMapper pickupPointMapper;

    @Resource
    private OrderMapper orderMapper;

    @Resource
    private MerchantMapper merchantMapper;

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    private static final Set<Integer> ORDER_DELETABLE_EXCLUDE = new HashSet<>(Arrays.asList(4, 5));

    /**
     * 获取商家的自提点列表
     */
    public List<Map<String, Object>> listPickupPoints(Long merchantId) {
        LambdaQueryWrapper<PickupPoint> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(PickupPoint::getMerchantId, merchantId);
        List<PickupPoint> points = pickupPointMapper.selectList(wrapper);

        List<Map<String, Object>> result = new ArrayList<>();
        for (PickupPoint point : points) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", point.getId());
            map.put("name", point.getName());
            map.put("address", point.getAddress());
            map.put("contactPhone", point.getContactPhone());
            map.put("status", point.getStatus());
            map.put("auditStatus", point.getAuditStatus());
            map.put("auditStatusText", auditStatusText(point.getAuditStatus()));
            map.put("auditRemark", point.getAuditRemark());
            map.put("image", point.getImage());
            map.put("createTime", formatDateTime(point.getCreateTime()));
            result.add(map);
        }
        return result;
    }

    /**
     * 新增自提点
     */
    public Map<String, Object> addPickupPoint(Long merchantId, String name, String address, String contactPhone, String image) {
        PickupPoint point = new PickupPoint();
        point.setMerchantId(merchantId);
        point.setName(name);
        point.setAddress(address);
        point.setContactPhone(contactPhone);
        point.setImage(image);
        point.setStatus(1);
        point.setAuditStatus(0);

        pickupPointMapper.insert(point);

        Map<String, Object> result = new HashMap<>();
        result.put("id", point.getId());
        result.put("message", "自提点已提交，等待审核");
        return result;
    }

    /**
     * 删除自提点
     */
    public Map<String, Object> deletePickupPoint(Long merchantId, Long pointId) {
        PickupPoint point = pickupPointMapper.selectById(pointId);
        if (point == null) {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "自提点不存在");
        }
        if (!point.getMerchantId().equals(merchantId)) {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "无权操作该自提点");
        }

        LambdaQueryWrapper<Order> orderWrapper = new LambdaQueryWrapper<>();
        orderWrapper.eq(Order::getPickupPointId, pointId);
        orderWrapper.notIn(Order::getStatus, ORDER_DELETABLE_EXCLUDE);
        Long activeOrderCount = orderMapper.selectCount(orderWrapper);
        if (activeOrderCount != null && activeOrderCount > 0) {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "该自提点有进行中的订单，无法删除");
        }

        pickupPointMapper.deleteById(pointId);

        Map<String, Object> result = new HashMap<>();
        result.put("message", "已删除");
        return result;
    }

    /**
     * 分页获取待审核的自提点
     */
    public PageResult<Map<String, Object>> getPendingPoints(int pageNum, int pageSize) {
        LambdaQueryWrapper<PickupPoint> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(PickupPoint::getAuditStatus, 0);
        wrapper.orderByDesc(PickupPoint::getCreateTime);

        Page<PickupPoint> page = new Page<>(pageNum, pageSize);
        Page<PickupPoint> pointPage = pickupPointMapper.selectPage(page, wrapper);

        List<Map<String, Object>> resultList = new ArrayList<>();
        for (PickupPoint point : pointPage.getRecords()) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", point.getId());
            map.put("merchantId", point.getMerchantId());

            String merchantName = "";
            if (point.getMerchantId() != null) {
                Merchant merchant = merchantMapper.selectById(point.getMerchantId());
                if (merchant != null) {
                    merchantName = merchant.getMerchantName();
                }
            }
            map.put("merchantName", merchantName);
            map.put("name", point.getName());
            map.put("address", point.getAddress());
            map.put("contactPhone", point.getContactPhone());
            map.put("image", point.getImage());
            map.put("createTime", formatDateTime(point.getCreateTime()));

            resultList.add(map);
        }

        return PageResult.of(resultList, pointPage.getTotal(), pageNum, pageSize);
    }

    /**
     * 审核自提点
     */
    public Map<String, Object> auditPickupPoint(Long pointId, Integer auditStatus, String auditRemark) {
        PickupPoint point = pickupPointMapper.selectById(pointId);
        if (point == null) {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "自提点不存在");
        }

        point.setAuditStatus(auditStatus);
        point.setAuditRemark(auditRemark);
        point.setAuditTime(LocalDateTime.now());

        if (Integer.valueOf(1).equals(auditStatus)) {
            point.setStatus(1);
        } else if (Integer.valueOf(2).equals(auditStatus)) {
            point.setStatus(0);
        }

        pickupPointMapper.updateById(point);

        Map<String, Object> result = new HashMap<>();
        result.put("id", pointId);
        result.put("auditStatus", auditStatus);
        result.put("auditStatusText", auditStatusText(auditStatus));
        result.put("message", Integer.valueOf(1).equals(auditStatus) ? "审核通过" : "已驳回");
        return result;
    }

    private String formatDateTime(LocalDateTime dt) {
        if (dt == null) {
            return null;
        }
        return dt.format(FORMATTER);
    }

    private String auditStatusText(Integer auditStatus) {
        if (auditStatus == null) {
            return "";
        }
        switch (auditStatus) {
            case 0:
                return "待审核";
            case 1:
                return "已通过";
            case 2:
                return "已驳回";
            default:
                return "";
        }
    }
}
