import request from '@/utils/request'

// 获取AI穿搭推荐
export function getAIRecommendation(data) {
  return request({
    url: '/wardrobe/recommend/ai',
    method: 'post',
    timeout: 20000,
    data: data
  })
}

// 获取推荐历史
export function getRecommendHistory(params) {
  return request({
    url: '/wardrobe/recommend/history',
    method: 'get',
    params: params
  })
}