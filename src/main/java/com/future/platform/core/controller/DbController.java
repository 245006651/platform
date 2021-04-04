package com.future.platform.core.controller;

import com.future.platform.common.annotation.TakeTime;
import com.future.platform.core.entity.PlatformResponse;
import com.future.platform.core.service.DbService;
import io.swagger.annotations.Api;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.Map;

/**
 * 数据库相关
 * @author lijihong
 * @date 2021/3/12
 */
@Api(tags="数据库相关")
@RestController
@RequestMapping("/db")
public class DbController {

    @Resource
    DbService dbService;

    @TakeTime
    @PostMapping("/mysql/addDataSource")
    public PlatformResponse addDataSource(@RequestBody Map<String, Object> params){
        return dbService.addDataSource(params);
    }
    @TakeTime
    @PostMapping("/mysql/createDB")
    public PlatformResponse createDB(@RequestBody Map<String, Object> params){
        return dbService.createDB(params);
    }

}
