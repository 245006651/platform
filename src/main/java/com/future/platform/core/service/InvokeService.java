package com.future.platform.core.service;

import com.future.platform.core.entity.PlatformResponse;

import java.util.Map;

/**
 * @author lijihong
 * @date 2021/1/14
 */
public interface InvokeService {

    /**
     * 公共入口
     * @param params
     * @return
     */
    PlatformResponse invoke(Map<String, Object> params);
}
