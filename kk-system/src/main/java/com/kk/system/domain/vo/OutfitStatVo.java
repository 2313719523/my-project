package com.kk.system.domain.vo;

/**
 * 首页看板统计数据对象 - 对接真实表字段
 */
public class OutfitStatVo {
    private Long activeUserCount;    // 当前活跃用户 (查 sys_user 表)
    private Long todayPostCount;     // 今日方案发布量 (查 outfit_post 的 create_time)
    private String hotStyle;         // 热门风格排行 (查 outfit_post 的 tags)
    private Long auditWarningCount;  // 违规内容预警 (查 outfit_post 的 status)

    public Long getActiveUserCount() { return activeUserCount; }
    public void setActiveUserCount(Long activeUserCount) { this.activeUserCount = activeUserCount; }

    public Long getTodayPostCount() { return todayPostCount; }
    public void setTodayPostCount(Long todayPostCount) { this.todayPostCount = todayPostCount; }

    public String getHotStyle() { return hotStyle; }
    public void setHotStyle(String hotStyle) { this.hotStyle = hotStyle; }

    public Long getAuditWarningCount() { return auditWarningCount; }
    public void setAuditWarningCount(Long auditWarningCount) { this.auditWarningCount = auditWarningCount; }
}