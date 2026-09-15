package com.socialretail.backend.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * DeepSeek AI 配置（OpenAI 兼容协议）。
 * API Key 必须通过环境变量 DEEPSEEK_API_KEY 注入，禁止硬编码。
 */
@Data
@Component
@ConfigurationProperties(prefix = "deepseek")
public class DeepSeekConfig {

    /** DeepSeek API Key，从环境变量读取 */
    private String apiKey;

    /** API 基础地址，默认 https://api.deepseek.com */
    private String baseUrl = "https://api.deepseek.com";

    /** 调用的模型名称，支持后续替换 */
    private String model = "deepseek-chat";

    /** 采样温度，越高越随机 */
    private double temperature = 0.8;

    /** 生成最大 token 数 */
    private int maxTokens = 500;
}
