package com.kk.web.controller.system;

import com.kk.common.core.controller.BaseController;
import com.kk.common.core.domain.AjaxResult;
import com.kk.common.core.page.TableDataInfo;
import com.kk.system.domain.OutfitPost;
import com.kk.system.mapper.OutfitPostMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/outfit/audit")
public class OutfitAuditController extends BaseController {

    @Autowired
    private OutfitPostMapper outfitPostMapper;

    /** 查询待审核列表 */
    @GetMapping("/list")
    public TableDataInfo list(OutfitPost post) {
        startPage();
        List<OutfitPost> list = outfitPostMapper.selectOutfitPostList(post);
        return getDataTable(list);
    }

    /** 审核操作 */
    @PutMapping("/status")
    public AjaxResult changeStatus(@RequestBody OutfitPost post) {
        return toAjax(outfitPostMapper.updateOutfitPostStatus(post));
    }
}