package com.socialretail.backend.mapper;

import com.socialretail.backend.entity.Payment;
import com.socialretail.backend.vo.payment.PaymentDetailVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;

@Mapper
public interface PaymentMapper {
    int insert(Payment payment);

    Payment selectById(@Param("id") Long id);

    PaymentDetailVO selectDetailByIdAndUserId(@Param("paymentId") Long paymentId,
                                               @Param("userId") Long userId);

    Payment selectLatestByOrderId(@Param("orderId") Long orderId);

    Payment selectLatestByOrderIdAndUserId(@Param("orderId") Long orderId,
                                            @Param("userId") Long userId);

    Payment selectLatestByOrderIdForUpdate(@Param("orderId") Long orderId);

    Payment selectByPaySn(@Param("paySn") String paySn);

    Payment selectByPaySnForUpdate(@Param("paySn") String paySn);

    int updatePaid(@Param("paymentId") Long paymentId,
                   @Param("thirdTradeNo") String thirdTradeNo,
                   @Param("payTime") LocalDateTime payTime,
                   @Param("callbackTime") LocalDateTime callbackTime);

    int updateFailed(@Param("paymentId") Long paymentId,
                     @Param("failReason") String failReason,
                     @Param("updateTime") LocalDateTime updateTime);

    int updatePlatformAndPaid(@Param("paymentId") Long paymentId,
                              @Param("payPlatform") Integer payPlatform,
                              @Param("thirdTradeNo") String thirdTradeNo,
                              @Param("payTime") LocalDateTime payTime,
                              @Param("callbackTime") LocalDateTime callbackTime);

    int updatePlatformAndFailed(@Param("paymentId") Long paymentId,
                                @Param("payPlatform") Integer payPlatform,
                                @Param("failReason") String failReason,
                                @Param("updateTime") LocalDateTime updateTime);
}
