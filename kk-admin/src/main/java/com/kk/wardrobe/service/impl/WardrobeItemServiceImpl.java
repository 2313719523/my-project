package com.kk.wardrobe.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.kk.wardrobe.mapper.WardrobeItemMapper;
import com.kk.wardrobe.domain.WardrobeItem;
import com.kk.wardrobe.service.IWardrobeItemService;

@Service
public class WardrobeItemServiceImpl implements IWardrobeItemService {

    @Autowired
    private WardrobeItemMapper wardrobeItemMapper;

    /**
     * 查询单品
     */
    @Override
    public WardrobeItem selectWardrobeItemById(Long id) {
        return wardrobeItemMapper.selectWardrobeItemById(id);
    }

    /**
     * 查询单品列表
     */
    @Override
    public List<WardrobeItem> selectWardrobeItemList(WardrobeItem wardrobeItem) {
        return wardrobeItemMapper.selectWardrobeItemList(wardrobeItem);
    }

    /**
     * 新增单品
     */
    @Override
    public int insertWardrobeItem(WardrobeItem wardrobeItem) {
        return wardrobeItemMapper.insertWardrobeItem(wardrobeItem);
    }

    /**
     * 修改单品
     */
    @Override
    public int updateWardrobeItem(WardrobeItem wardrobeItem) {
        return wardrobeItemMapper.updateWardrobeItem(wardrobeItem);
    }

    /**
     * 删除单品
     */
    @Override
    public int deleteWardrobeItemById(Long id) {
        return wardrobeItemMapper.deleteWardrobeItemById(id);
    }

    /**
     * 批量删除单品
     */
    @Override
    public int deleteWardrobeItemByIds(Long[] ids) {
        return wardrobeItemMapper.deleteWardrobeItemByIds(ids);
    }
}