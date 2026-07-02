package com.socialretail.backend.common;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;
import org.springframework.web.util.UriUtils;

import java.nio.charset.StandardCharsets;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Component
public class ImageUrlResolver {
    private static final Pattern MARKDOWN_LINK = Pattern.compile("^\\[[^]]*]\\((https?://[^)]+)\\)$");

    private final Path uploadRoot;
    private final String configuredBaseUrl;

    public ImageUrlResolver(@Value("${upload.path:./uploads}") String uploadPath,
                            @Value("${upload.base-url:}") String configuredBaseUrl) {
        this.uploadRoot = Paths.get(uploadPath).toAbsolutePath().normalize();
        this.configuredBaseUrl = trimTrailingSlash(configuredBaseUrl);
    }

    public String resolve(String storedValue) {
        if (!StringUtils.hasText(storedValue)) {
            return storedValue;
        }
        String value = storedValue.trim();
        Matcher markdown = MARKDOWN_LINK.matcher(value);
        if (markdown.matches()) {
            value = markdown.group(1);
        }
        if (value.startsWith("http://") || value.startsWith("https://")) {
            return value;
        }

        String relative = relativeUploadPath(value);
        if (!StringUtils.hasText(relative) || relative.contains("..")) {
            return value;
        }
        String encodedPath = UriUtils.encodePath(relative.replace('\\', '/'), StandardCharsets.UTF_8);
        return requestBaseUrl() + "/uploads/" + encodedPath;
    }

    private String relativeUploadPath(String value) {
        String normalized = value.replace('\\', '/');
        String lower = normalized.toLowerCase(Locale.ROOT);
        int marker = lower.lastIndexOf("/uploads/");
        if (marker >= 0) {
            return normalized.substring(marker + "/uploads/".length());
        }

        try {
            Path candidate = Paths.get(value).toAbsolutePath().normalize();
            if (candidate.startsWith(uploadRoot)) {
                return uploadRoot.relativize(candidate).toString().replace('\\', '/');
            }
        } catch (RuntimeException ignored) {
            // Treat non-filesystem values as relative paths below.
        }

        String relative = normalized.replaceFirst("^/+", "")
                .replaceFirst("^(?i:uploads|static)/", "");
        if (!relative.contains("/")) {
            return "temp/upload/" + relative;
        }
        return relative;
    }

    private String requestBaseUrl() {
        try {
            return trimTrailingSlash(ServletUriComponentsBuilder.fromCurrentContextPath().build().toUriString());
        } catch (IllegalStateException ignored) {
            return configuredBaseUrl;
        }
    }

    private static String trimTrailingSlash(String value) {
        if (!StringUtils.hasText(value)) {
            return "";
        }
        return value.replaceFirst("/+$", "");
    }
}
