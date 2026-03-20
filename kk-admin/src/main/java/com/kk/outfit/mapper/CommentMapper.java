package com.kk.outfit.mapper;

import com.kk.outfit.domain.Comment;
import java.util.List;

public interface CommentMapper {
    public List<Comment> selectCommentByOutfitId(Long outfitId);
    public int insertComment(Comment comment);
    public int deleteComment(Long commentId);
    public int deleteCommentByOutfitId(Long outfitId);
    public Comment selectCommentById(Long commentId);
}