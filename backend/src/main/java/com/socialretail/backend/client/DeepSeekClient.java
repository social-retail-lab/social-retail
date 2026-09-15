package com.socialretail.backend.client;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.config.DeepSeekConfig;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * DeepSeek API 客户端封装（OpenAI 兼容协议）。
 * 调用 /v1/chat/completions 接口完成对话补全。
 */
@Component
public class DeepSeekClient {

    private static final Logger log = LoggerFactory.getLogger(DeepSeekClient.class);
    private static final String CHAT_COMPLETIONS_PATH = "/v1/chat/completions";

    private final DeepSeekConfig config;
    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;

    public DeepSeekClient(DeepSeekConfig config) {
        this.config = config;
        this.restTemplate = new RestTemplate();
        this.objectMapper = new ObjectMapper();
    }

    /**
     * 调用 DeepSeek 对话补全接口。
     *
     * @param systemPrompt 系统角色提示词（定义 AI 人设）
     * @param userPrompt   用户角色提示词（包含具体任务信息）
     * @return AI 生成的文本内容
     * @throws BusinessException 当 API Key 缺失或调用失败时抛出 AI_SERVICE_ERROR
     */
    public String chatCompletion(String systemPrompt, String userPrompt) {
        if (config.getApiKey() == null || config.getApiKey().isBlank()) {
            throw new BusinessException(50031, HttpStatus.INTERNAL_SERVER_ERROR,
                    "DeepSeek API Key 未配置，请设置环境变量 DEEPSEEK_API_KEY");
        }

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(config.getApiKey());

        Map<String, Object> body = new LinkedHashMap<>();
        body.put("model", config.getModel());
        body.put("temperature", config.getTemperature());
        body.put("max_tokens", config.getMaxTokens());

        List<Map<String, String>> messages = new ArrayList<>();
        Map<String, String> systemMessage = new LinkedHashMap<>();
        systemMessage.put("role", "system");
        systemMessage.put("content", systemPrompt);
        messages.add(systemMessage);
        Map<String, String> userMessage = new LinkedHashMap<>();
        userMessage.put("role", "user");
        userMessage.put("content", userPrompt);
        messages.add(userMessage);
        body.put("messages", messages);

        String url = trimSlash(config.getBaseUrl()) + CHAT_COMPLETIONS_PATH;
        HttpEntity<Map<String, Object>> request = new HttpEntity<>(body, headers);

        ResponseEntity<String> response;
        try {
            response = restTemplate.postForEntity(url, request, String.class);
        } catch (RestClientException e) {
            log.error("DeepSeek API 调用失败: {}", e.getMessage());
            throw new BusinessException(50031, HttpStatus.INTERNAL_SERVER_ERROR,
                    "AI 服务调用失败：" + e.getMessage());
        }

        if (!response.getStatusCode().is2xxSuccessful() || response.getBody() == null) {
            log.error("DeepSeek API 返回非 2xx 状态: {}", response.getStatusCode());
            throw new BusinessException(50031, HttpStatus.INTERNAL_SERVER_ERROR,
                    "AI 服务返回异常状态：" + response.getStatusCode());
        }

        return parseContent(response.getBody());
    }

    private String parseContent(String responseBody) {
        try {
            JsonNode root = objectMapper.readTree(responseBody);
            JsonNode choices = root.path("choices");
            if (!choices.isArray() || choices.isEmpty()) {
                JsonNode error = root.path("error");
                String errorMsg = error.path("message").asText("未知错误");
                log.error("DeepSeek API 返回错误: {}", errorMsg);
                throw new BusinessException(50031, HttpStatus.INTERNAL_SERVER_ERROR,
                        "AI 服务返回错误：" + errorMsg);
            }
            JsonNode content = choices.get(0).path("message").path("content");
            if (content.isMissingNode() || content.asText().isBlank()) {
                throw new BusinessException(50031, HttpStatus.INTERNAL_SERVER_ERROR,
                        "AI 服务返回内容为空");
            }
            return content.asText();
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            log.error("解析 DeepSeek 响应失败: {}", e.getMessage());
            throw new BusinessException(50031, HttpStatus.INTERNAL_SERVER_ERROR,
                    "AI 服务响应解析失败");
        }
    }

    private static String trimSlash(String value) {
        if (value == null) return "";
        return value.replaceAll("/+$", "");
    }
}
