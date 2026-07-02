package com.socialretail.backend.mapper.product;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.socialretail.backend.entity.product.Product;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface ProductMapper extends BaseMapper<Product> {
    @Update("""
            UPDATE product
            SET sold_count = COALESCE(sold_count, 0) + #{quantity},
                update_time = CURRENT_TIMESTAMP
            WHERE id = #{productId}
            """)
    int incrementSoldCount(@Param("productId") Long productId,
                           @Param("quantity") int quantity);

    @Update("""
            UPDATE product
            SET sold_count = GREATEST(COALESCE(sold_count, 0) - #{quantity}, 0),
                update_time = CURRENT_TIMESTAMP
            WHERE id = #{productId}
            """)
    int decrementSoldCount(@Param("productId") Long productId,
                           @Param("quantity") int quantity);
}
