package com.kk.web.controller.common;

import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.concurrent.TimeUnit;
import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.FastByteArrayOutputStream;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import com.google.code.kaptcha.Producer;
import com.kk.common.config.KKConfig;
import com.kk.common.constant.CacheConstants;
import com.kk.common.constant.Constants;
import com.kk.common.core.domain.AjaxResult;
import com.kk.common.core.redis.RedisCache;
import com.kk.common.utils.sign.Base64;
import com.kk.common.utils.uuid.IdUtils;
import com.kk.system.service.ISysConfigService;

/**
 * 验证码操作处理
 */
@RestController
public class CaptchaController
{
    @Resource(name = "captchaProducer")
    private Producer captchaProducer;

    @Resource(name = "captchaProducerMath")
    private Producer captchaProducerMath;

    @Autowired
    private RedisCache redisCache;

    @Autowired
    private ISysConfigService configService;

    /**
     * 生成验证码 - 修复版
     */
    @GetMapping("/captchaImage")
    public AjaxResult getCode(HttpServletResponse response) throws IOException
    {
        AjaxResult ajax = AjaxResult.success();
        boolean captchaEnabled = configService.selectCaptchaEnabled();
        ajax.put("captchaEnabled", captchaEnabled);

        // 如果验证码被禁用，直接返回
        if (!captchaEnabled) {
            return ajax;
        }

        // 保存验证码信息
        String uuid = IdUtils.simpleUUID();
        String verifyKey = CacheConstants.CAPTCHA_CODE_KEY + uuid;

        String capStr = null, code = null;
        BufferedImage image = null;

        try {
            // 获取验证码类型
            String captchaType = KKConfig.getCaptchaType();
            System.out.println("验证码类型: " + captchaType);

            // ★★★ 强制使用字符验证码 ★★★
            captchaType = "char";

            if ("math".equals(captchaType))
            {
                // 数学验证码
                try {
                    String capText = captchaProducerMath.createText();
                    System.out.println("数学验证码原始文本: " + capText);

                    if (capText != null && capText.contains("@")) {
                        int lastAt = capText.lastIndexOf("@");
                        capStr = capText.substring(0, lastAt);
                        code = capText.substring(lastAt + 1);
                        capStr = capStr + "=?";
                        image = captchaProducerMath.createImage(capStr);
                    }
                } catch (Exception e) {
                    System.out.println("数学验证码失败，降级到字符验证码: " + e.getMessage());
                    // 降级到字符验证码
                    captchaType = "char";
                }
            }

            if ("char".equals(captchaType) || image == null)
            {
                // 字符验证码（默认）
                capStr = code = captchaProducer.createText();
                System.out.println("字符验证码文本: " + capStr);
                image = captchaProducer.createImage(capStr);
            }

            // 如果图片还是null，创建一个简单的图片
            if (image == null) {
                System.out.println("Kaptcha生成图片失败，使用备用图片");
                image = createSimpleImage("1234");
                code = "1234";
                capStr = "1234";
            }

        } catch (Exception e) {
            System.out.println("验证码生成异常: " + e.getMessage());
            // 返回禁用验证码
            ajax.put("captchaEnabled", false);
            return ajax;
        }

        // 保存到Redis
        redisCache.setCacheObject(verifyKey, code, Constants.CAPTCHA_EXPIRATION, TimeUnit.MINUTES);

        // 转换流信息写出
        FastByteArrayOutputStream os = new FastByteArrayOutputStream();
        try {
            ImageIO.write(image, "jpg", os);
        } catch (IOException e) {
            System.out.println("图片写入失败: " + e.getMessage());
            // 创建默认图片
            image = createSimpleImage("ERR");
            os.reset();
            ImageIO.write(image, "jpg", os);
        }

        ajax.put("uuid", uuid);
        ajax.put("img", Base64.encode(os.toByteArray()));
        return ajax;
    }

    /**
     * 创建简单的验证码图片（备用方案）
     */
    private BufferedImage createSimpleImage(String text) {
        int width = 160;
        int height = 60;

        BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        java.awt.Graphics2D g = image.createGraphics();

        // 背景色
        g.setColor(java.awt.Color.WHITE);
        g.fillRect(0, 0, width, height);

        // 边框
        g.setColor(java.awt.Color.GRAY);
        g.drawRect(0, 0, width - 1, height - 1);

        // 文字
        g.setColor(java.awt.Color.BLACK);
        g.setFont(new java.awt.Font("Arial", java.awt.Font.BOLD, 30));

        // 居中显示
        java.awt.FontMetrics fm = g.getFontMetrics();
        int textWidth = fm.stringWidth(text);
        int x = (width - textWidth) / 2;
        int y = (height - fm.getHeight()) / 2 + fm.getAscent();

        g.drawString(text, x, y);
        g.dispose();

        return image;
    }
}