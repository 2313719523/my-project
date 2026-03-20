package com.kk.outfit.service.impl;

import java.util.List;
import com.kk.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.kk.outfit.mapper.OutfitMapper;
import com.kk.outfit.domain.Outfit;
import com.kk.outfit.service.IOutfitService;

/**
 * 穿搭主Service业务层处理
 * 
 * @author kk
 * @date 2026-01-27
 */
@Service
public class OutfitServiceImpl implements IOutfitService
{
    @Autowired
    private OutfitMapper OutfitMapper;

    /**
     * 查询穿搭主
     * 
     * @param outfitId 穿搭主主键
     * @return 穿搭主
     */
    @Override
    public Outfit selectOutfitByOutfitId(Long outfitId)
    {
        return OutfitMapper.selectOutfitByOutfitId(outfitId);
    }

    /**
     * 查询穿搭主列表
     * 
     * @param Outfit 穿搭主
     * @return 穿搭主
     */
    @Override
    public List<Outfit> selectOutfitList(Outfit Outfit)
    {
        return OutfitMapper.selectOutfitList(Outfit);
    }

    /**
     * 新增穿搭主
     * 
     * @param Outfit 穿搭主
     * @return 结果
     */
    @Override
    public int insertOutfit(Outfit Outfit)
    {
        Outfit.setCreateTime(DateUtils.getNowDate());
        return OutfitMapper.insertOutfit(Outfit);
    }

    /**
     * 修改穿搭主
     * 
     * @param Outfit 穿搭主
     * @return 结果
     */
    @Override
    public int updateOutfit(Outfit Outfit)
    {
        Outfit.setUpdateTime(DateUtils.getNowDate());
        return OutfitMapper.updateOutfit(Outfit);
    }

    /**
     * 批量删除穿搭主
     * 
     * @param outfitIds 需要删除的穿搭主主键
     * @return 结果
     */
    @Override
    public int deleteOutfitByOutfitIds(Long[] outfitIds)
    {
        return OutfitMapper.deleteOutfitByOutfitIds(outfitIds);
    }

    /**
     * 删除穿搭主信息
     * 
     * @param outfitId 穿搭主主键
     * @return 结果
     */
    @Override
    public int deleteOutfitByOutfitId(Long outfitId)
    {
        return OutfitMapper.deleteOutfitByOutfitId(outfitId);
    }
}
