package com.future.platform.core.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import lombok.Data;
import java.util.Date;

/**
 * <p>
 * 接口配置表
 * </p>
 *
 * @author lijihong
 * @since 2020-12-28
 */
@Data
public class ConfigInterface {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 接口英文名
     */
    private String interfaceEn;

    /**
     * 接口中文名
     */
    private String interfaceCh;

    /**
     * 项目id
     */
    private Long projectId;

    /**
     * 数据源id
     */
    private Long datasourceId;

    /**
     *类别，0：查询，1：新增， 2:修改，3删除
     */
    private Integer type;

    /**
     * 状态 0：下线 1:上线
     */
    private Short status;
    /**
     * sql语句
     */
    private String content;

    /**
     * 入参
     */
    private String inputParam;

    /**
     * 出参
     */
    private String outputParam;

    /**
     * 调用次数
     */

    private Long count;
    /**
     * 成功次数
     */
    private Long successCount;

    /**
     * 创建时间
     */
    private Date createTime;

    /**
     * 修改时间
     */
    private Date updateTime;
}
