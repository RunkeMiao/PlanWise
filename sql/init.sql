-- =============================================
-- PlanWise 数据库初始化脚本
-- 数据库：MySQL 8.0+
-- 字符集：utf8mb4
-- =============================================

CREATE DATABASE IF NOT EXISTS planwise DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;-- 创建数据库


-- 使用数据库
USE planwise;

-- =============================================
-- 1. 用户表
-- =============================================
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
    `id` INT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    `username` VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    `password` VARCHAR(100) NOT NULL COMMENT '密码(MD5加密)',
    `email` VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
    `phone` VARCHAR(20) DEFAULT NULL COMMENT '手机号',
    `avatar` VARCHAR(255) DEFAULT '/images/avatar/default.png' COMMENT '头像路径',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX `idx_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- =============================================
-- 2. 技能字典表
-- =============================================
DROP TABLE IF EXISTS `skill`;
CREATE TABLE `skill` (
    `id` INT PRIMARY KEY AUTO_INCREMENT COMMENT '技能ID',
    `name` VARCHAR(50) NOT NULL UNIQUE COMMENT '技能名称',
    `category` VARCHAR(20) DEFAULT NULL COMMENT '分类(FRONTEND/BACKEND/DATABASE/TEST/DEVOPS/OTHER)',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX `idx_category` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='技能字典表';

-- =============================================
-- 3. 用户技能表
-- =============================================
DROP TABLE IF EXISTS `user_skill`;
CREATE TABLE `user_skill` (
    `id` INT PRIMARY KEY AUTO_INCREMENT COMMENT '记录ID',
    `user_id` INT NOT NULL COMMENT '用户ID',
    `skill_id` INT NOT NULL COMMENT '技能ID',
    `level` VARCHAR(20) DEFAULT 'BEGINNER' COMMENT '熟练度(BEGINNER/INTERMEDIATE/ADVANCED)',
    `years` INT DEFAULT 0 COMMENT '经验年限',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY `uk_user_skill` (`user_id`, `skill_id`),
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`skill_id`) REFERENCES `skill`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户技能表';

-- =============================================
-- 4. 项目表
-- =============================================
DROP TABLE IF EXISTS `project`;
CREATE TABLE `project` (
    `id` INT PRIMARY KEY AUTO_INCREMENT COMMENT '项目ID',
    `name` VARCHAR(100) NOT NULL COMMENT '项目名称',
    `description` TEXT COMMENT '项目描述',
    `type` VARCHAR(50) DEFAULT NULL COMMENT '项目类型',
    `duration` INT DEFAULT NULL COMMENT '开发周期(天)',
    `team_size` INT DEFAULT NULL COMMENT '团队人数',
    `status` VARCHAR(20) DEFAULT 'PLANNING' COMMENT '状态(PLANNING/DEVELOPING/TESTING/FINISHED)',
    `invite_code` VARCHAR(20) UNIQUE COMMENT '邀请码',
    `leader_id` INT NOT NULL COMMENT '负责人ID',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY `uk_invite_code` (`invite_code`),
    FOREIGN KEY (`leader_id`) REFERENCES `user`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='项目表';

-- =============================================
-- 5. 项目成员表
-- =============================================
DROP TABLE IF EXISTS `project_member`;
CREATE TABLE `project_member` (
    `id` INT PRIMARY KEY AUTO_INCREMENT COMMENT '记录ID',
    `project_id` INT NOT NULL COMMENT '项目ID',
    `user_id` INT NOT NULL COMMENT '用户ID',
    `role` VARCHAR(20) DEFAULT 'MEMBER' COMMENT '角色(LEADER/MEMBER)',
    `join_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '加入时间',
    UNIQUE KEY `uk_project_user` (`project_id`, `user_id`),
    FOREIGN KEY (`project_id`) REFERENCES `project`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='项目成员表';

-- =============================================
-- 6. 技术方案表
-- =============================================
DROP TABLE IF EXISTS `project_tech_stack`;
CREATE TABLE `project_tech_stack` (
    `id` INT PRIMARY KEY AUTO_INCREMENT COMMENT '记录ID',
    `project_id` INT NOT NULL COMMENT '项目ID',
    `category` VARCHAR(30) DEFAULT NULL COMMENT '分类(FRONTEND/BACKEND/DATABASE/CACHE/DEPLOY/OTHER)',
    `tech_name` VARCHAR(50) NOT NULL COMMENT '技术名称',
    `source` VARCHAR(20) DEFAULT 'AI' COMMENT '来源(AI/MANUAL)',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (`project_id`) REFERENCES `project`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='技术方案表';

-- =============================================
-- 7. 任务表
-- =============================================
DROP TABLE IF EXISTS `task`;
CREATE TABLE `task` (
    `id` INT PRIMARY KEY AUTO_INCREMENT COMMENT '任务ID',
    `project_id` INT NOT NULL COMMENT '项目ID',
    `name` VARCHAR(100) NOT NULL COMMENT '任务名称',
    `description` TEXT COMMENT '任务描述',
    `module` VARCHAR(50) DEFAULT NULL COMMENT '所属模块',
    `priority` VARCHAR(20) DEFAULT 'MEDIUM' COMMENT '优先级(LOW/MEDIUM/HIGH/URGENT)',
    `status` VARCHAR(20) DEFAULT 'TODO' COMMENT '状态(TODO/IN_PROGRESS/TESTING/DONE)',
    `deadline` DATE DEFAULT NULL COMMENT '截止日期',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX `idx_project_id` (`project_id`),
    INDEX `idx_status` (`status`),
    FOREIGN KEY (`project_id`) REFERENCES `project`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='任务表';

-- =============================================
-- 8. 任务分配表
-- =============================================
DROP TABLE IF EXISTS `task_assign`;
CREATE TABLE `task_assign` (
    `id` INT PRIMARY KEY AUTO_INCREMENT COMMENT '分配ID',
    `task_id` INT NOT NULL COMMENT '任务ID',
    `user_id` INT NOT NULL COMMENT '用户ID',
    `assign_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '分配时间',
    `status` VARCHAR(20) DEFAULT 'PENDING' COMMENT '状态(PENDING/ACCEPTED/COMPLETED)',
    `remark` TEXT COMMENT '备注',
    UNIQUE KEY `uk_task_user` (`task_id`, `user_id`),
    FOREIGN KEY (`task_id`) REFERENCES `task`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='任务分配表';

-- =============================================
-- 9. 工作日志表
-- =============================================
DROP TABLE IF EXISTS `work_log`;
CREATE TABLE `work_log` (
    `id` INT PRIMARY KEY AUTO_INCREMENT COMMENT '日志ID',
    `user_id` INT NOT NULL COMMENT '用户ID',
    `project_id` INT NOT NULL COMMENT '项目ID',
    `content` TEXT COMMENT '完成内容',
    `problem` TEXT COMMENT '遇到问题',
    `plan` TEXT COMMENT '下一步计划',
    `log_date` DATE NOT NULL COMMENT '日志日期',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '提交时间',
    INDEX `idx_project_user` (`project_id`, `user_id`),
    INDEX `idx_log_date` (`log_date`),
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`project_id`) REFERENCES `project`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='工作日志表';

-- =============================================
-- 10. AI记录表
-- =============================================
DROP TABLE IF EXISTS `ai_record`;
CREATE TABLE `ai_record` (
    `id` INT PRIMARY KEY AUTO_INCREMENT COMMENT '记录ID',
    `project_id` INT NOT NULL COMMENT '项目ID',
    `type` VARCHAR(30) DEFAULT NULL COMMENT '类型(TECH_STACK/MODULE_ANALYSIS/TASK_SPLIT/TASK_ASSIGN/WEEK_REPORT/RISK_ANALYSIS)',
    `input` TEXT COMMENT '输入内容',
    `output` TEXT COMMENT '输出内容',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX `idx_project_type` (`project_id`, `type`),
    FOREIGN KEY (`project_id`) REFERENCES `project`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='AI记录表';

-- =============================================
-- 初始数据：技能字典
-- =============================================
INSERT INTO `skill` (`name`, `category`) VALUES
-- 前端
('HTML/CSS', 'FRONTEND'),
('JavaScript', 'FRONTEND'),
('TypeScript', 'FRONTEND'),
('Vue3', 'FRONTEND'),
('React', 'FRONTEND'),
('Element Plus', 'FRONTEND'),
('Ant Design', 'FRONTEND'),
('Axios', 'FRONTEND'),
('Webpack', 'FRONTEND'),
('Vite', 'FRONTEND'),

-- 后端
('Java', 'BACKEND'),
('Python', 'BACKEND'),
('Spring Boot', 'BACKEND'),
('Spring Cloud', 'BACKEND'),
('MyBatis Plus', 'BACKEND'),
('Node.js', 'BACKEND'),
('Express', 'BACKEND'),

-- 数据库
('MySQL', 'DATABASE'),
('Redis', 'DATABASE'),
('MongoDB', 'DATABASE'),
('PostgreSQL', 'DATABASE'),
('Oracle', 'DATABASE'),

-- 测试
('JUnit', 'TEST'),
('Mockito', 'TEST'),
('Selenium', 'TEST'),
('Postman', 'TEST'),
('JMeter', 'TEST'),

-- 运维
('Linux', 'DEVOPS'),
('Docker', 'DEVOPS'),
('Nginx', 'DEVOPS'),
('Jenkins', 'DEVOPS'),
('Git', 'DEVOPS'),

-- 其他
('Figma', 'OTHER'),
('Photoshop', 'OTHER'),
('Markdown', 'OTHER');

-- =============================================
-- 初始数据：测试用户（密码都是 123456 的MD5值）
-- =============================================
INSERT INTO `user` (`username`, `password`, `email`, `phone`, `avatar`) VALUES
('zhangsan', 'e10adc3949ba59abbe56e057f20f883e', 'zhangsan@example.com', '13800138001', '/images/avatar/default.png'),
('lisi', 'e10adc3949ba59abbe56e057f20f883e', 'lisi@example.com', '13800138002', '/images/avatar/default.png'),
('wangwu', 'e10adc3949ba59abbe56e057f20f883e', 'wangwu@example.com', '13800138003', '/images/avatar/default.png'),
('zhaoliu', 'e10adc3949ba59abbe56e057f20f883e', 'zhaoliu@example.com', '13800138004', '/images/avatar/default.png'),
('test', 'e10adc3949ba59abbe56e057f20f883e', 'test@example.com', '13800138000', '/images/avatar/default.png');

-- =============================================
-- 初始数据：测试项目
-- =============================================
INSERT INTO `project` (`name`, `description`, `type`, `duration`, `team_size`, `status`, `invite_code`, `leader_id`) VALUES
('校园二手交易平台', '一个面向高校学生的二手物品交易平台，支持用户注册登录、商品发布浏览、订单管理等功能', 'Web应用', 15, 5, 'DEVELOPING', 'ABC123', 1),
('图书管理系统', '高校图书馆图书借阅管理系统', 'Web应用', 10, 3, 'PLANNING', 'DEF456', 1);

-- =============================================
-- 初始数据：项目成员
-- =============================================
INSERT INTO `project_member` (`project_id`, `user_id`, `role`) VALUES
(1, 1, 'LEADER'),
(1, 2, 'MEMBER'),
(1, 3, 'MEMBER'),
(2, 1, 'LEADER');

-- =============================================
-- 初始数据：用户技能
-- =============================================
INSERT INTO `user_skill` (`user_id`, `skill_id`, `level`, `years`) VALUES
-- 张三的技能
(1, 11, 'ADVANCED', 3),  -- Java 高级 3年
(1, 13, 'ADVANCED', 2),  -- Spring Boot 高级 2年
(1, 18, 'ADVANCED', 3),  -- MySQL 高级 3年
(1, 19, 'INTERMEDIATE', 1),  -- Redis 中级 1年

-- 李四的技能
(2, 4, 'ADVANCED', 2),   -- Vue3 高级 2年
(2, 3, 'INTERMEDIATE', 1),  -- TypeScript 中级 1年
(2, 6, 'ADVANCED', 2),   -- Element Plus 高级 2年

-- 王五的技能
(3, 25, 'ADVANCED', 2),  -- Selenium 高级 2年
(3, 28, 'ADVANCED', 3),  -- Linux 高级 3年
(3, 29, 'INTERMEDIATE', 1),  -- Docker 中级 1年

-- 赵六的技能
(4, 1, 'ADVANCED', 2),   -- HTML/CSS 高级 2年
(4, 2, 'ADVANCED', 3),   -- JavaScript 高级 3年
(4, 33, 'ADVANCED', 2);  -- Figma 高级 2年

-- =============================================
-- 初始数据：任务
-- =============================================
INSERT INTO `task` (`project_id`, `name`, `description`, `module`, `priority`, `status`, `deadline`) VALUES
(1, '数据库表设计', '设计用户、商品、订单等核心表结构', '公共', 'HIGH', 'DONE', '2024-01-17'),
(1, '用户登录注册', '实现用户注册、登录、JWT认证', '用户模块', 'HIGH', 'IN_PROGRESS', '2024-01-20'),
(1, '商品发布与管理', '实现商品发布、编辑、删除功能', '商品模块', 'HIGH', 'TESTING', '2024-01-22'),
(1, '商品列表与搜索', '实现商品列表展示和搜索功能', '商品模块', 'MEDIUM', 'IN_PROGRESS', '2024-01-24'),
(1, '订单管理', '实现下单、订单列表、订单详情', '订单模块', 'HIGH', 'TODO', '2024-01-26'),
(1, '收藏功能', '实现商品收藏和取消收藏', '收藏模块', 'LOW', 'TODO', '2024-01-28'),
(1, '评论功能', '实现商品评论的增删查', '评论模块', 'LOW', 'TODO', '2024-01-28');

-- =============================================
-- 初始数据：任务分配
-- =============================================
INSERT INTO `task_assign` (`task_id`, `user_id`, `status`) VALUES
(1, 3, 'COMPLETED'),  -- 数据库设计 -> 王五
(2, 1, 'ACCEPTED'),   -- 用户登录 -> 张三
(3, 2, 'ACCEPTED'),   -- 商品管理 -> 李四
(4, 2, 'PENDING');    -- 商品列表 -> 李四

-- =============================================
-- 初始数据：工作日志
-- =============================================
INSERT INTO `work_log` (`user_id`, `project_id`, `content`, `problem`, `plan`, `log_date`) VALUES
(3, 1, '完成数据库表设计，包括用户表、商品表、订单表等', '无', '等待后端开发', '2024-01-16'),
(1, 1, '完成用户登录接口开发', 'JWT token刷新机制有些问题', '明天完成注册接口和Token刷新', '2024-01-17'),
(2, 1, '完成商品列表页面开发', '搜索功能的分页有些bug', '修复搜索分页，开始商品详情页', '2024-01-17');

-- =============================================
-- 完成
-- =============================================
SELECT '数据库初始化完成！' AS message;
