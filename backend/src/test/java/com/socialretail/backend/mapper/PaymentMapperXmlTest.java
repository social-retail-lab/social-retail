package com.socialretail.backend.mapper;

import com.baomidou.mybatisplus.core.MybatisConfiguration;
import org.apache.ibatis.builder.xml.XMLMapperBuilder;
import org.apache.ibatis.io.Resources;
import org.junit.jupiter.api.Test;

import java.io.InputStream;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertTrue;

class PaymentMapperXmlTest {

    @Test
    void mapperXmlContainsAllPaymentStatements() throws Exception {
        MybatisConfiguration configuration = new MybatisConfiguration();
        try (InputStream input = Resources.getResourceAsStream("mapper/PaymentMapper.xml")) {
            new XMLMapperBuilder(
                    input, configuration, "mapper/PaymentMapper.xml", configuration.getSqlFragments()
            ).parse();
        }
        String namespace = PaymentMapper.class.getName() + ".";
        for (String statement : List.of(
                "insert", "selectById", "selectDetailByIdAndUserId",
                "selectLatestByOrderId", "selectLatestByOrderIdAndUserId",
                "selectLatestByOrderIdForUpdate", "selectByPaySn", "selectByPaySnForUpdate",
                "updatePaid", "updateFailed", "updatePlatformAndPaid", "updatePlatformAndFailed"
        )) {
            assertTrue(configuration.hasStatement(namespace + statement), statement);
        }
    }
}
