import cv2
import os
import numpy as np
from ultralytics import YOLO

# 1. 初始化（第一次运行会自动下载yolov8n.pt模型，约6MB）
model = YOLO("yolov8n.pt")

def get_smart_color(img, category):
    """ 
    智能取色算法：根据服装大类自动调整取色区域
    """
    h, w = img.shape[:2]
    
    # --- 区域分配策略 ---
    if any(k in category for k in ["鞋", "玛丽珍"]):
        # 鞋类：取图片中下方核心区域
        roi = img[int(h*0.5):int(h*0.8), int(w*0.3):int(w*0.7)]
    elif any(k in category for k in ["裤", "裙"]):
        # 裤/裙：取中段区域
        roi = img[int(h*0.3):int(h*0.7), int(w*0.3):int(w*0.7)]
    else:
        # 上衣/背心：取胸部中心区域
        roi = img[int(h*0.2):int(h*0.6), int(w*0.3):int(w*0.7)]

    # 颜色转换与噪点过滤
    rgb_roi = cv2.cvtColor(roi, cv2.COLOR_BGR2RGB)
    pixels = rgb_roi.reshape(-1, 3)
    
    # 过滤背景干扰（太亮或太暗的像素点剔除）
    valid = pixels[(np.sum(pixels, axis=1) > 40) & (np.sum(pixels, axis=1) < 700)]
    if len(valid) == 0: return "灰色"
    
    avg_color = np.mean(valid, axis=0)
    r, g, b = avg_color

    # --- 核心颜色逻辑库（针对你的照片调优） ---
    # 1. 基础色
    if r < 55 and g < 55 and b < 55: return "黑色"
    if r > 225 and g > 225 and b > 225: return "白色"
    if abs(r - g) < 15 and abs(g - b) < 15:
        return "深灰色" if r < 120 else "浅灰色"

    # 2. 蓝色/牛仔专项
    if b > r + 15:
        if b > 160: return "天蓝色/浅蓝"
        if b < 100: return "藏青色/深蓝"
        return "经典牛仔蓝"

    # 3. 暖色/大地色（卫衣、短裤、开衫常见）
    if r > 185 and g > 170 and b > 140: return "米色/杏色"
    if r > 120 and g > 90 and b < 100: return "咖色/棕色"
    if r > g + 40 and r > b + 40: return "红色/酒红"
    
    # 4. 绿色
    if g > r + 15 and g > b + 10: return "绿色"

    return "彩色/复合色"

def run_analysis(folder_path):
    """ 批量识别文件夹内的所有图片 """
    print(f"{'文件名':<20} | {'识别大类':<10} | {'特征颜色':<10}")
    print("-" * 55)
    
    # 定义你要识别的所有大类关键字
    keywords = ["T恤", "衬衫", "短裤", "开衫", "半身裙", "连衣裙", 
                "玛丽珍", "牛仔裤", "皮鞋", "卫衣", "西装裤", "运动背心", "运动鞋"]

    if not os.path.exists(folder_path):
        print(f"错误：找不到文件夹 '{folder_path}'")
        return

    for filename in os.listdir(folder_path):
        if not filename.lower().endswith(('.jpg', '.png', '.jpeg')):
            continue
            
        # 匹配大类：根据文件名强制锁定
        category = "未知大类"
        for key in keywords:
            if key in filename:
                category = key
                break
        
        # 读取并处理
        img_path = os.path.join(folder_path, filename)
        img = cv2.imread(img_path)
        if img is None: continue
        
        color = get_smart_color(img, category)
        
        # 结果输出
        print(f"{filename:<20} | {category:<10} | {color}")

if __name__ == "__main__":
    # 请确保你的所有照片都在同目录下的 images 文件夹里
    input_folder = "images" 
    run_analysis(input_folder)