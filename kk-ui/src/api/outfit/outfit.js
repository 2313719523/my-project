import request from '@/utils/request'

// 查询穿搭列表
export function listOutfit(query) {
  return request({
    url: '/outfit/outfit/list',
    method: 'get',
    params: query
  })
}

// 查询穿搭详细
export function getOutfit(outfitId) {
  return request({
    url: '/outfit/outfit/' + outfitId,
    method: 'get'
  })
}

// 新增穿搭
export function addOutfit(data) {
  return request({
    url: '/outfit/outfit',
    method: 'post',
    data: data
  })
}

// 修改穿搭
export function updateOutfit(data) {
  return request({
    url: '/outfit/outfit',
    method: 'put',
    data: data
  })
}

// 删除穿搭
export function delOutfit(outfitId) {
  return request({
    url: '/outfit/outfit/' + outfitId,
    method: 'delete'
  })
}

// 导出穿搭
export function exportOutfit(query) {
  return request({
    url: '/outfit/outfit/export',
    method: 'post',
    data: query
  })
}

// 点赞/取消点赞
export function likeOutfit(outfitId) {
  return request({
    url: '/outfit/like/' + outfitId,
    method: 'post'
  })
}

// 检查是否点赞
export function checkLike(outfitId) {
  return request({
    url: '/outfit/like/check/' + outfitId,
    method: 'get'
  })
}

// 获取点赞数
export function getLikeCount(outfitId) {
  return request({
    url: '/outfit/like/count/' + outfitId,
    method: 'get'
  })
}

// 获取评论列表
export function listComment(outfitId, query) {
  return request({
    url: '/outfit/comment/list/' + outfitId,
    method: 'get',
    params: query
  })
}

// 发表评论
export function addComment(data) {
  return request({
    url: '/outfit/comment',
    method: 'post',
    data: data
  })
}

// 删除评论
export function delComment(commentId) {
  return request({
    url: '/outfit/comment/' + commentId,
    method: 'delete'
  })
}

// 收藏/取消收藏
export function favoriteOutfit(outfitId) {
  return request({
    url: '/outfit/favorite/' + outfitId,
    method: 'post'
  })
}

// 检查是否收藏
export function checkFavorite(outfitId) {
  return request({
    url: '/outfit/favorite/check/' + outfitId,
    method: 'get'
  })
}

// 获取收藏数
export function getFavoriteCount(outfitId) {
  return request({
    url: '/outfit/favorite/count/' + outfitId,
    method: 'get'
  })
}

// 我的收藏列表
export function myFavorites(query) {
  return request({
    url: '/outfit/favorite/my',
    method: 'get',
    params: query
  })
}

// 首页推荐
export function recommendOutfit(query) {
  return request({
    url: '/outfit/outfit/recommend',
    method: 'get',
    params: query
  })
}

// 用户穿搭列表
export function getUserOutfits(userId, query) {
  return request({
    url: '/outfit/outfit/user/' + userId,
    method: 'get',
    params: query
  })
}

// 增加浏览量
export function addViewCount(outfitId) {
  return request({
    url: '/outfit/outfit/view/' + outfitId,
    method: 'put'
  })
}