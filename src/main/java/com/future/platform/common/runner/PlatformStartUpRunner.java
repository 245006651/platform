package com.future.platform.common.runner;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.future.platform.common.config.MySqlConfig;
import com.future.platform.core.entity.ConfigDb;
import com.future.platform.core.entity.ConfigInterface;
import com.future.platform.core.mapper.ConfigInterfaceMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 项目启动后自动执行
 * @author lijihong
 * @date 2020/01/23
 */
@Slf4j
@Component
public class PlatformStartUpRunner extends ServiceImpl<ConfigInterfaceMapper, ConfigInterface> implements ApplicationRunner {

    public static Map<Long, JdbcTemplate> datasource = new HashMap<>();
    public static Map<String, ConfigInterface> interfaceMap = new HashMap<>();

    @Autowired
    JdbcTemplate jdbcTemplate;

    @Override
    public void run(ApplicationArguments args) throws Exception {
        loadInterface();
        loadDataSource();
    }

    /**
     * 启动时把接口信息加载到内存，存到 interfaceMap 中
     */
    private void loadInterface(){
        List<ConfigInterface> configInterfaces = baseMapper.selectList(new LambdaQueryWrapper<>());
        for (ConfigInterface c : configInterfaces){
            interfaceMap.put(c.getInterfaceEn(), c);
        }
    }
    /**
     * 把数据源信息从库中读取出来，并获得 jdbcTemplate，以数据源id作为key，存到本地内存
     */
    private void loadDataSource() {
        List<Map<String, Object>> maps = jdbcTemplate.queryForList("select * from config_db");
        for (Map<String, Object> map : maps){
            ConfigDb configDb = new ConfigDb();
            configDb.setUrl(String.valueOf(map.get("url") == null ? "" : map.get("url")));
            configDb.setUser(String.valueOf(map.get("user") == null ? "" : map.get("user")));
            configDb.setPassword(String.valueOf(map.get("password") == null ? "" : map.get("password")));
            datasource.put(Long.valueOf(String.valueOf(map.get("id"))), MySqlConfig.getConnection(configDb));
        }
    }
}
