package com.socialretail.backend.service.product.impl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.socialretail.backend.common.ImageUrlResolver;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.dto.request.product.CatalogProductQueryDTO;
import com.socialretail.backend.entity.product.Category;
import com.socialretail.backend.entity.product.Product;
import com.socialretail.backend.entity.product.ProductCategoryRelation;
import com.socialretail.backend.entity.product.Sku;
import com.socialretail.backend.mapper.product.CategoryMapper;
import com.socialretail.backend.mapper.product.ProductCategoryRelationMapper;
import com.socialretail.backend.mapper.product.ProductMapper;
import com.socialretail.backend.mapper.product.SkuMapper;
import com.socialretail.backend.service.product.CategoryService;
import com.socialretail.backend.vo.CatalogProductVO;
import com.socialretail.backend.vo.CategoryProductPageVO;
import com.socialretail.backend.vo.CategoryTreeResultVO;
import com.socialretail.backend.vo.CategoryTreeVO;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
public class CategoryServiceImpl implements CategoryService {

    private static final int ON_SALE = 1;
    private static final int AUDIT_APPROVED = 1;

    private final CategoryMapper categoryMapper;
    private final ProductCategoryRelationMapper relationMapper;
    private final ProductMapper productMapper;
    private final SkuMapper skuMapper;
    private final ImageUrlResolver imageUrlResolver;

    public CategoryServiceImpl(CategoryMapper categoryMapper,
                               ProductCategoryRelationMapper relationMapper,
                               ProductMapper productMapper,
                               SkuMapper skuMapper,
                               ImageUrlResolver imageUrlResolver) {
        this.categoryMapper = categoryMapper;
        this.relationMapper = relationMapper;
        this.productMapper = productMapper;
        this.skuMapper = skuMapper;
        this.imageUrlResolver = imageUrlResolver;
    }

    @Override
    public CategoryTreeResultVO getCategoryTree() {
        List<Category> categories = categoryMapper.selectList(
                Wrappers.<Category>lambdaQuery()
                        .orderByAsc(Category::getLevel)
                        .orderByAsc(Category::getSortOrder)
                        .orderByAsc(Category::getId)
        );
        Map<Long, CategoryTreeVO> nodes = new HashMap<>();
        for (Category category : categories) {
            nodes.put(category.getId(), toTreeNode(category));
        }

        List<CategoryTreeVO> roots = new ArrayList<>();
        for (Category category : categories) {
            CategoryTreeVO node = nodes.get(category.getId());
            Long parentId = category.getParentId();
            if (parentId == null || parentId == 0 || !nodes.containsKey(parentId)) {
                roots.add(node);
            } else {
                nodes.get(parentId).getChildren().add(node);
            }
        }
        sortTree(roots);
        return new CategoryTreeResultVO(roots);
    }

    @Override
    public CategoryProductPageVO listCategoryProducts(Long categoryId, CatalogProductQueryDTO query) {
        Category category = categoryMapper.selectById(categoryId);
        if (category == null) {
            throw new BusinessException(40403, HttpStatus.NOT_FOUND, "分类不存在");
        }
        validatePriceRange(query);

        List<Long> productIds = relationMapper.selectList(
                        Wrappers.<ProductCategoryRelation>lambdaQuery()
                                .eq(ProductCategoryRelation::getCategoryId, categoryId)
                ).stream()
                .map(ProductCategoryRelation::getProductId)
                .distinct()
                .toList();
        if (productIds.isEmpty()) {
            return emptyPage(category, query);
        }

        var productQuery = Wrappers.<Product>lambdaQuery()
                .in(Product::getId, productIds)
                .eq(Product::getStatus, ON_SALE)
                .eq(Product::getAuditStatus, AUDIT_APPROVED);
        if (query.getBrandId() != null) {
            productQuery.eq(Product::getBrandId, query.getBrandId());
        }
        List<Product> products = productMapper.selectList(productQuery);
        return buildPage(category, products, query);
    }

    private CategoryProductPageVO buildPage(Category category,
                                             List<Product> products,
                                             CatalogProductQueryDTO query) {
        Map<Long, List<Sku>> skuMap = loadSkuMap(products);
        Map<Long, Product> productMap = products.stream()
                .collect(Collectors.toMap(Product::getId, Function.identity()));
        List<CatalogProductVO> items = products.stream()
                .map(product -> toCatalogProduct(product, skuMap.getOrDefault(product.getId(), List.of())))
                .filter(item -> priceMatches(item.getPrice(), query))
                .collect(Collectors.toCollection(ArrayList::new));
        items.sort(productComparator(query, productMap));

        int page = query.getPage();
        int pageSize = query.getPageSize();
        long total = items.size();
        int from = Math.min((page - 1) * pageSize, items.size());
        int to = Math.min(from + pageSize, items.size());
        int pages = (int) ((total + pageSize - 1) / pageSize);
        return new CategoryProductPageVO(
                category.getId(), category.getName(), new ArrayList<>(items.subList(from, to)),
                total, pages, page, pageSize
        );
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

    private CatalogProductVO toCatalogProduct(Product product, List<Sku> skus) {
        BigDecimal price = skus.stream().map(Sku::getPrice).filter(value -> value != null)
                .min(BigDecimal::compareTo).orElse(null);
        int stock = skus.stream().map(Sku::getStock).filter(value -> value != null)
                .mapToInt(Integer::intValue).sum();
        return new CatalogProductVO(
                product.getId(), product.getTitle(), imageUrlResolver.resolve(product.getMainImage()), price, price,
                product.getSoldCount() == null ? 0L : product.getSoldCount(), stock, List.of()
        );
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

    private void validatePriceRange(CatalogProductQueryDTO query) {
        if (query.getMinPrice() != null && query.getMaxPrice() != null
                && query.getMinPrice().compareTo(query.getMaxPrice()) > 0) {
            throw new BusinessException(40001, HttpStatus.BAD_REQUEST, "最低价格不能大于最高价格");
        }
    }

    private CategoryTreeVO toTreeNode(Category category) {
        return new CategoryTreeVO(
                category.getId(), category.getName(),
                category.getParentId() == null ? 0L : category.getParentId(),
                category.getLevel(), category.getSortOrder(), new ArrayList<>()
        );
    }

    private void sortTree(List<CategoryTreeVO> nodes) {
        nodes.sort(Comparator.comparing(CategoryTreeVO::getSort,
                        Comparator.nullsLast(Comparator.naturalOrder()))
                .thenComparing(CategoryTreeVO::getCategoryId));
        nodes.forEach(node -> sortTree(node.getChildren()));
    }

    private CategoryProductPageVO emptyPage(Category category, CatalogProductQueryDTO query) {
        return new CategoryProductPageVO(
                category.getId(), category.getName(), List.of(), 0L, 0,
                query.getPage(), query.getPageSize()
        );
    }
}
