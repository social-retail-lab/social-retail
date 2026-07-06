package com.socialretail.backend.entity.product;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.time.LocalDateTime;

@TableName("brand")
public class Brand {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private String name;

    private String logo;

    private String description;

    private LocalDateTime createTime;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLogo() {
        return logo;
    }

    public void setLogo(String logo) {
        this.logo = logo;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDateTime getCreateTime() {
        return createTime;
    }

    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }

    @Override
    public String toString() {
        return "Brand{" +
            ", id=" + id +
            ", name=" + name +
            ", logo=" + logo +
            ", description=" + description +
            ", createTime=" + createTime +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Brand that = (Brand) o;
        return java.util.Objects.equals(id, that.id)
                && java.util.Objects.equals(name, that.name)
                && java.util.Objects.equals(logo, that.logo)
                && java.util.Objects.equals(description, that.description)
                && java.util.Objects.equals(createTime, that.createTime);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(id, name, logo, description, createTime);
    }
}
