package com.kk.wardrobe.service.impl;

import com.kk.wardrobe.dto.AiRecommendRequest;
import com.kk.wardrobe.dto.AiRecommendResponse;
import com.kk.wardrobe.service.AiRecommendService;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.FileUtils;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import java.io.File;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

@Slf4j
@Service("localRuleService") // ✅ 给它起个名字，方便注入时区分
public class LocalRuleServiceImpl implements AiRecommendService {

    private final Random random = new Random();

    /**
     * 获取穿搭推荐 - 本地规则版
     */
    public AiRecommendResponse getOutfitRecommendation(AiRecommendRequest request) {
        log.info("收到推荐请求: {}岁, {}, {}身材, {}℃, {}",
                request.getAge(),
                request.getOccasion(),
                request.getBodyType(),
                request.getTemperature(),
                request.getGender());

        try {
            // 1. 读取本地知识库
            String knowledgeBase = readKnowledgeBase();
            log.info("读取知识库成功，长度: {}字符", knowledgeBase.length());

            // 2. 基于规则生成推荐
            AiRecommendResponse response = generateLocalRecommendation(request, knowledgeBase);
            log.info("推荐生成成功");

            return response;

        } catch (Exception e) {
            log.error("生成推荐失败", e);
            // 返回最基础的推荐
            return getBasicRecommendation(request);
        }
    }

    /**
     * 基于本地规则生成推荐
     */
    private AiRecommendResponse generateLocalRecommendation(AiRecommendRequest request, String knowledgeBase) {
        AiRecommendResponse response = new AiRecommendResponse();

        // 生成推荐方案
        String recommendation = generateOutfit(request);
        String reason = generateReason(request);
        String styleTips = generateStyleTips(request);
        String tempAdvice = getTemperatureAdvice(request.getTemperature());

        response.setRecommendation(recommendation);
        response.setReason(reason);
        response.setStyleTips(styleTips);
        response.setTemperatureAdvice(tempAdvice);

        return response;
    }

    /**
     * 生成具体的穿搭方案
     */
    private String generateOutfit(AiRecommendRequest request) {
        Map<String, String> outfit = new HashMap<>();

        // 根据场合选择
        switch (request.getOccasion()) {
            case "商务晚宴":
                outfit.put("上衣", "黑色西装/深色礼服衬衫");
                outfit.put("下装", "黑色西裤/及膝A字裙");
                outfit.put("外套", "西装外套/小香风外套");
                outfit.put("鞋子", "黑色皮鞋/尖头高跟鞋");
                outfit.put("配饰", "简约手表 + 珍珠/钻石饰品");
                break;

            case "商务会议":
                outfit.put("上衣", "白色/浅蓝色衬衫");
                outfit.put("下装", "西裤/铅笔裙");
                outfit.put("外套", "西装外套/针织开衫");
                outfit.put("鞋子", "乐福鞋/中跟鞋");
                outfit.put("配饰", "简约手表 + 公文包");
                break;

            case "日常办公":
                outfit.put("上衣", "衬衫/针织衫/ polo衫");
                outfit.put("下装", "卡其裤/直筒裤/半身裙");
                outfit.put("外套", "风衣/牛仔外套");
                outfit.put("鞋子", "乐福鞋/平底鞋/小白鞋");
                outfit.put("配饰", "简约包包 + 丝巾");
                break;

            case "朋友聚会":
                outfit.put("上衣", "T恤/卫衣/针织衫");
                outfit.put("下装", "牛仔裤/休闲裤/短裙");
                outfit.put("外套", "牛仔外套/飞行员夹克");
                outfit.put("鞋子", "运动鞋/帆布鞋/靴子");
                outfit.put("配饰", "帽子 + 斜挎包");
                break;

            case "约会":
                outfit.put("上衣", "连衣裙/蕾丝上衣");
                outfit.put("下装", "半身裙/阔腿裤");
                outfit.put("外套", "针织开衫/短外套");
                outfit.put("鞋子", "高跟鞋/玛丽珍鞋");
                outfit.put("配饰", "精致项链 + 手链");
                break;

            // 新增场景
            case "婚礼宾客":
                outfit.put("上衣", "连衣裙/礼服裙");
                outfit.put("下装", "-");
                outfit.put("外套", "披肩/小外套");
                outfit.put("鞋子", "中跟/低跟皮鞋");
                outfit.put("配饰", "精致手包 + 珍珠饰品");
                break;

            case "面试场合":
                outfit.put("上衣", "衬衫/西装外套");
                outfit.put("下装", "西裤/及膝裙");
                outfit.put("外套", "西装外套");
                outfit.put("鞋子", "皮鞋/低跟船鞋");
                outfit.put("配饰", "简约手表 + 公文包");
                break;

            case "运动健身":
                outfit.put("上衣", "运动T恤/速干衣");
                outfit.put("下装", "运动裤/瑜伽裤");
                outfit.put("外套", "运动外套/防风衣");
                outfit.put("鞋子", "运动鞋/训练鞋");
                outfit.put("配饰", "运动水壶 + 发带");
                break;

            case "海边度假":
                outfit.put("上衣", "吊带/比基尼+罩衫");
                outfit.put("下装", "短裤/沙滩裙");
                outfit.put("外套", "防晒衣/薄开衫");
                outfit.put("鞋子", "沙滩鞋/凉鞋");
                outfit.put("配饰", "草帽 + 太阳镜");
                break;


            default:
                outfit.put("上衣", "基本款T恤/衬衫");
                outfit.put("下装", "牛仔裤/休闲裤");
                outfit.put("外套", "夹克/针织衫");
                outfit.put("鞋子", "运动鞋/休闲鞋");
                outfit.put("配饰", "背包/帽子");
        }

        // 考虑风格偏好
        if (request.getStylePreference() != null) {
            adjustForStylePreference(outfit, request.getStylePreference());
        }

        // 考虑预算
        if (request.getBudget() != null) {
            adjustForBudget(outfit, request.getBudget());
        }

        // 考虑身高体重
        adjustForHeightWeight(outfit, request.getHeight(), request.getWeight());

        //考虑尺码偏好
        adjustForSizePreference(outfit, request.getSizePreference());
        // 根据温度调整
        adjustForTemperature(outfit, request.getTemperature());

        // 根据身材调整
        adjustForBodyType(outfit, request.getBodyType());

        // 根据年龄调整
        adjustForAge(outfit, request.getAge());



        // 格式化输出
        StringBuilder sb = new StringBuilder();
        sb.append("👔 推荐穿搭方案：\n\n");
        outfit.forEach((key, value) -> {
            sb.append("• ").append(key).append("：").append(value).append("\n");
        });

        return sb.toString();
    }

    /**
     * 根据温度调整穿搭
     */
    private void adjustForTemperature(Map<String, String> outfit, int temperature) {
        if (temperature >= 30) {
            outfit.put("材质建议", "选择棉麻、真丝等透气材质");
            outfit.put("颜色建议", "浅色系更凉爽");
        } else if (temperature >= 20) {
            outfit.put("外套", "可选薄外套或不穿外套");
        } else if (temperature >= 10) {
            outfit.put("外套", "需要保暖外套如风衣、针织衫");
        } else if (temperature >= 0) {
            outfit.put("外套", "必须穿厚外套如羽绒服、大衣");
            outfit.put("保暖建议", "搭配围巾、手套");
        } else {
            outfit.put("外套", "加厚羽绒服/棉服");
            outfit.put("保暖建议", "保暖内衣 + 围巾 + 手套 + 帽子");
        }
    }

    /**
     * 根据身材调整
     */
    private void adjustForBodyType(Map<String, String> outfit, String bodyType) {
        switch (bodyType) {
            case "梨型身材":
                outfit.put("身材建议", "上浅下深，突出上半身，A字裙/阔腿裤平衡比例");
                break;
            case "苹果型身材":
                outfit.put("身材建议", "V领/露肩上衣，直筒裤/A字裙，突出腿部线条");
                break;
            case "沙漏型身材":
                outfit.put("身材建议", "收腰款式，突出腰部曲线，避免过于宽松");
                break;
            case "矩形身材":
                outfit.put("身材建议", "创造腰线，层次穿搭增加曲线感");
                break;
            default:
                outfit.put("身材建议", "选择合身不紧身的款式");
        }
    }

    /**
     * 根据年龄调整
     */
    private void adjustForAge(Map<String, String> outfit, int age) {
        if (age < 25) {
            outfit.put("风格建议", "年轻时尚，可以尝试流行元素");
            outfit.put("颜色推荐", "明亮色系、流行色");
        } else if (age < 35) {
            outfit.put("风格建议", "轻熟优雅，简约大方");
            outfit.put("颜色推荐", "中性色、莫兰迪色系");
        } else {
            outfit.put("风格建议", "成熟稳重，注重质感");
            outfit.put("颜色推荐", "经典色、深色系");
        }
    }

    // 根据风格偏好调整
    private void adjustForStylePreference(Map<String, String> outfit, String style) {
        switch (style) {
            case "复古风":
                outfit.put("风格元素", "波点/格纹/珍珠/丝绒");
                outfit.put("颜色建议", "大地色/酒红色/墨绿色");
                break;
            case "运动风":
                outfit.put("风格元素", "logo/条纹/束脚设计");
                outfit.put("材质建议", "棉质/速干面料");
                break;
            case "北欧冷淡风":
                outfit.put("风格元素", "廓形/简约/纯色");
                outfit.put("颜色建议", "黑白灰/莫兰迪色");
                break;
            // ... 其他风格
        }
    }

    // 根据预算调整
    private void adjustForBudget(Map<String, String> outfit, String budget) {
        switch (budget) {
            case "平价":
                outfit.put("品牌建议", "优衣库/ZARA/H&M");
                outfit.put("材质建议", "棉质/聚酯纤维");
                break;
            case "轻奢":
                outfit.put("品牌建议", "COS/Massimo Dutti/Theory");
                outfit.put("材质建议", "羊毛/真丝/羊绒");
                break;
            case "高端":
                outfit.put("品牌建议", "Max Mara/Burberry/Celine");
                outfit.put("材质建议", "高级定制面料");
                break;
        }
    }
    //根据身高体重调整
    private void adjustForHeightWeight(Map<String, String> outfit, Integer height, Integer weight) {
        if (height != null && weight != null) {
            // 计算BMI
            double heightM = height / 100.0;
            double bmi = weight / (heightM * heightM);

            outfit.put("BMI指数", String.format("%.1f", bmi));

            if (bmi < 18.5) {
                outfit.put("身材建议", "偏瘦：建议层次穿搭增加体积感");
                outfit.put("剪裁建议", "宽松/有层次感的款式");
            } else if (bmi < 24) {
                outfit.put("身材建议", "标准：各种款式都适合");
                outfit.put("剪裁建议", "合身剪裁最显气质");
            } else if (bmi < 28) {
                outfit.put("身材建议", "偏胖：选择垂坠感好的材质");
                outfit.put("剪裁建议", "直筒/微喇款式，避免紧身");
            } else {
                outfit.put("身材建议", "肥胖：深色系显瘦，避免横条纹");
                outfit.put("剪裁建议", "宽松但要有型，注意腰线");
            }
        }
    }

    private void adjustForSizePreference(Map<String, String> outfit, String sizePreference) {
        if (sizePreference != null) {
            switch (sizePreference) {
                case "偏小":
                    outfit.put("购买建议", "建议选择比平时小一码");
                    outfit.put("剪裁注意", "注意肩宽和胸围尺寸");
                    break;
                case "偏大":
                    outfit.put("购买建议", "建议选择比平时大一码");
                    outfit.put("剪裁注意", "注意衣长和袖长");
                    break;
                case "宽松":
                    outfit.put("风格特点", "oversize风格，舒适休闲");
                    outfit.put("搭配建议", "上宽下窄或上宽下宽");
                    break;
                case "修身":
                    outfit.put("风格特点", "凸显身材曲线");
                    outfit.put("搭配建议", "注意腰线位置");
                    break;
            }
        }
    }

    /**
     * 生成推荐理由
     */
    private String generateReason(AiRecommendRequest request) {
        return String.format(
                "基于您的个人特征为您定制：\n\n" +
                        "📊 分析维度：\n" +
                        "• 年龄 %d 岁：选择适合年龄段的风格\n" +
                        "• %s 身材：%s\n" +
                        "• %d℃ 天气：%s\n" +
                        "• %s 场合：确保场合适宜性\n\n" +
                        "🎯 推荐逻辑：\n" +
                        "结合温度适配、身材优化、场合匹配等多维度算法",
                request.getAge(),
                request.getBodyType(),
                getBodyTypeAdvice(request.getBodyType()),
                request.getTemperature(),
                getTemperatureAdvice(request.getTemperature()),
                request.getOccasion()
        );
    }

    /**
     * 生成风格建议
     */
    private String generateStyleTips(AiRecommendRequest request) {
        String[] tips = {
                "选择合身不紧身的剪裁，舒适度很重要",
                "基础款+设计款的组合最不容易出错",
                "注意色彩搭配，全身不超过3个主色",
                "配饰是点睛之笔，但不要过多",
                "根据肤色选择适合的颜色",
                "投资几件质感好的基础款单品",
                "注意服装的材质和工艺细节"
        };

        String[] colorTips = {
                "黑白灰：经典百搭，适合所有场合",
                "大地色：温柔高级，适合日常通勤",
                "莫兰迪色：低调优雅，提升气质",
                "明亮色：增加活力，适合休闲场合"
        };

        return "💡 穿搭小贴士：\n" +
                "• " + tips[random.nextInt(tips.length)] + "\n" +
                "• " + tips[random.nextInt(tips.length)] + "\n" +
                "• 色彩建议：" + colorTips[random.nextInt(colorTips.length)];
    }

    /**
     * 基础推荐（备用）
     */
    private AiRecommendResponse getBasicRecommendation(AiRecommendRequest request) {
        AiRecommendResponse response = new AiRecommendResponse();

        response.setRecommendation(
                "👕 上衣：基础款衬衫/T恤\n" +
                        "👖 下装：牛仔裤/休闲裤\n" +
                        "🧥 外套：根据温度选择外套\n" +
                        "👟 鞋子：休闲鞋/运动鞋\n" +
                        "🎒 配饰：简约包包"
        );

        response.setReason("基于基本穿搭规则生成的推荐方案");
        response.setStyleTips("建议选择合身款式，注意色彩搭配");
        response.setTemperatureAdvice(getTemperatureAdvice(request.getTemperature()));

        return response;
    }

    /**
     * 读取本地知识库
     */
    private String readKnowledgeBase() {
        try {
            File file = new ClassPathResource("clothes_rules.txt").getFile();
            String content = FileUtils.readFileToString(file, StandardCharsets.UTF_8);

            // Java 8 兼容的方式计算行数
            String[] lines = content.split("\r\n|\r|\n");
            int lineCount = lines.length;

            log.info("知识库读取成功，行数: {}", lineCount);
            log.info("知识库内容前100字符: {}", content.substring(0, Math.min(100, content.length())));

            return content;
        } catch (Exception e) {
            log.warn("读取知识库失败，使用内置规则", e);
            return getDefaultRules();
        }
    }



    /**
     * 默认规则 - 修复了文本块问题
     */
    private String getDefaultRules() {
        return "# 温度适配规则\n" +
                "高温(>30℃): 棉麻、真丝等透气材质\n" +
                "温暖(20-30℃): 衬衫、薄外套、连衣裙\n" +
                "凉爽(10-20℃): 毛衣、风衣、牛仔外套\n" +
                "寒冷(0-10℃): 羽绒服、厚毛衣、保暖内衣\n" +
                "严寒(<0℃): 加厚羽绒服、围巾手套\n\n" +
                "# 场合规则\n" +
                "正式场合: 西装、礼服、皮鞋\n" +
                "商务场合: 衬衫、西裤、外套\n" +
                "休闲场合: T恤、牛仔裤、运动鞋\n" +
                "特殊场合: 根据活动性质选择";
    }

    // ---------- 原有的辅助方法 ----------
    private String getTemperatureAdvice(int temperature) {
        if (temperature > 30) return "🌞 炎热天气：选择轻薄透气材质，注意防晒";
        else if (temperature > 20) return "☀️ 温暖舒适：适合薄外套，早晚温差注意";
        else if (temperature > 10) return "🍂 凉爽宜人：需要保暖外套，注意层次穿搭";
        else if (temperature > 0) return "❄️ 寒冷天气：厚外套必备，注意保暖";
        else return "🥶 严寒天气：全方位保暖，羽绒服+围巾手套";
    }

    private String getBodyTypeAdvice(String bodyType) {
        switch (bodyType) {
            case "梨型身材": return "建议A字裙/阔腿裤平衡比例";
            case "苹果型身材": return "建议V领上衣拉长颈部线条";
            case "沙漏型身材": return "建议收腰款式突出曲线";
            case "矩形身材": return "建议创造腰线增加曲线感";
            default: return "建议合身款式展现身材优势";
        }
    }
}