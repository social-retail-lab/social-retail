package com.socialretail.backend.service.product.impl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.dto.request.product.ProductQueryDTO;
import com.socialretail.backend.entity.product.Product;
import com.socialretail.backend.entity.product.ProductCategoryRelation;
import com.socialretail.backend.entity.product.Sku;
import com.socialretail.backend.mapper.product.ProductCategoryRelationMapper;
import com.socialretail.backend.mapper.product.ProductMapper;
import com.socialretail.backend.mapper.product.SkuMapper;
import com.socialretail.backend.service.product.ProductService;
import com.socialretail.backend.vo.ProductDetailVO;
import com.socialretail.backend.vo.ProductListVO;
import com.socialretail.backend.vo.ProductSkuListVO;
import com.socialretail.backend.vo.ProductSkuVO;
import com.socialretail.backend.vo.SkuVO;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
public class ProductServiceImpl implements ProductService {

    private static final int ON_SALE = 1;
    private static final int AUDIT_APPROVED = 1;
    private static final TypeReference<List<String>> STRING_LIST_TYPE = new TypeReference<>() {
    };
    private static final TypeReference<LinkedHashMap<String, Object>> SPEC_MAP_TYPE = new TypeReference<>() {
    };

    private final ProductMapper productMapper;
    private final SkuMapper skuMapper;
    private final ProductCategoryRelationMapper productCategoryRelationMapper;
    private final ObjectMapper objectMapper;

    public ProductServiceImpl(ProductMapper productMapper,
                              SkuMapper skuMapper,
                              ProductCategoryRelationMapper productCategoryRelationMapper,
                              ObjectMapper objectMapper) {
        this.productMapper = productMapper;
        this.skuMapper = skuMapper;
        this.productCategoryRelationMapper = productCategoryRelationMapper;
        this.objectMapper = objectMapper;
    }

    @Override
    public PageResult<ProductListVO> listProducts(ProductQueryDTO dto) {
        int page = dto.getPage() == null ? 1 : dto.getPage();
        int size = dto.getSize() == null ? 10 : dto.getSize();

        Set<Long> categoryProductIds = findProductIdsByCategory(dto.getCategoryId());
        if (dto.getCategoryId() != null && categoryProductIds.isEmpty()) {
            return PageResult.empty(page, size);
        }

        var query = Wrappers.<Product>lambdaQuery()
                .eq(Product::getStatus, ON_SALE)
                .eq(Product::getAuditStatus, AUDIT_APPROVED);
        if (dto.getCategoryId() != null) {
            query.in(Product::getId, categoryProductIds);
        }
        if (StringUtils.hasText(dto.getKeyword())) {
            String keyword = dto.getKeyword().trim();
            query.and(wrapper -> wrapper
                    .like(Product::getTitle, keyword)
                    .or()
                    .like(Product::getSubTitle, keyword)
                    .or()
                    .like(Product::getDetailDesc, keyword));
        }

        List<Product> products = productMapper.selectList(query);
        if (products.isEmpty()) {
            return PageResult.empty(page, size);
        }

        Map<Long, List<Sku>> skusByProduct = findSkusByProduct(products);
        Map<Long, Product> productsById = products.stream()
                .collect(Collectors.toMap(Product::getId, Function.identity()));
        List<ProductListVO> result = products.stream()
                .map(product -> toListVO(product, skusByProduct.getOrDefault(product.getId(), List.of())))
                .collect(Collectors.toCollection(ArrayList::new));

        result.sort(resolveSort(dto.getSort(), productsById));
        long total = result.size();
        int fromIndex = Math.min((page - 1) * size, result.size());
        int toIndex = Math.min(fromIndex + size, result.size());
        return PageResult.of(new ArrayList<>(result.subList(fromIndex, toIndex)), total, page, size);
    }

    @Override
    public ProductDetailVO getProductDetail(Long productId) {
        Product product = requireAvailableProduct(productId);

        List<Sku> skus = skuMapper.selectList(
                Wrappers.<Sku>lambdaQuery()
                        .eq(Sku::getProductId, productId)
                        .orderByAsc(Sku::getPrice)
                        .orderByAsc(Sku::getId)
        );
        List<SkuVO> skuList = skus.stream().map(this::toSkuVO).toList();
        return new ProductDetailVO(
                product.getId(),
                product.getTitle(),
                product.getDetailDesc(),
                parseImages(product),
                minimumPrice(skus),
                skuList
        );
    }

    @Override
    public ProductSkuListVO listProductSkus(Long productId) {
        requireAvailableProduct(productId);
        List<ProductSkuVO> skuList = skuMapper.selectList(
                        Wrappers.<Sku>lambdaQuery()
                                .eq(Sku::getProductId, productId)
                                .orderByAsc(Sku::getPrice)
                                .orderByAsc(Sku::getId)
                ).stream()
                .map(this::toProductSkuVO)
                .toList();
        return new ProductSkuListVO(productId, skuList);
    }

    @Override
    public PageResult<ProductListVO> searchProducts(ProductQueryDTO dto) {
        return listProducts(dto);
    }

    private Set<Long> findProductIdsByCategory(Long categoryId) {
        if (categoryId == null) {
            return Set.of();
        }
        return productCategoryRelationMapper.selectList(
                        Wrappers.<ProductCategoryRelation>lambdaQuery()
                                .eq(ProductCategoryRelation::getCategoryId, categoryId)
                ).stream()
                .map(ProductCategoryRelation::getProductId)
                .collect(Collectors.toSet());
    }

    private Map<Long, List<Sku>> findSkusByProduct(List<Product> products) {
        List<Long> productIds = products.stream().map(Product::getId).toList();
        return skuMapper.selectList(
                        Wrappers.<Sku>lambdaQuery()
                                .in(Sku::getProductId, productIds)
                                .orderByAsc(Sku::getPrice)
                                .orderByAsc(Sku::getId)
                ).stream()
                .collect(Collectors.groupingBy(Sku::getProductId));
    }

    private ProductListVO toListVO(Product product, List<Sku> skus) {
        return new ProductListVO(
                product.getId(),
                product.getTitle(),
                product.getMainImage(),
                minimumPrice(skus),
                0
        );
    }

    private SkuVO toSkuVO(Sku sku) {
        return new SkuVO(sku.getId(), parseSpec(sku.getSpecs()), sku.getPrice(), sku.getStock());
    }

    private ProductSkuVO toProductSkuVO(Sku sku) {
        Map<String, Object> specs = parseSpec(sku.getSpecs());
        String skuName = specs.entrySet().stream()
                .filter(entry -> entry.getValue() != null)
                .map(entry -> String.valueOf(entry.getValue()))
                .filter(StringUtils::hasText)
                .findFirst()
                .orElse(sku.getSkuCode());
        return new ProductSkuVO(
                sku.getId(),
                skuName,
                specs,
                sku.getPrice(),
                sku.getPrice(),
                sku.getStock(),
                0,
                "ON_SALE"
        );
    }

    private Product requireAvailableProduct(Long productId) {
        Product product = productMapper.selectOne(
                Wrappers.<Product>lambdaQuery()
                        .eq(Product::getId, productId)
                        .eq(Product::getStatus, ON_SALE)
                        .eq(Product::getAuditStatus, AUDIT_APPROVED)
                        .last("LIMIT 1")
        );
        if (product == null) {
            throw new BusinessException(40402, HttpStatus.NOT_FOUND, "商品不存在或已下架");
        }
        return product;
    }

    private BigDecimal minimumPrice(List<Sku> skus) {
        return skus.stream()
                .map(Sku::getPrice)
                .filter(price -> price != null)
                .min(BigDecimal::compareTo)
                .orElse(null);
    }

    private List<String> parseImages(Product product) {
        LinkedHashSet<String> images = new LinkedHashSet<>();
        if (StringUtils.hasText(product.getMainImage())) {
            images.add(product.getMainImage());
        }
        if (StringUtils.hasText(product.getDetailImages())) {
            try {
                List<String> detailImages = objectMapper.readValue(product.getDetailImages(), STRING_LIST_TYPE);
                detailImages.stream().filter(StringUtils::hasText).forEach(images::add);
            } catch (Exception ignored) {
                images.add(product.getDetailImages());
            }
        }
        return new ArrayList<>(images);
    }

    private Map<String, Object> parseSpec(String specs) {
        if (!StringUtils.hasText(specs)) {
            return Map.of();
        }
        try {
            return objectMapper.readValue(specs, SPEC_MAP_TYPE);
        } catch (Exception ignored) {
            return Map.of("value", specs);
        }
    }

    private Comparator<ProductListVO> resolveSort(String sort, Map<Long, Product> productsById) {
        String normalized = StringUtils.hasText(sort)
                ? sort.trim().toLowerCase(Locale.ROOT)
                : "default";
        Comparator<ProductListVO> byIdDesc = Comparator.comparing(
                ProductListVO::getProductId,
                Comparator.nullsLast(Comparator.reverseOrder())
        );
        return switch (normalized) {
            case "price_asc" -> Comparator.comparing(
                    ProductListVO::getPrice,
                    Comparator.nullsLast(Comparator.naturalOrder())
            ).thenComparing(byIdDesc);
            case "price_desc" -> Comparator.comparing(
                    ProductListVO::getPrice,
                    Comparator.nullsLast(Comparator.reverseOrder())
            ).thenComparing(byIdDesc);
            case "sales_desc" -> Comparator.comparing(
                    ProductListVO::getSales,
                    Comparator.nullsLast(Comparator.reverseOrder())
            ).thenComparing(byIdDesc);
            case "newest", "time_desc" -> Comparator.comparing(
                    (ProductListVO vo) -> {
                        Product product = productsById.get(vo.getProductId());
                        return product == null || product.getCreateTime() == null
                                ? LocalDateTime.MIN
                                : product.getCreateTime();
                    },
                    Comparator.reverseOrder()
            ).thenComparing(byIdDesc);
            default -> byIdDesc;
        };
    }
}
