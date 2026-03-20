import request from '@/utils/request'

// ==================== 帖子相关 ====================

// 获取帖子列表
export function getPosts(params) {
  return request({
    url: '/outfit-api/posts',
    method: 'get',
    params: params
  })
}

// 获取帖子详情
export function getPost(id) {
  return request({
    url: `/outfit-api/post/${id}`,
    method: 'get'
  })
}

// 发布帖子
export function createPost(data) {
  return request({
    url: '/outfit-api/post',
    method: 'post',
    data: data
  })
}

// 点赞/取消点赞帖子
export function togglePostLike(postId, userId) {
  return request({
    url: `/outfit-api/post/${postId}/like`,
    method: 'post',
    params: { userId: userId }
  })
}

// 收藏/取消收藏帖子
export function togglePostCollect(postId, userId) {
  return request({
    url: `/outfit-api/post/${postId}/collect`,
    method: 'post',
    params: { userId: userId }
  })
}

// 获取帖子点赞收藏状态
export function getPostStatus(postId, userId) {
  return request({
    url: `/outfit-api/post/${postId}/status`,
    method: 'get',
    params: { userId: userId }
  })
}

// ==================== 评论相关 ====================

// 获取评论列表
export function getComments(postId) {
  return request({
    url: `/outfit-api/post/${postId}/comments`,
    method: 'get'
  })
}

// 发表评论
export function addComment(data) {
  return request({
    url: '/outfit-api/comment',
    method: 'post',
    data: data
  })
}

// 点赞评论
export function toggleCommentLike(commentId, userId) {
  return request({
    url: `/outfit-api/comment/${commentId}/like`,
    method: 'post',
    params: { userId: userId }
  })
}

// ==================== 用户相关 ====================

// 获取当前用户
export function getCurrentUser() {
  return request({
    url: '/outfit-api/user/current',
    method: 'get'
  })
}