package com.socialretail.backend.service.product.impl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.dto.request.product.BrandQueryDTO;
import com.socialretail.backend.dto.request.product.CatalogProductQueryDTO;
import com.socialretail.backend.entity.product.Brand;
import com.socialretail.backend.entity.product.Category;
import com.socialretail.backend.entity.product.Product;
import com.socialretail.backend.entity.product.ProductCategoryRelation;
import com.socialretail.backend.entity.product.Sku;
import com.socialretail.backend.mapper.product.BrandMapper;
import com.socialretail.backend.mapper.product.CategoryMapper;
import com.socialretail.backend.mapper.product.ProductCategoryRelationMapper;
import com.socialretail.backend.mapper.product.ProductMapper;
import com.socialretail.backend.mapper.product.SkuMapper;
import com.socialretail.backend.service.product.BrandService;
import com.socialretail.backend.service.product.CurrentProductPriceService;
import com.socialretail.backend.vo.BrandProductPageVO;
import com.socialretail.backend.vo.BrandVO;
import com.socialretail.backend.vo.CatalogProductVO;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
public class BrandServiceImpl implements BrandService {

    private static final int ON_SALE = 1;
    private static final int AUDIT_APPROVED = 1;

    private final BrandMapper brandMapper;
    private final CategoryMapper categoryMapper;
    private final ProductMapper productMapper;
    private final ProductCategoryRelationMapper relationMapper;
    private final SkuMapper skuMapper;
    private final CurrentProductPriceService currentProductPriceService;

    public BrandServiceImpl(BrandMapper brandMapper,
                            CategoryMapper categoryMapper,
                            ProductMapper productMapper,
                            ProductCategoryRelationMapper relationMapper,
                            SkuMapper skuMapper,
                            CurrentProductPriceService currentProductPriceService) {
        this.brandMapper = brandMapper;
        this.categoryMapper = categoryMapper;
        this.productMapper = productMapper;
        this.relationMapper = relationMapper;
        this.skuMapper = skuMapper;
        this.currentProductPriceService = currentProductPriceService;
    }

    @Override
    public PageResult<BrandVO> listBrands(BrandQueryDTO query) {
        Set<Long> brandIds = null;
        if (query.getCategoryId() != null) {
            requireCategory(query.getCategoryId());
            List<Long> productIds = productIdsForCategory(query.getCategoryId());
            if (productIds.isEmpty()) {
                return PageResult.empty(query.getPage(), query.getPageSize());
            }
            brandIds = productMapper.selectList(
                            Wrappers.<Product>lambdaQuery()
                                    .in(Product::getId, productIds)
                                    .eq(Product::getStatus, ON_SALE)
                                    .eq(Product::getAuditStatus, AUDIT_APPROVED)
                    ).stream()
                    .map(Product::getBrandId)
                    .filter(id -> id != null)
                    .collect(Collectors.toSet());
            if (brandIds.isEmpty()) {
                return PageResult.empty(query.getPage(), query.getPageSize());
            }
        }

        var brandQuery = Wrappers.<Brand>lambdaQuery()
                .orderByAsc(Brand::getCreateTime)
                .orderByAsc(Brand::getId);
        if (brandIds != null) {
            brandQuery.in(Brand::getId, brandIds);
        }
        List<Brand> brands = brandMapper.selectList(brandQuery);
        List<BrandVO> values = new ArrayList<>();
        for (int index = 0; index < brands.size(); index++) {
            Brand brand = brands.get(index);
            values.add(new BrandVO(
                    brand.getId(), brand.getName(), brand.getLogo(), brand.getDescription(), index + 1
            ));
        }

        int page = query.getPage();
        int pageSize = query.getPageSize();
        long total = values.size();
        int from = Math.min((page - 1) * pageSize, values.size());
        int to = Math.min(from + pageSize, values.size());
        return PageResult.of(new ArrayList<>(values.subList(from, to)), total, page, pageSize);
    }

    @Override
    public BrandProductPageVO listBrandProducts(Long brandId, CatalogProductQueryDTO query) {
        Brand brand = brandMapper.selectById(brandId);
        if (brand == null) {
            throw new BusinessException(40404, HttpStatus.NOT_FOUND, "品牌不存在");
        }
        validatePriceRange(query);

        var productQuery = Wrappers.<Product>lambdaQuery()
                .eq(Product::getBrandId, brandId)
                .eq(Product::getStatus, ON_SALE)
                .eq(Product::getAuditStatus, AUDIT_APPROVED);
        if (query.getCategoryId() != null) {
            requireCategory(query.getCategoryId());
            List<Long> productIds = productIdsForCategory(query.getCategoryId());
            if (productIds.isEmpty()) {
                return emptyPage(brand, query);
            }
            productQuery.in(Product::getId, productIds);
        }
        List<Product> products = productMapper.selectList(productQuery);
        return buildPage(brand, products, query);
    }

    private BrandProductPageVO buildPage(Brand brand,
                                         List<Product> products,
                                         CatalogProductQueryDTO query) {
        Map<Long, List<Sku>> skuMap = loadSkuMap(products);
        Map<Long, CurrentProductPriceService.Price> prices = currentProductPriceService.resolve(
                skuMap.values().stream().flatMap(List::stream).toList());
        Map<Long, Product> productMap = products.stream()
                .collect(Collectors.toMap(Product::getId, Function.identity()));
        List<CatalogProductVO> items = products.stream()
                .map(product -> toCatalogProduct(product, skuMap.getOrDefault(product.getId(), List.of()), prices))
                .filter(item -> priceMatches(item.getPrice(), query))
                .collect(Collectors.toCollection(ArrayList::new));
        items.sort(productComparator(query, productMap));

        int page = query.getPage();
        int pageSize = query.getPageSize();
        long total = items.size();
        int from = Math.min((page - 1) * pageSize, items.size());
        int to = Math.min(from + pageSize, items.size());
        int pages = (int) ((total + pageSize - 1) / pageSize);
        return new BrandProductPageVO(
                brand.getId(), brand.getName(), new ArrayList<>(items.subList(from, to)),
                total, pages, page, pageSize
        );
    }

    private List<Long> productIdsForCategory(Long categoryId) {
        return relationMapper.selectList(
                        Wrappers.<ProductCategoryRelation>lambdaQuery()
                                .eq(ProductCategoryRelation::getCategoryId, categoryId)
                ).stream()
                .map(ProductCategoryRelation::getProductId)
                .distinct()
                .toList();
    }

    private Map<Long, List<Sku>> loadSkuMap(List<Product> products) {
        if (products.isEmpty()) {
            return Map.of();
        }
        return skuMapper.selectList(
                        Wrappers.<Sku>lambdaQuery()
                                .in(Sku::getProductId, products.stream().map(Product::getId).toList())
                ).stream()
                .collect(Collectors.groupingBy(Sku::getProductId));
    }

    private CatalogProductVO toCatalogProduct(Product product, List<Sku> skus,
                                               Map<Long, CurrentProductPriceService.Price> prices) {
        CurrentProductPriceService.Price price = lowestPrice(skus, prices);
        int stock = skus.stream().map(Sku::getStock).filter(value -> value != null)
                .mapToInt(Integer::intValue).sum();
        return new CatalogProductVO(
                product.getId(), product.getTitle(), product.getMainImage(),
                price == null ? null : price.finalPrice(), price == null ? null : price.originalPrice(),
                product.getSoldCount() == null ? 0L : product.getSoldCount(), stock, List.of()
        );
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

    private Comparator<CatalogProductVO> productComparator(CatalogProductQueryDTO query,
                                                            Map<Long, Product> products) {
        String field = StringUtils.hasText(query.getSortField())
                ? query.getSortField().trim().toLowerCase(Locale.ROOT) : "createtime";
        boolean ascending = "asc".equalsIgnoreCase(query.getSortOrder());
        Comparator<CatalogProductVO> comparator = switch (field) {
            case "price" -> Comparator.comparing(CatalogProductVO::getPrice,
                    Comparator.nullsLast(Comparator.naturalOrder()));
            case "soldcount" -> Comparator.comparing(CatalogProductVO::getSoldCount,
                    Comparator.nullsLast(Comparator.naturalOrder()));
            default -> Comparator.comparing(item -> {
                Product product = products.get(item.getProductId());
                return product == null || product.getCreateTime() == null
                        ? LocalDateTime.MIN : product.getCreateTime();
            });
        };
        if (!ascending) {
            comparator = comparator.reversed();
        }
        return comparator.thenComparing(CatalogProductVO::getProductId, Comparator.reverseOrder());
    }

    private boolean priceMatches(BigDecimal price, CatalogProductQueryDTO query) {
        if (price == null) {
            return query.getMinPrice() == null && query.getMaxPrice() == null;
        }
        return (query.getMinPrice() == null || price.compareTo(query.getMinPrice()) >= 0)
                && (query.getMaxPrice() == null || price.compareTo(query.getMaxPrice()) <= 0);
    }

    private void requireCategory(Long categoryId) {
        Category category = categoryMapper.selectById(categoryId);
        if (category == null) {
            throw new BusinessException(40403, HttpStatus.NOT_FOUND, "分类不存在");
        }
    }

    private void validatePriceRange(CatalogProductQueryDTO query) {
        if (query.getMinPrice() != null && query.getMaxPrice() != null
                && query.getMinPrice().compareTo(query.getMaxPrice()) > 0) {
            throw new BusinessException(40001, HttpStatus.BAD_REQUEST, "最低价格不能大于最高价格");
        }
    }

    private BrandProductPageVO emptyPage(Brand brand, CatalogProductQueryDTO query) {
        return new BrandProductPageVO(
                brand.getId(), brand.getName(), List.of(), 0L, 0,
                query.getPage(), query.getPageSize()
        );
    }
}
