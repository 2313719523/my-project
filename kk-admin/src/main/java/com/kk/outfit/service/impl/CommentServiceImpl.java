package com.kk.outfit.service.impl;

import com.kk.common.core.domain.AjaxResult;
import com.kk.common.utils.SecurityUtils;
import com.kk.outfit.domain.Comment;
import com.kk.outfit.domain.Outfit;
import com.kk.outfit.mapper.CommentMapper;
import com.kk.outfit.mapper.OutfitMapper;
import com.kk.outfit.service.ICommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
public class CommentServiceImpl implements ICommentService {

    @Autowired
    private CommentMapper commentMapper;
    
    @Autowired
    private OutfitMapper outfitMapper;

    @Override
    public List<Comment> selectCommentsByOutfitId(Long outfitId) {
        return commentMapper.selectCommentByOutfitId(outfitId);
    }

    @Override
    @Transactional
    public AjaxResult addComment(Comment comment) {
        comment.setUserId(SecurityUtils.getUserId());
        int result = commentMapper.insertComment(comment);
        
        if (result > 0 && comment.getOutfitId() != null) {
            Outfit outfit = outfitMapper.selectOutfitByOutfitId(comment.getOutfitId());
            if (outfit != null) {
                outfit.setCommentCount(outfit.getCommentCount() == null ? 1 : outfit.getCommentCount() + 1);
                outfitMapper.updateOutfit(outfit);
            }
        }
        
        return toAjax(result);
    }

    @Override
    @Transactional
    public AjaxResult deleteComment(Long commentId) {
        Comment comment = commentMapper.selectCommentById(commentId);
        if (comment == null) {
            return AjaxResult.error("评论不存在");
        }
        if (!comment.getUserId().equals(SecurityUtils.getUserId())) {
            return AjaxResult.error("只能删除自己的评论");
        }
        commentMapper.deleteComment(commentId);
        
        if (comment.getOutfitId() != null) {
            Outfit outfit = outfitMapper.selectOutfitByOutfitId(comment.getOutfitId());
            if (outfit != null && outfit.getCommentCount() != null && outfit.getCommentCount() > 0) {
                outfit.setCommentCount(outfit.getCommentCount() - 1);
                outfitMapper.updateOutfit(outfit);
            }
        }
        
        return AjaxResult.success("删除成功");
    }

    private AjaxResult toAjax(int rows) {
        return rows > 0 ? AjaxResult.success() : AjaxResult.error();
    }
}