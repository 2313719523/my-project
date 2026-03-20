package com.kk.outfit.controller;

import com.kk.common.core.controller.BaseController;
import com.kk.common.core.domain.AjaxResult;
import com.kk.common.core.page.TableDataInfo;
import com.kk.common.utils.SecurityUtils;
import com.kk.outfit.domain.Outfit;
import com.kk.outfit.service.IFavoriteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/outfit/favorite")
public class FavoriteController extends BaseController {

    @Autowired
    private IFavoriteService favoriteService;

    @PostMapping("/{outfitId}")
    public AjaxResult favorite(@PathVariable Long outfitId) {
        return favoriteService.favorite(outfitId);
    }

    @GetMapping("/check/{outfitId}")
    public AjaxResult checkFavorite(@PathVariable Long outfitId) {
        boolean favorited = favoriteService.hasUserFavorited(SecurityUtils.getUserId(), outfitId);
        return AjaxResult.success(favorited);
    }

    @GetMapping("/count/{outfitId}")
    public AjaxResult count(@PathVariable Long outfitId) {
        return AjaxResult.success(favoriteService.countFavorites(outfitId));
    }

    @GetMapping("/my")
    public TableDataInfo myFavorites() {
        startPage();
        List<Outfit> list = favoriteService.selectMyFavorites();
        return getDataTable(list);
    }
}