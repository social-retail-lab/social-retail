package com.socialretail.backend.enums.file;

public enum ImageUploadType {
    PRODUCT_DETAIL("product/detail"),
    COMMENT("review/images"),
    AFTER_SALE("after-sale/evidence"),
    POSTER("social/poster");

    private final String directory;

    ImageUploadType(String directory) {
        this.directory = directory;
    }

    public String getDirectory() {
        return directory;
    }
}
