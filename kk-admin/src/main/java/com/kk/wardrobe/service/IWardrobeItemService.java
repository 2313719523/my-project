package com.kk.wardrobe.service;

import java.util.List;
import com.kk.wardrobe.domain.WardrobeItem;

public interface IWardrobeItemService {
    public WardrobeItem selectWardrobeItemById(Long id);
    public List<WardrobeItem> selectWardrobeItemList(WardrobeItem wardrobeItem);
    public int insertWardrobeItem(WardrobeItem wardrobeItem);
    public int updateWardrobeItem(WardrobeItem wardrobeItem);
    public int deleteWardrobeItemById(Long id);
    public int deleteWardrobeItemByIds(Long[] ids);
}