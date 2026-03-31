package com.kk.system.mapper;

import com.kk.system.domain.OutfitConfig;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
@Mapper
public interface OutfitConfigMapper {
    /** 查询所有配置列表 */
    public List<OutfitConfig> selectOutfitConfigList(OutfitConfig config);

    /** 新增配置 */
    public int insertOutfitConfig(OutfitConfig config);

    /** 删除配置 */
    public int deleteOutfitConfigById(Long configId);
}