package com.kk.outfit.service;

import java.util.List;
import com.kk.outfit.domain.Outfit;

/**
 * 穿搭主Service接口
 * 
 * @author kk
 * @date 2026-01-27
 */
public interface IOutfitService
{
    /**
     * 查询穿搭主
     * 
     * @param outfitId 穿搭主主键
     * @return 穿搭主
     */
    public Outfit selectOutfitByOutfitId(Long outfitId);

    /**
     * 查询穿搭主列表
     * 
     * @param Outfit 穿搭主
     * @return 穿搭主集合
     */
    public List<Outfit> selectOutfitList(Outfit Outfit);

    /**
     * 新增穿搭主
     * 
     * @param Outfit 穿搭主
     * @return 结果
     */
    public int insertOutfit(Outfit Outfit);

    /**
     * 修改穿搭主
     * 
     * @param Outfit 穿搭主
     * @return 结果
     */
    public int updateOutfit(Outfit Outfit);

    /**
     * 批量删除穿搭主
     * 
     * @param outfitIds 需要删除的穿搭主主键集合
     * @return 结果
     */
    public int deleteOutfitByOutfitIds(Long[] outfitIds);

    /**
     * 删除穿搭主信息
     * 
     * @param outfitId 穿搭主主键
     * @return 结果
     */
    public int deleteOutfitByOutfitId(Long outfitId);
}
