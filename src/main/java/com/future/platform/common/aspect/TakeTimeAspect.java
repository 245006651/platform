package com.future.platform.common.aspect;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.future.platform.common.runner.PlatformStartUpRunner;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

/**
 * 耗时接口统计
 * @author 李吉洪
 * @date 2021/03/14
 */
@Slf4j
@Aspect
@Component
public class TakeTimeAspect {

    @Autowired
    JdbcTemplate jdbcTemplate;

    /**
     * 统计请求的处理时间
     */
    ThreadLocal<Long> startTime = new ThreadLocal<>();
    /**
     * 入参
     */
    ThreadLocal<Object> params = new ThreadLocal<>();

    /**
     * 带有@TakeTime注解的方法
     */
    @Pointcut("@annotation(com.future.platform.common.annotation.TakeTime)")
    public void log() {

    }

    @Before("log()")
    public void doBefore(JoinPoint joinPoint) throws Throwable {
        params.set(joinPoint.getArgs()[0]);
        startTime.set(System.currentTimeMillis());
        //接收到请求，记录请求内容
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        HttpServletRequest request = attributes.getRequest();
        //记录请求的内容
        log.info(String.format("请求URL: %s，请求METHOD: %s，入参：%s" ,
                request.getRequestURL().toString(),request.getMethod(),params.get()));
    }

    @AfterReturning(returning = "ret", pointcut = "log()")
    public void doAfterReturning(Object ret) {
        //接收到请求，记录请求内容
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        HttpServletRequest request = attributes.getRequest();
        JSONObject jsonObject = (JSONObject) JSONObject.toJSON(params.get());
        String interfaceName = jsonObject.get("interfaceName") == null ? null : String.valueOf(jsonObject.get("interfaceName"));
        JSONObject r = (JSONObject) JSONObject.toJSON(ret);
        if (interfaceName != null){
            String isSuccess = "";
            if (Integer.parseInt(String.valueOf(r.get("code"))) == 200){
                isSuccess = ",success_count=success_count+1";
            }
            String sql = String.format("update config_interface set count = count+1 %s where interface_en=?", isSuccess);
            String[] p = new String[]{interfaceName};
            log.info(String.format("统计接口调用次数，开始执行 SQL: %s，参数: %s", sql, p[0]));
            jdbcTemplate.update(sql, p);
            log.info(String.format("统计接口调用次数，执行成功 SQL: %s，参数: %s", sql, p[0]));

        }
        long rt = System.currentTimeMillis() - startTime.get();
        String sql = "INSERT interface_log(interface_name,response_time,url,method,response_status) VALUES(?,?,?,?,?);";
        List<String> p = new ArrayList<>();
        p.add(interfaceName);
        p.add(String.valueOf(rt));
        p.add(request.getRequestURL().toString());
        p.add(request.getMethod());
        p.add(String.valueOf(r.get("code")));
        log.info(String.format("接口日志表，开始执行 SQL: %s，参数: %s", sql, p));
        jdbcTemplate.update(sql, p.toArray());
        log.info(String.format("接口日志表，执行成功 SQL: %s，参数: %s", sql, p));
        //处理完请求后，返回内容
        log.info(String.format("URL：%s，返回值: %s，执行时间：%s ms",
                request.getRequestURL().toString(),
                JSON.toJSONString(ret),
                rt
                ));
    }

}
