package com.socialretail.backend.entity.product;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

@TableName("category")
public class Category {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long parentId;

    private String name;

    private Integer level;

    private Integer sortOrder;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getParentId() {
        return parentId;
    }

    public void setParentId(Long parentId) {
        this.parentId = parentId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getLevel() {
        return level;
    }

    public void setLevel(Integer level) {
        this.level = level;
    }

    public Integer getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(Integer sortOrder) {
        this.sortOrder = sortOrder;
    }

    @Override
    public String toString() {
        return "Category{" +
            ", id=" + id +
            ", parentId=" + parentId +
            ", name=" + name +
            ", level=" + level +
            ", sortOrder=" + sortOrder +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Category that = (Category) o;
        return java.util.Objects.equals(id, that.id)
                && java.util.Objects.equals(parentId, that.parentId)
                && java.util.Objects.equals(name, that.name)
                && java.util.Objects.equals(level, that.level)
                && java.util.Objects.equals(sortOrder, that.sortOrder);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(id, parentId, name, level, sortOrder);
    }
}
