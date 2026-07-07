package com.socialretail.backend.enums.file;

public enum ImageUploadType {
    USER_AVATAR("user/avatar", Ownership.USER, true),
    MERCHANT_AVATAR("merchant/avatar", Ownership.MERCHANT, true),
    MERCHANT_LOGO("merchant/logo", Ownership.MERCHANT, true),
    BRAND_LOGO("brand/logo", Ownership.MERCHANT_OR_ADMIN, true),
    MERCHANT_IDCARD_FRONT("merchant/idcard/front", Ownership.USER, true),
    MERCHANT_IDCARD_BACK("merchant/idcard/back", Ownership.USER, true),
    DISTRIBUTOR_IDCARD_FRONT("front", Ownership.USER, true),
    DISTRIBUTOR_IDCARD_BACK("back", Ownership.USER, true),
    MERCHANT_LICENSE("merchant/license", Ownership.USER),
    QUALIFICATION("merchant/license", Ownership.USER),
    PRODUCT("product/main", Ownership.MERCHANT, true),
    PRODUCT_MAIN("product/main", Ownership.MERCHANT, true),
    PRODUCT_DETAIL("product/detail", Ownership.MERCHANT),
    PRODUCT_SKU("product/sku", Ownership.MERCHANT),
    COMMENT("review/images", Ownership.USER),
    AFTER_SALE("after-sale/evidence", Ownership.USER),
    POSTER("social/poster", Ownership.ANY),
    SOCIAL_SHARE("social/share", Ownership.ANY),
    PROMOTION_SECKILL("promotion/seckill", Ownership.MERCHANT_OR_ADMIN),
    PROMOTION_GROUP("promotion/group", Ownership.MERCHANT_OR_ADMIN),
    PROMOTION_COUPON("promotion/coupon", Ownership.MERCHANT_OR_ADMIN),
    SYSTEM_BANNER("system/banner", Ownership.ADMIN),
    SYSTEM_QRCODE("system/qrcode", Ownership.ADMIN),
    SYSTEM_DEFAULT("system/default", Ownership.ADMIN),
    SYSTEM_CONFIG("system/config", Ownership.ADMIN);

    private final String directory;
    private final Ownership ownership;
    private final boolean singleImageOnly;

    ImageUploadType(String directory, Ownership ownership) {
        this(directory, ownership, false);
    }

    ImageUploadType(String directory, Ownership ownership, boolean singleImageOnly) {
        this.directory = directory;
        this.ownership = ownership;
        this.singleImageOnly = singleImageOnly;
    }

    public String getDirectory() {
        return directory;
    }

    public Ownership getOwnership() {
        return ownership;
    }

    public boolean isSingleImageOnly() {
        return singleImageOnly;
    }

    public boolean isDistributorIdCard() {
        return this == DISTRIBUTOR_IDCARD_FRONT || this == DISTRIBUTOR_IDCARD_BACK;
    }

    public enum Ownership {
        USER, MERCHANT, MERCHANT_OR_ADMIN, ADMIN, ANY
    }
}
