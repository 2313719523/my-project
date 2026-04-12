package com.kk.outfit.controller;

import java.util.List;
import com.kk.common.utils.SecurityUtils;
import com.kk.outfit.domain.Outfit;
import com.kk.outfit.service.IOutfitService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.kk.common.core.controller.BaseController;
import com.kk.common.core.domain.AjaxResult;
import com.kk.common.core.page.TableDataInfo;

@RestController
@RequestMapping("/outfit/outfit")
public class OutfitController extends BaseController {

    @Autowired
    private IOutfitService outfitService;

    @PostMapping
    public AjaxResult add(@RequestBody Outfit outfit) {
        // 设置当前用户ID
        outfit.setUserId(SecurityUtils.getUserId());
        // 初始状态为待审核
        outfit.setStatus("0");
        return toAjax(outfitService.insertOutfit(outfit));
    }

    @GetMapping("/recommend")
    public TableDataInfo recommend(Outfit outfit) {
        startPage();
        outfit.setStatus("1"); // 首页只查已通过的
        List<Outfit> list = outfitService.selectOutfitList(outfit);
        return getDataTable(list);
    }

    @GetMapping("/list")
    public TableDataInfo list(Outfit outfit) {
        startPage();
        List<Outfit> list = outfitService.selectOutfitList(outfit);
        return getDataTable(list);
    }
}