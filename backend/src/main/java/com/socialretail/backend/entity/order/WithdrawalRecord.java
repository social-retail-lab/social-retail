package com.socialretail.backend.entity.order;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@TableName("withdrawal_record")
public class WithdrawalRecord {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 商家ID */
    private Long merchantId;

    /** 提现金额 */
    private BigDecimal amount;

    /** 银行卡号 */
    private String bankCardNumber;

    /** 开户人姓名 */
    private String accountName;

    /** 银行名称 */
    private String bankName;

    /** 状态 0-处理中 1-已汇款 2-失败 */
    private Integer status;

    /** 处理备注 */
    private String remark;

    /** 申请时间 */
    private LocalDateTime applyTime;

    /** 处理时间 */
    private LocalDateTime processTime;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getMerchantId() {
        return merchantId;
    }

    public void setMerchantId(Long merchantId) {
        this.merchantId = merchantId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getBankCardNumber() {
        return bankCardNumber;
    }

    public void setBankCardNumber(String bankCardNumber) {
        this.bankCardNumber = bankCardNumber;
    }

    public String getAccountName() {
        return accountName;
    }

    public void setAccountName(String accountName) {
        this.accountName = accountName;
    }

    public String getBankName() {
        return bankName;
    }

    public void setBankName(String bankName) {
        this.bankName = bankName;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public LocalDateTime getApplyTime() {
        return applyTime;
    }

    public void setApplyTime(LocalDateTime applyTime) {
        this.applyTime = applyTime;
    }

    public LocalDateTime getProcessTime() {
        return processTime;
    }

    public void setProcessTime(LocalDateTime processTime) {
        this.processTime = processTime;
    }

    @Override
    public String toString() {
        return "WithdrawalRecord{" +
            ", id=" + id +
            ", merchantId=" + merchantId +
            ", amount=" + amount +
            ", bankCardNumber=" + bankCardNumber +
            ", accountName=" + accountName +
            ", bankName=" + bankName +
            ", status=" + status +
            ", remark=" + remark +
            ", applyTime=" + applyTime +
            ", processTime=" + processTime +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        WithdrawalRecord that = (WithdrawalRecord) o;
        return java.util.Objects.equals(id, that.id)
                && java.util.Objects.equals(merchantId, that.merchantId)
                && java.util.Objects.equals(amount, that.amount)
                && java.util.Objects.equals(bankCardNumber, that.bankCardNumber)
                && java.util.Objects.equals(accountName, that.accountName)
                && java.util.Objects.equals(bankName, that.bankName)
                && java.util.Objects.equals(status, that.status)
                && java.util.Objects.equals(remark, that.remark)
                && java.util.Objects.equals(applyTime, that.applyTime)
                && java.util.Objects.equals(processTime, that.processTime);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(id, merchantId, amount, bankCardNumber, accountName, bankName, status, remark, applyTime, processTime);
    }
}
