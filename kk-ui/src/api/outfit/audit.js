import request from '@/utils/request'

// 查询穿搭列表（支持按用户名、状态、标题筛选）
export function listAuditPosts(query) {
  return request({
    url: '/outfit/audit/list',
    method: 'get',
    params: query
  })
}

// 修改穿搭状态（审核：1通过，2违规）
export function updatePostStatus(id, status) {
  return request({
    url: '/outfit/audit/status',
    method: 'put',
    data: {
      id: id,
      status: status
    }
  })
}