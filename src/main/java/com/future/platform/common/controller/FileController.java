package com.future.platform.common.controller;


import com.future.platform.common.annotation.TakeTime;
import com.future.platform.common.entity.UploadFileResponse;
import com.future.platform.common.service.FileService;
import com.future.platform.core.entity.PlatformResponse;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;


/**
 * @author lijihong
 * @date 2021-03-13
 */

@RestController
@Api(tags = "文件管理")
public class FileController {
    private static final Logger logger = LoggerFactory.getLogger(FileController.class);

    @Autowired
    private FileService fileService;

    @ApiOperation("上传单文件")
    @PostMapping("/uploadFile")
    @TakeTime
    public PlatformResponse uploadFile(@RequestParam("file") MultipartFile file) {
        UploadFileResponse fileResponse = upload(file);
        PlatformResponse result = new PlatformResponse();
        result.data(fileResponse);
        return result;
    }

    private UploadFileResponse upload(@RequestParam("file") MultipartFile file) {
        String fileName = fileService.storeFile(file);

        String fileDownloadUri = ServletUriComponentsBuilder.fromCurrentContextPath()
                .path("/downloadFile/")
                .path(fileName)
                .toUriString();

        logger.info(fileDownloadUri);

        return new UploadFileResponse(fileName, fileDownloadUri, file.getContentType(), file.getSize());
    }

    @TakeTime
    @ApiOperation("上传多文件")
    @ApiImplicitParams({@ApiImplicitParam(name = "files", value = "文件流对象,接收数组格式", required = true, dataType = "MultipartFile", allowMultiple = true)})
    @PostMapping(value = "/uploadMultipleFiles", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public PlatformResponse uploadMultipleFiles(@RequestParam(value = "files") MultipartFile[] files) {
        List<UploadFileResponse> list = Arrays.stream(files).map(this::upload).collect(Collectors.toList());
        PlatformResponse result = new PlatformResponse();
        result.data(list);
        return result;
    }

    @TakeTime
    @ApiOperation("下载文件")
    /**
     * [:.+]作用是过滤url中的特殊字符
     */
    @GetMapping("/downloadFile/{date:.+}/{fileName:.+}")
    public ResponseEntity<Resource> downloadFile(@PathVariable String date,
                                                 @PathVariable String fileName, HttpServletRequest request) {
        // Load file as Resource
        Resource resource = fileService.loadFileAsResource(buildFileName(date, fileName));

        // Try to determine file's content type
        String contentType = null;
        try {
            contentType = request.getServletContext().getMimeType(resource.getFile().getAbsolutePath());
        } catch (IOException ex) {
            logger.error("Could not determine file type.", ex);
        }

        // Fallback to the default content type if type could not be determined
        if (contentType == null) {
            contentType = "application/octet-stream";
        }

        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(contentType))
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + resource.getFilename() + "\"")
                .body(resource);
    }

    /**
     * 按照日期文件夹组织上传文件
     *
     * @return
     */
    private String buildFileName(String date, String fileName) {
        StringBuffer sb = new StringBuffer();
        sb.append(date);
        sb.append(File.separatorChar);
        sb.append(fileName);

        return sb.toString();
    }
}
