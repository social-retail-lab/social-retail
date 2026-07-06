package com.socialretail.backend.controller.merchant;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.Result;
import com.socialretail.backend.entity.order.MerchantBankCard;
import com.socialretail.backend.entity.order.MerchantEarnings;
import com.socialretail.backend.entity.order.WithdrawalRecord;
import com.socialretail.backend.mapper.order.MerchantBankCardMapper;
import com.socialretail.backend.mapper.order.MerchantEarningsMapper;
import com.socialretail.backend.mapper.order.WithdrawalRecordMapper;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/merchant")
public class MerchantEarningsController {

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(MerchantEarningsController.class);

    @Resource
    private MerchantEarningsMapper merchantEarningsMapper;

    @Resource
    private WithdrawalRecordMapper withdrawalRecordMapper;

    @Resource
    private MerchantBankCardMapper bankCardMapper;

    @Autowired(required = false)
    private StringRedisTemplate stringRedisTemplate;

    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    // ========== 银行卡信息 ==========
    @GetMapping("/bank-card")
    public Result<?> getBankCard(HttpServletRequest request) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        LambdaQueryWrapper<MerchantBankCard> wrapper = new LambdaQueryWrapper<MerchantBankCard>()
                .eq(MerchantBankCard::getMerchantId, merchantId);
        MerchantBankCard card = bankCardMapper.selectOne(wrapper);
        if (card == null) {
            return Result.ok(null);
        }
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("id", card.getId());
        data.put("bankName", card.getBankName());
        data.put("bankCardNumber", card.getBankCardNumber());
        data.put("accountName", card.getAccountName());
        data.put("maskedCardNumber", maskCardNumber(card.getBankCardNumber()));
        return Result.ok(data);
    }

    @PostMapping("/bank-card")
    public Result<?> saveBankCard(HttpServletRequest request, @RequestBody Map<String, String> body) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        String bankName = body.get("bankName");
        String bankCardNumber = body.get("bankCardNumber");
        String accountName = body.get("accountName");

        if (bankName == null || bankName.isBlank()) return Result.error("请输入开户银行");
        if (bankCardNumber == null || !bankCardNumber.matches("\\d{16,19}")) return Result.error("请输入正确的银行卡号");
        if (accountName == null || accountName.isBlank()) return Result.error("请输入开户人姓名");

        LambdaQueryWrapper<MerchantBankCard> wrapper = new LambdaQueryWrapper<MerchantBankCard>()
                .eq(MerchantBankCard::getMerchantId, merchantId);
        MerchantBankCard existing = bankCardMapper.selectOne(wrapper);

        if (existing != null) {
            existing.setBankName(bankName);
            existing.setBankCardNumber(bankCardNumber);
            existing.setAccountName(accountName);
            bankCardMapper.updateById(existing);
            log.info("[银行卡] 更新成功 merchantId={}", merchantId);
        } else {
            MerchantBankCard card = new MerchantBankCard();
            card.setMerchantId(merchantId);
            card.setBankName(bankName);
            card.setBankCardNumber(bankCardNumber);
            card.setAccountName(accountName);
            bankCardMapper.insert(card);
            log.info("[银行卡] 绑定成功 merchantId={}", merchantId);
        }
        return Result.ok("保存成功", null);
    }

    // ========== 发送短信验证码（模拟） ==========
    @PostMapping("/sms/send-verify-code")
    public Result<?> sendVerifyCode(HttpServletRequest request) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        String code = String.format("%06d", new Random().nextInt(1000000));
        log.info("[短信验证码] merchantId={}, code={}", merchantId, code);

        // 存入Redis，60秒有效
        if (stringRedisTemplate != null) {
            stringRedisTemplate.opsForValue().set("sms:withdraw:" + merchantId, code, 60, TimeUnit.SECONDS);
        } else {
            // 无Redis时存到内存（简化处理）
            request.getServletContext().setAttribute("sms:withdraw:" + merchantId, code);
        }
        return Result.ok("验证码已发送（模拟），请在60秒内输入", null);
    }

    // ========== 收益信息 & 收益列表 ==========
    @GetMapping("/earnings")
    public Result<?> getEarnings(HttpServletRequest request,
                                 @RequestParam(required = false) Integer page,
                                 @RequestParam(required = false) Integer pageSize) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        log.info("[收益查询] merchantId={}, page={}, pageSize={}", merchantId, page, pageSize);

        if (merchantId == null) {
            log.warn("[收益查询] merchantId为空");
            return Result.error("未获取到商家信息");
        }

        // 分页请求（收益明细列表）
        if (page != null && pageSize != null) {
            Page<MerchantEarnings> mpPage = new Page<>(page, pageSize);
            LambdaQueryWrapper<MerchantEarnings> wrapper = new LambdaQueryWrapper<MerchantEarnings>()
                    .eq(MerchantEarnings::getMerchantId, merchantId)
                    .orderByDesc(MerchantEarnings::getCreateTime);
            Page<MerchantEarnings> result = merchantEarningsMapper.selectPage(mpPage, wrapper);

            List<Map<String, Object>> list = result.getRecords().stream().map(e -> {
                Map<String, Object> map = new LinkedHashMap<>();
                map.put("earningsId", e.getId());
                map.put("orderSn", e.getOrderSn());
                map.put("amount", e.getAmount() != null ? e.getAmount() : BigDecimal.ZERO);
                map.put("status", e.getStatus());
                map.put("statusText", getStatusText(e.getStatus()));
                map.put("orderTime", e.getCreateTime() != null ? e.getCreateTime().format(FMT) : null);
                map.put("expectedTime", e.getUnfreezeTime() != null ? e.getUnfreezeTime().format(FMT) : null);
                return map;
            }).collect(Collectors.toList());

            log.info("[收益列表] merchantId={}, 记录数={}", merchantId, list.size());
            PageResult<Map<String, Object>> pageResult = PageResult.of(list, result.getTotal(), page, pageSize);
            return Result.ok(pageResult);
        }

        // 汇总信息
        LambdaQueryWrapper<MerchantEarnings> availableWrapper = new LambdaQueryWrapper<MerchantEarnings>()
                .eq(MerchantEarnings::getMerchantId, merchantId)
                .eq(MerchantEarnings::getStatus, 1);
        List<MerchantEarnings> availableList = merchantEarningsMapper.selectList(availableWrapper);
        BigDecimal availableAmount = BigDecimal.ZERO;
        for (MerchantEarnings e : availableList) {
            if (e.getAmount() != null) {
                availableAmount = availableAmount.add(e.getAmount());
            }
        }

        LambdaQueryWrapper<MerchantEarnings> pendingWrapper = new LambdaQueryWrapper<MerchantEarnings>()
                .eq(MerchantEarnings::getMerchantId, merchantId)
                .eq(MerchantEarnings::getStatus, 0);
        List<MerchantEarnings> pendingList = merchantEarningsMapper.selectList(pendingWrapper);
        BigDecimal pendingAmount = BigDecimal.ZERO;
        for (MerchantEarnings e : pendingList) {
            if (e.getAmount() != null) {
                pendingAmount = pendingAmount.add(e.getAmount());
            }
        }

        Map<String, Object> info = new LinkedHashMap<>();
        info.put("availableAmount", availableAmount);
        info.put("pendingAmount", pendingAmount);
        log.info("[收益信息] merchantId={}, availableCount={}, availableAmount={}, pendingCount={}, pendingAmount={}",
                merchantId, availableList.size(), availableAmount, pendingList.size(), pendingAmount);
        return Result.ok(info);
    }

    // ========== 申请提现 ==========
    @PostMapping("/earnings/withdraw")
    public Result<?> applyWithdraw(HttpServletRequest request, @RequestBody Map<String, Object> body) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        log.info("[申请提现] merchantId={}, body={}", merchantId, body);

        if (merchantId == null) {
            return Result.error("未获取到商家信息");
        }

        BigDecimal amount;
        try {
            amount = new BigDecimal(body.get("amount").toString());
        } catch (Exception e) {
            return Result.error("提现金额无效");
        }

        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            return Result.error("提现金额必须大于0");
        }

        // 校验银行卡
        String bankCardNumber = (String) body.get("bankCardNumber");
        String accountName = (String) body.get("accountName");
        String bankName = (String) body.get("bankName");

        if (bankCardNumber == null || bankCardNumber.isBlank()) {
            return Result.error("请先绑定银行卡");
        }

        // 校验验证码
        String verifyCode = (String) body.get("verifyCode");
        if (verifyCode == null || verifyCode.isBlank()) {
            return Result.error("请输入短信验证码");
        }

        String cachedCode = null;
        if (stringRedisTemplate != null) {
            cachedCode = stringRedisTemplate.opsForValue().get("sms:withdraw:" + merchantId);
        } else {
            cachedCode = (String) request.getServletContext().getAttribute("sms:withdraw:" + merchantId);
        }

        // 模拟验证：任意6位数字都能通过
        if (!verifyCode.matches("\\d{6}")) {
            return Result.error("验证码格式不正确，请输入6位数字");
        }

        // 模拟验证码校验（开发环境任意6位数字都通过）
        if (cachedCode != null && !verifyCode.equals(cachedCode)) {
            log.info("[提现验证] 验证码不匹配, cached={}, input={}", cachedCode, verifyCode);
            // 模拟模式下不真正拒绝，仅记录日志
        }

        // 校验可提现金额
        LambdaQueryWrapper<MerchantEarnings> availableWrapper = new LambdaQueryWrapper<MerchantEarnings>()
                .eq(MerchantEarnings::getMerchantId, merchantId)
                .eq(MerchantEarnings::getStatus, 1);
        List<MerchantEarnings> availableList = merchantEarningsMapper.selectList(availableWrapper);
        BigDecimal availableAmount = BigDecimal.ZERO;
        for (MerchantEarnings e : availableList) {
            if (e.getAmount() != null) {
                availableAmount = availableAmount.add(e.getAmount());
            }
        }

        if (amount.compareTo(availableAmount) > 0) {
            return Result.error("可提现金额不足，当前可提现：" + availableAmount);
        }

        // 从可提现收益中按顺序扣除指定金额
        BigDecimal remaining = amount;
        LocalDateTime now = LocalDateTime.now();
        for (MerchantEarnings e : availableList) {
            if (remaining.compareTo(BigDecimal.ZERO) <= 0) break;
            BigDecimal earnAmount = e.getAmount() != null ? e.getAmount() : BigDecimal.ZERO;
            if (earnAmount.compareTo(remaining) <= 0) {
                // 整笔扣除
                e.setStatus(2);
                e.setWithdrawTime(now);
                merchantEarningsMapper.updateById(e);
                remaining = remaining.subtract(earnAmount);
            } else {
                // 部分扣除：拆分该笔收益
                e.setAmount(earnAmount.subtract(remaining));
                merchantEarningsMapper.updateById(e);
                // 已提现部分作为新记录
                MerchantEarnings withdrawnPart = new MerchantEarnings();
                withdrawnPart.setMerchantId(e.getMerchantId());
                withdrawnPart.setOrderId(e.getOrderId());
                withdrawnPart.setOrderSn(e.getOrderSn());
                withdrawnPart.setAmount(remaining);
                withdrawnPart.setStatus(2);
                withdrawnPart.setCreateTime(e.getCreateTime());
                withdrawnPart.setWithdrawTime(now);
                merchantEarningsMapper.insert(withdrawnPart);
                remaining = BigDecimal.ZERO;
            }
        }

        // 插入提现记录
        WithdrawalRecord record = new WithdrawalRecord();
        record.setMerchantId(merchantId);
        record.setAmount(amount);
        record.setBankCardNumber(bankCardNumber);
        record.setAccountName(accountName != null ? accountName : "");
        record.setBankName(bankName != null ? bankName : "");
        record.setStatus(0);
        record.setApplyTime(now);
        withdrawalRecordMapper.insert(record);

        log.info("[申请提现] 成功, merchantId={}, amount={}, card={}", merchantId, amount, maskCardNumber(bankCardNumber));
        return Result.ok("提现申请已提交，预计1-3个工作日到账", null);
    }

    // ========== 提现记录 ==========
    @GetMapping("/earnings/withdraw-records")
    public Result<?> getWithdrawRecords(HttpServletRequest request,
                                        @RequestParam(defaultValue = "1") int page,
                                        @RequestParam(defaultValue = "20") int pageSize) {
        Long merchantId = (Long) request.getAttribute("merchantId");

        Page<WithdrawalRecord> mpPage = new Page<>(page, pageSize);
        LambdaQueryWrapper<WithdrawalRecord> wrapper = new LambdaQueryWrapper<WithdrawalRecord>()
                .eq(WithdrawalRecord::getMerchantId, merchantId)
                .orderByDesc(WithdrawalRecord::getApplyTime);
        Page<WithdrawalRecord> result = withdrawalRecordMapper.selectPage(mpPage, wrapper);

        List<Map<String, Object>> list = result.getRecords().stream().map(r -> {
            Map<String, Object> map = new LinkedHashMap<>();
            map.put("withdrawalId", r.getId());
            map.put("amount", r.getAmount());
            map.put("bankCardNumber", maskCardNumber(r.getBankCardNumber()));
            map.put("accountName", r.getAccountName());
            map.put("bankName", r.getBankName());
            map.put("status", r.getStatus());
            map.put("statusText", getWithdrawStatusText(r.getStatus()));
            map.put("applyTime", r.getApplyTime() != null ? r.getApplyTime().format(FMT) : null);
            map.put("processTime", r.getProcessTime() != null ? r.getProcessTime().format(FMT) : null);
            return map;
        }).collect(Collectors.toList());

        return Result.ok(PageResult.of(list, result.getTotal(), page, pageSize));
    }

    // ========== 工具函数 ==========
    private String getStatusText(Integer status) {
        if (status == null) return "未知";
        switch (status) {
            case 0: return "冻结中";
            case 1: return "可提现";
            case 2: return "已提现";
            default: return "未知";
        }
    }

    private String getWithdrawStatusText(Integer status) {
        if (status == null) return "未知";
        switch (status) {
            case 0: return "处理中";
            case 1: return "已汇款";
            case 2: return "失败";
            default: return "未知";
        }
    }

    private String maskCardNumber(String cardNo) {
        if (cardNo == null || cardNo.length() < 8) return cardNo != null ? cardNo : "****";
        return cardNo.substring(0, 4) + " **** **** " + cardNo.substring(cardNo.length() - 4);
    }
}

