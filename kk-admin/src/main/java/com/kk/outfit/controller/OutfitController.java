package com.kk.outfit.controller;

import java.util.List;
import javax.servlet.http.HttpServletResponse;

import com.kk.common.utils.SecurityUtils;
import com.kk.outfit.domain.Outfit;
import com.kk.outfit.service.ILikeService;
import com.kk.outfit.service.IFavoriteService;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.kk.common.annotation.Log;
import com.kk.common.core.controller.BaseController;
import com.kk.common.core.domain.AjaxResult;
import com.kk.common.enums.BusinessType;
import com.kk.outfit.service.IOutfitService;
import com.kk.common.utils.poi.ExcelUtil;
import com.kk.common.core.page.TableDataInfo;

@RestController
@RequestMapping("/outfit/outfit")
public class OutfitController extends BaseController
{
    @Autowired
    private IOutfitService outfitService;

    @Autowired
    private ILikeService likeService;

    @Autowired
    private IFavoriteService favoriteService;

    @PreAuthorize("@ss.hasPermi('system:outfit:list')")
    @GetMapping("/list")
    public TableDataInfo list(Outfit outfit)
    {
        startPage();
        List<Outfit> list = outfitService.selectOutfitList(outfit);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('system:outfit:export')")
    @Log(title = "穿搭主", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Outfit outfit)
    {
        List<Outfit> list = outfitService.selectOutfitList(outfit);
        ExcelUtil<Outfit> util = new ExcelUtil<Outfit>(Outfit.class);
        util.exportExcel(response, list, "穿搭主数据");
    }

    @PreAuthorize("@ss.hasPermi('system:outfit:que')")
    @GetMapping(value = "/{outfitId}")
    public AjaxResult getInfo(@PathVariable("outfitId") Long outfitId)
    {
        return success(outfitService.selectOutfitByOutfitId(outfitId));
    }

    @PreAuthorize("@ss.hasPermi('system:outfit:add')")
    @Log(title = "穿搭主", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Outfit outfit)
    {
        outfit.setUserId(SecurityUtils.getUserId());
        return toAjax(outfitService.insertOutfit(outfit));
    }

    @PreAuthorize("@ss.hasPermi('system:outfit:edit')")
    @Log(title = "穿搭主", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Outfit outfit)
    {
        return toAjax(outfitService.updateOutfit(outfit));
    }

    @PreAuthorize("@ss.hasPermi('system:outfit:remove')")
    @Log(title = "穿搭主", businessType = BusinessType.DELETE)
    @DeleteMapping("/{outfitIds}")
    public AjaxResult remove(@PathVariable Long[] outfitIds)
    {
        return toAjax(outfitService.deleteOutfitByOutfitIds(outfitIds));
    }

    @GetMapping("/recommend")
    public TableDataInfo recommend(Outfit outfit)
    {
        startPage();
        outfit.setStatus("0");
        List<Outfit> list = outfitService.selectOutfitList(outfit);
        return getDataTable(list);
    }

    @GetMapping("/user/{userId}")
    public TableDataInfo userOutfits(@PathVariable Long userId, Outfit outfit)
    {
        startPage();
        outfit.setUserId(userId);
        outfit.setStatus("0");
        List<Outfit> list = outfitService.selectOutfitList(outfit);
        return getDataTable(list);
    }

    @PutMapping("/view/{outfitId}")
    public AjaxResult addView(@PathVariable Long outfitId)
    {
        Outfit outfit = outfitService.selectOutfitByOutfitId(outfitId);
        if (outfit != null) {
            outfit.setViewCount(outfit.getViewCount() == null ? 1 : outfit.getViewCount() + 1);
            return toAjax(outfitService.updateOutfit(outfit));
        }
        return AjaxResult.error("穿搭不存在");
    }

    @GetMapping("/checkLike/{outfitId}")
    public AjaxResult checkLike(@PathVariable Long outfitId)
    {
        return AjaxResult.success(likeService.hasUserLiked(SecurityUtils.getUserId(), outfitId));
    }

    @GetMapping("/checkFavorite/{outfitId}")
    public AjaxResult checkFavorite(@PathVariable Long outfitId)
    {
        return AjaxResult.success(favoriteService.hasUserFavorited(SecurityUtils.getUserId(), outfitId));
    }
}