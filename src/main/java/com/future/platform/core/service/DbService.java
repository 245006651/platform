package com.future.platform.core.service;

import com.future.platform.core.entity.PlatformResponse;

import java.util.Map;

/**
 * @author lijihong
 * @date 2021/1/14
 */
public interface DbService {

    /**
     * 新建数据源
     * @param params
     * @return
     */
    PlatformResponse addDataSource(Map<String, Object> params);

    /**
     * 新建表
     * @param params
     * @return
     */
    PlatformResponse createDB(Map<String, Object> params);

}
