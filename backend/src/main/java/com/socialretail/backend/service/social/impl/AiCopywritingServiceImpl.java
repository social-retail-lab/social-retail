package com.socialretail.backend.service.social.impl;

import com.socialretail.backend.client.DeepSeekClient;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.service.social.AiCopywritingService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * AI 营销文案生成服务实现。
 * 查询商品详细信息并调用 DeepSeek 生成适合社交分享的推广文案。
 */
@Service
public class AiCopywritingServiceImpl implements AiCopywritingService {

    private static final Logger log = LoggerFactory.getLogger(AiCopywritingServiceImpl.class);

    private static final String SYSTEM_PROMPT =
            "你是一位资深的电商营销文案专家，擅长撰写适合微信朋友圈、社群分享的推广文案。" +
            "文案要求：吸睛开头、突出卖点、引发购买欲望、附带行动号召，语气亲切自然，可适当使用 emoji，" +
            "总长度控制在 150-300 字，只输出文案正文，不要解释、不要标题前缀。";

    private final JdbcTemplate jdbc;
    private final DeepSeekClient deepSeekClient;

    public AiCopywritingServiceImpl(JdbcTemplate jdbc, DeepSeekClient deepSeekClient) {
        this.jdbc = jdbc;
        this.deepSeekClient = deepSeekClient;
    }

    @Override
    public String generateCopywriting(Long userId, Long distributorProductId) {
        // 1. 校验分销员身份（NO_PERMISSION）
        Long distributorId = requireDistributor(userId);

        // 2. 查询商品信息（PRODUCT_NOT_FOUND）
        Map<String, Object> row = queryDistributorProduct(distributorProductId, distributorId);

        // 3. 组装 prompt 并调用 DeepSeek
        String userPrompt = buildUserPrompt(row);
        log.info("为分销员[{}]推广商品[{}]生成文案", distributorId, distributorProductId);
        String copywriting = deepSeekClient.chatCompletion(SYSTEM_PROMPT, userPrompt);

        // 4. 清理可能的 markdown 代码块包裹
        return cleanCopywriting(copywriting);
    }

    private Long requireDistributor(Long userId) {
        List<Map<String, Object>> rows = jdbc.queryForList(
                "SELECT id FROM distributor WHERE user_id=? AND status=1", userId);
        if (rows.isEmpty()) {
            throw new BusinessException(40361, HttpStatus.FORBIDDEN, "当前用户不是分销员");
        }
        return ((Number) rows.get(0).get("id")).longValue();
    }

    private Map<String, Object> queryDistributorProduct(Long distributorProductId, Long distributorId) {
        List<Map<String, Object>> rows = jdbc.queryForList("""
                SELECT p.title, p.sub_title, p.detail_desc, p.main_image,
                       p.sold_count, m.merchant_name, s.price
                FROM distributor_product dp
                JOIN merchant_distribution_product mdp ON mdp.id = dp.distribution_product_id
                JOIN product p ON p.id = mdp.product_id
                JOIN merchant m ON m.id = p.merchant_id
                LEFT JOIN (SELECT product_id, MIN(price) price FROM sku GROUP BY product_id) s
                  ON s.product_id = p.id
                WHERE dp.id = ? AND dp.distributor_id = ?
                """, distributorProductId, distributorId);
        if (rows.isEmpty()) {
            throw new BusinessException(40461, HttpStatus.NOT_FOUND, "推广商品不存在");
        }
        return rows.get(0);
    }

    private String buildUserPrompt(Map<String, Object> row) {
        String productName = stringOr(row.get("title"), "未知商品");
        String subTitle = stringOr(row.get("sub_title"), "");
        String detailDesc = stringOr(row.get("detail_desc"), "");
        String merchantName = stringOr(row.get("merchant_name"), "未知商家");
        Object soldCountObj = row.get("sold_count");
        String soldCount = soldCountObj == null ? "0" : soldCountObj.toString();
        Object priceObj = row.get("price");
        String price = priceObj == null ? "暂无报价" : "¥" + ((BigDecimal) priceObj).toPlainString();

        StringBuilder sellingPoints = new StringBuilder();
        if (!subTitle.isBlank()) {
            sellingPoints.append(subTitle);
        }
        if (!detailDesc.isBlank()) {
            if (sellingPoints.length() > 0) sellingPoints.append("；");
            // 描述可能很长，截取前 500 字避免 token 超限
            String desc = detailDesc.length() > 500 ? detailDesc.substring(0, 500) : detailDesc;
            sellingPoints.append(desc);
        }
        if (sellingPoints.length() == 0) {
            sellingPoints.append("暂无详细卖点");
        }

        return """
                请根据以下商品信息生成一段推广文案：

                商品名称：%s
                商品卖点：%s
                商品价格：%s
                销量：%s
                商家：%s

                要求：生成适合微信朋友圈、社交分享的推广文案，突出商品优势，激发购买欲。""".formatted(
                productName, sellingPoints.toString(), price, soldCount, merchantName);
    }

    private String cleanCopywriting(String text) {
        if (text == null) return "";
        String trimmed = text.trim();
        // 去除可能的 ```markdown 或 ``` 代码块包裹
        if (trimmed.startsWith("```")) {
            int firstNewline = trimmed.indexOf('\n');
            if (firstNewline > 0) {
                trimmed = trimmed.substring(firstNewline + 1);
            }
            if (trimmed.endsWith("```")) {
                trimmed = trimmed.substring(0, trimmed.length() - 3);
            }
            trimmed = trimmed.trim();
        }
        return trimmed;
    }

    private static String stringOr(Object value, String defaultValue) {
        if (value == null) return defaultValue;
        String s = value.toString();
        return s.isBlank() ? defaultValue : s;
    }
}
