package com.socialretail.backend.service.aftersale.impl;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.dto.request.aftersale.*;
import com.socialretail.backend.dto.response.aftersale.*;
import com.socialretail.backend.entity.order.AfterSale;
import com.socialretail.backend.entity.order.Order;
import com.socialretail.backend.entity.order.OrderItem;
import com.socialretail.backend.enums.aftersale.*;
import com.socialretail.backend.infrastructure.pay.refund.AliPayRefundResult;
import com.socialretail.backend.infrastructure.pay.refund.AliPayRefundService;
import com.socialretail.backend.mapper.order.AfterSaleMapper;
import com.socialretail.backend.mapper.order.OrderItemMapper;
import com.socialretail.backend.mapper.order.OrderMapper;
import com.socialretail.backend.service.aftersale.AfterSaleService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.*;

@Slf4j
@Service("userAfterSaleService")
public class AfterSaleServiceImpl implements AfterSaleService {
    private static final Set<Integer> AFTER_SALE_ORDER_STATUSES = Set.of(1, 2, 3, 4);
    private static final int WAIT_SHIP = 1;
    private static final int MAX_IMAGES = 9;

    private final AfterSaleMapper afterSaleMapper;
    private final OrderMapper orderMapper;
    private final OrderItemMapper orderItemMapper;
    private final AliPayRefundService aliPayRefundService;
    private final ObjectMapper objectMapper;

    public AfterSaleServiceImpl(AfterSaleMapper afterSaleMapper, OrderMapper orderMapper,
                                OrderItemMapper orderItemMapper, AliPayRefundService aliPayRefundService,
                                ObjectMapper objectMapper) {
        this.afterSaleMapper = afterSaleMapper;
        this.orderMapper = orderMapper;
        this.orderItemMapper = orderItemMapper;
        this.aliPayRefundService = aliPayRefundService;
        this.objectMapper = objectMapper;
    }

    @Override
    @Transactional
    public AfterSaleCreateResponse createAfterSale(Long userId, AfterSaleCreateRequest request) {
        Order order = orderMapper.selectByIdAndUserIdForUpdate(request.orderId(), userId);
        if (order == null) throw new BusinessException(40401, HttpStatus.NOT_FOUND, "订单不存在");
        if (!AFTER_SALE_ORDER_STATUSES.contains(order.getStatus())) {
            throw new BusinessException(40931, HttpStatus.CONFLICT, "当前订单状态不允许申请售后",
                    Map.of("orderId", order.getId(), "status", orderStatus(order.getStatus())));
        }
        OrderItem item = orderItemMapper.selectById(request.orderItemId());
        if (item == null || !order.getId().equals(item.getOrderId())) {
            throw new BusinessException(40402, HttpStatus.NOT_FOUND, "订单商品不存在");
        }
        BigDecimal refundable = refundableAmount(item);
        if (request.refundAmount().compareTo(refundable) > 0) {
            throw new BusinessException(40933, HttpStatus.CONFLICT, "申请退款金额超过该商品实付金额",
                    Map.of("maxRefundAmount", refundable));
        }
        if (afterSaleMapper.countActiveByOrderItemId(item.getId()) > 0) {
            throw new BusinessException(40934, HttpStatus.CONFLICT, "该订单商品已有进行中的售后申请");
        }

        LocalDateTime now = LocalDateTime.now();
        AfterSale afterSale = new AfterSale();
        afterSale.setOrderId(order.getId());
        afterSale.setOrderItemId(item.getId());
        afterSale.setMerchantId(order.getMerchantId());
        afterSale.setOrderSn(order.getOrderSn());
        afterSale.setType(request.type().getCode());
        afterSale.setServiceType(request.type().getCode());
        afterSale.setRefundAmount(request.refundAmount());
        afterSale.setReason(request.reason().trim());
        afterSale.setEvidenceImages(writeImages(normalizeImages(request.evidenceImages())));
        afterSale.setProductName(item.getProductName());
        afterSale.setSkuSpecs(item.getSkuSpecs());
        afterSale.setStatus(AfterSaleStatus.APPLYING.getCode());
        afterSale.setAuditStatus(AuditStatus.PENDING.getCode());
        afterSale.setRefundStatus(RefundStatus.NOT_REFUNDED.getCode());
        afterSale.setReturnReceivedStatus(0);
        afterSale.setApplyTime(now);
        afterSale.setUpdateTime(now);
        afterSale.setIsDeleted(0);
        afterSaleMapper.insert(afterSale);

        return new AfterSaleCreateResponse(afterSale.getId(), order.getId(), item.getId(), request.type(),
                request.refundAmount(), AfterSaleStatus.APPLYING, now);
    }

    @Override
    public PageResult<AfterSaleListItemResponse> list(Long userId, AfterSaleStatus status, int page, int pageSize) {
        int statusCode = status == null ? 0 : status.getCode();
        Integer filter = status == null ? null : statusCode;
        long total = afterSaleMapper.countUserPage(userId, filter);
        List<AfterSaleListItemResponse> list = afterSaleMapper
                .selectUserPage(userId, filter, (page - 1) * pageSize, pageSize).stream()
                .map(this::toListItem).toList();
        return PageResult.of(list, total, page, pageSize);
    }

    @Override
    public AfterSaleDetailResponse detail(Long userId, Long afterSaleId) {
        Map<String, Object> row = afterSaleMapper.selectUserDetail(afterSaleId, userId);
        if (row == null) throw afterSaleNotFound();
        return toDetail(row);
    }

    @Override
    public AfterSaleStatusResponse cancel(Long userId, Long afterSaleId, AfterSaleCancelRequest request) {
        AfterSaleDetailResponse current = detail(userId, afterSaleId);
        if (current.status() != AfterSaleStatus.APPLYING
                || current.auditStatus() != AuditStatus.PENDING
                || current.refundStatus() != RefundStatus.NOT_REFUNDED) {
            throw new BusinessException(40932, HttpStatus.CONFLICT, "当前售后状态不允许取消",
                    Map.of("afterSaleId", afterSaleId,
                            "status", current.status().name(),
                            "auditStatus", current.auditStatus().name(),
                            "refundStatus", current.refundStatus().name()));
        }
        String reason = request == null || request.cancelReason() == null ? null : request.cancelReason().trim();
        if (afterSaleMapper.cancelApplying(afterSaleId, userId, reason, LocalDateTime.now()) != 1) {
            throw new BusinessException(40932, HttpStatus.CONFLICT, "当前售后状态不允许取消");
        }
        return new AfterSaleStatusResponse(afterSaleId, AfterSaleStatus.CANCELLED);
    }

    @Override
    public AfterSaleImagesResponse appendImages(Long userId, Long afterSaleId, AfterSaleImagesRequest request) {
        AfterSaleDetailResponse current = detail(userId, afterSaleId);
        if (!Set.of(AfterSaleStatus.APPLYING, AfterSaleStatus.APPROVED).contains(current.status())) {
            throw new BusinessException(40935, HttpStatus.CONFLICT, "当前售后状态不允许补充凭证");
        }
        LinkedHashSet<String> merged = new LinkedHashSet<>(current.evidenceImages());
        merged.addAll(normalizeImages(request.imageUrls()));
        if (merged.size() > MAX_IMAGES) {
            throw new BusinessException(40031, HttpStatus.BAD_REQUEST, "凭证图片累计最多9张");
        }
        List<String> images = List.copyOf(merged);
        if (afterSaleMapper.updateUserImages(afterSaleId, userId, writeImages(images), LocalDateTime.now()) != 1) {
            throw new BusinessException(40935, HttpStatus.CONFLICT, "当前售后状态不允许补充凭证");
        }
        return new AfterSaleImagesResponse(afterSaleId, images);
    }

    @Override
    public void handleAuditResult(Long afterSaleId, AuditStatus auditStatus, String remark) {
        if (auditStatus == null || auditStatus == AuditStatus.PENDING) {
            throw new IllegalArgumentException("审核结果只能是 APPROVED 或 REJECTED");
        }
        AfterSale afterSale = afterSaleMapper.selectById(afterSaleId);
        if (afterSale == null || Objects.equals(afterSale.getIsDeleted(), 1)) throw afterSaleNotFound();
        LocalDateTime now = LocalDateTime.now();

        if (auditStatus == AuditStatus.REJECTED) {
            int changed = afterSaleMapper.recordAudit(afterSaleId, auditStatus.getCode(),
                    AfterSaleStatus.REJECTED.getCode(), remark, remark, now);
            if (changed == 0 && !Objects.equals(afterSaleMapper.selectById(afterSaleId).getAuditStatus(), auditStatus.getCode())) {
                throw new BusinessException(40936, HttpStatus.CONFLICT, "该售后申请已完成审核");
            }
            return;
        }

        int audited = afterSaleMapper.recordAudit(afterSaleId, auditStatus.getCode(),
                AfterSaleStatus.APPROVED.getCode(), remark, null, now);
        AfterSale approved = afterSaleMapper.selectById(afterSaleId);
        if (audited == 0 && !Objects.equals(approved.getAuditStatus(), AuditStatus.APPROVED.getCode())) {
            throw new BusinessException(40936, HttpStatus.CONFLICT, "该售后申请已完成审核");
        }
        if (Objects.equals(approved.getRefundStatus(), RefundStatus.SUCCESS.getCode())
                || afterSaleMapper.claimRefund(afterSaleId, LocalDateTime.now()) != 1) {
            return;
        }

        Order order = orderMapper.selectById(approved.getOrderId());
        if (order == null) {
            finishRefund(afterSaleId, AliPayRefundResult.fail("关联订单不存在"), null);
            return;
        }
        if (Objects.equals(order.getStatus(), WAIT_SHIP)) {
            finishRefund(afterSaleId, safeRefund(order.getId(), approved.getRefundAmount()), null);
            return;
        }

        aliPayRefundService.refundAsync(order.getId(), approved.getRefundAmount())
                .whenComplete((result, throwable) -> finishRefund(afterSaleId, result, throwable));
    }

    private AliPayRefundResult safeRefund(Long orderId, BigDecimal amount) {
        try { return aliPayRefundService.refund(orderId, amount); }
        catch (RuntimeException exception) { return AliPayRefundResult.fail(exception.getMessage()); }
    }

    private void finishRefund(Long afterSaleId, AliPayRefundResult result, Throwable throwable) {
        boolean success = throwable == null && result != null && result.success();
        String message = throwable != null ? "支付宝沙箱调用异常: " + throwable.getMessage()
                : result == null ? "支付宝沙箱未返回结果" : result.message();
        int changed = afterSaleMapper.finishRefund(afterSaleId,
                success ? AfterSaleStatus.COMPLETED.getCode() : AfterSaleStatus.FAILED.getCode(),
                success ? RefundStatus.SUCCESS.getCode() : RefundStatus.FAILED.getCode(),
                message, LocalDateTime.now());
        if (changed == 0) log.info("售后退款结果已处理，忽略重复回写: afterSaleId={}", afterSaleId);
    }

    private AfterSaleListItemResponse toListItem(Map<String, Object> row) {
        AfterSaleStatus status = AfterSaleStatus.fromCode(integer(row, "status"));
        return new AfterSaleListItemResponse(longValue(row, "id"), longValue(row, "order_id"),
                string(row, "order_sn"), longValue(row, "order_item_id"), string(row, "product_name"),
                string(row, "product_image"), AfterSaleType.fromCode(integer(row, "type")),
                decimal(row, "refund_amount"), status, status.getText(), dateTime(row, "apply_time"));
    }

    private AfterSaleDetailResponse toDetail(Map<String, Object> row) {
        AfterSaleStatus status = AfterSaleStatus.fromCode(integer(row, "status"));
        return new AfterSaleDetailResponse(longValue(row, "id"), longValue(row, "order_id"), string(row, "order_sn"),
                longValue(row, "order_item_id"), string(row, "product_name"), string(row, "product_image"),
                string(row, "sku_specs"), AfterSaleType.fromCode(integer(row, "type")), decimal(row, "refund_amount"),
                decimal(row, "actual_refund_amount"), string(row, "reason"), readImages(string(row, "evidence_images")),
                status, status.getText(), AuditStatus.fromCode(integer(row, "audit_status")),
                RefundStatus.fromCode(integer(row, "refund_status")), string(row, "audit_remark"),
                string(row, "reject_reason"), dateTime(row, "apply_time"), dateTime(row, "audit_time"),
                dateTime(row, "complete_time"));
    }

    private BigDecimal refundableAmount(OrderItem item) {
        if (item.getItemFinalAmount() != null) return item.getItemFinalAmount();
        BigDecimal unit = item.getFinalPrice() != null ? item.getFinalPrice() : item.getPrice();
        return unit.multiply(BigDecimal.valueOf(item.getQuantity() == null ? 1 : item.getQuantity()));
    }

    private List<String> normalizeImages(List<String> images) {
        if (images == null) return List.of();
        return images.stream().filter(Objects::nonNull).map(String::trim).filter(value -> !value.isEmpty()).distinct().toList();
    }

    private String writeImages(List<String> images) {
        try { return objectMapper.writeValueAsString(images); }
        catch (JsonProcessingException exception) { throw new IllegalStateException("凭证图片序列化失败", exception); }
    }

    private List<String> readImages(String json) {
        if (json == null || json.isBlank()) return List.of();
        try { return objectMapper.readValue(json, new TypeReference<>() { }); }
        catch (JsonProcessingException exception) { throw new IllegalStateException("凭证图片数据格式错误", exception); }
    }

    private Object value(Map<String, Object> row, String key) {
        Object value = row.get(key);
        if (value == null) value = row.get(key.toUpperCase(Locale.ROOT));
        return value;
    }
    private String string(Map<String, Object> row, String key) { Object value = value(row, key); return value == null ? null : value.toString(); }
    private Long longValue(Map<String, Object> row, String key) { Object value = value(row, key); return value == null ? null : ((Number) value).longValue(); }
    private Integer integer(Map<String, Object> row, String key) { Object value = value(row, key); return value == null ? 0 : ((Number) value).intValue(); }
    private BigDecimal decimal(Map<String, Object> row, String key) { Object value = value(row, key); return value == null ? null : new BigDecimal(value.toString()); }
    private LocalDateTime dateTime(Map<String, Object> row, String key) {
        Object value = value(row, key);
        if (value instanceof LocalDateTime time) return time;
        if (value instanceof Timestamp timestamp) return timestamp.toLocalDateTime();
        return null;
    }

    private BusinessException afterSaleNotFound() {
        return new BusinessException(40431, HttpStatus.NOT_FOUND, "售后申请不存在");
    }
    private String orderStatus(Integer status) {
        return switch (status == null ? -1 : status) {
            case 0 -> "WAIT_PAY"; case 1 -> "WAIT_SHIP"; case 2 -> "WAIT_PICKUP";
            case 3 -> "DELIVERING"; case 4 -> "COMPLETED"; case 5 -> "CANCELLED"; default -> "UNKNOWN";
        };
    }
}
