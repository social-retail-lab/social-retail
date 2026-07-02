package com.socialretail.backend.service.merchant.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.entity.order.MerchantEarnings;
import com.socialretail.backend.entity.order.Order;
import com.socialretail.backend.entity.order.WithdrawalRecord;
import com.socialretail.backend.mapper.member.MerchantMapper;
import com.socialretail.backend.mapper.order.MerchantEarningsMapper;
import com.socialretail.backend.mapper.order.OrderMapper;
import com.socialretail.backend.mapper.order.WithdrawalRecordMapper;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
public class EarningsServiceImpl {

    @Resource
    private MerchantEarningsMapper merchantEarningsMapper;

    @Resource
    private WithdrawalRecordMapper withdrawalRecordMapper;

    @Resource
    private OrderMapper orderMapper;

    @Resource
    private MerchantMapper merchantMapper;

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    /**
     * 获取收益列表
     */
    public Map<String, Object> getEarningsList(Long merchantId, Integer status, int pageNum, int pageSize) {
        LambdaQueryWrapper<MerchantEarnings> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(MerchantEarnings::getMerchantId, merchantId);

        if (status != null) {
            wrapper.eq(MerchantEarnings::getStatus, status);
        }

        wrapper.orderByDesc(MerchantEarnings::getCreateTime);

        Page<MerchantEarnings> page = new Page<>(pageNum, pageSize);
        Page<MerchantEarnings> earningsPage = merchantEarningsMapper.selectPage(page, wrapper);

        List<Map<String, Object>> resultList = new ArrayList<>();
        for (MerchantEarnings earnings : earningsPage.getRecords()) {
            Map<String, Object> map = new HashMap<>();
            map.put("earningsId", earnings.getId());
            map.put("orderSn", earnings.getOrderSn());
            map.put("amount", earnings.getAmount());
            map.put("status", earnings.getStatus());
            map.put("statusText", earningsStatusText(earnings.getStatus()));
            map.put("freezeTime", formatDateTime(earnings.getFreezeTime()));
            map.put("unfreezeTime", formatDateTime(earnings.getUnfreezeTime()));
            map.put("createTime", formatDateTime(earnings.getCreateTime()));

            // 查询订单时间
            if (earnings.getOrderId() != null) {
                Order order = orderMapper.selectById(earnings.getOrderId());
                map.put("orderTime", order != null ? formatDateTime(order.getCreateTime()) : null);
            } else {
                map.put("orderTime", null);
            }
            resultList.add(map);
        }

        // 计算可提现金额（status=1）
        LambdaQueryWrapper<MerchantEarnings> availableWrapper = new LambdaQueryWrapper<>();
        availableWrapper.eq(MerchantEarnings::getMerchantId, merchantId);
        availableWrapper.eq(MerchantEarnings::getStatus, 1);
        List<MerchantEarnings> availableEarnings = merchantEarningsMapper.selectList(availableWrapper);
        BigDecimal totalAvailable = availableEarnings.stream()
                .map(MerchantEarnings::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        // 计算冻结金额（status=0）
        LambdaQueryWrapper<MerchantEarnings> frozenWrapper = new LambdaQueryWrapper<>();
        frozenWrapper.eq(MerchantEarnings::getMerchantId, merchantId);
        frozenWrapper.eq(MerchantEarnings::getStatus, 0);
        List<MerchantEarnings> frozenEarnings = merchantEarningsMapper.selectList(frozenWrapper);
        BigDecimal totalFrozen = frozenEarnings.stream()
                .map(MerchantEarnings::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        Map<String, Object> result = new HashMap<>();
        result.put("list", resultList);
        result.put("total", earningsPage.getTotal());
        result.put("pageNum", pageNum);
        result.put("pageSize", pageSize);
        result.put("totalAvailable", totalAvailable);
        result.put("totalFrozen", totalFrozen);

        return result;
    }

    /**
     * 提现申请
     */
    public Map<String, Object> withdraw(Long merchantId, String bankCardNumber, String accountName, String bankName) {
        // 计算可提现金额
        LambdaQueryWrapper<MerchantEarnings> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(MerchantEarnings::getMerchantId, merchantId);
        wrapper.eq(MerchantEarnings::getStatus, 1);
        List<MerchantEarnings> availableEarnings = merchantEarningsMapper.selectList(wrapper);

        BigDecimal totalAvailable = availableEarnings.stream()
                .map(MerchantEarnings::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        if (totalAvailable.compareTo(BigDecimal.ZERO) <= 0) {
            throw new BusinessException(400, HttpStatus.BAD_REQUEST, "无可提现金额");
        }

        // 创建提现记录
        WithdrawalRecord record = new WithdrawalRecord();
        record.setMerchantId(merchantId);
        record.setAmount(totalAvailable);
        record.setBankCardNumber(bankCardNumber);
        record.setAccountName(accountName);
        record.setBankName(bankName);
        record.setStatus(0);
        record.setApplyTime(LocalDateTime.now());
        withdrawalRecordMapper.insert(record);

        // 更新所有可提现收益为已提现
        LocalDateTime now = LocalDateTime.now();
        for (MerchantEarnings earnings : availableEarnings) {
            earnings.setStatus(2);
            earnings.setWithdrawTime(now);
            merchantEarningsMapper.updateById(earnings);
        }

        log.info("商户 {} 提现成功，提现ID：{}，金额：{}", merchantId, record.getId(), totalAvailable);

        Map<String, Object> result = new HashMap<>();
        result.put("withdrawalId", record.getId());
        result.put("amount", totalAvailable);
        result.put("status", 0);
        result.put("message", "提现申请已提交");

        return result;
    }

    /**
     * 获取提现记录列表
     */
    public PageResult<Map<String, Object>> getWithdrawalRecords(Long merchantId, int pageNum, int pageSize) {
        LambdaQueryWrapper<WithdrawalRecord> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(WithdrawalRecord::getMerchantId, merchantId);
        wrapper.orderByDesc(WithdrawalRecord::getApplyTime);

        Page<WithdrawalRecord> page = new Page<>(pageNum, pageSize);
        Page<WithdrawalRecord> recordPage = withdrawalRecordMapper.selectPage(page, wrapper);

        List<Map<String, Object>> resultList = new ArrayList<>();
        for (WithdrawalRecord record : recordPage.getRecords()) {
            Map<String, Object> map = new HashMap<>();
            map.put("withdrawalId", record.getId());
            map.put("amount", record.getAmount());
            map.put("bankCardNumber", maskBankCard(record.getBankCardNumber()));
            map.put("accountName", record.getAccountName());
            map.put("bankName", record.getBankName());
            map.put("status", record.getStatus());
            map.put("statusText", record.getStatus() != null && record.getStatus() == 0 ? "处理中" : "已汇款");
            map.put("applyTime", formatDateTime(record.getApplyTime()));
            map.put("processTime", formatDateTime(record.getProcessTime()));
            resultList.add(map);
        }

        return PageResult.of(resultList, recordPage.getTotal(), pageNum, pageSize);
    }

    // ==================== Helper Methods ====================

    private String formatDateTime(LocalDateTime dt) {
        if (dt == null) {
            return null;
        }
        return dt.format(FORMATTER);
    }

    private String maskBankCard(String cardNumber) {
        if (cardNumber == null || cardNumber.length() < 8) {
            return cardNumber == null ? "" : cardNumber;
        }
        return cardNumber.substring(0, 4) + "****" + cardNumber.substring(cardNumber.length() - 4);
    }

    private String earningsStatusText(Integer status) {
        if (status == null) {
            return "";
        }
        switch (status) {
            case 0:
                return "冻结中";
            case 1:
                return "可提现";
            case 2:
                return "已提现";
            default:
                return "";
        }
    }
}
