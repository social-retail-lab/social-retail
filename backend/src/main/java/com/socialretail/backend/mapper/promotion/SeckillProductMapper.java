package com.socialretail.backend.mapper.promotion;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.socialretail.backend.dto.promotion.SeckillProductView;
import com.socialretail.backend.entity.promotion.SeckillProduct;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import java.util.List;

@Mapper
public interface SeckillProductMapper extends BaseMapper<SeckillProduct> {
    String VIEW_COLUMNS = """
            sp.id AS seckill_product_id, sp.seckill_activity_id AS activity_id,
            a.title AS activity_title, a.start_time, a.end_time,
            sp.product_id, s.id AS sku_id, p.title AS product_name, p.sub_title,
            p.main_image AS product_image, p.merchant_id, p.sale_type,
            COALESCE(p.sold_count, 0) AS product_sold_count,
            COALESCE(p.create_time, p.update_time, p.audit_time) AS product_create_time,
            s.specs AS sku_specs, s.price AS origin_price, sp.seckill_price,
            sp.seckill_stock, COALESCE(sp.sold_count, 0) AS sold_count,
            COALESCE(sp.limit_quantity, 1) AS limit_quantity,
            p.status AS product_status, p.audit_status AS product_audit_status,
            COALESCE(sp.status, 1) AS seckill_product_status
            """;

    @Select("SELECT " + VIEW_COLUMNS + " FROM seckill_product sp " +
            "JOIN seckill_activity a ON a.id=sp.seckill_activity_id " +
            "JOIN product p ON p.id=sp.product_id JOIN sku s ON s.sku_code=sp.sku_id " +
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
            "JOIN product p ON p.id=sp.product_id JOIN sku s ON s.sku_code=sp.sku_id " +
            "WHERE sp.id=#{seckillProductId} LIMIT 1")
    SeckillProductView selectViewById(@Param("seckillProductId") Long seckillProductId);

    @Select("SELECT " + VIEW_COLUMNS + " FROM seckill_product sp " +
            "JOIN seckill_activity a ON a.id=sp.seckill_activity_id " +
            "JOIN product p ON p.id=sp.product_id JOIN sku s ON s.sku_code=sp.sku_id " +
            "WHERE s.id=#{skuId} AND COALESCE(sp.status,1)=1 AND a.status=1 " +
            "AND a.start_time<=#{now} AND a.end_time>#{now} " +
            "AND p.status=1 AND p.audit_status=1 ORDER BY sp.seckill_price,sp.id LIMIT 1")
    SeckillProductView selectCurrentViewBySku(@Param("skuId") Long skuId,
                                               @Param("now") java.time.LocalDateTime now);

    @Select("<script>SELECT " + VIEW_COLUMNS + " FROM seckill_product sp " +
            "JOIN seckill_activity a ON a.id=sp.seckill_activity_id " +
            "JOIN product p ON p.id=sp.product_id JOIN sku s ON s.sku_code=sp.sku_id " +
            "WHERE s.id IN <foreach collection='skuIds' item='skuId' open='(' separator=',' close=')'>#{skuId}</foreach> " +
            "AND COALESCE(sp.status,1)=1 AND a.status=1 " +
            "AND a.start_time&lt;=#{now} AND a.end_time&gt;#{now} " +
            "AND p.status=1 AND p.audit_status=1 " +
            "AND COALESCE(sp.sold_count,0)&lt;sp.seckill_stock " +
            "ORDER BY sp.seckill_price,sp.id</script>")
    List<SeckillProductView> selectCurrentViewsBySkuIds(@Param("skuIds") List<Long> skuIds,
                                                         @Param("now") java.time.LocalDateTime now);

    @Select("SELECT COALESCE(SUM(oi.quantity),0) FROM `order` o " +
            "JOIN order_item oi ON oi.order_id=o.id " +
            "WHERE o.user_id=#{userId} AND o.seckill_id=#{seckillProductId} " +
            "AND oi.sku_id=#{skuId} AND o.status NOT IN (5,6)")
    int sumBoughtQuantity(@Param("userId") Long userId,
                          @Param("seckillProductId") Long seckillProductId,
                          @Param("skuId") Long skuId);

    @Update("UPDATE seckill_product SET sold_count=COALESCE(sold_count,0)+#{quantity}, " +
            "update_time=NOW() WHERE id=#{seckillProductId} AND status=1 " +
            "AND COALESCE(sold_count,0)+#{quantity}<=seckill_stock")
    int consumeStock(@Param("seckillProductId") Long seckillProductId,
                     @Param("quantity") Integer quantity);

    @Update("UPDATE seckill_product SET sold_count=GREATEST(COALESCE(sold_count,0)-#{quantity},0), " +
            "update_time=NOW() WHERE id=#{seckillProductId}")
    int releaseStock(@Param("seckillProductId") Long seckillProductId,
                     @Param("quantity") Integer quantity);

    @Select("SELECT " + VIEW_COLUMNS + " FROM seckill_product sp " +
            "JOIN seckill_activity a ON a.id=sp.seckill_activity_id " +
            "JOIN product p ON p.id=sp.product_id JOIN sku s ON s.sku_code=sp.sku_id " +
            "WHERE sp.seckill_activity_id=#{activityId} AND COALESCE(sp.status,1)=1")
    List<SeckillProductView> selectAllEnabled(@Param("activityId") Long activityId);
}
