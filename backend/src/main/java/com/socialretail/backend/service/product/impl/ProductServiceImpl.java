package com.socialretail.backend.service.product.impl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.ImageUrlResolver;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.dto.request.product.ProductQueryDTO;
import com.socialretail.backend.entity.product.Product;
import com.socialretail.backend.entity.product.ProductCategoryRelation;
import com.socialretail.backend.entity.product.Sku;
import com.socialretail.backend.entity.product.Brand;
import com.socialretail.backend.entity.product.Category;
import com.socialretail.backend.entity.member.Merchant;
import com.socialretail.backend.mapper.member.MerchantMapper;
import com.socialretail.backend.mapper.product.BrandMapper;
import com.socialretail.backend.mapper.product.CategoryMapper;
import com.socialretail.backend.mapper.product.ProductCategoryRelationMapper;
import com.socialretail.backend.mapper.product.ProductMapper;
import com.socialretail.backend.mapper.product.SkuMapper;
import com.socialretail.backend.service.product.ProductService;
import com.socialretail.backend.service.product.CurrentProductPriceService;
import com.socialretail.backend.service.social.DistributionAttributionService;
import com.socialretail.backend.vo.ProductDetailVO;
import com.socialretail.backend.vo.ProductCardVO;
import com.socialretail.backend.vo.ProductSkuListVO;
import com.socialretail.backend.vo.ProductSkuVO;
import com.socialretail.backend.vo.ProductMerchantInfoVO;
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
import java.util.Objects;
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
    private final BrandMapper brandMapper;
    private final CategoryMapper categoryMapper;
    private final MerchantMapper merchantMapper;
    private final ObjectMapper objectMapper;
    private final ImageUrlResolver imageUrlResolver;
    private final DistributionAttributionService distributionAttributionService;
    private final CurrentProductPriceService currentProductPriceService;

    public ProductServiceImpl(ProductMapper productMapper,
                              SkuMapper skuMapper,
                              ProductCategoryRelationMapper productCategoryRelationMapper,
                              BrandMapper brandMapper,
                              CategoryMapper categoryMapper,
                              MerchantMapper merchantMapper,
                              ObjectMapper objectMapper,
                              ImageUrlResolver imageUrlResolver,
                              DistributionAttributionService distributionAttributionService,
                              CurrentProductPriceService currentProductPriceService) {
        this.productMapper = productMapper;
        this.skuMapper = skuMapper;
        this.productCategoryRelationMapper = productCategoryRelationMapper;
        this.brandMapper = brandMapper;
        this.categoryMapper = categoryMapper;
        this.merchantMapper = merchantMapper;
        this.objectMapper = objectMapper;
        this.imageUrlResolver = imageUrlResolver;
        this.distributionAttributionService = distributionAttributionService;
        this.currentProductPriceService = currentProductPriceService;
    }

    @Override
    public PageResult<ProductCardVO> listProducts(ProductQueryDTO dto) {
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
        Map<Long, CurrentProductPriceService.Price> prices = currentProductPriceService.resolve(
                skusByProduct.values().stream().flatMap(List::stream).toList());
        Map<Long, Product> productsById = products.stream()
                .collect(Collectors.toMap(Product::getId, Function.identity()));
        Map<Long, Merchant> merchantsById = findMerchantsByProduct(products);
        List<ProductCardVO> result = products.stream()
                .map(product -> toListVO(product,
                        skusByProduct.getOrDefault(product.getId(), List.of()),
                        prices,
                        merchantsById.get(product.getMerchantId())))
                .collect(Collectors.toCollection(ArrayList::new));

        result.sort(resolveSort(resolveSortKey(dto), productsById));
        long total = result.size();
        int fromIndex = Math.min((page - 1) * size, result.size());
        int toIndex = Math.min(fromIndex + size, result.size());
        return PageResult.of(new ArrayList<>(result.subList(fromIndex, toIndex)), total, page, size);
    }

    @Override
    public ProductDetailVO getProductDetail(Long productId, String promotionCode) {
        Product product = requireAvailableProduct(productId);

        List<Sku> skus = skuMapper.selectList(
                Wrappers.<Sku>lambdaQuery()
                        .eq(Sku::getProductId, productId)
                        .orderByAsc(Sku::getPrice)
                        .orderByAsc(Sku::getId)
        );
        Map<Long, CurrentProductPriceService.Price> prices = currentProductPriceService.resolve(skus);
        List<SkuVO> skuList = skus.stream().map(sku -> toSkuVO(sku, prices.get(sku.getId()))).toList();
        CurrentProductPriceService.Price lowestPrice = lowestPrice(skus, prices);
        ProductDetailVO detail = new ProductDetailVO();
        detail.setProductId(product.getId());
        detail.setProductName(product.getTitle());
        detail.setProductImage(imageUrlResolver.resolve(product.getMainImage()));
        detail.setDetailImages(parseDetailImages(product));
        detail.setDescription(product.getDetailDesc());
        detail.setPrice(lowestPrice == null ? null : lowestPrice.finalPrice());
        detail.setOriginalPrice(lowestPrice == null ? null : lowestPrice.originalPrice());
        detail.setSoldCount(soldCount(product));
        detail.setStock(skus.stream().map(Sku::getStock).filter(value -> value != null)
                .mapToInt(Integer::intValue).sum());
        detail.setStatus(product.getStatus() != null && product.getStatus() == ON_SALE
                ? "ON_SALE" : "OFF_SALE");
        detail.setSkuList(skuList);
        DistributionAttributionService.Attribution attribution =
                distributionAttributionService.resolve(promotionCode, productId);
        if (attribution != null) {
            detail.setDistributorProductId(attribution.distributorProductId());
            detail.setPromotionCode(attribution.promotionCode());
            detail.setPromotionExpiresAt(LocalDateTime.now()
                    .plusDays(DistributionAttributionService.ATTRIBUTION_DAYS));
        }

        if (product.getBrandId() != null) {
            Brand brand = brandMapper.selectById(product.getBrandId());
            if (brand != null) {
                detail.setBrandId(brand.getId());
                detail.setBrandName(brand.getName());
            }
        }
        ProductCategoryRelation relation = productCategoryRelationMapper.selectOne(
                Wrappers.<ProductCategoryRelation>lambdaQuery()
                        .eq(ProductCategoryRelation::getProductId, productId)
                        .orderByAsc(ProductCategoryRelation::getId)
                        .last("LIMIT 1")
        );
        if (relation != null) {
            Category category = categoryMapper.selectById(relation.getCategoryId());
            if (category != null) {
                detail.setCategoryId(category.getId());
                detail.setCategoryName(category.getName());
            }
        }
        if (product.getMerchantId() != null) {
            Merchant merchant = merchantMapper.selectById(product.getMerchantId());
            if (merchant != null) {
                detail.setMerchantInfo(new ProductMerchantInfoVO(
                        merchant.getId(), merchant.getMerchantName(),
                        imageUrlResolver.resolve(merchant.getLogo())));
            }
        }
        return detail;
    }

    @Override
    public ProductSkuListVO listProductSkus(Long productId) {
        requireAvailableProduct(productId);
        List<Sku> skus = skuMapper.selectList(
                        Wrappers.<Sku>lambdaQuery()
                                .eq(Sku::getProductId, productId)
                                .orderByAsc(Sku::getPrice)
                                .orderByAsc(Sku::getId)
                );
        Map<Long, CurrentProductPriceService.Price> prices = currentProductPriceService.resolve(skus);
        List<ProductSkuVO> skuList = skus.stream()
                .map(sku -> toProductSkuVO(sku, prices.get(sku.getId())))
                .toList();
        return new ProductSkuListVO(productId, skuList);
    }

    @Override
    public PageResult<ProductCardVO> searchProducts(ProductQueryDTO dto) {
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

    private ProductCardVO toListVO(Product product, List<Sku> skus,
                                   Map<Long, CurrentProductPriceService.Price> prices,
                                   Merchant merchant) {
        CurrentProductPriceService.Price price = lowestPrice(skus, prices);
        int stock = skus.stream().map(Sku::getStock).filter(value -> value != null)
                .mapToInt(Integer::intValue).sum();
        return new ProductCardVO(
                product.getId(),
                product.getTitle(),
                imageUrlResolver.resolve(product.getMainImage()),
                price == null ? null : price.finalPrice(),
                price == null ? null : price.originalPrice(),
                soldCount(product),
                stock,
                List.of(),
                product.getMerchantId(),
                merchant == null ? null : merchant.getMerchantName(),
                null
        );
    }

    private Map<Long, Merchant> findMerchantsByProduct(List<Product> products) {
        List<Long> merchantIds = products.stream().map(Product::getMerchantId)
                .filter(Objects::nonNull).distinct().toList();
        if (merchantIds.isEmpty()) {
            return Map.of();
        }
        return merchantMapper.selectBatchIds(merchantIds).stream()
                .collect(Collectors.toMap(Merchant::getId, Function.identity()));
    }

    private SkuVO toSkuVO(Sku sku, CurrentProductPriceService.Price price) {
        SkuVO result = new SkuVO(sku.getId(), parseSpec(sku.getSpecs()),
                price == null ? sku.getPrice() : price.finalPrice(), sku.getStock());
        result.setOriginalPrice(price == null ? sku.getPrice() : price.originalPrice());
        result.setSeckillProductId(price == null ? null : price.seckillProductId());
        return result;
    }

    private ProductSkuVO toProductSkuVO(Sku sku, CurrentProductPriceService.Price price) {
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
                price == null ? sku.getPrice() : price.finalPrice(),
                price == null ? sku.getPrice() : price.originalPrice(),
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

    private CurrentProductPriceService.Price lowestPrice(
            List<Sku> skus, Map<Long, CurrentProductPriceService.Price> prices) {
        return skus.stream()
                .map(sku -> prices.getOrDefault(sku.getId(),
                        new CurrentProductPriceService.Price(sku.getPrice(), sku.getPrice(), null)))
                .filter(price -> price.finalPrice() != null)
                .min(Comparator.comparing(CurrentProductPriceService.Price::finalPrice))
                .orElse(null);
    }

    private long soldCount(Product product) {
        return product.getSoldCount() == null ? 0L : product.getSoldCount();
    }

    private List<String> parseDetailImages(Product product) {
        LinkedHashSet<String> images = new LinkedHashSet<>();
        if (StringUtils.hasText(product.getDetailImages())) {
            try {
                List<String> detailImages = objectMapper.readValue(product.getDetailImages(), STRING_LIST_TYPE);
                detailImages.stream().filter(StringUtils::hasText)
                        .map(imageUrlResolver::resolve).forEach(images::add);
            } catch (Exception ignored) {
                images.add(imageUrlResolver.resolve(product.getDetailImages()));
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

    private Comparator<ProductCardVO> resolveSort(String sort, Map<Long, Product> productsById) {
        String normalized = StringUtils.hasText(sort)
                ? sort.trim().toLowerCase(Locale.ROOT)
                : "default";
        Comparator<ProductCardVO> byIdDesc = Comparator.comparing(
                ProductCardVO::getProductId,
                Comparator.nullsLast(Comparator.reverseOrder())
        );
        return switch (normalized) {
            case "price_asc" -> Comparator.comparing(
                    ProductCardVO::getPrice,
                    Comparator.nullsLast(Comparator.naturalOrder())
            ).thenComparing(byIdDesc);
            case "price_desc" -> Comparator.comparing(
                    ProductCardVO::getPrice,
                    Comparator.nullsLast(Comparator.reverseOrder())
            ).thenComparing(byIdDesc);
            case "sales_desc" -> Comparator.comparing(
                    ProductCardVO::getSoldCount,
                    Comparator.nullsLast(Comparator.reverseOrder())
            ).thenComparing(byIdDesc);
            case "sales_asc" -> Comparator.comparing(
                    ProductCardVO::getSoldCount,
                    Comparator.nullsLast(Comparator.naturalOrder())
            ).thenComparing(byIdDesc);
            case "newest", "time_desc" -> Comparator.comparing(
                    (ProductCardVO vo) -> {
                        Product product = productsById.get(vo.getProductId());
                        return product == null || product.getCreateTime() == null
                                ? LocalDateTime.MIN
                                : product.getCreateTime();
                    },
                    Comparator.reverseOrder()
            ).thenComparing(byIdDesc);
            case "time_asc" -> Comparator.comparing(
                    (ProductCardVO vo) -> {
                        Product product = productsById.get(vo.getProductId());
                        return product == null || product.getCreateTime() == null
                                ? LocalDateTime.MAX
                                : product.getCreateTime();
                    }
            ).thenComparing(byIdDesc);
            default -> byIdDesc;
        };
    }

    static String resolveSortKey(ProductQueryDTO dto) {
        if (StringUtils.hasText(dto.getSort())) {
            return dto.getSort().trim().toLowerCase(Locale.ROOT);
        }
        if (!StringUtils.hasText(dto.getSortField())) {
            return "default";
        }

        String field = dto.getSortField().trim().toLowerCase(Locale.ROOT);
        boolean ascending = "asc".equalsIgnoreCase(dto.getSortOrder());
        return switch (field) {
            case "price" -> ascending ? "price_asc" : "price_desc";
            case "sales", "soldcount" -> ascending ? "sales_asc" : "sales_desc";
            case "new", "newest", "time", "createtime" -> ascending ? "time_asc" : "newest";
            default -> "default";
        };
    }
}
