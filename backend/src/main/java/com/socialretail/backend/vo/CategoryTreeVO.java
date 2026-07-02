package com.socialretail.backend.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CategoryTreeVO {
    private Long categoryId;
    private String categoryName;
    private Long parentId;
    private Integer level;
    private Integer sort;
    private List<CategoryTreeVO> children = new ArrayList<>();
}
