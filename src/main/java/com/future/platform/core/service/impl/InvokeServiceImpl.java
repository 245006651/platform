package com.future.platform.core.service.impl;

import com.future.platform.core.entity.ConfigInterface;
import com.future.platform.core.entity.PlatformResponse;
import com.future.platform.common.runner.PlatformStartUpRunner;
import com.future.platform.core.service.InvokeService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @author lijihong
 * @date 2021/1/14
 */
@Slf4j
@Service
public class InvokeServiceImpl implements InvokeService {

    @Resource
    JdbcTemplate jdbcTemplate;

    @Override
    public PlatformResponse invoke(Map<String, Object> params){
        PlatformResponse res = new PlatformResponse().success();
        if (params.get("interfaceName") == null){
            res.data("interfaceName参数必须存在");
            return res;
        }
        //获取接口信息
        ConfigInterface configInterface = PlatformStartUpRunner.interfaceMap.get(params.get("interfaceName"));
        //判断接口是否存在或者上线状态
        if (configInterface == null || configInterface.getStatus() == 0 && !params.get("interfaceName").equals("setInterfaceStatus")){
            res.data("接口不存在或者接口已下线！");
            log.info(String.format("接口: %s :不存在或者接口已下线！", params.get("interfaceName")));
            return res;
        }
        //处理入参
        List<Object> p = new ArrayList<>();
        if (configInterface.getInputParam() != null && !"".equals(configInterface.getInputParam().trim())){
            for (String s : configInterface.getInputParam().split(",")){
                p.add(params.get(s)==null||params.get(s).toString().trim().equals("") ? null : params.get(s));
            }
        }
        /**
         * 判断是否是本系统的数据源，如果是就直接执行语句
         * 如果不是，查找到对应的数据源执行语句
         * datasourceId为空则为本系统数据源
         */
        log.info(String.format("接口：%s 开始执行 SQL：%s，参数：%s",params.get("interfaceName"),configInterface.getContent(),p));

        if (null == configInterface.getDatasourceId()){
            byCaseInvoke(jdbcTemplate, configInterface.getContent(),
                    p.toArray(), configInterface.getType(), res);
        }else{
            JdbcTemplate j = PlatformStartUpRunner.datasource.get(configInterface.getDatasourceId());
            byCaseInvoke(j, configInterface.getContent(),
                    p.toArray(), configInterface.getType(), res);
        }
        log.info(String.format("接口：%s 执行完成 SQL：%s，参数：%s",params.get("interfaceName"),configInterface.getContent(), p));
        if("addInterface".equals(params.get("interfaceName").toString().trim())){
            ConfigInterface c = new ConfigInterface();
            c.setInterfaceEn(String.valueOf(params.get("interfaceEn")));
            c.setInterfaceCh(String.valueOf(params.get("interfaceCh")));
//            c.setProjectId(Long.parseLong(String.valueOf(params.get("projectId"))));
            c.setDatasourceId(Long.parseLong(String.valueOf(params.get("datasourceId"))));
            c.setType(Integer.valueOf(String.valueOf(params.get("type"))));
            c.setContent(String.valueOf(params.get("content")));
            c.setStatus(Short.parseShort("0"));
            c.setInputParam(params.get("inputParam") == null ? null :String.valueOf(params.get("inputParam")));
            c.setOutputParam(String.valueOf(params.get("outputParam")));
            PlatformStartUpRunner.interfaceMap.put(c.getInterfaceEn(), c);
        }
        if (params.get("interfaceEnAndStatus") != null){
            ConfigInterface c =  PlatformStartUpRunner.interfaceMap.get(params.get("interfaceEnAndStatus").toString().trim());
            c.setStatus((short) (c.getStatus() == 0 || c.getStatus() == null ? 1 : 0));
            PlatformStartUpRunner.interfaceMap.put(c.getInterfaceEn(), c);
        }
        return res;
    }

    /**
     * 根据type选择是查询还是更新
     * @param jdbcTemplate
     * @param sql
     * @param params
     * @param type
     * @param res
     */
    private void byCaseInvoke(JdbcTemplate jdbcTemplate, String sql,
                              Object[] params, Integer type, PlatformResponse res){
        if (type.equals(0)) {
            res.data(jdbcTemplate.queryForList(sql, params));
            return;
        }
        res.data(jdbcTemplate.update(sql, params));

    }
}
