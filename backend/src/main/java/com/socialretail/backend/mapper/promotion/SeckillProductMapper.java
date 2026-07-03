package com.socialretail.backend.mapper.promotion;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.socialretail.backend.dto.promotion.SeckillProductView;
import com.socialretail.backend.entity.promotion.SeckillProduct;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import java.util.List;

@Mapper
public interface SeckillProductMapper extends BaseMapper<SeckillProduct> {
    String VIEW_COLUMNS = """
            sp.id AS seckill_product_id, sp.seckill_activity_id AS activity_id,
            a.title AS activity_title, a.start_time, a.end_time,
            sp.product_id, sp.sku_id, p.title AS product_name, p.main_image AS product_image,
            s.specs AS sku_specs, s.price AS origin_price, sp.seckill_price,
            sp.seckill_stock, COALESCE(sp.sold_count, 0) AS sold_count,
            COALESCE(sp.limit_quantity, 1) AS limit_quantity,
            p.status AS product_status, p.audit_status AS product_audit_status,
            COALESCE(sp.status, 1) AS seckill_product_status
            """;

    @Select("SELECT " + VIEW_COLUMNS + " FROM seckill_product sp " +
            "JOIN seckill_activity a ON a.id=sp.seckill_activity_id " +
            "JOIN product p ON p.id=sp.product_id JOIN sku s ON s.id=sp.sku_id " +
            "WHERE sp.seckill_activity_id=#{activityId} AND COALESCE(sp.status,1)=1 " +
            "AND p.status=1 AND p.audit_status=1 ORDER BY sp.id LIMIT #{offset},#{pageSize}")
    List<SeckillProductView> selectPageView(@Param("activityId") Long activityId,
                                            @Param("offset") long offset,
                                            @Param("pageSize") int pageSize);

    @Select("SELECT COUNT(*) FROM seckill_product sp JOIN product p ON p.id=sp.product_id " +
            "WHERE sp.seckill_activity_id=#{activityId} AND COALESCE(sp.status,1)=1 " +
            "AND p.status=1 AND p.audit_status=1")
    long countEnabled(@Param("activityId") Long activityId);

    @Select("SELECT " + VIEW_COLUMNS + " FROM seckill_product sp " +
            "JOIN seckill_activity a ON a.id=sp.seckill_activity_id " +
            "JOIN product p ON p.id=sp.product_id JOIN sku s ON s.id=sp.sku_id " +
            "WHERE sp.id=#{seckillProductId} LIMIT 1")
    SeckillProductView selectViewById(@Param("seckillProductId") Long seckillProductId);

    @Select("SELECT COALESCE(SUM(oi.quantity),0) FROM `order` o " +
            "JOIN order_item oi ON oi.order_id=o.id " +
            "WHERE o.user_id=#{userId} AND o.seckill_id=#{activityId} " +
            "AND oi.sku_id=#{skuId} AND o.status NOT IN (5,6)")
    int sumBoughtQuantity(@Param("userId") Long userId,
                          @Param("activityId") Long activityId,
                          @Param("skuId") Long skuId);

    @Select("SELECT " + VIEW_COLUMNS + " FROM seckill_product sp " +
            "JOIN seckill_activity a ON a.id=sp.seckill_activity_id " +
            "JOIN product p ON p.id=sp.product_id JOIN sku s ON s.id=sp.sku_id " +
            "WHERE sp.seckill_activity_id=#{activityId} AND COALESCE(sp.status,1)=1")
    List<SeckillProductView> selectAllEnabled(@Param("activityId") Long activityId);
}
