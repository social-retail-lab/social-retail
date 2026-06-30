package com.socialretail.backend.mapper.address;

import com.baomidou.mybatisplus.core.MybatisConfiguration;
import org.apache.ibatis.builder.xml.XMLMapperBuilder;
import org.apache.ibatis.io.Resources;
import org.junit.jupiter.api.Test;

import java.io.InputStream;

import static org.junit.jupiter.api.Assertions.assertTrue;

class AddressMapperXmlTest {

    @Test
    void mapperXmlContainsAllRequiredStatements() throws Exception {
        MybatisConfiguration configuration = new MybatisConfiguration();
        try (InputStream input = Resources.getResourceAsStream("mapper/AddressMapper.xml")) {
            XMLMapperBuilder builder = new XMLMapperBuilder(
                    input,
                    configuration,
                    "mapper/AddressMapper.xml",
                    configuration.getSqlFragments()
            );
            builder.parse();
        }

        String namespace = AddressMapper.class.getName() + ".";
        assertTrue(configuration.hasStatement(namespace + "selectByIdAndUserId"));
        assertTrue(configuration.hasStatement(namespace + "selectListByUserId"));
        assertTrue(configuration.hasStatement(namespace + "selectDefaultByUserId"));
        assertTrue(configuration.hasStatement(namespace + "insert"));
        assertTrue(configuration.hasStatement(namespace + "updateByIdAndUserId"));
        assertTrue(configuration.hasStatement(namespace + "deleteByIdAndUserId"));
        assertTrue(configuration.hasStatement(namespace + "clearDefaultByUserId"));
        assertTrue(configuration.hasStatement(namespace + "setDefault"));
        assertTrue(configuration.hasStatement(namespace + "countByUserId"));
        assertTrue(configuration.hasStatement(namespace + "selectLatestByUserId"));
    }
}
