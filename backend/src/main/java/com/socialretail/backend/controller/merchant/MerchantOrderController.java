package com.socialretail.backend.controller.merchant;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.socialretail.backend.common.OrderStatus;
import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.entity.order.Delivery;
import com.socialretail.backend.entity.order.DeliveryStatusLog;
import com.socialretail.backend.entity.order.MerchantEarnings;
import com.socialretail.backend.entity.order.Order;
import com.socialretail.backend.entity.order.OrderItem;
import com.socialretail.backend.entity.order.OrderStatusLog;
import com.socialretail.backend.mapper.order.DeliveryMapper;
import com.socialretail.backend.mapper.order.DeliveryStatusLogMapper;
import com.socialretail.backend.mapper.order.MerchantEarningsMapper;
import com.socialretail.backend.mapper.order.OrderItemMapper;
import com.socialretail.backend.mapper.order.OrderMapper;
import com.socialretail.backend.mapper.order.OrderStatusLogMapper;
import com.socialretail.backend.service.merchant.PickupPointService;
import com.socialretail.backend.service.merchant.PickupService;
import com.socialretail.backend.service.merchant.impl.AfterSaleServiceImpl;
import com.socialretail.backend.service.merchant.impl.EarningsServiceImpl;
import com.socialretail.backend.service.merchant.impl.MerchantOrderServiceImpl;
import com.socialretail.backend.vo.*;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/merchant")
public class MerchantOrderController {

    @Resource
    private MerchantOrderServiceImpl serviceImpl;

    @Resource
    private PickupService pickupService;

    @Resource
    private AfterSaleServiceImpl afterSaleService;

    @Resource
    private EarningsServiceImpl earningsService;

    @Resource
    private DeliveryMapper deliveryMapper;

    @Resource
    private DeliveryStatusLogMapper deliveryStatusLogMapper;

    @Resource
    private OrderMapper orderMapper;

    @Resource
    private OrderItemMapper orderItemMapper;

    @Resource
    private OrderStatusLogMapper orderStatusLogMapper;

    @Resource
    private MerchantEarningsMapper merchantEarningsMapper;

    @Resource
    private PickupPointService pickupPointService;

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();

    // ==================== 1. 订单列表 ====================

    @GetMapping("/orders")
    public Result<PageResult<Map<String, Object>>> getOrderList(HttpServletRequest request,
                                                                 @RequestParam(required = false) Integer status,
                                                                 @RequestParam(required = false) Integer deliveryType,
                                                                 @RequestParam(required = false) String orderSn,
                                                                 @RequestParam(required = false) String startDate,
                                                                 @RequestParam(required = false) String endDate,
                                                                 @RequestParam(defaultValue = "1") int pageNum,
                                                                 @RequestParam(defaultValue = "10") int pageSize) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        log.info("[订单列表] merchantId={}, status={}, deliveryType={}, orderSn={}, startDate={}, endDate={}, pageNum={}, pageSize={}",
                merchantId, status, deliveryType, orderSn, startDate, endDate, pageNum, pageSize);
        try {
            PageResult<Map<String, Object>> pageResult = serviceImpl.getOrderList(
                    merchantId, status, deliveryType, orderSn, startDate, endDate, pageNum, pageSize);
            log.info("[订单列表] 成功, merchantId={}, total={}, count={}", merchantId, pageResult.getTotal(), pageResult.getList().size());
            return Result.success(pageResult);
        } catch (RuntimeException e) {
            log.warn("[订单列表] 失败, merchantId={}, 原因: {}", merchantId, e.getMessage());
            throw e;
        }
    }

    // ==================== 2. 订单详情 ====================

    @GetMapping("/orders/{orderId}")
    public Result<Map<String, Object>> getOrderDetail(HttpServletRequest request,
                                                       @PathVariable Long orderId) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        log.info("[订单详情] merchantId={}, orderId={}", merchantId, orderId);
        try {
            Map<String, Object> detail = serviceImpl.getOrderDetail(orderId, merchantId);
            log.info("[订单详情] 成功, orderId={}, orderSn={}", orderId, detail.get("orderSn"));
            return Result.success(detail);
        } catch (RuntimeException e) {
            log.warn("[订单详情] 失败, merchantId={}, orderId={}, 原因: {}", merchantId, orderId, e.getMessage());
            throw e;
        }
    }

    // ==================== 3. 接单 ====================

    @PostMapping("/orders/{orderId}/accept")
    public Result<Map<String, Object>> acceptOrder(HttpServletRequest request,
                                                    @PathVariable Long orderId,
                                                    @RequestBody OrderOperateRequest req) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        log.info("[接单] merchantId={}, orderId={}, remark={}", merchantId, orderId, req.getRemark());
        try {
            Map<String, Object> result = serviceImpl.acceptOrder(orderId, merchantId, req.getRemark());
            log.info("[接单] 成功, orderId={}, newStatus={}", orderId, result.get("newStatus"));
            return Result.success("接单成功", result);
        } catch (RuntimeException e) {
            log.warn("[接单] 失败, merchantId={}, orderId={}, 原因: {}", merchantId, orderId, e.getMessage());
            throw e;
        }
    }

    // ==================== 4. 备货 ====================

    @PostMapping("/orders/{orderId}/prepare")
    public Result<Map<String, Object>> prepareGoods(HttpServletRequest request,
                                                     @PathVariable Long orderId,
                                                     @RequestBody OrderOperateRequest req) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        log.info("[备货] merchantId={}, orderId={}, remark={}", merchantId, orderId, req.getRemark());
        try {
            Map<String, Object> result = serviceImpl.prepareGoods(orderId, merchantId, req.getRemark());
            log.info("[备货] 成功, orderId={}, newStatus={}", orderId, result.get("newStatus"));
            return Result.success("备货完成", result);
        } catch (RuntimeException e) {
            log.warn("[备货] 失败, merchantId={}, orderId={}, 原因: {}", merchantId, orderId, e.getMessage());
            throw e;
        }
    }

    // ==================== 5. 发货 ====================

    @PostMapping("/orders/{orderId}/ship")
    public Result<Map<String, Object>> shipOrder(HttpServletRequest request,
                                                  @PathVariable Long orderId,
                                                  @RequestBody(required = false) OrderOperateRequest req) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        String remark = req != null ? req.getRemark() : null;
        log.info("[发货] merchantId={}, orderId={}, remark={}", merchantId, orderId, remark);
        try {
            Map<String, Object> result = serviceImpl.shipOrder(orderId, merchantId, remark);
            log.info("[发货] 成功, orderId={}, deliveryId={}", orderId, result.get("deliveryId"));
            return Result.success("发货成功", result);
        } catch (RuntimeException e) {
            log.warn("[发货] 失败, merchantId={}, orderId={}, 原因: {}", merchantId, orderId, e.getMessage());
            throw e;
        }
    }

    // ==================== 6. 取消订单 ====================

    @PostMapping("/orders/{orderId}/cancel")
    public Result<Map<String, Object>> cancelOrder(HttpServletRequest request,
                                                    @PathVariable Long orderId,
                                                    @RequestBody Map<String, Object> body) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        String reason = body != null && body.get("reason") != null ? body.get("reason").toString() : null;
        log.info("[取消订单] merchantId={}, orderId={}, reason={}", merchantId, orderId, reason);
        try {
            Map<String, Object> result = serviceImpl.cancelOrder(orderId, merchantId, reason);
            log.info("[取消订单] 成功, orderId={}, newStatus={}", orderId, result.get("newStatus"));
            return Result.success("订单已取消", result);
        } catch (RuntimeException e) {
            log.warn("[取消订单] 失败, merchantId={}, orderId={}, 原因: {}", merchantId, orderId, e.getMessage());
            throw e;
        }
    }

    // ==================== 7. 创建配送记录 ====================

    @PostMapping("/orders/{orderId}/delivery")
    public Result<Map<String, Object>> createDelivery(HttpServletRequest request,
                                                       @PathVariable Long orderId,
                                                       @RequestBody DeliveryCreateRequest req) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        log.info("[创建配送] merchantId={}, orderId={}, dispatcherName={}, remark={}",
                merchantId, orderId, req.getDispatcherName(), req.getRemark());
        try {
            Map<String, Object> result = serviceImpl.shipOrder(orderId, merchantId, req.getRemark());
            log.info("[创建配送] 成功, orderId={}, deliveryId={}", orderId, result.get("deliveryId"));
            return Result.success(result);
        } catch (RuntimeException e) {
            log.warn("[创建配送] 失败, merchantId={}, orderId={}, 原因: {}", merchantId, orderId, e.getMessage());
            throw e;
        }
    }

    // ==================== 8. 配送详情 ====================

    @GetMapping("/deliveries/{deliveryId}")
    public Result<Map<String, Object>> getDeliveryDetail(HttpServletRequest request,
                                                          @PathVariable Long deliveryId) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        log.info("[配送详情] merchantId={}, deliveryId={}", merchantId, deliveryId);
        try {
            Delivery delivery = deliveryMapper.selectById(deliveryId);
            if (delivery == null) {
                throw new BusinessException(400, HttpStatus.BAD_REQUEST, "配送记录不存在");
            }
            Order order = orderMapper.selectById(delivery.getOrderId());
            if (order == null || !order.getMerchantId().equals(merchantId)) {
                throw new BusinessException(403, HttpStatus.FORBIDDEN, "无权查看该配送记录");
            }

            Map<String, Object> result = new HashMap<>();
            result.put("deliveryId", delivery.getId());
            result.put("deliverySn", delivery.getDeliverySn());
            result.put("orderId", delivery.getOrderId());
            result.put("orderSn", order.getOrderSn());
            result.put("dispatcherName", delivery.getDispatcherName());
            result.put("dispatcherPhone", delivery.getDispatcherPhone());
            result.put("status", delivery.getStatus());
            result.put("remark", delivery.getRemark());
            result.put("startTime", formatDateTime(delivery.getStartTime()));
            result.put("endTime", formatDateTime(delivery.getEndTime()));
            result.put("simulateCompleteTime", formatDateTime(delivery.getSimulateCompleteTime()));

            // 订单商品
            LambdaQueryWrapper<OrderItem> itemWrapper = new LambdaQueryWrapper<>();
            itemWrapper.eq(OrderItem::getOrderId, delivery.getOrderId());
            List<OrderItem> orderItems = orderItemMapper.selectList(itemWrapper);
            List<Map<String, Object>> itemList = new ArrayList<>();
            for (OrderItem item : orderItems) {
                Map<String, Object> itemMap = new HashMap<>();
                itemMap.put("id", item.getId());
                itemMap.put("skuId", item.getSkuId());
                itemMap.put("productName", item.getProductName());
                itemMap.put("skuSpecs", item.getSkuSpecs());
                itemMap.put("price", item.getPrice());
                itemMap.put("quantity", item.getQuantity());
                itemList.add(itemMap);
            }
            result.put("orderItems", itemList);

            // 配送状态时间线
            LambdaQueryWrapper<DeliveryStatusLog> logWrapper = new LambdaQueryWrapper<>();
            logWrapper.eq(DeliveryStatusLog::getDeliveryId, deliveryId);
            logWrapper.orderByAsc(DeliveryStatusLog::getCreateTime);
            List<DeliveryStatusLog> statusLogs = deliveryStatusLogMapper.selectList(logWrapper);
            List<Map<String, Object>> timelineList = new ArrayList<>();
            for (DeliveryStatusLog log : statusLogs) {
                Map<String, Object> logMap = new HashMap<>();
                logMap.put("id", log.getId());
                logMap.put("fromStatus", log.getFromStatus());
                logMap.put("toStatus", log.getToStatus());
                logMap.put("statusText", log.getStatusText());
                logMap.put("remark", log.getRemark());
                logMap.put("createTime", formatDateTime(log.getCreateTime()));
                timelineList.add(logMap);
            }
            result.put("timeline", timelineList);

            log.info("[配送详情] 成功, deliveryId={}, deliverySn={}", deliveryId, delivery.getDeliverySn());
            return Result.success(result);
        } catch (RuntimeException e) {
            log.warn("[配送详情] 失败, merchantId={}, deliveryId={}, 原因: {}", merchantId, deliveryId, e.getMessage());
            throw e;
        }
    }

    // ==================== 9. 更新配送状态 ====================

    @PatchMapping("/deliveries/{deliveryId}/status")
    public Result<Map<String, Object>> updateDeliveryStatus(HttpServletRequest request,
                                                             @PathVariable Long deliveryId,
                                                             @RequestBody DeliveryStatusRequest req) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        log.info("[更新配送状态] merchantId={}, deliveryId={}, targetStatus={}", merchantId, deliveryId, req.getStatus());
        try {
            Delivery delivery = deliveryMapper.selectById(deliveryId);
            if (delivery == null) {
                throw new BusinessException(400, HttpStatus.BAD_REQUEST, "配送记录不存在");
            }
            Order order = orderMapper.selectById(delivery.getOrderId());
            if (order == null || !order.getMerchantId().equals(merchantId)) {
                throw new BusinessException(403, HttpStatus.FORBIDDEN, "无权操作该配送记录");
            }

            Integer fromStatus = delivery.getStatus();
            LocalDateTime now = LocalDateTime.now();

            // 更新配送状态
            delivery.setStatus(req.getStatus());
            if (req.getStatus() == 4) {
                delivery.setEndTime(now);
            }
            deliveryMapper.updateById(delivery);

            // 如果配送已送达，更新订单状态为已完成并创建收益
            if (req.getStatus() == 4) {
                order.setStatus(OrderStatus.COMPLETED);
                order.setCompleteTime(now);
                orderMapper.updateById(order);

                // 创建订单状态日志
                OrderStatusLog orderStatusLog = new OrderStatusLog();
                orderStatusLog.setOrderId(order.getId());
                orderStatusLog.setFromStatus(OrderStatus.IN_PROGRESS);
                orderStatusLog.setToStatus(OrderStatus.COMPLETED);
                orderStatusLog.setStatusText("已完成");
                orderStatusLog.setOperatorType("system");
                orderStatusLog.setOperatorId(merchantId);
                orderStatusLog.setRemark("配送已送达");
                orderStatusLog.setCreateTime(now);
                orderStatusLogMapper.insert(orderStatusLog);

                // 创建收益记录
                MerchantEarnings earnings = new MerchantEarnings();
                earnings.setMerchantId(merchantId);
                earnings.setOrderId(order.getId());
                earnings.setOrderSn(order.getOrderSn());
                earnings.setAmount(order.getPayAmount());
                earnings.setStatus(0);
                earnings.setFreezeTime(now);
                earnings.setUnfreezeTime(now.plusHours(2));
                earnings.setCreateTime(now);
                merchantEarningsMapper.insert(earnings);
            }

            // 插入配送状态日志
            DeliveryStatusLog deliveryLog = new DeliveryStatusLog();
            deliveryLog.setDeliveryId(deliveryId);
            deliveryLog.setFromStatus(fromStatus);
            deliveryLog.setToStatus(req.getStatus());
            deliveryLog.setStatusText(getDeliveryStatusText(req.getStatus()));
            deliveryLog.setRemark(null);
            deliveryLog.setCreateTime(now);
            deliveryStatusLogMapper.insert(deliveryLog);

            Map<String, Object> result = new HashMap<>();
            result.put("deliveryId", deliveryId);
            result.put("fromStatus", fromStatus);
            result.put("toStatus", req.getStatus());
            result.put("statusText", getDeliveryStatusText(req.getStatus()));
            log.info("[更新配送状态] 成功, deliveryId={}, {} -> {}", deliveryId, fromStatus, req.getStatus());
            return Result.success(result);
        } catch (RuntimeException e) {
            log.warn("[更新配送状态] 失败, merchantId={}, deliveryId={}, 原因: {}", merchantId, deliveryId, e.getMessage());
            throw e;
        }
    }

    // ==================== 10. 自提核销 ====================

    @PostMapping("/pickup/verify")
    public Result<Map<String, Object>> verifyPickup(HttpServletRequest request,
                                                     @RequestBody PickupVerifyRequest req) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        log.info("[自提核销] merchantId={}, pickupCode={}", merchantId, req.getPickupCode());
        try {
            Map<String, Object> result = pickupService.verifyPickup(merchantId, req.getPickupCode());
            log.info("[自提核销] 成功, orderId={}, orderSn={}", result.get("orderId"), result.get("orderSn"));
            return Result.success("核销成功，订单已完成", result);
        } catch (RuntimeException e) {
            log.warn("[自提核销] 失败, merchantId={}, pickupCode={}, 原因: {}", merchantId, req.getPickupCode(), e.getMessage());
            throw e;
        }
    }

    // ==================== 10.1 确认自提（订单管理内） ====================

    @PostMapping("/pickup/confirm/{orderId}")
    public Result<Map<String, Object>> confirmPickup(HttpServletRequest request,
                                                      @PathVariable Long orderId,
                                                      @RequestBody Map<String, String> body) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        String pickupCode = body.get("pickupCode");
        log.info("[确认自提] merchantId={}, orderId={}, pickupCode={}", merchantId, orderId, pickupCode);
        try {
            Map<String, Object> result = pickupService.confirmPickup(merchantId, orderId, pickupCode);
            log.info("[确认自提] 成功, orderId={}, orderSn={}", result.get("orderId"), result.get("orderSn"));
            return Result.success("自提确认成功", result);
        } catch (RuntimeException e) {
            log.warn("[确认自提] 失败, merchantId={}, orderId={}, 原因: {}", merchantId, orderId, e.getMessage());
            throw e;
        }
    }

    // ==================== 11. 自提记录 ====================

    @GetMapping("/pickup/records")
    public Result<PageResult<Map<String, Object>>> getPickupRecords(HttpServletRequest request,
                                                                     @RequestParam(required = false) String startDate,
                                                                     @RequestParam(required = false) String endDate,
                                                                     @RequestParam(defaultValue = "1") int pageNum,
                                                                     @RequestParam(defaultValue = "10") int pageSize) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        log.info("[自提记录] merchantId={}, startDate={}, endDate={}, pageNum={}, pageSize={}",
                merchantId, startDate, endDate, pageNum, pageSize);
        try {
            PageResult<Map<String, Object>> pageResult = pickupService.getPickupRecords(
                    merchantId, startDate, endDate, pageNum, pageSize);
            log.info("[自提记录] 成功, merchantId={}, total={}, count={}",
                    merchantId, pageResult.getTotal(), pageResult.getList().size());
            return Result.success(pageResult);
        } catch (RuntimeException e) {
            log.warn("[自提记录] 失败, merchantId={}, 原因: {}", merchantId, e.getMessage());
            throw e;
        }
    }

    // ==================== 12. 售后列表 ====================

    @GetMapping("/after-sales")
    public Result<PageResult<Map<String, Object>>> getAfterSaleList(HttpServletRequest request,
                                                                     @RequestParam(required = false) Integer type,
                                                                     @RequestParam(required = false) Integer status,
                                                                     @RequestParam(required = false) String orderSn,
                                                                     @RequestParam(defaultValue = "1") int pageNum,
                                                                     @RequestParam(defaultValue = "10") int pageSize) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        log.info("[售后列表] merchantId={}, type={}, status={}, orderSn={}, pageNum={}, pageSize={}",
                merchantId, type, status, orderSn, pageNum, pageSize);
        try {
            PageResult<Map<String, Object>> pageResult = afterSaleService.getAfterSaleList(
                    merchantId, type, status, orderSn, pageNum, pageSize);
            log.info("[售后列表] 成功, merchantId={}, total={}, count={}",
                    merchantId, pageResult.getTotal(), pageResult.getList().size());
            return Result.success(pageResult);
        } catch (RuntimeException e) {
            log.warn("[售后列表] 失败, merchantId={}, 原因: {}", merchantId, e.getMessage());
            throw e;
        }
    }

    // ==================== 13. 售后详情 ====================

    @GetMapping("/after-sales/{afterSaleId}")
    public Result<Map<String, Object>> getAfterSaleDetail(HttpServletRequest request,
                                                           @PathVariable Long afterSaleId) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        log.info("[售后详情] merchantId={}, afterSaleId={}", merchantId, afterSaleId);
        try {
            Map<String, Object> detail = afterSaleService.getAfterSaleDetail(merchantId, afterSaleId);
            log.info("[售后详情] 成功, afterSaleId={}, orderSn={}", afterSaleId, detail.get("orderSn"));
            return Result.success(detail);
        } catch (RuntimeException e) {
            log.warn("[售后详情] 失败, merchantId={}, afterSaleId={}, 原因: {}", merchantId, afterSaleId, e.getMessage());
            throw e;
        }
    }

    // ==================== 14. 售后审核 ====================

    @PostMapping("/after-sales/{afterSaleId}/audit")
    public Result<Map<String, Object>> auditAfterSale(HttpServletRequest request,
                                                       @PathVariable Long afterSaleId,
                                                       @RequestBody AfterSaleAuditRequest req) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        log.info("[售后审核] merchantId={}, afterSaleId={}, action={}, remark={}, actualRefundAmount={}",
                merchantId, afterSaleId, req.getAction(), req.getRemark(), req.getActualRefundAmount());
        try {
            Map<String, Object> result = afterSaleService.auditAfterSale(
                    merchantId, afterSaleId, req.getAction(), req.getRemark(), req.getActualRefundAmount());
            log.info("[售后审核] 成功, afterSaleId={}, newStatus={}", afterSaleId, result.get("newStatus"));
            return Result.success(result);
        } catch (RuntimeException e) {
            log.warn("[售后审核] 失败, merchantId={}, afterSaleId={}, 原因: {}", merchantId, afterSaleId, e.getMessage());
            throw e;
        }
    }

    // ==================== 15. 退货确认 ====================

    @PostMapping("/after-sales/{afterSaleId}/return-confirm")
    public Result<Map<String, Object>> returnConfirm(HttpServletRequest request,
                                                      @PathVariable Long afterSaleId,
                                                      @RequestBody AfterSaleReturnConfirmRequest req) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        log.info("[退货确认] merchantId={}, afterSaleId={}, receivedStatus={}, remark={}",
                merchantId, afterSaleId, req.getReceivedStatus(), req.getRemark());
        try {
            Map<String, Object> result = afterSaleService.returnConfirm(
                    merchantId, afterSaleId, req.getReceivedStatus(), req.getRemark());
            log.info("[退货确认] 成功, afterSaleId={}, newStatus={}", afterSaleId, result.get("newStatus"));
            return Result.success(result);
        } catch (RuntimeException e) {
            log.warn("[退货确认] 失败, merchantId={}, afterSaleId={}, 原因: {}", merchantId, afterSaleId, e.getMessage());
            throw e;
        }
    }

    // ==================== 16. 添加工单反馈 ====================

    @PostMapping("/after-sales/{afterSaleId}/feedback")
    public Result<Map<String, Object>> addFeedback(HttpServletRequest request,
                                                    @PathVariable Long afterSaleId,
                                                    @RequestBody AfterSaleFeedbackRequest req) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        String imagesJson = null;
        try {
            if (req.getImages() != null) {
                imagesJson = OBJECT_MAPPER.writeValueAsString(req.getImages());
            }
        } catch (Exception e) {
            log.warn("[售后反馈] 图片序列化失败, images={}, 原因: {}", req.getImages(), e.getMessage());
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "图片数据格式错误");
        }
        log.info("[售后反馈] merchantId={}, afterSaleId={}, content={}, imagesJson={}",
                merchantId, afterSaleId, req.getContent(), imagesJson);
        try {
            Map<String, Object> result = afterSaleService.addFeedback(
                    merchantId, afterSaleId, req.getContent(), imagesJson);
            log.info("[售后反馈] 成功, afterSaleId={}", afterSaleId);
            return Result.success(result);
        } catch (RuntimeException e) {
            log.warn("[售后反馈] 失败, merchantId={}, afterSaleId={}, 原因: {}", merchantId, afterSaleId, e.getMessage());
            throw e;
        }
    }

    // ==================== 17. 收益列表 ====================

    @GetMapping("/earnings")
    public Result<Map<String, Object>> getEarningsList(HttpServletRequest request,
                                                        @RequestParam(required = false) Integer status,
                                                        @RequestParam(defaultValue = "1") int pageNum,
                                                        @RequestParam(defaultValue = "10") int pageSize) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        log.info("[收益列表] merchantId={}, status={}, pageNum={}, pageSize={}",
                merchantId, status, pageNum, pageSize);
        try {
            Map<String, Object> result = earningsService.getEarningsList(merchantId, status, pageNum, pageSize);
            log.info("[收益列表] 成功, merchantId={}, total={}, totalAvailable={}",
                    merchantId, result.get("total"), result.get("totalAvailable"));
            return Result.success(result);
        } catch (RuntimeException e) {
            log.warn("[收益列表] 失败, merchantId={}, 原因: {}", merchantId, e.getMessage());
            throw e;
        }
    }

    // ==================== 18. 提现申请 ====================

    @PostMapping("/earnings/withdraw")
    public Result<Map<String, Object>> withdraw(HttpServletRequest request,
                                                 @RequestBody WithdrawRequest req) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        log.info("[提现申请] merchantId={}, bankCardNumber={}, accountName={}, bankName={}",
                merchantId, req.getBankCardNumber(), req.getAccountName(), req.getBankName());
        try {
            Map<String, Object> result = earningsService.withdraw(
                    merchantId, req.getBankCardNumber(), req.getAccountName(), req.getBankName());
            log.info("[提现申请] 成功, merchantId={}, withdrawalId={}, amount={}",
                    merchantId, result.get("withdrawalId"), result.get("amount"));
            return Result.success(result);
        } catch (RuntimeException e) {
            log.warn("[提现申请] 失败, merchantId={}, 原因: {}", merchantId, e.getMessage());
            throw e;
        }
    }

    // ==================== 19. 提现记录 ====================

    @GetMapping("/earnings/withdraw-records")
    public Result<PageResult<Map<String, Object>>> getWithdrawalRecords(HttpServletRequest request,
                                                                        @RequestParam(defaultValue = "1") int pageNum,
                                                                        @RequestParam(defaultValue = "10") int pageSize) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        log.info("[提现记录] merchantId={}, pageNum={}, pageSize={}", merchantId, pageNum, pageSize);
        try {
            PageResult<Map<String, Object>> pageResult = earningsService.getWithdrawalRecords(
                    merchantId, pageNum, pageSize);
            log.info("[提现记录] 成功, merchantId={}, total={}, count={}",
                    merchantId, pageResult.getTotal(), pageResult.getList().size());
            return Result.success(pageResult);
        } catch (RuntimeException e) {
            log.warn("[提现记录] 失败, merchantId={}, 原因: {}", merchantId, e.getMessage());
            throw e;
        }
    }

    // ==================== 20. 自提点列表 ====================

    @GetMapping("/pickup-points")
    public Result<List<Map<String, Object>>> listPickupPoints(HttpServletRequest request) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        log.info("[自提点列表] merchantId={}", merchantId);
        try {
            List<Map<String, Object>> points = pickupPointService.listPickupPoints(merchantId);
            log.info("[自提点列表] 成功, merchantId={}, count={}", merchantId, points.size());
            return Result.success(points);
        } catch (RuntimeException e) {
            log.warn("[自提点列表] 失败, merchantId={}, 原因: {}", merchantId, e.getMessage());
            throw e;
        }
    }

    // ==================== 21. 新增自提点 ====================

    @PostMapping("/pickup-points")
    public Result<Map<String, Object>> addPickupPoint(HttpServletRequest request,
                                                       @RequestBody Map<String, Object> body) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        String name = (String) body.get("name");
        String address = (String) body.get("address");
        String contactPhone = (String) body.get("contactPhone");
        String image = (String) body.get("image");
        log.info("[新增自提点] merchantId={}, name={}, address={}", merchantId, name, address);
        try {
            Map<String, Object> result = pickupPointService.addPickupPoint(merchantId, name, address, contactPhone, image);
            log.info("[新增自提点] 成功, pointId={}", result.get("id"));
            return Result.success(result);
        } catch (RuntimeException e) {
            log.warn("[新增自提点] 失败, merchantId={}, 原因: {}", merchantId, e.getMessage());
            throw e;
        }
    }

    // ==================== 22. 删除自提点 ====================

    @DeleteMapping("/pickup-points/{pointId}")
    public Result<Map<String, Object>> deletePickupPoint(HttpServletRequest request,
                                                          @PathVariable Long pointId) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        log.info("[删除自提点] merchantId={}, pointId={}", merchantId, pointId);
        try {
            Map<String, Object> result = pickupPointService.deletePickupPoint(merchantId, pointId);
            log.info("[删除自提点] 成功, pointId={}", pointId);
            return Result.success(result);
        } catch (RuntimeException e) {
            log.warn("[删除自提点] 失败, merchantId={}, pointId={}, 原因: {}", merchantId, pointId, e.getMessage());
            throw e;
        }
    }

    // ==================== Helper Methods ====================

    private String getDeliveryStatusText(Integer status) {
        if (status == null) {
            return "";
        }
        switch (status) {
            case 1:
                return "待配送";
            case 2:
                return "已分配骑手";
            case 3:
                return "配送中";
            case 4:
                return "已送达";
            default:
                return "";
        }
    }

    private String formatDateTime(LocalDateTime dt) {
        if (dt == null) {
            return null;
        }
        return dt.format(FORMATTER);
    }
}
