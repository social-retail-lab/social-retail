package com.socialretail.backend.mapper.order;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.socialretail.backend.entity.order.AfterSale;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Mapper
public interface AfterSaleMapper extends BaseMapper<AfterSale> {
    @Select("""
            SELECT a.*, i.product_image
            FROM after_sale a
            JOIN `order` o ON o.id = a.order_id
            LEFT JOIN order_item i ON i.id = a.order_item_id
            WHERE o.user_id = #{userId} AND COALESCE(a.is_deleted, 0) = 0
              AND (#{status} IS NULL OR a.status = #{status})
            ORDER BY a.apply_time DESC, a.id DESC LIMIT #{offset}, #{pageSize}
            """)
    List<Map<String, Object>> selectUserPage(@Param("userId") Long userId,
                                             @Param("status") Integer status,
                                             @Param("offset") int offset,
                                             @Param("pageSize") int pageSize);

    @Select("""
            SELECT COUNT(*) FROM after_sale a JOIN `order` o ON o.id = a.order_id
            WHERE o.user_id = #{userId} AND COALESCE(a.is_deleted, 0) = 0
              AND (#{status} IS NULL OR a.status = #{status})
            """)
    long countUserPage(@Param("userId") Long userId, @Param("status") Integer status);

    @Select("""
            SELECT a.*, i.product_image FROM after_sale a
            JOIN `order` o ON o.id = a.order_id
            LEFT JOIN order_item i ON i.id = a.order_item_id
            WHERE a.id = #{id} AND o.user_id = #{userId} AND COALESCE(a.is_deleted, 0) = 0 LIMIT 1
            """)
    Map<String, Object> selectUserDetail(@Param("id") Long id, @Param("userId") Long userId);

    @Select("""
            SELECT COUNT(*) FROM after_sale
            WHERE order_item_id = #{orderItemId} AND COALESCE(is_deleted, 0) = 0
              AND (status IN (1, 2, 4) OR refund_status = 2)
            """)
    int countActiveByOrderItemId(@Param("orderItemId") Long orderItemId);

    @Update("""
            UPDATE after_sale SET status = 7, audit_remark = #{reason}, update_time = #{now}
            WHERE id = #{id}
              AND status = 1
              AND audit_status = 0
              AND refund_status = 0
              AND COALESCE(is_deleted, 0) = 0
              AND EXISTS (SELECT 1 FROM `order` o WHERE o.id = after_sale.order_id AND o.user_id = #{userId})
            """)
    int cancelApplying(@Param("id") Long id, @Param("userId") Long userId,
                       @Param("reason") String reason, @Param("now") LocalDateTime now);

    @Update("""
            UPDATE after_sale SET evidence_images = #{images}, update_time = #{now}
            WHERE id = #{id} AND COALESCE(is_deleted, 0) = 0 AND status IN (1, 2)
              AND EXISTS (SELECT 1 FROM `order` o WHERE o.id = after_sale.order_id AND o.user_id = #{userId})
            """)
    int updateUserImages(@Param("id") Long id, @Param("userId") Long userId,
                         @Param("images") String images, @Param("now") LocalDateTime now);

    @Update("""
            UPDATE after_sale SET audit_status = #{auditStatus}, status = #{status},
                audit_remark = #{remark}, reject_reason = #{rejectReason}, audit_time = #{now}, update_time = #{now}
            WHERE id = #{id} AND audit_status = 0 AND status = 1 AND refund_status = 0
            """)
    int recordAudit(@Param("id") Long id, @Param("auditStatus") int auditStatus,
                    @Param("status") int status, @Param("remark") String remark,
                    @Param("rejectReason") String rejectReason, @Param("now") LocalDateTime now);

    @Update("""
            UPDATE after_sale SET status = 4, refund_status = 1, update_time = #{now}
            WHERE id = #{id} AND audit_status = 1 AND status = 2 AND refund_status = 0
            """)
    int claimRefund(@Param("id") Long id, @Param("now") LocalDateTime now);

    @Update("""
            UPDATE after_sale SET status = #{status}, refund_status = #{refundStatus},
                actual_refund_amount = CASE WHEN #{refundStatus} = 2 THEN refund_amount ELSE actual_refund_amount END,
                complete_time = #{now}, update_time = #{now}, audit_remark = COALESCE(#{message}, audit_remark)
            WHERE id = #{id} AND status = 4 AND refund_status = 1
            """)
    int finishRefund(@Param("id") Long id, @Param("status") int status,
                     @Param("refundStatus") int refundStatus, @Param("message") String message,
                     @Param("now") LocalDateTime now);
}
