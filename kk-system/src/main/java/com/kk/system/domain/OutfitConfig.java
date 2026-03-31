

package com.kk.system.domain;

import com.kk.common.core.domain.BaseEntity;
import lombok.Data;

/**
 * 穿搭配置对象 outfit_config
 */
@Data
public class OutfitConfig extends BaseEntity {
    private Long configId;
    private String configType; // 类型
    private String configName; // 名称
    private String status;     // 状态
}