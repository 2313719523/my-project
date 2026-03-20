package com.kk.outfit.service;

import com.kk.common.core.domain.AjaxResult;
import com.kk.outfit.domain.Comment;
import java.util.List;

public interface ICommentService {
    public List<Comment> selectCommentsByOutfitId(Long outfitId);
    public AjaxResult addComment(Comment comment);
    public AjaxResult deleteComment(Long commentId);
}