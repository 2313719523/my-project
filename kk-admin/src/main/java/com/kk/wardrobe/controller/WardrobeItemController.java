package com.kk.wardrobe.controller;

import java.util.List;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;

import com.kk.common.annotation.Anonymous;  // ← 添加这行导入

import org.springframework.web.bind.annotation.*;
import com.kk.common.annotation.Log;
import com.kk.common.core.controller.BaseController;
import com.kk.common.core.domain.AjaxResult;
import com.kk.common.enums.BusinessType;
import com.kk.wardrobe.domain.WardrobeItem;
import com.kk.wardrobe.service.IWardrobeItemService;

@Anonymous
@RestController
@RequestMapping("/wardrobe/item")
public class WardrobeItemController extends BaseController {

    @Autowired
    private IWardrobeItemService wardrobeItemService;

    /**
     * 查询单品列表
     */
//    @PreAuthorize("@ss.hasPermi('wardrobe:item:list')")
    @GetMapping("/list")
    public AjaxResult list(WardrobeItem wardrobeItem) {
        List<WardrobeItem> list = wardrobeItemService.selectWardrobeItemList(wardrobeItem);
        return AjaxResult.success(list);
    }

    /**
     * 获取单品详细信息
     */
    @PreAuthorize("@ss.hasPermi('wardrobe:item:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id) {
        return AjaxResult.success(wardrobeItemService.selectWardrobeItemById(id));
    }

    /**
     * 新增单品
     */
    @PreAuthorize("@ss.hasPermi('wardrobe:item:add')")
    @Log(title = "衣橱单品", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody WardrobeItem wardrobeItem) {
        return toAjax(wardrobeItemService.insertWardrobeItem(wardrobeItem));
    }

    /**
     * 修改单品
     */
    @PreAuthorize("@ss.hasPermi('wardrobe:item:edit')")
    @Log(title = "衣橱单品", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody WardrobeItem wardrobeItem) {
        return toAjax(wardrobeItemService.updateWardrobeItem(wardrobeItem));
    }

    /**
     * 删除单品
     */
    @PreAuthorize("@ss.hasPermi('wardrobe:item:remove')")
    @Log(title = "衣橱单品", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids) {
        return toAjax(wardrobeItemService.deleteWardrobeItemByIds(ids));
    }
}