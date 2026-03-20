package com.kk.outfit.controller;

import com.kk.common.core.controller.BaseController;
import com.kk.common.core.domain.AjaxResult;
import com.kk.common.core.page.TableDataInfo;
import com.kk.outfit.domain.Comment;
import com.kk.outfit.service.ICommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/outfit/comment")
public class CommentController extends BaseController {

    @Autowired
    private ICommentService commentService;

    @GetMapping("/list/{outfitId}")
    public TableDataInfo list(@PathVariable Long outfitId) {
        startPage();
        List<Comment> list = commentService.selectCommentsByOutfitId(outfitId);
        return getDataTable(list);
    }

    @PostMapping
    public AjaxResult add(@RequestBody Comment comment) {
        return commentService.addComment(comment);
    }

    @DeleteMapping("/{commentId}")
    public AjaxResult remove(@PathVariable Long commentId) {
        return commentService.deleteComment(commentId);
    }
}