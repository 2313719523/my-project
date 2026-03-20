import request from '@/utils/request'

// 查询单品列表
export function listItem(query) {
  return request({
    url: '/wardrobe/item/list',
    method: 'get',
    params: query
  })
}

// 查询单品详细
export function getItem(id) {
  return request({
    url: '/wardrobe/item/' + id,
    method: 'get'
  })
}

// 新增单品
export function addItem(data) {
  return request({
    url: '/wardrobe/item',
    method: 'post',
    data: data
  })
}

// 修改单品
export function updateItem(data) {
  return request({
    url: '/wardrobe/item',
    method: 'put',
    data: data
  })
}

// 删除单品
export function delItem(ids) {
  return request({
    url: '/wardrobe/item/' + ids,
    method: 'delete'
  })
}

// 导出单品
export function exportItem(query) {
  return request({
    url: '/wardrobe/item/export',
    method: 'get',
    params: query
  })
}