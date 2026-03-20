package com.kk.wardrobe.mapper;

import java.util.List;
import com.kk.wardrobe.domain.WardrobeItem;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface WardrobeItemMapper {
    public WardrobeItem selectWardrobeItemById(Long id);
    public List<WardrobeItem> selectWardrobeItemList(WardrobeItem wardrobeItem);
    public int insertWardrobeItem(WardrobeItem wardrobeItem);
    public int updateWardrobeItem(WardrobeItem wardrobeItem);
    public int deleteWardrobeItemById(Long id);
    public int deleteWardrobeItemByIds(Long[] ids);
}