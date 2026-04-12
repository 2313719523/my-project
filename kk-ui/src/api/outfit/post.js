import request from '@/utils/request'

// 新增穿搭发布
export function addPost(data) {
  return request({
    url: '/outfit/outfit', 
    method: 'post',        
    data: data            
  })
}