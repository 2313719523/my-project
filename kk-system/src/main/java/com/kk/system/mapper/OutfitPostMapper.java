package com.kk.system.mapper;

import java.util.List;
import com.kk.system.domain.OutfitPost;
import com.kk.system.domain.vo.OutfitStatVo;

/**
 * 穿搭文章Mapper接口
 */
public interface OutfitPostMapper {
    /** 查询穿搭列表 */
    public List<OutfitPost> selectOutfitPostList(OutfitPost outfitPost);

    /** 修改穿搭状态 */
    public int updateOutfitPostStatus(OutfitPost outfitPost);

    public OutfitStatVo selectOutfitStatistics();
}