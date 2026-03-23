import os
import cv2
import numpy as np
from ultralytics import YOLO

# 初始化模型
try:
    model = YOLO("yolov8n.pt")
except Exception as e:
    print(f"模型加载提醒: {e}")

def get_color_and_category(img_path, filename):
    img = cv2.imread(img_path)
    if img is None:
        return "其他", "未知"
    
    # 类别匹配
    category = "其他"
    keywords = ["T恤", "衬衫", "短裤", "开衫", "半身裙", "连衣裙", "玛丽珍", "牛仔裤", "皮鞋", "卫衣", "西装裤", "运动背心", "运动鞋"]
    for k in keywords:
        if k in filename:
            category = k
            break
            
    # 颜色匹配
    h, w = img.shape[:2]
    roi = img[int(h*0.3):int(h*0.7), int(w*0.3):int(w*0.7)]
    avg_bgr = np.mean(roi, axis=(0, 1))
    b, g, r = avg_bgr
    
    color = "彩色"
    if r < 65 and g < 65 and b < 65: color = "黑色"
    elif r > 210 and g > 210 and b > 210: color = "白色"
    elif b > r + 20: color = "蓝色"
    elif r > g + 20: color = "红色"
    elif abs(r-g) < 15: color = "灰色"
    else: color = "米色/浅色"
    
    return category, color

def main():
    image_folder = "images" 
    if not os.path.exists(image_folder):
        print(f"❌ 错误：找不到 '{image_folder}' 文件夹！")
        return

    sql_file = "import_clothes.sql"
    base_url = "/profile/upload/" 
    
    count = 0
    print("🚀 开始扫描并生成 SQL...")

    with open(sql_file, "w", encoding="utf-8") as f:
        f.write("TRUNCATE TABLE sys_wardrobe_item;\n\n")
        
        for filename in os.listdir(image_folder):
            if filename.lower().endswith(('.jpg', '.png', '.jpeg')):
                path = os.path.join(image_folder, filename)
                cat, col = get_color_and_category(path, filename)
                safe_name = filename.replace("'", "''")
                
                sql = (f"INSERT INTO sys_wardrobe_item (file_name, category, color, img_url) "
                       f"VALUES ('{safe_name}', '{cat}', '{col}', '{base_url}{safe_name}');\n")
                
                f.write(sql)
                count += 1
                print(f"识别成功: {filename} -> {cat}")
                
    print(f"\n✅ 完成！SQL已生成在: {sql_file}")

if __name__ == "__main__":
    main()