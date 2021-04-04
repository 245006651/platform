package com.future.platform.common.service.impl;

import com.future.platform.common.config.PlatformProperties;
import com.future.platform.common.exception.FileDownloadException;
import com.future.platform.common.service.FileService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URI;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * @author lijihong
 * @date 2021/03/13
 */
@Service
public class FileServiceImpl implements FileService {
    /**
     * 文件上传根路径
     */
    private PlatformProperties platformProperties;
    private Logger logger = LoggerFactory.getLogger(getClass());


    private SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMdd");


    @Autowired
    public FileServiceImpl(PlatformProperties platformProperties) {
        this.platformProperties = platformProperties;
    }

    /**
     * 按照日期文件夹组织上传文件
     *
     * @param
     * @return
     */
    private String buildTodayPath() {
        StringBuffer sb = new StringBuffer();
        sb.append(simpleDateFormat.format(new Date()));
        return sb.toString();
    }


    @Override
    public String storeFile(MultipartFile file) {
        // Normalize file name
        String fileName = StringUtils.cleanPath(file.getOriginalFilename());

        try {
            // Check if the file's name contains invalid characters
            if (fileName.contains("..")) {
                throw new FileDownloadException("Sorry! Filename contains invalid path sequence " + fileName);
            }
            // 创建日期文件夹
            String path = buildTodayPath();
            Path targetPath = Paths.get(platformProperties.getUploadDir() + File.separatorChar + path).toAbsolutePath().normalize();
            Files.createDirectories(targetPath);
            // 用时间戳当文件名
            String extName = guessExtName(fileName);
            fileName = System.currentTimeMillis() + extName;

            // Copy file to the target location (Replacing existing file with the same name)
            Path targetLocation = targetPath.resolve(fileName);
            Files.copy(file.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);

            return path + "/" + fileName;
        } catch (IOException ex) {
            throw new FileDownloadException("Could not store file " + fileName + ". Please try again!", ex);
        }
    }


    @Override
    public Resource loadFileAsResource(String fileName) {
        logger.info(fileName);
        try {
            Path filePath = Paths.get(platformProperties.getUploadDir()).toAbsolutePath().normalize().resolve(fileName).normalize();

            URI uri = filePath.toUri();
            logger.info(uri.toString());
            System.out.println(uri.toString());
            Resource resource = new UrlResource(uri);
            if (resource.exists()) {
                return resource;
            } else {
                throw new FileDownloadException("File not found " + fileName);
            }
        } catch (MalformedURLException ex) {
            logger.error(ex.getMessage(), ex);
            throw new FileDownloadException("File not found " + fileName, ex);
        }
    }

    /**
     * 文件后缀名
     *
     * @param fileName
     * @return
     */
    private String guessExtName(String fileName) {
        int dotPos = fileName.lastIndexOf(".");
        return dotPos == -1 ? "" : fileName.substring(dotPos);
    }
}
