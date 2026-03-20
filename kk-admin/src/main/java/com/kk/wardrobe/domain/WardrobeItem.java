package com.kk.wardrobe.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.kk.common.annotation.Excel;
import com.kk.common.core.domain.BaseEntity;

public class WardrobeItem extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** 单品ID */
    private Long id;

    /** 单品名称 */
    @Excel(name = "单品名称")
    private String name;

    /** 品类 */
    @Excel(name = "品类")
    private String category;

    /** 颜色 */
    @Excel(name = "颜色")
    private String color;

    /** 季节 */
    @Excel(name = "季节")
    private String season;

    /** 价格 */
    @Excel(name = "价格")
    private Double price;

    /** 是否常用 */
    @Excel(name = "是否常用")
    private Boolean isCommon;

    /** 添加时间 */
    @Excel(name = "添加时间", width = 30, dateFormat = "yyyy-MM-dd")
    private String addTime;

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

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getSeason() {
        return season;
    }

    public void setSeason(String season) {
        this.season = season;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public Boolean getCommon() {
        return isCommon;
    }

    public void setCommon(Boolean common) {
        isCommon = common;
    }

    public String getAddTime() {
        return addTime;
    }

    public void setAddTime(String addTime) {
        this.addTime = addTime;
    }
}