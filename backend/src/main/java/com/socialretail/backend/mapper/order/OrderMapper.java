package com.socialretail.backend.mapper.order;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.socialretail.backend.entity.order.Order;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface OrderMapper extends BaseMapper<Order> {
}
