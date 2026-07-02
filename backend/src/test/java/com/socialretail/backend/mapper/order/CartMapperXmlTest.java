package com.socialretail.backend.mapper.order;

import com.baomidou.mybatisplus.core.MybatisConfiguration;
import org.apache.ibatis.builder.xml.XMLMapperBuilder;
import org.apache.ibatis.io.Resources;
import org.junit.jupiter.api.Test;

import java.io.InputStream;

import static org.junit.jupiter.api.Assertions.assertTrue;

class CartMapperXmlTest {

    @Test
    void mapperXmlContainsAllRequiredStatements() throws Exception {
        MybatisConfiguration configuration = new MybatisConfiguration();
        try (InputStream input = Resources.getResourceAsStream("mapper/CartMapper.xml")) {
            XMLMapperBuilder builder = new XMLMapperBuilder(
                    input,
                    configuration,
                    "mapper/CartMapper.xml",
                    configuration.getSqlFragments()
            );
            builder.parse();
        }

        String namespace = CartMapper.class.getName() + ".";
        assertTrue(configuration.hasStatement(namespace + "selectByIdAndUserId"));
        assertTrue(configuration.hasStatement(namespace + "selectByUserIdAndSkuId"));
        assertTrue(configuration.hasStatement(namespace + "selectCartItemsByUserId"));
        assertTrue(configuration.hasStatement(namespace + "selectCartItemsByIds"));
        assertTrue(configuration.hasStatement(namespace + "insert"));
        assertTrue(configuration.hasStatement(namespace + "updateQuantity"));
        assertTrue(configuration.hasStatement(namespace + "deleteByIdAndUserId"));
        assertTrue(configuration.hasStatement(namespace + "deleteByIdsAndUserId"));
    }
}
