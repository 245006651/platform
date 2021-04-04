package com.future.platform.common.exception;

/**
 * 文件下载异常
 */
public class FileDownloadException extends RuntimeException {

    private static final long serialVersionUID = -3608667856397125671L;

    public FileDownloadException(String message) {
        super(message);
    }

    public FileDownloadException(String message, Throwable cause) {
        super(message, cause);
    }
}