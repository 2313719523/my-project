package com.kk.outfit.service.impl;

import java.util.List;
import com.kk.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.kk.outfit.mapper.OutfitMapper;
import com.kk.outfit.domain.Outfit;
import com.kk.outfit.service.IOutfitService;
// 必须导入这个VO类，否则selectOutfitStatistics会报错
import com.kk.system.domain.vo.OutfitStatVo;

/**
 * 穿搭主Service业务层处理
 */
@Service
public class OutfitServiceImpl implements IOutfitService
{
    @Autowired
    private OutfitMapper outfitMapper;

    /**
     * 实现首页看板统计数据接口
     * 这是解决你报错的关键代码
     */
    @Override
    public OutfitStatVo selectOutfitStatistics()
    {
        return outfitMapper.selectOutfitStatistics();
    }

    /**
     * 查询穿搭主
     */
    @Override
    public Outfit selectOutfitByOutfitId(Long outfitId)
    {
        return outfitMapper.selectOutfitByOutfitId(outfitId);
    }

    /**
     * 查询穿搭主列表
     */
    @Override
    public List<Outfit> selectOutfitList(Outfit outfit)
    {
        return outfitMapper.selectOutfitList(outfit);
    }

    /**
     * 新增穿搭主
     */
    @Override
    public int insertOutfit(Outfit outfit)
    {
        outfit.setCreateTime(DateUtils.getNowDate());
        return outfitMapper.insertOutfit(outfit);
    }

    /**
     * 修改穿搭主
     */
    @Override
    public int updateOutfit(Outfit outfit)
    {
        outfit.setUpdateTime(DateUtils.getNowDate());
        return outfitMapper.updateOutfit(outfit);
    }

    /**
     * 批量删除穿搭主
     */
    @Override
    public int deleteOutfitByOutfitIds(Long[] outfitIds)
    {
        return outfitMapper.deleteOutfitByOutfitIds(outfitIds);
    }

    /**
     * 删除穿搭主信息
     */
    @Override
    public int deleteOutfitByOutfitId(Long outfitId)
    {
        return outfitMapper.deleteOutfitByOutfitId(outfitId);
    }
}