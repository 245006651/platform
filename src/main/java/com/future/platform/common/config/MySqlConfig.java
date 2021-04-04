package com.future.platform.common.config;

import com.future.platform.core.entity.ConfigDb;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * mysql类
 * @author lijihong
 * @date 20201/1/14
 */
public class MySqlConfig {

    /**
     * 连接MySQL并返回JdbcTemplate
     * @param configDb
     * @return
     */
    public static JdbcTemplate getConnection(ConfigDb configDb){
        try {
            DriverManagerDataSource dataSource = new DriverManagerDataSource();
            dataSource.setDriverClassName("com.mysql.cj.jdbc.Driver");
            dataSource.setUrl("jdbc:mysql://" + configDb.getUrl() + "?useUnicode=true&characterEncoding=UTF-8&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=GMT%2b8");
            dataSource.setUsername(configDb.getUser());
            dataSource.setPassword(configDb.getPassword());
            return new JdbcTemplate(dataSource);
        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }
    public static boolean conn(ConfigDb configDb){
        try {
            configDb.setUrl("jdbc:mysql://" + configDb.getUrl() + "?useUnicode=true&characterEncoding=UTF-8&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=GMT%2b8");
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(configDb.getUrl(), configDb.getUser(), configDb.getPassword());
            conn.close();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static void main(String[] args) {
        ConfigDb configDb = new ConfigDb();
        configDb.setUrl("127.0.0.1:3307/test");
        configDb.setUser("root");
        System.out.println(configDb);
        System.out.println(conn(configDb));
    }
}
