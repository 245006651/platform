package com.future.platform.core.controller;

import com.future.platform.common.annotation.TakeTime;
import com.future.platform.core.entity.PlatformResponse;
import com.future.platform.core.service.InvokeService;
import io.swagger.annotations.Api;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.Map;

/**
 * 公共入口
 * @author lijihong
 * @date 2021/1/14
 */
@Api(tags="公共入口")
@RestController
public class InvokeController {

    @Resource
    InvokeService invokeService;

    @TakeTime
    @PostMapping("/")
    public PlatformResponse invokeSelect(@RequestBody Map<String, Object> params){
        return invokeService.invoke(params);
    }
}

