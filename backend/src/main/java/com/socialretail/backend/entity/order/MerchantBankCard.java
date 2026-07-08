package com.socialretail.backend.entity.order;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.time.LocalDateTime;

@TableName("merchant_bank_card")
public class MerchantBankCard {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 商家ID */
    private Long merchantId;

    /** 开户银行名称 */
    private String bankName;

    /** 银行卡号 */
    private String bankCardNumber;

    /** 开户人姓名 */
    private String accountName;

    /** 绑定时间 */
    private LocalDateTime createTime;

    /** 更新时间 */
    private LocalDateTime updateTime;

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

    public String getBankName() {
        return bankName;
    }

    public void setBankName(String bankName) {
        this.bankName = bankName;
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

    public LocalDateTime getCreateTime() {
        return createTime;
    }

    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }

    public LocalDateTime getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(LocalDateTime updateTime) {
        this.updateTime = updateTime;
    }

    @Override
    public String toString() {
        return "MerchantBankCard{" +
            ", id=" + id +
            ", merchantId=" + merchantId +
            ", bankName=" + bankName +
            ", bankCardNumber=" + bankCardNumber +
            ", accountName=" + accountName +
            ", createTime=" + createTime +
            ", updateTime=" + updateTime +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        MerchantBankCard that = (MerchantBankCard) o;
        return java.util.Objects.equals(id, that.id)
                && java.util.Objects.equals(merchantId, that.merchantId)
                && java.util.Objects.equals(bankName, that.bankName)
                && java.util.Objects.equals(bankCardNumber, that.bankCardNumber)
                && java.util.Objects.equals(accountName, that.accountName)
                && java.util.Objects.equals(createTime, that.createTime)
                && java.util.Objects.equals(updateTime, that.updateTime);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(id, merchantId, bankName, bankCardNumber, accountName, createTime, updateTime);
    }
}
