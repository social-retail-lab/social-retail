package com.socialretail.backend.mapper.order;

import com.baomidou.mybatisplus.core.MybatisConfiguration;
import org.apache.ibatis.builder.xml.XMLMapperBuilder;
import org.apache.ibatis.io.Resources;
import org.junit.jupiter.api.Test;

import java.io.InputStream;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertTrue;

class OrderMapperXmlTest {

    @Test
    void mapperXmlContainsAllRequiredStatements() throws Exception {
        MybatisConfiguration configuration = new MybatisConfiguration();
        try (InputStream input = Resources.getResourceAsStream("mapper/OrderMapper.xml")) {
            new XMLMapperBuilder(
                    input, configuration, "mapper/OrderMapper.xml", configuration.getSqlFragments()
            ).parse();
        }

        String namespace = OrderMapper.class.getName() + ".";
        for (String statement : List.of(
                "insertOrder", "insertOrderItem", "insertStatusLog",
                "selectByIdAndUserId", "selectItemsByOrderId",
                "selectOrdersByUserId", "countOrdersByUserId",
                "decrementStock", "incrementStock",
                "cancelWaitPayOrder", "completeOrder", "selectPickupPointById",
                "selectExpiredWaitPayOrderIds", "expireWaitPayOrder",
                "selectById", "selectByIdForUpdate", "selectByIdAndUserIdForUpdate",
                "updateStatusAfterPay", "updateStatus"
        )) {
            assertTrue(configuration.hasStatement(namespace + statement), statement);
        }
    }
}
