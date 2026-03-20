package com.kk;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.context.annotation.ComponentScan;
/**
 * 启动程序
 * 
 * @author kk
 */

@SpringBootApplication(exclude = { DataSourceAutoConfiguration.class })
@ComponentScan({"com.kk", "com.kk.wardrobe","com.kk.wardrobe.controller"})
@MapperScan({"com.kk.outfit.mapper", "com.kk.wardrobe.mapper", "com.kk.system.mapper", "com.kk.**.mapper"})
public class KKApplication
{
    public static void main(String[] args)
    {
        // System.setProperty("spring.devtools.restart.enabled", "false");
        SpringApplication.run(KKApplication.class, args);
        System.out.println(" kk的每日穿搭推荐项目启动成功！！  \n" +
                " .-------.       ____     __        \n" +
                " |  _ _   \\      \\   \\   /  /    \n" +
                " | ( ' )  |       \\  _. /  '       \n" +
                " |(_ o _) /        _( )_ .'         \n" +
                " | (_,_).' __  ___(_ o _)'          \n" +
                " |  |\\ \\  |  ||   |(_,_)'         \n" +
                " |  | \\ `'   /|   `-'  /           \n" +
                " |  |  \\    /  \\      /           \n" +
                " ''-'   `'-'    `-..-'              ");
    }
}
