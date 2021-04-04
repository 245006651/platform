package com.future.platform.core.service.impl;

import com.future.platform.common.config.MySqlConfig;
import com.future.platform.common.runner.PlatformStartUpRunner;
import com.future.platform.core.entity.ConfigDb;
import com.future.platform.core.entity.PlatformResponse;
import com.future.platform.core.service.DbService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @author lijihong
 * @date 2021/1/14
 */
@Slf4j
@Service
public class DbServiceImpl implements DbService {
    @Autowired
    JdbcTemplate jdbcTemplate;
    @Override
    public PlatformResponse addDataSource(Map<String, Object> params){
        PlatformResponse res = new PlatformResponse().success();
        ConfigDb configDb = new ConfigDb();
        configDb.setUrl(params.get("url") == null||String.valueOf(params.get("url")).equals("") ? null : String.valueOf(params.get("url")));
        configDb.setUser(params.get("user") == null||String.valueOf(params.get("user")).equals("") ? null : String.valueOf(params.get("user")));
        configDb.setPassword(params.get("password") == null||String.valueOf(params.get("password")).equals("") ? null : String.valueOf(params.get("password")));
        System.out.println(configDb);
        if (!MySqlConfig.conn(configDb)){
            log.info(String.format("URL：/db/mysql/addDataSource，数据库连接失败，请检查"));
            return res.data("数据库连接失败，请检查");
        }
        System.out.println(params);
        JdbcTemplate j = MySqlConfig.getConnection(configDb);
        if (j == null){
            log.info(String.format("URL：/db/mysql/addDataSource，数据库连接失败，请检查"));
            return res.data("数据库连接失败，请检查");
        }
        String sql = "insert config_db(url,user,password,db_name,type) values (?,?,?,?,?) on duplicate key update url=values(url),user=values(user),password=values(password),db_name=values(db_name),type=values(type)";
        List<Object> p = new ArrayList<>();
        p.add(params.get("url")==null||params.get("url").toString().trim().equals("") ? null : params.get("url"));
        p.add(params.get("user")==null||params.get("user").toString().trim().equals("") ? null : params.get("user"));
        p.add(params.get("password")==null||params.get("password").toString().trim().equals("") ? null : params.get("password"));
        p.add(params.get("dbName")==null||params.get("dbName").toString().trim().equals("") ? null : params.get("dbName"));
        p.add(params.get("type")==null||params.get("type").toString().trim().equals("") ? null : params.get("type"));
        log.info(String.format("URL：/db/mysql/addDataSource，开始执行 SQL：%s，参数：%s", sql, p));
        jdbcTemplate.update(sql, p.toArray());
        log.info(String.format("URL：/db/mysql/addDataSource，执行完成 SQL：%s，参数：%s", sql, p));
        String sql1 = "select id from config_db where url=?";
        String[] p1 = new String[]{params.get("url").toString().trim()};
        log.info(String.format("URL：/db/mysql/addDataSource，开始执行 SQL：%s，参数：%s", sql1, p1[0]));
        List<Map<String, Object>> s = jdbcTemplate.queryForList(sql1,p1);
        log.info(String.format("URL：/db/mysql/addDataSource，执行完成 SQL：%s，参数：%s", sql1, p1[0]));
        if (s.size() == 0){
            log.info(String.format("URL：/db/mysql/addDataSource，失败"));
            return res.data("失败");
        }
        PlatformStartUpRunner.datasource.put(Long.valueOf(String.valueOf(s.get(0).get("id"))), j);
        return res.data("成功");
    }

    @Override
    public PlatformResponse createDB(Map<String, Object> params) {
        PlatformResponse res = new PlatformResponse().success();
        JdbcTemplate j = PlatformStartUpRunner.datasource.get(Long.valueOf(String.valueOf(params.get("datasourceId"))));
        if (j == null){
            log.info(String.format("URL：/db/mysql/createDB，数据库连接失败，请检查"));
            return res.data("数据库连接失败，请检查");
        }
        String sql = "CREATE DATABASE " + params.get("dbName");
        log.info(String.format("URL：/db/mysql/createDB，开始执行 SQL：%s", sql));
        j.update(sql);
        log.info(String.format("URL：/db/mysql/createDB，执行完成 SQL：%s", sql));
        return res.data(true);
    }
}
