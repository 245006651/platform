/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 50723
 Source Host           : localhost:3306
 Source Schema         : platform

 Target Server Type    : MySQL
 Target Server Version : 50723
 File Encoding         : 65001

 Date: 05/04/2021 01:03:48
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for config_db
-- ----------------------------
DROP TABLE IF EXISTS `config_db`;
CREATE TABLE `config_db`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'url',
  `user` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '密码',
  `db_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '数据库名称',
  `type` tinyint(2) NULL DEFAULT 0 COMMENT '数据库类别，0：mysql,1:Redis,2：MySQL-CDS',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `unq`(`url`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of config_db
-- ----------------------------
INSERT INTO `config_db` VALUES (2, '127.0.0.1:3306/platform', 'root', NULL, 'platform', 0, '2021-01-14 21:51:32', '2021-03-13 01:30:23');
INSERT INTO `config_db` VALUES (3, '39.96.170.233:3306/yihaokx', 'root', '', 'yihaokx', 0, '2021-01-14 21:51:51', '2021-04-05 01:03:37');
INSERT INTO `config_db` VALUES (17, '127.0.0.1:3306/test', 'root', NULL, 'test', 0, '2021-03-13 01:36:30', '2021-03-13 01:36:30');
INSERT INTO `config_db` VALUES (23, '127.0.0.1:3306/werwedfgd', 'root', NULL, 'werwedfgd', 0, '2021-03-14 04:28:31', '2021-03-14 04:28:59');

-- ----------------------------
-- Table structure for config_interface
-- ----------------------------
DROP TABLE IF EXISTS `config_interface`;
CREATE TABLE `config_interface`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `interface_en` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '接口英文名',
  `interface_ch` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '接口中文名',
  `project_id` bigint(20) NULL DEFAULT NULL COMMENT '项目id',
  `datasource_id` bigint(20) NULL DEFAULT NULL COMMENT '数据源id',
  `type` int(10) NULL DEFAULT 0 COMMENT '类别，0：查询，1：新增， 2:修改，3删除',
  `status` tinyint(1) NULL DEFAULT 0 COMMENT '状态 0：下线 1:上线',
  `content` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'sql语句',
  `input_param` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '入参',
  `output_param` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '出参',
  `count` bigint(20) UNSIGNED NULL DEFAULT 0 COMMENT '接口调用次数',
  `success_count` bigint(20) UNSIGNED NULL DEFAULT 0 COMMENT '调用成功次数',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`, `create_time`) USING BTREE,
  UNIQUE INDEX `interface_en`(`interface_en`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 46 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '接口配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of config_interface
-- ----------------------------
INSERT INTO `config_interface` VALUES (6, 'getInterfaceData', '获取接口信息', NULL, NULL, 0, 1, 'select * from config_interface order by create_time desc', NULL, NULL, 65, 65, '2021-03-06 23:18:50', '2021-04-02 13:47:21');
INSERT INTO `config_interface` VALUES (7, 'setInterfaceStatus', '接口上下线', NULL, NULL, 2, 1, 'update config_interface set status=? where id=?', 'status,id', NULL, 7, 7, '2021-03-10 01:29:20', '2021-03-16 03:14:25');
INSERT INTO `config_interface` VALUES (8, 'getUserProjectInfo', '获取用户所在项目信息', NULL, NULL, 0, 1, 'SELECT\r\n	* \r\nFROM\r\n project\r\n	where FIND_IN_SET(?,owners)>0 or FIND_IN_SET(?,members) > 0', 'owners,members', NULL, 0, 0, '2021-03-10 04:20:29', '2021-03-15 23:58:38');
INSERT INTO `config_interface` VALUES (9, 'getDataSourceInfo', '获取数据源信息', NULL, NULL, 0, 1, 'select * from config_db', NULL, NULL, 81, 81, '2021-03-10 05:04:39', '2021-04-02 14:44:11');
INSERT INTO `config_interface` VALUES (10, 'getTablesName', '获取数据库中的所有表名称', NULL, NULL, 0, 1, 'select table_name from information_schema.tables where table_schema=? and table_type=\'base table\';', 'dbName', NULL, 9, 9, '2021-03-10 05:14:52', '2021-03-18 01:12:43');
INSERT INTO `config_interface` VALUES (11, 'getFieldsInfo', '获取表中字段信息', 2, NULL, 0, 1, 'select COLUMN_NAME,COLUMN_COMMENT,IS_NULLABLE,COLUMN_TYPE,COLUMN_KEY from information_schema.COLUMNS where table_name = ? and table_schema = ?;', 'tableName,dbName', NULL, 10, 10, '2021-03-10 06:35:11', '2021-03-18 01:12:45');
INSERT INTO `config_interface` VALUES (13, 'addInterface', '新增接口', NULL, NULL, 1, 1, 'insert config_interface(interface_en,interface_ch,project_id,datasource_id,`type`,content,input_param,output_param) values(?,?,?,?,?,?,?,?)', 'interfaceEn,interfaceCh,projectId,datasourceId,type,content,inputParam,outputParam', NULL, 6, 6, '2021-03-11 03:25:50', '2021-03-16 03:14:15');
INSERT INTO `config_interface` VALUES (28, 'login', '登录', NULL, NULL, 0, 1, 'select * from user where username=? and password=? limit 1', 'userName,password', NULL, 3, 3, '2021-03-11 06:37:05', '2021-03-19 03:55:25');
INSERT INTO `config_interface` VALUES (29, 'register', '注册', NULL, NULL, 1, 1, 'insert user(username,password) values(?,?)', 'username,password', NULL, 0, 0, '2021-03-11 08:20:19', '2021-03-15 23:58:49');
INSERT INTO `config_interface` VALUES (30, 'getProjectInfo', '查询项目列表', NULL, NULL, 0, 1, 'select * from project order by create_time desc', NULL, NULL, 73, 73, '2021-03-12 00:14:32', '2021-04-02 14:36:32');
INSERT INTO `config_interface` VALUES (32, 'addProject', '新增/修改项目', 18, 2, 1, 1, 'insert project (project_name,owners,members,description) values (?,?,?,?) \r\non duplicate key update project_name = values(project_name),owners=values(owners),members=values(members),description=values(description);', 'projectName,owners,members,description', NULL, 0, 0, '2021-03-12 02:18:46', '2021-03-15 23:58:51');
INSERT INTO `config_interface` VALUES (33, 'getUserInfo', '获取用户表信息', NULL, NULL, 0, 1, 'select * from user order by create_time desc', NULL, NULL, 15, 15, '2021-03-12 03:44:07', '2021-04-02 14:36:15');
INSERT INTO `config_interface` VALUES (36, 'getInterfaceByUserName', '根据用户名获取接口列表', NULL, NULL, 0, 1, 'SELECT\n	c.* \nFROM\n	config_interface c\n	RIGHT JOIN project p ON c.project_id = p.id\r\n	where FIND_IN_SET(?,p.owners)>0 or FIND_IN_SET(?,p.members) > 0', 'owners,members', NULL, 0, 0, '2021-03-14 02:22:26', '2021-03-15 23:58:52');
INSERT INTO `config_interface` VALUES (37, 'addDataBase', '新建数据库', NULL, NULL, 0, 1, 'CREATE DATABASE', NULL, NULL, 0, 0, '2021-03-14 03:24:07', '2021-03-15 23:58:53');
INSERT INTO `config_interface` VALUES (39, 'countUserNumbers', '统计用户数量', NULL, 2, 0, 1, 'select count(*) as s from user', NULL, NULL, 33, 33, '2021-03-16 01:34:21', '2021-04-02 13:46:49');
INSERT INTO `config_interface` VALUES (40, 'countInterfaceInfo', '统计接口信息', NULL, 2, 0, 1, 'select count(*) interfaceNumber, sum(count) c ,sum(success_count) sc from config_interface ', NULL, NULL, 35, 35, '2021-03-16 01:43:04', '2021-04-02 13:46:49');
INSERT INTO `config_interface` VALUES (41, 'countAvgResponseTime', '统计平均响应时间', NULL, 2, 0, 1, 'select FLOOR(sum(response_time)/count(*)) a from interface_log', NULL, NULL, 31, 31, '2021-03-16 01:55:07', '2021-04-02 13:46:49');
INSERT INTO `config_interface` VALUES (42, 'getInterfaceLogInfo', '查看接口日志列表', NULL, 2, 0, 1, 'select * from interface_log ORDER BY create_time desc', NULL, NULL, 16, 16, '2021-03-16 02:12:23', '2021-04-02 13:46:49');
INSERT INTO `config_interface` VALUES (45, 'test', '测试', NULL, 2, 0, 1, 'select id,username,password,create_time,update_time from user', NULL, 'id,username,password,create_time,update_time', 4, 4, '2021-03-16 03:14:15', '2021-04-02 14:15:46');

-- ----------------------------
-- Table structure for interface_log
-- ----------------------------
DROP TABLE IF EXISTS `interface_log`;
CREATE TABLE `interface_log`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `interface_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '接口英文名',
  `response_time` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '执行时间',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '接口请求时间',
  `url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '请求URL',
  `method` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '请求方法',
  `response_status` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '响应状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 413 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of interface_log
-- ----------------------------
INSERT INTO `interface_log` VALUES (2, 'getInterfaceData', '205', '2021-03-16 00:58:29', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (3, 'getDataSourceInfo', '243', '2021-03-16 00:58:29', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (4, 'getProjectInfo', '243', '2021-03-16 00:58:29', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (5, 'getProjectInfo', '224', '2021-03-16 01:19:27', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (6, 'getDataSourceInfo', '251', '2021-03-16 01:19:27', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (7, 'getInterfaceData', '251', '2021-03-16 01:19:27', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (8, 'setInterfaceStatus', '105', '2021-03-16 01:19:42', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (9, 'getUserInfo', '65', '2021-03-16 01:19:44', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (10, 'getDataSourceInfo', '58', '2021-03-16 01:20:05', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (11, 'getUserInfo', '135', '2021-03-16 01:20:06', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (12, 'getProjectInfo', '48', '2021-03-16 01:20:10', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (13, 'getDataSourceInfo', '88', '2021-03-16 01:20:10', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (14, 'getInterfaceData', '95', '2021-03-16 01:20:10', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (15, 'setInterfaceStatus', '154', '2021-03-16 01:20:17', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (16, 'getUserInfo', '82', '2021-03-16 01:20:19', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (17, 'getInterfaceData', '83', '2021-03-16 01:20:26', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (18, 'getProjectInfo', '110', '2021-03-16 01:20:26', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (19, 'getDataSourceInfo', '103', '2021-03-16 01:20:26', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (20, 'getTablesName', '166', '2021-03-16 01:22:31', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (21, 'getFieldsInfo', '118', '2021-03-16 01:22:35', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (22, 'getInterfaceData', '138', '2021-03-16 01:22:55', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (23, 'getProjectInfo', '369', '2021-03-16 01:22:55', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (24, 'getDataSourceInfo', '471', '2021-03-16 01:22:55', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (25, 'getInterfaceData', '153', '2021-03-16 01:25:28', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (26, 'getDataSourceInfo', '199', '2021-03-16 01:25:28', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (27, 'getProjectInfo', '203', '2021-03-16 01:25:28', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (28, 'countInterfaceNumbers', '54', '2021-03-16 01:25:31', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (29, 'countInterfaceNumbers', '771', '2021-03-16 01:25:42', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (30, 'getProjectInfo', '135', '2021-03-16 01:25:47', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (31, 'getProjectInfo', '93', '2021-03-16 01:25:48', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (32, 'getInterfaceData', '141', '2021-03-16 01:25:48', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (33, 'getDataSourceInfo', '137', '2021-03-16 01:25:48', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (34, 'getInterfaceData', '127', '2021-03-16 01:25:57', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (35, 'getDataSourceInfo', '149', '2021-03-16 01:25:57', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (36, 'getProjectInfo', '152', '2021-03-16 01:25:57', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (37, 'countInterfaceNumbers', '56', '2021-03-16 01:25:59', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (38, 'countInterfaceNumbers', '310', '2021-03-16 01:27:32', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (39, 'countInterfaceNumbers', '323', '2021-03-16 01:28:52', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (40, 'countInterfaceNumbers', '65', '2021-03-16 01:29:03', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (41, 'countInterfaceNumbers', '102', '2021-03-16 01:29:11', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (42, 'countInterfaceNumbers', '104', '2021-03-16 01:29:29', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (43, 'getInterfaceData', '69', '2021-03-16 01:29:50', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (44, 'getDataSourceInfo', '120', '2021-03-16 01:29:50', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (45, 'getProjectInfo', '291', '2021-03-16 01:29:50', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (46, 'getTablesName', '12601', '2021-03-16 01:33:06', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (47, 'getFieldsInfo', '100', '2021-03-16 01:33:13', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (48, 'getProjectInfo', '4034', '2021-03-16 01:34:03', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (49, 'getDataSourceInfo', '4111', '2021-03-16 01:34:04', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (50, 'getInterfaceData', '6449', '2021-03-16 01:34:05', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (51, 'getInterfaceData', '168', '2021-03-16 01:38:07', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (52, 'getDataSourceInfo', '222', '2021-03-16 01:38:07', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (53, 'getProjectInfo', '299', '2021-03-16 01:38:07', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (54, 'setInterfaceStatus', '66', '2021-03-16 01:38:11', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (55, 'countInterfaceNumbers', '75', '2021-03-16 01:38:15', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (56, 'getInterfaceData', '192', '2021-03-16 01:41:54', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (57, 'getProjectInfo', '257', '2021-03-16 01:41:54', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (58, 'getDataSourceInfo', '307', '2021-03-16 01:41:55', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (59, 'getTablesName', '92', '2021-03-16 01:42:57', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (60, 'getFieldsInfo', '64', '2021-03-16 01:43:01', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (61, 'addInterface', '105', '2021-03-16 01:43:05', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (62, 'getInterfaceData', '119', '2021-03-16 01:43:05', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (63, 'getProjectInfo', '76', '2021-03-16 01:43:05', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (64, 'getDataSourceInfo', '190', '2021-03-16 01:43:05', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (65, 'getDataSourceInfo', '74', '2021-03-16 01:43:40', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (66, 'getInterfaceData', '127', '2021-03-16 01:43:40', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (67, 'getProjectInfo', '121', '2021-03-16 01:43:40', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (68, 'countInterfaceInfo', '25400', '2021-03-16 01:48:08', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (69, 'getInterfaceData', '74', '2021-03-16 01:48:25', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (70, 'getDataSourceInfo', '277', '2021-03-16 01:48:25', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (71, 'getProjectInfo', '361', '2021-03-16 01:48:25', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (72, 'setInterfaceStatus', '89', '2021-03-16 01:48:31', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (73, 'countInterfaceInfo', '102', '2021-03-16 01:48:33', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (74, 'getInterfaceData', '120', '2021-03-16 01:48:52', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (75, 'getDataSourceInfo', '143', '2021-03-16 01:48:52', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (76, 'getProjectInfo', '147', '2021-03-16 01:48:52', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (77, 'getInterfaceData', '141', '2021-03-16 01:50:17', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (78, 'getProjectInfo', '204', '2021-03-16 01:50:17', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (79, 'getDataSourceInfo', '264', '2021-03-16 01:50:17', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (80, 'countInterfaceInfo', '184', '2021-03-16 01:50:28', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (81, 'countUserNumbers', '399', '2021-03-16 01:50:28', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (82, 'countInterfaceInfo', '89', '2021-03-16 01:50:39', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (83, 'countUserNumbers', '187', '2021-03-16 01:50:39', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (84, 'countInterfaceInfo', '97', '2021-03-16 01:50:53', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (85, 'countUserNumbers', '253', '2021-03-16 01:50:53', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (86, 'getInterfaceData', '157', '2021-03-16 01:54:09', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (87, 'getDataSourceInfo', '226', '2021-03-16 01:54:09', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (88, 'getProjectInfo', '308', '2021-03-16 01:54:09', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (89, 'getTablesName', '77', '2021-03-16 01:54:54', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (90, 'getFieldsInfo', '75', '2021-03-16 01:54:59', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (91, 'addInterface', '99', '2021-03-16 01:55:07', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (92, 'getInterfaceData', '70', '2021-03-16 01:55:07', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (93, 'getDataSourceInfo', '106', '2021-03-16 01:55:07', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (94, 'getProjectInfo', '110', '2021-03-16 01:55:07', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (95, 'getDataSourceInfo', '144', '2021-03-16 01:57:02', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (96, 'getProjectInfo', '261', '2021-03-16 01:57:02', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (97, 'getInterfaceData', '288', '2021-03-16 01:57:02', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (98, 'getProjectInfo', '155', '2021-03-16 01:58:21', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (99, 'getDataSourceInfo', '172', '2021-03-16 01:58:21', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (100, 'getInterfaceData', '289', '2021-03-16 01:58:21', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (101, 'getDataSourceInfo', '71', '2021-03-16 01:58:55', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (102, 'getProjectInfo', '98', '2021-03-16 01:58:55', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (103, 'getInterfaceData', '98', '2021-03-16 01:58:55', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (104, 'getProjectInfo', '193', '2021-03-16 02:00:09', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (105, 'getInterfaceData', '220', '2021-03-16 02:00:09', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (106, 'getDataSourceInfo', '220', '2021-03-16 02:00:09', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (107, 'countInterfaceInfo', '176', '2021-03-16 02:00:12', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (108, 'countAvgResponseTime', '286', '2021-03-16 02:00:12', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (109, 'countUserNumbers', '288', '2021-03-16 02:00:12', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (110, 'countInterfaceInfo', '127', '2021-03-16 02:00:27', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (111, 'countAvgResponseTime', '231', '2021-03-16 02:00:27', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (112, 'countUserNumbers', '236', '2021-03-16 02:00:27', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (113, 'countInterfaceInfo', '92', '2021-03-16 02:00:52', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (114, 'countAvgResponseTime', '314', '2021-03-16 02:00:52', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (115, 'countUserNumbers', '388', '2021-03-16 02:00:52', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (116, 'countInterfaceInfo', '67', '2021-03-16 02:01:00', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (117, 'countAvgResponseTime', '208', '2021-03-16 02:01:00', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (118, 'countUserNumbers', '243', '2021-03-16 02:01:00', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (119, 'countInterfaceInfo', '154', '2021-03-16 02:01:29', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (120, 'countUserNumbers', '208', '2021-03-16 02:01:30', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (121, 'countAvgResponseTime', '350', '2021-03-16 02:01:30', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (122, 'countInterfaceInfo', '161', '2021-03-16 02:03:20', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (123, 'countUserNumbers', '215', '2021-03-16 02:03:20', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (124, 'countAvgResponseTime', '254', '2021-03-16 02:03:20', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (125, 'countUserNumbers', '89', '2021-03-16 02:03:49', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (126, 'countInterfaceInfo', '117', '2021-03-16 02:03:49', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (127, 'countAvgResponseTime', '115', '2021-03-16 02:03:49', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (128, 'countInterfaceInfo', '203', '2021-03-16 02:06:08', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (129, 'countUserNumbers', '249', '2021-03-16 02:06:08', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (130, 'countAvgResponseTime', '236', '2021-03-16 02:06:08', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (131, 'getUserInfo', '254', '2021-03-16 02:06:08', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (132, 'getUserInfo', '87', '2021-03-16 02:07:16', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (133, 'countInterfaceInfo', '249', '2021-03-16 02:07:17', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (134, 'countUserNumbers', '292', '2021-03-16 02:07:17', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (135, 'countAvgResponseTime', '507', '2021-03-16 02:07:17', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (136, 'countUserNumbers', '483', '2021-03-16 02:08:38', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (137, 'countAvgResponseTime', '560', '2021-03-16 02:08:38', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (138, 'countInterfaceInfo', '649', '2021-03-16 02:08:38', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (139, 'getUserInfo', '734', '2021-03-16 02:08:38', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (140, 'getUserInfo', '97', '2021-03-16 02:08:57', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (141, 'countUserNumbers', '316', '2021-03-16 02:08:58', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (142, 'countInterfaceInfo', '363', '2021-03-16 02:08:58', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (143, 'countAvgResponseTime', '353', '2021-03-16 02:08:58', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (144, 'getUserInfo', '107', '2021-03-16 02:09:36', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (145, 'countInterfaceInfo', '330', '2021-03-16 02:09:36', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (146, 'countAvgResponseTime', '394', '2021-03-16 02:09:36', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (147, 'countUserNumbers', '436', '2021-03-16 02:09:36', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (148, 'getUserInfo', '82', '2021-03-16 02:10:14', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (149, 'countUserNumbers', '294', '2021-03-16 02:10:15', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (150, 'countInterfaceInfo', '332', '2021-03-16 02:10:15', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (151, 'countAvgResponseTime', '321', '2021-03-16 02:10:15', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (152, 'getUserInfo', '56', '2021-03-16 02:10:26', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (153, 'countInterfaceInfo', '188', '2021-03-16 02:10:26', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (154, 'countUserNumbers', '214', '2021-03-16 02:10:26', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (155, 'countAvgResponseTime', '212', '2021-03-16 02:10:26', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (156, 'getProjectInfo', '78', '2021-03-16 02:10:28', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (157, 'getDataSourceInfo', '79', '2021-03-16 02:10:28', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (158, 'getInterfaceData', '107', '2021-03-16 02:10:28', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (159, 'getTablesName', '93', '2021-03-16 02:11:24', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (160, 'getFieldsInfo', '61', '2021-03-16 02:11:30', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (161, 'addInterface', '480', '2021-03-16 02:12:24', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (162, 'getInterfaceData', '341', '2021-03-16 02:12:24', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (163, 'getProjectInfo', '400', '2021-03-16 02:12:24', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (164, 'getDataSourceInfo', '400', '2021-03-16 02:12:24', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (165, 'getInterfaceData', '2023', '2021-03-16 02:13:46', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (166, 'getDataSourceInfo', '2089', '2021-03-16 02:13:46', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (167, 'getProjectInfo', '2198', '2021-03-16 02:13:46', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (168, 'countAvgResponseTime', '76', '2021-03-16 02:13:49', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (169, 'countInterfaceInfo', '167', '2021-03-16 02:13:49', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (170, 'countUserNumbers', '248', '2021-03-16 02:13:49', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (171, 'getDataSourceInfo', '122', '2021-03-16 02:13:51', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (172, 'getProjectInfo', '186', '2021-03-16 02:13:51', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (173, 'getInterfaceData', '186', '2021-03-16 02:13:51', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (174, 'countInterfaceInfo', '49', '2021-03-16 02:13:56', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (175, 'countUserNumbers', '182', '2021-03-16 02:13:56', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (176, 'countAvgResponseTime', '185', '2021-03-16 02:13:56', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (177, 'countUserNumbers', '315', '2021-03-16 02:16:13', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (178, 'countAvgResponseTime', '370', '2021-03-16 02:16:13', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (179, 'getInterfaceLogInfo', '424', '2021-03-16 02:16:13', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (180, 'countInterfaceInfo', '476', '2021-03-16 02:16:13', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (181, 'countAvgResponseTime', '432', '2021-03-16 02:18:40', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (182, 'countInterfaceInfo', '324', '2021-03-16 02:18:40', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (183, 'countUserNumbers', '390', '2021-03-16 02:18:40', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (184, 'getInterfaceLogInfo', '607', '2021-03-16 02:18:40', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (185, 'countInterfaceInfo', '51', '2021-03-16 02:18:48', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (186, 'countAvgResponseTime', '82', '2021-03-16 02:18:48', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (187, 'countUserNumbers', '90', '2021-03-16 02:18:48', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (188, 'getInterfaceLogInfo', '150', '2021-03-16 02:18:48', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (189, 'countAvgResponseTime', '98', '2021-03-16 02:19:35', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (190, 'countUserNumbers', '172', '2021-03-16 02:19:35', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (191, 'countInterfaceInfo', '174', '2021-03-16 02:19:35', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (192, 'getInterfaceLogInfo', '250', '2021-03-16 02:19:35', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (193, 'getProjectInfo', '112', '2021-03-16 02:19:52', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (194, 'getInterfaceData', '151', '2021-03-16 02:19:52', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (195, 'getDataSourceInfo', '150', '2021-03-16 02:19:52', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (196, 'countUserNumbers', '73', '2021-03-16 02:20:10', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (197, 'countInterfaceInfo', '108', '2021-03-16 02:20:11', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (198, 'countAvgResponseTime', '97', '2021-03-16 02:20:11', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (199, 'getInterfaceLogInfo', '110', '2021-03-16 02:20:11', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (200, 'getInterfaceData', '60', '2021-03-16 02:20:54', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (201, 'getProjectInfo', '69', '2021-03-16 02:20:54', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (202, 'getDataSourceInfo', '66', '2021-03-16 02:20:54', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (203, 'getInterfaceData', '62', '2021-03-16 02:21:09', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (204, 'getProjectInfo', '78', '2021-03-16 02:21:09', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (205, 'getDataSourceInfo', '70', '2021-03-16 02:21:09', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (206, 'getInterfaceLogInfo', '167', '2021-03-16 02:26:28', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (207, 'countAvgResponseTime', '356', '2021-03-16 02:26:28', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (208, 'countUserNumbers', '429', '2021-03-16 02:26:29', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (209, 'countInterfaceInfo', '496', '2021-03-16 02:26:29', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (210, 'getInterfaceData', '82', '2021-03-16 02:26:30', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (211, 'getProjectInfo', '109', '2021-03-16 02:26:30', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (212, 'getDataSourceInfo', '108', '2021-03-16 02:26:30', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (213, 'getDataSourceInfo', '58', '2021-03-16 02:26:31', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (214, 'getProjectInfo', '123', '2021-03-16 02:26:34', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (215, 'getDataSourceInfo', '55', '2021-03-16 02:26:37', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (216, 'getUserInfo', '80', '2021-03-16 02:26:38', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (217, 'getInterfaceLogInfo', '188', '2021-03-16 02:26:40', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (218, 'countInterfaceInfo', '258', '2021-03-16 02:26:40', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (219, 'countUserNumbers', '256', '2021-03-16 02:26:40', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (220, 'countAvgResponseTime', '397', '2021-03-16 02:26:40', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (221, 'getDataSourceInfo', '173', '2021-03-16 02:26:42', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (222, 'getInterfaceData', '217', '2021-03-16 02:26:42', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (223, 'getProjectInfo', '229', '2021-03-16 02:26:42', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (224, 'getProjectInfo', '39', '2021-03-16 02:26:49', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (225, 'getInterfaceData', '199', '2021-03-16 02:32:50', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (226, 'getProjectInfo', '352', '2021-03-16 02:32:50', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (227, 'getDataSourceInfo', '436', '2021-03-16 02:32:50', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (228, 'getProjectInfo', '140', '2021-03-16 02:36:25', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (229, 'getDataSourceInfo', '218', '2021-03-16 02:36:25', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (230, 'getInterfaceData', '286', '2021-03-16 02:36:25', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (231, 'getInterfaceData', '362', '2021-03-16 02:37:14', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (232, 'getDataSourceInfo', '453', '2021-03-16 02:37:14', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (233, 'getProjectInfo', '670', '2021-03-16 02:37:14', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (234, 'getInterfaceData', '34', '2021-03-16 02:37:18', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (235, 'getDataSourceInfo', '49', '2021-03-16 02:37:18', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (236, 'getProjectInfo', '50', '2021-03-16 02:37:18', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (237, 'getInterfaceData', '212', '2021-03-16 02:38:19', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (238, 'getProjectInfo', '297', '2021-03-16 02:38:19', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (239, 'getDataSourceInfo', '327', '2021-03-16 02:38:19', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (240, 'getInterfaceData', '73', '2021-03-16 02:38:24', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (241, 'getDataSourceInfo', '67', '2021-03-16 02:38:24', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (242, 'getProjectInfo', '95', '2021-03-16 02:38:24', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (243, 'getInterfaceData', '126', '2021-03-16 02:38:38', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (244, 'getDataSourceInfo', '162', '2021-03-16 02:38:38', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (245, 'getProjectInfo', '174', '2021-03-16 02:38:38', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (246, 'getInterfaceData', '69', '2021-03-16 02:39:30', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (247, 'getProjectInfo', '89', '2021-03-16 02:39:30', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (248, 'getDataSourceInfo', '84', '2021-03-16 02:39:30', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (249, 'getProjectInfo', '98', '2021-03-16 02:44:57', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (250, 'getInterfaceData', '170', '2021-03-16 02:44:57', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (251, 'getDataSourceInfo', '244', '2021-03-16 02:44:57', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (252, 'getInterfaceData', '88', '2021-03-16 02:45:38', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (253, 'getProjectInfo', '181', '2021-03-16 02:45:38', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (254, 'getDataSourceInfo', '177', '2021-03-16 02:45:38', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (255, 'getProjectInfo', '296', '2021-03-16 02:48:41', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (256, 'getDataSourceInfo', '344', '2021-03-16 02:48:41', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (257, 'getInterfaceData', '245', '2021-03-16 02:48:41', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (258, 'getInterfaceData', '81', '2021-03-16 02:48:52', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (259, 'getProjectInfo', '132', '2021-03-16 02:48:52', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (260, 'getDataSourceInfo', '132', '2021-03-16 02:48:52', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (261, 'afd', '2', '2021-03-16 02:49:02', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (262, 'getInterfaceData', '183', '2021-03-16 02:50:32', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (263, 'getProjectInfo', '213', '2021-03-16 02:50:32', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (264, 'getDataSourceInfo', '275', '2021-03-16 02:50:32', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (265, 'getInterfaceData', '110', '2021-03-16 02:51:44', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (266, 'getDataSourceInfo', '259', '2021-03-16 02:51:45', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (267, 'getProjectInfo', '325', '2021-03-16 02:51:45', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (268, 'getInterfaceData', '109', '2021-03-16 02:51:49', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (269, 'getProjectInfo', '164', '2021-03-16 02:51:49', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (270, 'getDataSourceInfo', '151', '2021-03-16 02:51:49', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (271, 'afd', '1', '2021-03-16 02:51:57', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (272, 'getInterfaceData', '101', '2021-03-16 02:53:30', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (273, 'getProjectInfo', '215', '2021-03-16 02:53:30', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (274, 'getDataSourceInfo', '304', '2021-03-16 02:53:30', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (275, 'afd', '1', '2021-03-16 02:53:38', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (276, 'getInterfaceData', '71', '2021-03-16 02:54:38', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (277, 'getProjectInfo', '207', '2021-03-16 02:54:38', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (278, 'getDataSourceInfo', '260', '2021-03-16 02:54:38', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (279, 'getInterfaceData', '58', '2021-03-16 02:54:43', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (280, 'getProjectInfo', '75', '2021-03-16 02:54:44', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (281, 'getDataSourceInfo', '71', '2021-03-16 02:54:44', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (282, 'getInterfaceLogInfo', '85', '2021-03-16 02:54:55', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (283, 'getInterfaceData', '174', '2021-03-16 02:56:09', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (284, 'getProjectInfo', '410', '2021-03-16 02:56:09', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (285, 'getDataSourceInfo', '485', '2021-03-16 02:56:09', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (286, 'getProjectInfo', '40', '2021-03-16 02:56:13', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (287, 'getDataSourceInfo', '66', '2021-03-16 02:56:13', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (288, 'getInterfaceData', '69', '2021-03-16 02:56:13', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (289, 'getInterfaceLogInfo', '125', '2021-03-16 02:56:19', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (290, 'countAvgResponseTime', '54', '2021-03-16 02:56:25', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (291, 'getTablesName', '60', '2021-03-16 02:56:41', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (292, 'getFieldsInfo', '212', '2021-03-16 02:56:43', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (293, 'getProjectInfo', '31', '2021-03-16 02:56:54', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (294, 'getInterfaceData', '36', '2021-03-16 02:56:54', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (295, 'addInterface', '213', '2021-03-16 02:56:54', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (296, 'getDataSourceInfo', '49', '2021-03-16 02:56:54', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (297, 'test', '80', '2021-03-16 02:56:58', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (298, 'setInterfaceStatus', '126', '2021-03-16 02:57:03', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (299, 'getInterfaceData', '179', '2021-03-16 03:01:54', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (300, 'getProjectInfo', '244', '2021-03-16 03:01:55', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (301, 'getDataSourceInfo', '270', '2021-03-16 03:01:55', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (302, 'test', '116', '2021-03-16 03:01:59', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (303, 'getTablesName', '159', '2021-03-16 03:02:20', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (304, 'getFieldsInfo', '51', '2021-03-16 03:02:24', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (305, 'getFieldsInfo', '35', '2021-03-16 03:02:28', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (306, 'getProjectInfo', '5216', '2021-03-16 03:03:07', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (307, 'getDataSourceInfo', '60937', '2021-03-16 03:03:57', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (308, 'getInterfaceData', '62978', '2021-03-16 03:03:57', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (309, 'addInterface', '129937', '2021-03-16 03:05:01', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (310, 'getProjectInfo', '187', '2021-03-16 03:05:27', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (311, 'getInterfaceData', '9998', '2021-03-16 03:05:27', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (312, 'getDataSourceInfo', '618', '2021-03-16 03:05:27', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (313, 'test11', '6309', '2021-03-16 03:05:48', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (314, 'setInterfaceStatus', '85235', '2021-03-16 03:07:20', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (315, 'getProjectInfo', '145', '2021-03-16 03:13:49', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (316, 'getInterfaceData', '163', '2021-03-16 03:13:49', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (317, 'getDataSourceInfo', '163', '2021-03-16 03:13:49', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (318, 'getTablesName', '65', '2021-03-16 03:14:04', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (319, 'getFieldsInfo', '32', '2021-03-16 03:14:07', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (320, 'addInterface', '79', '2021-03-16 03:14:15', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (321, 'getProjectInfo', '30', '2021-03-16 03:14:16', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (322, 'getDataSourceInfo', '61', '2021-03-16 03:14:16', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (323, 'getInterfaceData', '65', '2021-03-16 03:14:16', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (324, 'test', '108', '2021-03-16 03:14:21', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (325, 'setInterfaceStatus', '131', '2021-03-16 03:14:25', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (326, 'test', '87', '2021-03-16 03:14:29', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (327, 'getDataSourceInfo', '56', '2021-03-16 03:14:36', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (328, 'getProjectInfo', '44', '2021-03-16 03:14:37', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (329, 'getDataSourceInfo', '45', '2021-03-16 03:14:38', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (330, 'getUserInfo', '68', '2021-03-16 03:14:41', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (331, 'login', '1011', '2021-03-18 00:58:09', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (332, 'getDataSourceInfo', '110', '2021-03-18 00:58:18', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (333, 'getInterfaceData', '176', '2021-03-18 00:58:18', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (334, 'getProjectInfo', '184', '2021-03-18 00:58:18', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (335, 'countUserNumbers', '1071', '2021-03-18 01:06:11', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (336, 'getInterfaceLogInfo', '1000', '2021-03-18 01:06:11', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (337, 'countInterfaceInfo', '950', '2021-03-18 01:06:11', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (338, 'countAvgResponseTime', '1225', '2021-03-18 01:06:11', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (339, 'countUserNumbers', '440', '2021-03-18 01:06:32', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (340, 'countInterfaceInfo', '544', '2021-03-18 01:06:32', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (341, 'countAvgResponseTime', '536', '2021-03-18 01:06:32', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (342, 'getInterfaceLogInfo', '573', '2021-03-18 01:06:32', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (343, 'countUserNumbers', '286', '2021-03-18 01:08:12', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (344, 'countAvgResponseTime', '362', '2021-03-18 01:08:12', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (345, 'countInterfaceInfo', '502', '2021-03-18 01:08:12', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (346, 'getInterfaceLogInfo', '484', '2021-03-18 01:08:12', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (347, 'countUserNumbers', '380', '2021-03-18 01:09:34', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (348, 'getInterfaceLogInfo', '267', '2021-03-18 01:09:34', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (349, 'countInterfaceInfo', '570', '2021-03-18 01:09:34', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (350, 'countAvgResponseTime', '659', '2021-03-18 01:09:34', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (351, 'countUserNumbers', '106', '2021-03-18 01:10:17', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (352, 'countAvgResponseTime', '194', '2021-03-18 01:10:17', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (353, 'getInterfaceLogInfo', '232', '2021-03-18 01:10:17', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (354, 'countInterfaceInfo', '238', '2021-03-18 01:10:17', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (355, 'getProjectInfo', '80', '2021-03-18 01:10:25', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (356, 'getDataSourceInfo', '111', '2021-03-18 01:10:25', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (357, 'getInterfaceData', '114', '2021-03-18 01:10:25', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (358, 'getTablesName', '344', '2021-03-18 01:12:43', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (359, 'getFieldsInfo', '375', '2021-03-18 01:12:45', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (360, 'test', '160', '2021-03-18 01:15:01', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (361, 'getDataSourceInfo', '148', '2021-03-18 01:16:03', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (362, 'login', '1006', '2021-03-19 03:55:24', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (363, 'login', '90', '2021-03-19 03:55:25', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (364, 'countInterfaceInfo', '1563', '2021-03-19 03:55:28', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (365, 'countAvgResponseTime', '1736', '2021-03-19 03:55:28', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (366, 'countUserNumbers', '1909', '2021-03-19 03:55:28', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (367, 'getInterfaceLogInfo', '4424', '2021-03-19 03:55:31', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (368, 'getInterfaceData', '173', '2021-03-19 03:56:06', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (369, 'getDataSourceInfo', '287', '2021-03-19 03:56:06', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (370, 'getProjectInfo', '553', '2021-03-19 03:56:06', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (371, 'getDataSourceInfo', '60', '2021-03-19 03:56:08', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (372, 'getProjectInfo', '459', '2021-03-19 03:56:11', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (373, 'getDataSourceInfo', '135', '2021-03-19 03:56:11', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (374, 'getUserInfo', '178', '2021-03-19 03:56:12', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (375, NULL, '119', '2021-03-25 01:33:35', 'http://localhost/', 'POST', '200');
INSERT INTO `interface_log` VALUES (376, NULL, '117', '2021-03-25 01:33:35', 'http://localhost/', 'POST', '200');
INSERT INTO `interface_log` VALUES (377, NULL, '120', '2021-03-25 01:33:35', 'http://localhost/', 'POST', '200');
INSERT INTO `interface_log` VALUES (378, NULL, '117', '2021-03-25 01:33:35', 'http://localhost/', 'POST', '200');
INSERT INTO `interface_log` VALUES (379, NULL, '118', '2021-03-25 01:33:35', 'http://localhost/', 'POST', '200');
INSERT INTO `interface_log` VALUES (380, NULL, '118', '2021-03-25 01:33:35', 'http://localhost/', 'POST', '200');
INSERT INTO `interface_log` VALUES (381, NULL, '119', '2021-03-25 01:33:35', 'http://localhost/', 'POST', '200');
INSERT INTO `interface_log` VALUES (382, NULL, '120', '2021-03-25 01:33:35', 'http://localhost/', 'POST', '200');
INSERT INTO `interface_log` VALUES (383, NULL, '119', '2021-03-25 01:33:36', 'http://localhost/', 'POST', '200');
INSERT INTO `interface_log` VALUES (384, NULL, '118', '2021-03-25 01:33:36', 'http://localhost/', 'POST', '200');
INSERT INTO `interface_log` VALUES (385, NULL, '94', '2021-04-02 13:39:18', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (386, NULL, '1', '2021-04-02 13:39:20', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (387, NULL, '2', '2021-04-02 13:39:20', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (388, NULL, '0', '2021-04-02 13:39:20', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (389, NULL, '4', '2021-04-02 13:39:21', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (390, NULL, '0', '2021-04-02 13:45:23', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (391, NULL, '1', '2021-04-02 13:45:23', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (392, NULL, '0', '2021-04-02 13:45:23', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (393, NULL, '0', '2021-04-02 13:45:23', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (394, 'countInterfaceInfo', '482', '2021-04-02 13:46:49', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (395, 'countAvgResponseTime', '526', '2021-04-02 13:46:49', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (396, 'getInterfaceLogInfo', '526', '2021-04-02 13:46:49', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (397, 'countUserNumbers', '526', '2021-04-02 13:46:49', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (398, 'getProjectInfo', '113', '2021-04-02 13:47:21', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (399, 'getInterfaceData', '151', '2021-04-02 13:47:21', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (400, 'getDataSourceInfo', '141', '2021-04-02 13:47:21', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (401, 'test', '468', '2021-04-02 14:15:46', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (402, 'getDataSourceInfo', '105', '2021-04-02 14:19:29', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (403, 'getDataSourceInfo', '407', '2021-04-02 14:22:43', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (404, 'getDataSourceInfo', '96', '2021-04-02 14:29:57', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (405, 'getProjectInfo', '119', '2021-04-02 14:29:58', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (406, 'getDataSourceInfo', '127', '2021-04-02 14:32:32', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (407, 'getProjectInfo', '77', '2021-04-02 14:32:33', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (408, 'getUserInfo', '387', '2021-04-02 14:36:16', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (409, 'getDataSourceInfo', '58', '2021-04-02 14:36:16', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (410, 'getDataSourceInfo', '97', '2021-04-02 14:36:23', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (411, 'getProjectInfo', '83', '2021-04-02 14:36:32', 'http://127.0.0.1/', 'POST', '200');
INSERT INTO `interface_log` VALUES (412, 'getDataSourceInfo', '404', '2021-04-02 14:44:12', 'http://127.0.0.1/', 'POST', '200');

-- ----------------------------
-- Table structure for project
-- ----------------------------
DROP TABLE IF EXISTS `project`;
CREATE TABLE `project`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `project_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '项目名称',
  `owners` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '负责人',
  `members` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '成员',
  `description` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '描述',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `project_name`(`project_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '项目表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of project
-- ----------------------------
INSERT INTO `project` VALUES (2, '项目3', '小李2', '小张,小王', 'sdf', '2020-12-30 18:29:39', '2021-03-14 02:42:12');
INSERT INTO `project` VALUES (18, '集团合规', '小李子', '小吉子,小梅梅', '集团合规项目', '2021-03-12 04:50:05', '2021-03-12 05:05:14');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '密码',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'super_admin', '123456', '2021-03-12 03:36:29', '2021-03-12 03:43:06');
INSERT INTO `user` VALUES (2, 'future', '123', '2021-03-12 03:36:29', '2021-03-12 03:43:06');
INSERT INTO `user` VALUES (3, 'fur', '12', '2021-03-12 03:36:29', '2021-03-12 03:43:06');
INSERT INTO `user` VALUES (4, '34', '234', '2021-03-12 03:36:29', '2021-03-12 03:43:06');
INSERT INTO `user` VALUES (5, '3', '3', '2021-03-12 03:36:29', '2021-03-12 03:43:06');
INSERT INTO `user` VALUES (6, '小李子', '1', '2021-03-14 01:21:06', '2021-03-14 01:21:06');

SET FOREIGN_KEY_CHECKS = 1;
