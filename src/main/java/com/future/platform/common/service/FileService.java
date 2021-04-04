package com.future.platform.common.service;

import org.springframework.core.io.Resource;
import org.springframework.web.multipart.MultipartFile;

/**
 * 文件操作服务类，统一处理文件上传与下载
 *
 * @author icechen1219
 * @date 2019/08/10
 */
public interface FileService {
    /**
     * 存储文件到系统
     *
     * @param file 文件
     * @return 文件名
     */
    String storeFile(MultipartFile file);

    /**
     * 加载文件
     *
     * @param fileName 文件名
     * @return 文件
     */
    Resource loadFileAsResource(String fileName);
}
