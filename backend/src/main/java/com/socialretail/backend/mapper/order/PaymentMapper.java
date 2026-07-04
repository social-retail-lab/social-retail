package com.socialretail.backend.mapper.order;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.socialretail.backend.entity.order.Payment;
import com.socialretail.backend.vo.payment.PaymentDetailVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;

@Mapper
public interface PaymentMapper extends BaseMapper<Payment> {

    Payment selectLatestByOrderIdAndUserId(@Param("orderId") Long orderId,
                                           @Param("userId") Long userId);

    Payment selectLatestByOrderIdForUpdate(@Param("orderId") Long orderId);

    Payment selectByPaySn(@Param("paySn") String paySn);

    Payment selectByPaySnForUpdate(@Param("paySn") String paySn);

    PaymentDetailVO selectDetailByIdAndUserId(@Param("paymentId") Long paymentId,
                                              @Param("userId") Long userId);

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
