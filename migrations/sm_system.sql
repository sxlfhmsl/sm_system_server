/*
Navicat MySQL Data Transfer

Source Server         : 本地
Source Server Version : 50712
Source Host           : localhost:3306
Source Database       : sm_system

Target Server Type    : MYSQL
Target Server Version : 50712
File Encoding         : 65001

Date: 2019-07-23 01:13:10
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for alembic_version
-- ----------------------------
DROP TABLE IF EXISTS `alembic_version`;
CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL,
  PRIMARY KEY (`version_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of alembic_version
-- ----------------------------
INSERT INTO `alembic_version` VALUES ('768b6b5afa5a');

-- ----------------------------
-- Table structure for sm_agent_drawing
-- ----------------------------
DROP TABLE IF EXISTS `sm_agent_drawing`;
CREATE TABLE `sm_agent_drawing` (
  `ID` varchar(64) NOT NULL COMMENT '提款ID',
  `AgentID` varchar(64) NOT NULL COMMENT '目标账户ID',
  `DrawingTime` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '提款日期',
  `DrawingValue` double NOT NULL COMMENT '提款金额',
  `Bank` varchar(50) DEFAULT NULL COMMENT '银行',
  `BankOfDeposit` varchar(50) DEFAULT NULL COMMENT '开户行',
  `BankAccount` varchar(50) NOT NULL COMMENT '银行账户',
  `DrawingStatus` int(5) NOT NULL COMMENT '提款状态',
  `ChangeTime` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '处理时间',
  PRIMARY KEY (`ID`),
  KEY `FK_Reference_17` (`AgentID`),
  CONSTRAINT `FK_Reference_17` FOREIGN KEY (`AgentID`) REFERENCES `sm_user_agent` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='代理提款';

-- ----------------------------
-- Records of sm_agent_drawing
-- ----------------------------

-- ----------------------------
-- Table structure for sm_buy_trade
-- ----------------------------
DROP TABLE IF EXISTS `sm_buy_trade`;
CREATE TABLE `sm_buy_trade` (
  `ID` varchar(64) NOT NULL COMMENT '持仓id',
  `Number` varchar(30) NOT NULL COMMENT '单号',
  `MemberID` varchar(64) NOT NULL COMMENT '会员ID',
  `TradeTime` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '购买时间',
  `TickerSymbol` varchar(30) NOT NULL COMMENT '股票代码',
  `Price` double NOT NULL COMMENT '购买价格',
  `Hands` int(11) unsigned NOT NULL COMMENT '手数',
  `BuyType` int(5) unsigned NOT NULL COMMENT '购买类型（多/空）',
  `BuyFeeRate` double DEFAULT NULL COMMENT '买入手续费',
  `StoreFeeRate` double DEFAULT NULL COMMENT '留仓费',
  `RiseFallSpreadRate` double DEFAULT NULL COMMENT '点差费',
  PRIMARY KEY (`ID`),
  KEY `FK_Reference_8` (`MemberID`),
  CONSTRAINT `FK_Reference_8` FOREIGN KEY (`MemberID`) REFERENCES `sm_user_member` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户持仓表';

-- ----------------------------
-- Records of sm_buy_trade
-- ----------------------------

-- ----------------------------
-- Table structure for sm_clerk
-- ----------------------------
DROP TABLE IF EXISTS `sm_clerk`;
CREATE TABLE `sm_clerk` (
  `ID` varchar(64) NOT NULL COMMENT '业务员ID',
  `AgentID` varchar(64) NOT NULL COMMENT '创建的代理的ID',
  `NickName` varchar(255) DEFAULT NULL COMMENT '名称',
  `Forbidden` tinyint(1) DEFAULT NULL COMMENT '是否禁用，默认不禁用',
  PRIMARY KEY (`ID`),
  KEY `FK_Reference_5` (`AgentID`),
  CONSTRAINT `FK_Reference_5` FOREIGN KEY (`AgentID`) REFERENCES `sm_user_agent` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='业务员表';

-- ----------------------------
-- Records of sm_clerk
-- ----------------------------

-- ----------------------------
-- Table structure for sm_close_plan
-- ----------------------------
DROP TABLE IF EXISTS `sm_close_plan`;
CREATE TABLE `sm_close_plan` (
  `ID` varchar(64) NOT NULL COMMENT '编号',
  `CreatorID` varchar(64) DEFAULT NULL COMMENT '管理员ID',
  `PlanDate` date NOT NULL COMMENT '休市日期',
  `Time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `Note` varchar(255) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`ID`),
  KEY `FK_Reference_13` (`CreatorID`),
  CONSTRAINT `FK_Reference_13` FOREIGN KEY (`CreatorID`) REFERENCES `sm_user_admin` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='休市安排';

-- ----------------------------
-- Records of sm_close_plan
-- ----------------------------

-- ----------------------------
-- Table structure for sm_manual_trade
-- ----------------------------
DROP TABLE IF EXISTS `sm_manual_trade`;
CREATE TABLE `sm_manual_trade` (
  `ID` varchar(64) NOT NULL COMMENT '主键',
  `MemberID` varchar(64) DEFAULT NULL COMMENT '会员id',
  `OpType` varchar(20) DEFAULT NULL COMMENT '操作类型',
  `DetailType` varchar(50) DEFAULT NULL,
  `CreatorID` varchar(64) DEFAULT NULL COMMENT '管理员ID',
  `CreateTime` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `Value` int(11) unsigned NOT NULL COMMENT '金额',
  `Note` varchar(255) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`ID`),
  KEY `FK_Reference_14` (`MemberID`),
  KEY `FK_Reference_15` (`CreatorID`),
  CONSTRAINT `FK_Reference_14` FOREIGN KEY (`MemberID`) REFERENCES `sm_user_member` (`ID`),
  CONSTRAINT `FK_Reference_15` FOREIGN KEY (`CreatorID`) REFERENCES `sm_user_admin` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='手动入扣款';

-- ----------------------------
-- Records of sm_manual_trade
-- ----------------------------

-- ----------------------------
-- Table structure for sm_member_drawing
-- ----------------------------
DROP TABLE IF EXISTS `sm_member_drawing`;
CREATE TABLE `sm_member_drawing` (
  `ID` varchar(64) NOT NULL COMMENT '会员提款ID',
  `MemberID` varchar(64) NOT NULL COMMENT '会员ID',
  `DrawingTime` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '提款日期',
  `DrawingValue` double NOT NULL COMMENT '提款金额',
  `Bank` varchar(50) DEFAULT NULL COMMENT '银行',
  `BankOfDeposit` varchar(50) DEFAULT NULL COMMENT '开户行',
  `BankAccountName` varchar(20) DEFAULT NULL COMMENT '账户名',
  `BankAccount` varchar(50) NOT NULL COMMENT '银行账户',
  `DrawingStatus` int(5) NOT NULL COMMENT '提款状态',
  `ChangeTime` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '处理时间',
  `Note` varchar(255) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`ID`),
  KEY `FK_Reference_18` (`MemberID`),
  CONSTRAINT `FK_Reference_18` FOREIGN KEY (`MemberID`) REFERENCES `sm_user_member` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='会员提款表';

-- ----------------------------
-- Records of sm_member_drawing
-- ----------------------------

-- ----------------------------
-- Table structure for sm_recharge
-- ----------------------------
DROP TABLE IF EXISTS `sm_recharge`;
CREATE TABLE `sm_recharge` (
  `Number` varchar(64) NOT NULL COMMENT '订单号',
  `MemberID` varchar(64) DEFAULT NULL COMMENT '参与者',
  `Value` double DEFAULT NULL COMMENT '充值金额',
  `OrderIP` varchar(30) DEFAULT NULL COMMENT '下单的IP',
  `CreateTime` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `SNumber` varchar(50) DEFAULT NULL COMMENT '流水号',
  `VendorNumber` varchar(50) DEFAULT NULL COMMENT '商家号',
  `Bank` varchar(50) DEFAULT NULL COMMENT '银行',
  `DepositIP` varchar(30) DEFAULT NULL COMMENT '存款IP',
  `DepositTime` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '存款时间',
  `DepositStatus` varchar(50) DEFAULT NULL COMMENT '存款状态',
  `Note` varchar(255) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`Number`),
  KEY `FK_Reference_16` (`MemberID`),
  CONSTRAINT `FK_Reference_16` FOREIGN KEY (`MemberID`) REFERENCES `sm_user_member` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='充值管理表';

-- ----------------------------
-- Records of sm_recharge
-- ----------------------------

-- ----------------------------
-- Table structure for sm_sell_trade
-- ----------------------------
DROP TABLE IF EXISTS `sm_sell_trade`;
CREATE TABLE `sm_sell_trade` (
  `ID` varchar(64) NOT NULL COMMENT '平仓ID',
  `MemberID` varchar(64) DEFAULT NULL COMMENT '会员ID',
  `TickerSymbol` varchar(30) NOT NULL COMMENT '股票代码',
  `BuyNumber` varchar(30) NOT NULL COMMENT '购买单号',
  `BuyTime` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '购买时间',
  `BuyPrice` double NOT NULL COMMENT '购买价格',
  `SellNumber` varchar(30) NOT NULL COMMENT '售出编码',
  `SellTime` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '售出时间',
  `SellPrice` double NOT NULL COMMENT '售出价格',
  `BuyType` int(5) unsigned NOT NULL COMMENT '购买类型（多/空）',
  `Fee` double NOT NULL COMMENT '手续费',
  `Interest` double NOT NULL COMMENT '融资利息',
  `StampDuty` double NOT NULL COMMENT '印花税',
  `Profit` double NOT NULL COMMENT '收益',
  `Hands` int(10) unsigned NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK_Reference_9` (`MemberID`),
  CONSTRAINT `FK_Reference_9` FOREIGN KEY (`MemberID`) REFERENCES `sm_user_member` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户平仓表';

-- ----------------------------
-- Records of sm_sell_trade
-- ----------------------------

-- ----------------------------
-- Table structure for sm_stock_para
-- ----------------------------
DROP TABLE IF EXISTS `sm_stock_para`;
CREATE TABLE `sm_stock_para` (
  `TickerSymbol` varchar(64) NOT NULL COMMENT '股票代码',
  `Name` varchar(50) DEFAULT NULL COMMENT '股票名称',
  `Abridge` varchar(30) DEFAULT NULL COMMENT '拼音缩写',
  `Type` varchar(30) DEFAULT NULL COMMENT '股票类型',
  `BuyByBullish` tinyint(1) DEFAULT '1' COMMENT '可买多',
  `BuyByBearish` tinyint(1) DEFAULT '1' COMMENT '可买空',
  `Buiable` tinyint(1) DEFAULT '1' COMMENT '可买的',
  `Sellable` tinyint(1) DEFAULT '1' COMMENT '可卖的',
  `Close` tinyint(1) DEFAULT NULL COMMENT '关盘',
  `Suspend` tinyint(1) DEFAULT NULL COMMENT '停牌',
  `SuspendTime` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '停牌时间',
  `Forbidden` tinyint(1) DEFAULT NULL COMMENT '禁用',
  `Note` varchar(255) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`TickerSymbol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sm_stock_para
-- ----------------------------

-- ----------------------------
-- Table structure for sm_sys_conf
-- ----------------------------
DROP TABLE IF EXISTS `sm_sys_conf`;
CREATE TABLE `sm_sys_conf` (
  `Key` varchar(100) NOT NULL COMMENT '配置的键值',
  `Value` varchar(255) NOT NULL COMMENT '值',
  `Description` varchar(255) DEFAULT NULL COMMENT '描述',
  PRIMARY KEY (`Key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='系统配置表';

-- ----------------------------
-- Records of sm_sys_conf
-- ----------------------------

-- ----------------------------
-- Table structure for sm_sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sm_sys_notice`;
CREATE TABLE `sm_sys_notice` (
  `ID` varchar(64) NOT NULL COMMENT '公告编号',
  `CreatorID` varchar(64) DEFAULT NULL COMMENT '创建者ID',
  `Title` varchar(50) DEFAULT NULL COMMENT '标题',
  `Content` varchar(255) DEFAULT NULL COMMENT '内容',
  `Time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `AgentDisable` tinyint(1) NOT NULL COMMENT '代理不显示',
  `MemberDisable` tinyint(1) NOT NULL COMMENT '成员不显示',
  PRIMARY KEY (`ID`),
  KEY `FK_Reference_12` (`CreatorID`),
  CONSTRAINT `FK_Reference_12` FOREIGN KEY (`CreatorID`) REFERENCES `sm_user_admin` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='系统公告表';

-- ----------------------------
-- Records of sm_sys_notice
-- ----------------------------

-- ----------------------------
-- Table structure for sm_trade_bill
-- ----------------------------
DROP TABLE IF EXISTS `sm_trade_bill`;
CREATE TABLE `sm_trade_bill` (
  `ID` varchar(64) NOT NULL COMMENT '交易账单ID',
  `Number` varchar(30) NOT NULL COMMENT '交易单号',
  `TradeType` int(5) unsigned NOT NULL COMMENT '交易类型',
  `MemberID` varchar(64) DEFAULT NULL COMMENT '会员ID',
  `TickerSymbol` varchar(30) NOT NULL COMMENT '股票代码',
  `TickerName` varchar(30) NOT NULL COMMENT '股票名称',
  `UnitPrice` double NOT NULL COMMENT '单价',
  `Hands` int(11) unsigned NOT NULL COMMENT '手数',
  `Amount` double NOT NULL COMMENT '交易金额',
  `Time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '时间',
  `OpID` int(11) unsigned DEFAULT NULL COMMENT '操作人',
  `Note` varchar(255) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`ID`),
  KEY `FK_Reference_10` (`MemberID`),
  CONSTRAINT `FK_Reference_10` FOREIGN KEY (`MemberID`) REFERENCES `sm_user_member` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='交易账单表';

-- ----------------------------
-- Records of sm_trade_bill
-- ----------------------------

-- ----------------------------
-- Table structure for sm_user
-- ----------------------------
DROP TABLE IF EXISTS `sm_user`;
CREATE TABLE `sm_user` (
  `ID` varchar(64) NOT NULL COMMENT '管理员表ID主键',
  `LoginName` varchar(64) NOT NULL COMMENT '登录名',
  `NickName` varchar(64) NOT NULL COMMENT '昵称',
  `Password` varchar(255) NOT NULL COMMENT '密码',
  `CreateTime` datetime NOT NULL COMMENT '创建时间',
  `LastLogonTime` datetime DEFAULT NULL COMMENT '上次登录时间',
  `CreatorID` varchar(64) DEFAULT NULL COMMENT '创建者ID',
  `Forbidden` tinyint(1) unsigned zerofill NOT NULL COMMENT '是否禁用， 默认不禁用',
  `RoleID` varchar(64) DEFAULT NULL COMMENT '用户类型ID',
  `Lock` tinyint(1) unsigned zerofill NOT NULL,
  PRIMARY KEY (`ID`,`LoginName`),
  KEY `FK_Reference_4` (`RoleID`),
  CONSTRAINT `FK_Reference_4` FOREIGN KEY (`RoleID`) REFERENCES `sm_user_role` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户表';

-- ----------------------------
-- Records of sm_user
-- ----------------------------
INSERT INTO `sm_user` VALUES ('1', 'superadmin', 'superadmin', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', '2019-07-10 14:42:39', '2019-07-20 14:45:58', null, '0', 'eabbb5362bedec4981e460c40e60a55b', '0');

-- ----------------------------
-- Table structure for sm_user_admin
-- ----------------------------
DROP TABLE IF EXISTS `sm_user_admin`;
CREATE TABLE `sm_user_admin` (
  `ID` varchar(64) NOT NULL COMMENT '管理员ID',
  PRIMARY KEY (`ID`),
  CONSTRAINT `FK_Reference_1` FOREIGN KEY (`ID`) REFERENCES `sm_user` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='管理员表';

-- ----------------------------
-- Records of sm_user_admin
-- ----------------------------
INSERT INTO `sm_user_admin` VALUES ('1');

-- ----------------------------
-- Table structure for sm_user_agent
-- ----------------------------
DROP TABLE IF EXISTS `sm_user_agent`;
CREATE TABLE `sm_user_agent` (
  `ID` varchar(64) NOT NULL COMMENT '代理ID',
  `Margin` double DEFAULT NULL COMMENT '保证金',
  `TestMargin` double DEFAULT NULL COMMENT '测试保证金',
  `CommissionRatio` double DEFAULT NULL COMMENT '交易佣金分成',
  `ExchangeRate` double DEFAULT NULL COMMENT '人民币与股币兑换',
  `MemberPrefix` varchar(255) DEFAULT NULL COMMENT '会员账号前缀',
  `MemberNum` int(10) unsigned zerofill NOT NULL COMMENT '当前会员数量',
  `MemberMaximum` int(11) unsigned zerofill NOT NULL COMMENT '可创建会员数量限制',
  `Bank` varchar(255) DEFAULT NULL COMMENT '收款银行',
  `BankAccount` varchar(30) DEFAULT NULL COMMENT '银行账号',
  `Cardholder` varchar(30) DEFAULT NULL COMMENT '银行账户名',
  `WithdrawPassWord` varchar(30) DEFAULT NULL COMMENT '取款密码',
  `Type` int(11) NOT NULL COMMENT '账户类型，正式，测试，其他',
  `AgentLevel` int(11) unsigned NOT NULL COMMENT '代理用户等级（甄别多级代理）',
  PRIMARY KEY (`ID`),
  KEY `Type` (`Type`),
  CONSTRAINT `FK_Reference_2` FOREIGN KEY (`ID`) REFERENCES `sm_user` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sm_user_agent_ibfk_1` FOREIGN KEY (`Type`) REFERENCES `sm_user_type` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='代理表';

-- ----------------------------
-- Records of sm_user_agent
-- ----------------------------

-- ----------------------------
-- Table structure for sm_user_log
-- ----------------------------
DROP TABLE IF EXISTS `sm_user_log`;
CREATE TABLE `sm_user_log` (
  `ID` varchar(64) NOT NULL COMMENT '日志id',
  `UserID` varchar(64) DEFAULT NULL COMMENT '操作者',
  `Type` varchar(50) DEFAULT NULL COMMENT '操作类型',
  `Model` varchar(50) DEFAULT NULL COMMENT '操作模块',
  `Time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '发生时间',
  `Note` varchar(255) DEFAULT NULL COMMENT '操作记录',
  PRIMARY KEY (`ID`),
  KEY `FK_Reference_11` (`UserID`),
  CONSTRAINT `FK_Reference_11` FOREIGN KEY (`UserID`) REFERENCES `sm_user` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户日志记录';

-- ----------------------------
-- Records of sm_user_log
-- ----------------------------

-- ----------------------------
-- Table structure for sm_user_member
-- ----------------------------
DROP TABLE IF EXISTS `sm_user_member`;
CREATE TABLE `sm_user_member` (
  `ID` varchar(64) NOT NULL COMMENT '会员ID',
  `AgentID` varchar(64) NOT NULL COMMENT '归属的代理账号id',
  `ClerkID` varchar(64) DEFAULT NULL COMMENT '业务员ID',
  `CustomerName` varchar(30) DEFAULT NULL COMMENT '客户姓名',
  `Margin` double DEFAULT NULL COMMENT '保证金',
  `Earning` double unsigned zerofill NOT NULL COMMENT '客户总盈亏',
  `PhoneNum` varchar(20) DEFAULT NULL COMMENT '手机号码',
  `BuyFeeRate` double DEFAULT NULL COMMENT '买入手续费',
  `SellFeeRate` double DEFAULT NULL COMMENT '卖出手续费',
  `RiseFallSpreadRate` double DEFAULT NULL COMMENT '涨跌点差率',
  `Bank` varchar(255) DEFAULT NULL COMMENT '收款银行',
  `BankAccount` varchar(30) DEFAULT NULL COMMENT '银行账户',
  `Cardholder` varchar(30) DEFAULT NULL COMMENT '银行账户名',
  `OpeningBank` varchar(30) DEFAULT NULL COMMENT '开户行',
  `WithdrawPassWord` varchar(64) DEFAULT NULL COMMENT '取款密码',
  `EmailAddress` varchar(50) DEFAULT NULL COMMENT '邮箱地址',
  `QQNum` varchar(20) DEFAULT NULL COMMENT 'QQ号',
  `Type` int(11) NOT NULL COMMENT '账户类型，正式，测试，其他',
  PRIMARY KEY (`ID`),
  KEY `FK_Reference_6` (`ClerkID`),
  KEY `FK_Reference_7` (`AgentID`),
  KEY `Type` (`Type`),
  CONSTRAINT `FK_Reference_3` FOREIGN KEY (`ID`) REFERENCES `sm_user` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_Reference_6` FOREIGN KEY (`ClerkID`) REFERENCES `sm_clerk` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_Reference_7` FOREIGN KEY (`AgentID`) REFERENCES `sm_user_agent` (`ID`),
  CONSTRAINT `sm_user_member_ibfk_1` FOREIGN KEY (`Type`) REFERENCES `sm_user_type` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='会员表';

-- ----------------------------
-- Records of sm_user_member
-- ----------------------------

-- ----------------------------
-- Table structure for sm_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sm_user_role`;
CREATE TABLE `sm_user_role` (
  `ID` varchar(64) NOT NULL COMMENT '用户类型id',
  `Name` char(50) NOT NULL COMMENT '名称',
  `Description` varchar(255) DEFAULT NULL COMMENT '描述',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户组表';

-- ----------------------------
-- Records of sm_user_role
-- ----------------------------
INSERT INTO `sm_user_role` VALUES ('2800d5549b224f0e0a36be4880830f8b', 'Member', '会员');
INSERT INTO `sm_user_role` VALUES ('dcf76f2e05fc5394efe44f5b23cb3a9a', 'Agent', '代理');
INSERT INTO `sm_user_role` VALUES ('eabbb5362bedec4981e460c40e60a55b', 'Admin', '管理员');

-- ----------------------------
-- Table structure for sm_user_type
-- ----------------------------
DROP TABLE IF EXISTS `sm_user_type`;
CREATE TABLE `sm_user_type` (
  `ID` int(11) NOT NULL,
  `Name` varchar(50) NOT NULL COMMENT '名称',
  `Description` varchar(255) NOT NULL COMMENT '描述',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户类型表，正式，测试，其他';

-- ----------------------------
-- Records of sm_user_type
-- ----------------------------
INSERT INTO `sm_user_type` VALUES ('1', 'Formal', '正式');
INSERT INTO `sm_user_type` VALUES ('2', 'Test', '测试');
INSERT INTO `sm_user_type` VALUES ('99', 'Other', '其他');
