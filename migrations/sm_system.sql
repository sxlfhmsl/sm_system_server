/*
Navicat MySQL Data Transfer

Source Server         : 本地
Source Server Version : 50712
Source Host           : localhost:3306
Source Database       : sm_system

Target Server Type    : MYSQL
Target Server Version : 50712
File Encoding         : 65001

Date: 2019-07-29 01:26:43
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
  `DrawingTime` datetime NOT NULL COMMENT '提款日期',
  `DrawingValue` double NOT NULL COMMENT '提款金额',
  `Bank` varchar(50) DEFAULT NULL COMMENT '银行',
  `BankOfDeposit` varchar(50) DEFAULT NULL COMMENT '开户行',
  `BankAccountName` varchar(20) DEFAULT NULL COMMENT '账户名',
  `BankAccount` varchar(50) NOT NULL COMMENT '银行账户',
  `DrawingStatus` int(5) NOT NULL COMMENT '提款状态',
  `ChangeTime` datetime DEFAULT NULL COMMENT '处理时间',
  `Note` varchar(255) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`ID`),
  KEY `FK_Reference_17` (`AgentID`),
  KEY `DrawingStatus` (`DrawingStatus`),
  CONSTRAINT `FK_Reference_17` FOREIGN KEY (`AgentID`) REFERENCES `sm_user_agent` (`ID`),
  CONSTRAINT `sm_agent_drawing_ibfk_1` FOREIGN KEY (`DrawingStatus`) REFERENCES `sm_drawing_status` (`ID`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='代理提款';

-- ----------------------------
-- Records of sm_agent_drawing
-- ----------------------------

-- ----------------------------
-- Table structure for sm_buy_trade
-- ----------------------------
DROP TABLE IF EXISTS `sm_buy_trade`;
CREATE TABLE `sm_buy_trade` (
  `Number` varchar(30) NOT NULL COMMENT '单号',
  `MemberID` varchar(64) NOT NULL COMMENT '会员ID',
  `TradeTime` datetime NOT NULL COMMENT '购买时间',
  `TickerSymbol` varchar(30) NOT NULL COMMENT '股票代码',
  `Price` double NOT NULL COMMENT '购买价格',
  `Hands` int(11) unsigned NOT NULL COMMENT '手数',
  `BuyType` int(5) unsigned NOT NULL COMMENT '购买类型（多/空）0多 1空',
  `BuyFeeRate` double NOT NULL COMMENT '买入手续费',
  `StoreFeeRate` double NOT NULL COMMENT '留仓费',
  `RiseFallSpreadRate` double NOT NULL COMMENT '点差费',
  PRIMARY KEY (`Number`),
  KEY `FK_Reference_8` (`MemberID`),
  KEY `BuyType` (`BuyType`),
  CONSTRAINT `FK_Reference_8` FOREIGN KEY (`MemberID`) REFERENCES `sm_user_member` (`ID`),
  CONSTRAINT `sm_buy_trade_ibfk_1` FOREIGN KEY (`BuyType`) REFERENCES `sm_trade_type` (`ID`) ON UPDATE CASCADE
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
  `Time` datetime NOT NULL COMMENT '创建时间',
  `Note` varchar(255) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`ID`),
  KEY `FK_Reference_13` (`CreatorID`),
  CONSTRAINT `FK_Reference_13` FOREIGN KEY (`CreatorID`) REFERENCES `sm_user_admin` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='休市安排';

-- ----------------------------
-- Records of sm_close_plan
-- ----------------------------

-- ----------------------------
-- Table structure for sm_drawing_status
-- ----------------------------
DROP TABLE IF EXISTS `sm_drawing_status`;
CREATE TABLE `sm_drawing_status` (
  `ID` int(5) NOT NULL AUTO_INCREMENT COMMENT '状态ID',
  `Description` varchar(255) NOT NULL COMMENT '描述',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sm_drawing_status
-- ----------------------------
INSERT INTO `sm_drawing_status` VALUES ('1', '待审核');
INSERT INTO `sm_drawing_status` VALUES ('2', '已撤销');
INSERT INTO `sm_drawing_status` VALUES ('3', '已通过');
INSERT INTO `sm_drawing_status` VALUES ('4', '未通过');

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
  `CreateTime` datetime DEFAULT NULL COMMENT '创建时间',
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
  `DrawingTime` datetime DEFAULT NULL COMMENT '提款日期',
  `DrawingValue` double NOT NULL COMMENT '提款金额',
  `Bank` varchar(50) DEFAULT NULL COMMENT '银行',
  `BankOfDeposit` varchar(50) DEFAULT NULL COMMENT '开户行',
  `BankAccountName` varchar(20) DEFAULT NULL COMMENT '账户名',
  `BankAccount` varchar(50) NOT NULL COMMENT '银行账户',
  `DrawingStatus` int(5) NOT NULL COMMENT '提款状态',
  `ChangeTime` datetime DEFAULT NULL COMMENT '处理时间',
  `Note` varchar(255) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`ID`),
  KEY `FK_Reference_18` (`MemberID`),
  KEY `DrawingStatus` (`DrawingStatus`),
  CONSTRAINT `FK_Reference_18` FOREIGN KEY (`MemberID`) REFERENCES `sm_user_member` (`ID`),
  CONSTRAINT `sm_member_drawing_ibfk_1` FOREIGN KEY (`DrawingStatus`) REFERENCES `sm_drawing_status` (`ID`) ON UPDATE CASCADE
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
  `CreateTime` datetime DEFAULT NULL COMMENT '创建时间',
  `SNumber` varchar(50) DEFAULT NULL COMMENT '流水号',
  `VendorNumber` varchar(50) DEFAULT NULL COMMENT '商家号',
  `Bank` varchar(50) DEFAULT NULL COMMENT '银行',
  `DepositIP` varchar(30) DEFAULT NULL COMMENT '存款IP',
  `DepositTime` datetime DEFAULT NULL COMMENT '存款时间',
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
  `SellNumber` varchar(30) NOT NULL COMMENT '售出编码',
  `MemberID` varchar(64) DEFAULT NULL COMMENT '会员ID',
  `TickerSymbol` varchar(30) NOT NULL COMMENT '股票代码',
  `BuyNumber` varchar(30) NOT NULL COMMENT '购买单号',
  `BuyTime` datetime NOT NULL COMMENT '购买时间',
  `BuyPrice` double NOT NULL COMMENT '购买价格',
  `SellTime` datetime NOT NULL COMMENT '售出时间',
  `SellPrice` double NOT NULL COMMENT '售出价格',
  `BuyType` int(5) unsigned NOT NULL COMMENT '购买类型（多/空）',
  `Fee` double NOT NULL COMMENT '手续费',
  `Interest` double NOT NULL COMMENT '融资利息',
  `StampDuty` double NOT NULL COMMENT '印花税',
  `Profit` double NOT NULL COMMENT '收益',
  `Hands` int(10) unsigned NOT NULL,
  PRIMARY KEY (`SellNumber`),
  KEY `FK_Reference_9` (`MemberID`),
  KEY `BuyType` (`BuyType`),
  CONSTRAINT `FK_Reference_9` FOREIGN KEY (`MemberID`) REFERENCES `sm_user_member` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `sm_sell_trade_ibfk_1` FOREIGN KEY (`BuyType`) REFERENCES `sm_trade_type` (`ID`) ON UPDATE CASCADE
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
  `Name` varchar(50) NOT NULL COMMENT '股票名称',
  `Abridge` varchar(30) NOT NULL COMMENT '拼音缩写',
  `Type` varchar(30) NOT NULL COMMENT '股票类型',
  `BuyByBullish` tinyint(1) NOT NULL DEFAULT '1' COMMENT '可买多',
  `BuyByBearish` tinyint(1) NOT NULL DEFAULT '1' COMMENT '可买空',
  `Buiable` tinyint(1) NOT NULL DEFAULT '1' COMMENT '可买的',
  `Sellable` tinyint(1) NOT NULL DEFAULT '1' COMMENT '可卖的',
  `Close` tinyint(1) NOT NULL COMMENT '关盘',
  `Suspend` tinyint(1) NOT NULL COMMENT '停牌',
  `Forbidden` tinyint(1) NOT NULL COMMENT '禁用',
  `SuspendTime` datetime DEFAULT NULL COMMENT '停牌时间',
  `Note` varchar(255) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`TickerSymbol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sm_stock_para
-- ----------------------------
INSERT INTO `sm_stock_para` VALUES ('000001', '平安银行', 'PAYX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000002', '万  科Ａ', 'W  KＡ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000004', '国农科技', 'GNKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000005', '世纪星源', 'SJXY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000006', '深振业Ａ', 'SZYＡ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000007', '全新好', 'QXH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000008', '神州高铁', 'SZGT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000009', '中国宝安', 'ZGBA', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000010', '美丽生态', 'MLST', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000011', '深物业A', 'SWYA', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000012', '南  玻Ａ', 'N  BＡ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000014', '沙河股份', 'SHGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000016', '深康佳Ａ', 'SKJＡ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000017', '深中华A', 'SZHA', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000018', '神州长城', 'SZCC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000019', '深深宝Ａ', 'SSBＡ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000020', '深华发Ａ', 'SHFＡ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000021', '深科技', 'SKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000022', '深赤湾Ａ', 'SCWＡ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000023', '深天地Ａ', 'STDＡ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000024', '招商地产', 'ZSDC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000025', '特  力Ａ', 'T  LＡ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000026', '飞亚达Ａ', 'FYDＡ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000027', '深圳能源', 'S圳NY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000028', '国药一致', 'GYYZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000029', '深深房Ａ', 'SSFＡ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000030', '富奥股份', 'FAGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000031', '中粮地产', 'ZLDC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000032', '深桑达Ａ', 'SSDＡ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000033', '新都退', 'XDT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000034', '神州数码', 'SZSM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000035', '中国天楹', 'ZGT楹', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000036', '华联控股', 'HLKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000037', '深南电A', 'SNDA', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000038', '深大通', 'SDT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000039', '中集集团', 'ZJJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000040', '东旭蓝天', 'DXLT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000042', '中洲控股', 'ZZKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000043', '中航善达', 'ZHSD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000045', '深纺织Ａ', 'SFZＡ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000046', '泛海控股', 'FHKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000048', '*ST康达', '*STKD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000049', '德赛电池', 'DSDC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000050', '深天马Ａ', 'STMＡ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000055', '方大集团', 'FDJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000056', '皇庭国际', 'HTGJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000058', '深 赛 格', 'S S G', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000059', '华锦股份', 'HJGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000060', '中金岭南', 'ZJLN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000061', '农 产 品', 'N C P', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000062', '深圳华强', 'S圳HQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000063', '中兴通讯', 'ZXTX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000065', '北方国际', 'BFGJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000066', '中国长城', 'ZGCC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000068', '华控赛格', 'HKSG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000069', '华侨城Ａ', 'HQCＡ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000070', '特发信息', 'TFXX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000078', '海王生物', 'HWSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000088', '盐 田 港', 'Y T G', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000089', '深圳机场', 'S圳JC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000090', '天健集团', 'TJJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000096', '广聚能源', 'GJNY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000099', '中信海直', 'ZXHZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000100', 'TCL 集团', 'TCL JT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000150', '宜华健康', 'YHJK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000151', '中成股份', 'ZCGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000153', '丰原药业', 'FYYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000155', '川化股份', 'CHGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000156', '华数传媒', 'HSCM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000157', '中联重科', 'ZLZK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000158', '常山北明', 'CSBM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000159', '国际实业', 'GJSY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000166', '申万宏源', 'SWHY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000301', '东方市场', 'DFSC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000333', '美的集团', 'MDJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000338', '潍柴动力', 'WCDL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000400', '许继电气', 'XJDQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000401', '冀东水泥', 'JDSN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000402', '金 融 街', 'J R J', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000403', 'ST生化', 'STSH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000404', '长虹华意', 'CHHY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000407', '胜利股份', 'SLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000408', '藏格控股', 'CGKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000409', '*ST地矿', '*STDK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000410', '沈阳机床', 'SYJC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000411', '英特集团', 'YTJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000413', '东旭光电', 'DXGD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000415', '渤海金控', 'BHJK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000416', '民生控股', 'MSKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000417', '合肥百货', 'HFBH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000418', '小天鹅Ａ', 'XTEＡ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000419', '通程控股', 'TCKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000420', '吉林化纤', 'JLHX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000421', '南京公用', 'NJGY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000422', '*ST宜化', '*STYH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000423', '东阿阿胶', 'DAAJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000425', '徐工机械', 'XGJX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000426', '兴业矿业', 'XYKY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000428', '华天酒店', 'HTJD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000429', '粤高速Ａ', 'YGSＡ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000430', '张家界', 'ZJJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000488', '晨鸣纸业', 'CMZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000498', '山东路桥', 'SDLQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000501', '鄂武商Ａ', 'EWSＡ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000502', '绿景控股', 'LJKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000503', '国新健康', 'GXJK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000504', '南华生物', 'NHSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000505', '京粮控股', 'JLKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000506', '中润资源', 'ZRZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000507', '珠海港', 'ZHG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000509', '华塑控股', 'HSKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000510', '金路集团', 'JLJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000511', '烯碳退', 'XTT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000513', '丽珠集团', 'LZJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000514', '渝 开 发', 'Y K F', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000516', '国际医学', 'GJYX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000517', '荣安地产', 'RADC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000518', '四环生物', 'SHSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000519', '中兵红箭', 'ZBHJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000520', '长航凤凰', 'CHFH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000521', '长虹美菱', 'CHML', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000523', '广州浪奇', 'GZLQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000524', '岭南控股', 'LNKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000525', '红 太 阳', 'H T Y', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000526', '紫光学大', 'ZGXD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000528', '柳    工', 'L    G', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000529', '广弘控股', 'GHKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000530', '大冷股份', 'DLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000531', '穗恒运Ａ', 'SHYＡ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000532', '华金资本', 'HJZB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000533', '万 家 乐', 'W J L', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000534', '万泽股份', 'WZGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000536', '华映科技', 'HYKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000537', '广宇发展', 'GYFZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000538', '云南白药', 'YNBY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000539', '粤电力Ａ', 'YDLＡ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000540', '中天金融', 'ZTJR', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000541', '佛山照明', 'FSZM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000543', '皖能电力', 'WNDL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000544', '中原环保', 'ZYHB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000545', '金浦钛业', 'JP钛Y', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000546', '金圆股份', 'JYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000547', '航天发展', 'HTFZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000548', '湖南投资', 'HNTZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000550', '江铃汽车', 'JLQC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000551', '创元科技', 'CYKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000552', '靖远煤电', 'JYMD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000553', '沙隆达Ａ', 'SLDＡ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000554', '泰山石油', 'TSSY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000555', '神州信息', 'SZXX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000557', '西部创业', 'XBCY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000558', '莱茵体育', 'LYTY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000559', '万向钱潮', 'WXQC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000560', '我爱我家', 'WAWJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000561', '烽火电子', 'FHDZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000562', '宏源证券', 'HYZQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000563', '陕国投Ａ', 'SGTＡ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000564', '供销大集', 'GXDJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000565', '渝三峡Ａ', 'YSXＡ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000566', '海南海药', 'HNHY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000567', '海德股份', 'HDGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000568', '泸州老窖', '泸ZLJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000570', '苏常柴Ａ', 'SCCＡ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000571', '新大洲Ａ', 'XDZＡ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000572', '海马汽车', 'HMQC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000573', '粤宏远Ａ', 'YHYＡ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000576', '广东甘化', 'GDGH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000581', '威孚高科', 'W孚GK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000582', '北部湾港', 'BBWG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000584', '哈工智能', 'HGZN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000585', '*ST东电', '*STDD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000586', '汇源通信', 'HYTX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000587', '金洲慈航', 'JZCH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000589', '黔轮胎Ａ', 'QLTＡ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000590', '启迪古汉', 'QDGH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000591', '太阳能', 'TYN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000592', '平潭发展', 'PTFZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000593', '大通燃气', 'DTRQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000594', '国恒退', 'GHT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000595', '宝塔实业', 'BTSY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000596', '古井贡酒', 'GJGJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000597', '东北制药', 'DBZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000598', '兴蓉环境', 'XRHJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000599', '青岛双星', 'QDSX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000600', '建投能源', 'JTNY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000601', '韶能股份', 'SNGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000603', '盛达矿业', 'SDKY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000605', '渤海股份', 'BHGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000606', '顺利办', 'SLB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000607', '华媒控股', 'HMKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000608', '阳光股份', 'YGGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000609', '中迪投资', 'ZDTZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000610', '西安旅游', 'XALY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000611', '天首发展', 'TSFZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000612', '焦作万方', 'JZWF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000613', '大东海A', 'DDHA', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000615', '京汉股份', 'JHGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000616', '海航投资', 'HHTZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000617', '中油资本', 'ZYZB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000619', '海螺型材', 'HLXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000620', '新华联', 'XHL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000622', '恒立实业', 'HLSY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000623', '吉林敖东', 'JLAD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000625', '长安汽车', 'CAQC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000626', '远大控股', 'YDKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000627', '天茂集团', 'TMJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000628', '高新发展', 'GXFZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000629', '攀钢钒钛', 'PGF钛', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000630', '铜陵有色', 'TLYS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000631', '顺发恒业', 'SFHY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000632', '三木集团', 'SMJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000633', '合金投资', 'HJTZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000635', '英 力 特', 'Y L T', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000636', '风华高科', 'FHGK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000637', '茂化实华', 'MHSH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000638', '万方发展', 'WFFZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000639', '西王食品', 'XWSP', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000650', '仁和药业', 'RHYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000651', '格力电器', 'GLDQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000652', '泰达股份', 'TDGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000655', '*ST金岭', '*STJL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000656', '金科股份', 'JKGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000657', '中钨高新', 'ZWGX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000659', '珠海中富', 'ZHZF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000661', '长春高新', 'CCGX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000662', '天夏智慧', 'TXZH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000663', '永安林业', 'YALY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000665', '湖北广电', 'HBGD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000666', '经纬纺机', 'JWFJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000667', '美好置业', 'MHZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000668', '荣丰控股', 'RFKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000669', '金鸿控股', 'JHKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000670', '盈方微', 'YFW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000671', '阳 光 城', 'Y G C', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000672', '上峰水泥', 'SFSN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000673', '当代东方', 'DDDF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000676', '智度股份', 'ZDGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000677', '恒天海龙', 'HTHL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000678', '襄阳轴承', 'XYZC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000679', '大连友谊', 'DLYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000680', '山推股份', 'STGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000681', '视觉中国', 'SJZG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000682', '东方电子', 'DFDZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000683', '远兴能源', 'YXNY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000685', '中山公用', 'ZSGY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000686', '东北证券', 'DBZQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000687', '华讯方舟', 'HXFZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000688', '国城矿业', 'GCKY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000690', '宝新能源', 'BXNY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000691', '亚太实业', 'YTSY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000692', '惠天热电', 'HTRD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000693', '*ST华泽', '*STHZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000695', '滨海能源', 'BHNY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000697', '炼石有色', 'LSYS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000698', '沈阳化工', 'SYHG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000700', '模塑科技', 'MSKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000701', '厦门信达', 'XMXD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000702', '正虹科技', 'ZHKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000703', '恒逸石化', 'HYSH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000705', '浙江震元', 'ZJZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000707', '*ST双环', '*STSH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000708', '大冶特钢', 'DYTG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000709', '河钢股份', 'HGGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000710', '贝瑞基因', 'BRJY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000711', '京蓝科技', 'JLKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000712', '锦龙股份', 'JLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000713', '丰乐种业', 'FLZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000715', '中兴商业', 'ZXSY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000716', '黑芝麻', 'HZM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000717', '韶钢松山', 'SGSS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000718', '苏宁环球', 'SNHQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000719', '中原传媒', 'ZYCM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000720', '*ST新能', '*STXN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000721', '西安饮食', 'XAYS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000722', '湖南发展', 'HNFZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000723', '美锦能源', 'MJNY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000725', '京东方Ａ', 'JDFＡ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000726', '鲁  泰Ａ', 'L  TＡ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000727', '华东科技', 'HDKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000728', '国元证券', 'GYZQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000729', '燕京啤酒', 'YJPJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000731', '四川美丰', 'SCMF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000732', '泰禾集团', 'THJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000733', '振华科技', 'ZHKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000735', '罗 牛 山', 'L N S', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000736', '中交地产', 'ZJDC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000737', '*ST南风', '*STNF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000738', '航发控制', 'HFKZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000739', '普洛药业', 'PLYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000748', '长城信息', 'CCXX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000750', '国海证券', 'GHZQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000751', '锌业股份', 'XYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000752', '西藏发展', 'XCFZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000753', '漳州发展', 'ZZFZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000755', '*ST三维', '*STSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000756', '新华制药', 'XHZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000757', '浩物股份', 'HWGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000758', '中色股份', 'ZSGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000759', '中百集团', 'ZBJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000760', '斯太尔', 'STE', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000761', '本钢板材', 'BGBC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000762', '西藏矿业', 'XCKY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000766', '通化金马', 'THJM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000767', '漳泽电力', 'ZZDL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000768', '中航飞机', 'ZHFJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000776', '广发证券', 'GFZQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000777', '中核科技', 'ZHKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000778', '新兴铸管', 'XXZG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000779', '三毛派神', 'SMPS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000780', '平庄能源', 'PZNY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000782', '美达股份', 'MDGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000783', '长江证券', 'CJZQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000785', '武汉中商', 'WHZS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000786', '北新建材', 'BXJC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000788', '北大医药', 'BDYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000789', '万年青', 'WNQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000790', '泰合健康', 'THJK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000791', '甘肃电投', 'GSDT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000792', '盐湖股份', 'YHGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000793', '华闻传媒', 'HWCM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000795', '英洛华', 'YLH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000796', '凯撒旅游', 'KSLY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000797', '中国武夷', 'ZGWY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000798', '中水渔业', 'ZSYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000799', '酒鬼酒', 'JGJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000800', '一汽轿车', 'YQJC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000801', '四川九洲', 'SCJZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000802', '北京文化', 'BJWH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000803', '*ST金宇', '*STJY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000806', '银河生物', 'YHSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000807', '云铝股份', 'YLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000809', '铁岭新城', 'TLXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000810', '创维数字', 'CWSZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000811', '冰轮环境', 'BLHJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000812', '陕西金叶', 'SXJY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000813', '德展健康', 'DZJK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000815', '美利云', 'MLY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000816', '*ST慧业', '*STHY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000818', '航锦科技', 'HJKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000819', '岳阳兴长', 'YYXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000820', '神雾节能', 'SWJN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000821', '京山轻机', 'JSQJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000822', '山东海化', 'SDHH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000823', '超声电子', 'CSDZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000825', '太钢不锈', 'TGBX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000826', '启迪桑德', 'QDSD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000828', '东莞控股', 'D莞KG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000829', '天音控股', 'TYKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000830', '鲁西化工', 'LXHG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000831', '五矿稀土', 'WKXT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000833', '粤桂股份', 'YGGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000835', '长城动漫', 'CCDM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000836', '鑫茂科技', '鑫MKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000837', '秦川机床', 'QCJC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000838', '财信发展', 'CXFZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000839', '中信国安', 'ZXGA', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000848', '承德露露', 'CDLL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000850', '华茂股份', 'HMGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000851', '高鸿股份', 'GHGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000852', '石化机械', 'SHJX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000856', '冀东装备', 'JDZB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000858', '五 粮 液', 'W L Y', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000859', '国风塑业', 'GFSY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000860', '顺鑫农业', 'S鑫NY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000861', '海印股份', 'HYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000862', '银星能源', 'YXNY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000863', '三湘印象', 'SXYX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000868', '安凯客车', 'AKKC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000869', '张  裕Ａ', 'Z  YＡ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000875', '吉电股份', 'JDGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000876', '新 希 望', 'X X W', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000877', '天山股份', 'TSGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000878', '云南铜业', 'YNTY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000880', '潍柴重机', 'WCZJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000881', '中广核技', 'ZGHJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000882', '华联股份', 'HLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000883', '湖北能源', 'HBNY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000885', '同力水泥', 'TLSN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000886', '海南高速', 'HNGS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000887', '中鼎股份', 'ZDGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000888', '峨眉山Ａ', 'EMSＡ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000889', '茂业通信', 'MYTX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000890', '法 尔 胜', 'F E S', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000892', '欢瑞世纪', 'HRSJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000893', '*ST东凌', '*STDL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000895', '双汇发展', 'SHFZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000897', '津滨发展', 'JBFZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000898', '鞍钢股份', 'AGGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000899', '赣能股份', 'GNGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000900', '现代投资', 'XDTZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000901', '航天科技', 'HTKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000902', '新洋丰', 'XYF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000903', '云内动力', 'YNDL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000905', '厦门港务', 'XMGW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000906', '浙商中拓', 'ZSZT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000908', '景峰医药', 'JFYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000909', '数源科技', 'SYKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000910', '大亚圣象', 'DYSX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000911', '南宁糖业', 'NNTY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000912', '*ST天化', '*STTH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000913', '钱江摩托', 'QJMT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000915', '山大华特', 'SDHT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000916', '华北高速', 'HBGS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000917', '电广传媒', 'DGCM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000918', '嘉凯城', 'JKC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000919', '金陵药业', 'JLYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000920', '南方汇通', 'NFHT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000921', '海信科龙', 'HXKL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000922', '*ST佳电', '*STJD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000923', '河北宣工', 'HBXG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000925', '众合科技', 'ZHKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000926', '福星股份', 'FXGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000927', '一汽夏利', 'YQXL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000928', '中钢国际', 'ZGGJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000929', '兰州黄河', 'LZHH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000930', '中粮生化', 'ZLSH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000931', '中 关 村', 'Z G C', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000932', '华菱钢铁', 'HLGT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000933', '神火股份', 'SHGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000935', '四川双马', 'SCSM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000936', '华西股份', 'HXGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000937', '冀中能源', 'JZNY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000938', '紫光股份', 'ZGGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000939', '*ST凯迪', '*STKD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000948', '南天信息', 'NTXX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000949', '新乡化纤', 'XXHX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000950', '重药控股', 'ZYKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000951', '中国重汽', 'ZGZQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000952', '广济药业', 'GJYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000953', 'ST河化', 'STHH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000955', '欣龙控股', 'XLKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000957', '中通客车', 'ZTKC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000958', '东方能源', 'DFNY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000959', '首钢股份', 'SGGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000960', '锡业股份', 'XYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000961', '中南建设', 'ZNJS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000962', '东方钽业', 'DF钽Y', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000963', '华东医药', 'HDYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000965', '天保基建', 'TBJJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000966', '长源电力', 'CYDL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000967', '盈峰环境', 'YFHJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000968', '蓝焰控股', 'LYKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000969', '安泰科技', 'ATKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000970', '中科三环', 'ZKSH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000971', '高升控股', 'GSKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000972', '*ST中基', '*STZJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000973', '佛塑科技', 'FSKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000975', '银泰资源', 'YTZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000976', '华铁股份', 'HTGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000977', '浪潮信息', 'LCXX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000978', '桂林旅游', 'GLLY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000979', '中弘股份', 'ZHGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000980', '众泰汽车', 'ZTQC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000981', '银亿股份', 'YYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000982', '*ST 中绒', '*ST ZR', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000983', '西山煤电', 'XSMD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000985', '大庆华科', 'DQHK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000987', '越秀金控', 'YXJK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000988', '华工科技', 'HGKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000989', '九 芝 堂', 'J Z T', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000990', '诚志股份', 'CZGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000993', '闽东电力', 'MDDL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000995', '*ST皇台', '*STHT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000996', '中国中期', 'ZGZQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000997', '新 大 陆', 'X D L', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000998', '隆平高科', 'LPGK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('000999', '华润三九', 'HRSJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('001696', '宗申动力', 'ZSDL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('001896', '豫能控股', 'YNKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('001965', '招商公路', 'ZSGL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('001979', '招商蛇口', 'ZSSK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002001', '新 和 成', 'X H C', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002002', '鸿达兴业', 'HDXY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002003', '伟星股份', 'WXGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002004', '华邦健康', 'HBJK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002005', '德豪润达', 'DHRD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002006', '精功科技', 'JGKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002007', '华兰生物', 'HLSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002008', '大族激光', 'DZJG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002009', '天奇股份', 'TQGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002010', '传化智联', 'CHZL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002011', '盾安环境', 'DAHJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002012', '凯恩股份', 'KEGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002013', '中航机电', 'ZHJD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002014', '永新股份', 'YXGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002015', '霞客环保', 'XKHB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002016', '世荣兆业', 'SRZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002017', '东信和平', 'DXHP', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002018', '*ST华信', '*STHX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002019', '亿帆医药', 'YFYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002020', '京新药业', 'JXYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002021', '中捷资源', 'ZJZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002022', '科华生物', 'KHSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002023', '海特高新', 'HTGX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002024', '苏宁易购', 'SNYG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002025', '航天电器', 'HTDQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002026', '山东威达', 'SDWD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002027', '分众传媒', 'FZCM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002028', '思源电气', 'SYDQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002029', '七 匹 狼', 'Q P L', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002030', '达安基因', 'DAJY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002031', '巨轮智能', 'JLZN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002032', '苏 泊 尔', 'S B E', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002033', '丽江旅游', 'LJLY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002034', '旺能环境', 'WNHJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002035', '华帝股份', 'HDGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002036', '联创电子', 'LCDZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002037', '久联发展', 'JLFZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002038', '双鹭药业', 'S鹭YY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002039', '黔源电力', 'QYDL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002040', '南 京 港', 'N J G', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002041', '登海种业', 'DHZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002042', '华孚时尚', 'H孚SS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002043', '兔 宝 宝', 'T B B', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002044', '美年健康', 'MNJK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002045', '国光电器', 'GGDQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002046', '轴研科技', 'ZYKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002047', '宝鹰股份', 'BYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002048', '宁波华翔', 'NBHX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002049', '紫光国微', 'ZGGW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002050', '三花智控', 'SHZK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002051', '中工国际', 'ZGGJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002052', '同洲电子', 'TZDZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002053', '云南能投', 'YNNT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002054', '德美化工', 'DMHG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002055', '得润电子', 'DRDZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002056', '横店东磁', 'HDDC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002057', '中钢天源', 'ZGTY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002058', '威 尔 泰', 'W E T', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002059', '云南旅游', 'YNLY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002060', '粤 水 电', 'Y S D', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002061', '浙江交科', 'ZJJK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002062', '宏润建设', 'HRJS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002063', '远光软件', 'YGRJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002064', '华峰氨纶', 'HFAL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002065', '东华软件', 'DHRJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002066', '瑞泰科技', 'RTKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002067', '景兴纸业', 'JXZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002068', '黑猫股份', 'HMGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002069', '獐子岛', '獐ZD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002070', '*ST众和', '*STZH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002071', '长城影视', 'CCYS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002072', '凯瑞德', 'KRD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002073', '软控股份', 'RKGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002074', '国轩高科', 'GXGK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002075', '沙钢股份', 'SGGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002076', '雪 莱 特', 'X L T', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002077', '大港股份', 'DGGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002078', '太阳纸业', 'TYZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002079', '苏州固锝', 'SZG锝', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002080', '中材科技', 'ZCKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002081', '金 螳 螂', 'J 螳 螂', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002082', '万邦德', 'WBD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002083', '孚日股份', '孚RGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002084', '海鸥住工', 'HOZG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002085', '万丰奥威', 'WFAW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002086', '东方海洋', 'DFHY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002087', '新野纺织', 'XYFZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002088', '鲁阳节能', 'LYJN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002089', '新 海 宜', 'X H Y', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002090', '金智科技', 'JZKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002091', '江苏国泰', 'JSGT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002092', '中泰化学', 'ZTHX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002093', '国脉科技', 'GMKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002094', '青岛金王', 'QDJW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002095', '生 意 宝', 'S Y B', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002096', '南岭民爆', 'NLMB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002097', '山河智能', 'SHZN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002098', '浔兴股份', '浔XGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002099', '海翔药业', 'HXYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002100', '天康生物', 'TKSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002101', '广东鸿图', 'GDHT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002102', '冠福股份', 'GFGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002103', '广博股份', 'GBGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002104', '恒宝股份', 'HBGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002105', '信隆健康', 'XLJK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002106', '莱宝高科', 'LBGK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002107', '沃华医药', 'WHYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002108', '沧州明珠', 'CZMZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002109', '兴化股份', 'XHGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002110', '三钢闽光', 'SGMG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002111', '威海广泰', 'WHGT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002112', '三变科技', 'SBKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002113', '天润数娱', 'TRSY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002114', '罗平锌电', 'LPXD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002115', '三维通信', 'SWTX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002116', '中国海诚', 'ZGHC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002117', '东港股份', 'DGGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002118', '紫鑫药业', 'Z鑫YY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002119', '康强电子', 'KQDZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002120', '韵达股份', 'YDGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002121', '科陆电子', 'KLDZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002122', '*ST天马', '*STTM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002123', '梦网集团', 'MWJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002124', '天邦股份', 'TBGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002125', '湘潭电化', 'XTDH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002126', '银轮股份', 'YLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002127', '南极电商', 'NJDS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002128', '露天煤业', 'LTMY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002129', '中环股份', 'ZHGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002130', '沃尔核材', 'WEHC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002131', '利欧股份', 'LOGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002132', '恒星科技', 'HXKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002133', '广宇集团', 'GYJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002134', '天津普林', 'TJPL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002135', '东南网架', 'DNWJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002136', '安 纳 达', 'A N D', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002137', '麦达数字', 'MDSZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002138', '顺络电子', 'SLDZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002139', '拓邦股份', 'TBGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002140', '东华科技', 'DHKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002141', '贤丰控股', 'XFKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002142', '宁波银行', 'NBYX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002143', '印纪传媒', 'YJCM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002144', '宏达高科', 'HDGK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002145', '中核钛白', 'ZH钛B', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002146', '荣盛发展', 'RSFZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002147', '新光圆成', 'XGYC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002148', '北纬科技', 'BWKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002149', '西部材料', 'XBCL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002150', '通润装备', 'TRZB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002151', '北斗星通', 'BDXT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002152', '广电运通', 'GDYT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002153', '石基信息', 'SJXX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002154', '报 喜 鸟', 'B X N', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002155', '湖南黄金', 'HNHJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002156', '通富微电', 'TFWD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002157', '正邦科技', 'ZBKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002158', '汉钟精机', 'HZJJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002159', '三特索道', 'STSD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002160', '常铝股份', 'CLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002161', '远 望 谷', 'Y W G', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002162', '悦心健康', 'YXJK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002163', '中航三鑫', 'ZHS鑫', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002164', '宁波东力', 'NBDL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002165', '红 宝 丽', 'H B L', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002166', '莱茵生物', 'LYSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002167', '东方锆业', 'DF锆Y', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002168', '深圳惠程', 'S圳HC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002169', '智光电气', 'ZGDQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002170', '芭田股份', 'BTGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002171', '楚江新材', 'CJXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002172', '澳洋健康', 'AYJK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002173', '创新医疗', 'CXYL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002174', '游族网络', 'YZWL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002175', '东方网络', 'DFWL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002176', '江特电机', 'JTDJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002177', '御银股份', 'YYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002178', '延华智能', 'YHZN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002179', '中航光电', 'ZHGD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002180', '纳思达', 'NSD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002181', '粤 传 媒', 'Y C M', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002182', '云海金属', 'YHJS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002183', '怡 亚 通', '怡 Y T', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002184', '海得控制', 'HDKZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002185', '华天科技', 'HTKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002186', '全 聚 德', 'Q J D', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002187', '广百股份', 'GBGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002188', '*ST巴士', '*STBS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002189', '利达光电', 'LDGD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002190', '成飞集成', 'CFJC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002191', '劲嘉股份', 'JJGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002192', '融捷股份', 'RJGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002193', '如意集团', 'RYJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002194', '*ST凡谷', '*STFG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002195', '二三四五', 'ESSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002196', '方正电机', 'FZDJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002197', '证通电子', 'ZTDZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002198', '嘉应制药', 'JYZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002199', '东晶电子', 'DJDZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002200', '云投生态', 'YTST', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002201', '九鼎新材', 'JDXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002202', '金风科技', 'JFKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002203', '海亮股份', 'HLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002204', '大连重工', 'DLZG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002205', '国统股份', 'GTGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002206', '海 利 得', 'H L D', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002207', 'ST准油', 'STZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002208', '合肥城建', 'HFCJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002209', '达 意 隆', 'D Y L', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002210', '飞马国际', 'FMGJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002211', '宏达新材', 'HDXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002212', '南洋股份', 'NYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002213', '特 尔 佳', 'T E J', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002214', '大立科技', 'DLKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002215', '诺 普 信', 'N P X', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002216', '三全食品', 'SQSP', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002217', '合力泰', 'HLT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002218', '拓日新能', 'TRXN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002219', '恒康医疗', 'HKYL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002220', '天宝食品', 'TBSP', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002221', '东华能源', 'DHNY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002222', '福晶科技', 'FJKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002223', '鱼跃医疗', 'YYYL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002224', '三 力 士', 'S L S', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002225', '濮耐股份', '濮NGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002226', '江南化工', 'JNHG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002227', '奥 特 迅', 'A T X', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002228', '合兴包装', 'HXBZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002229', '鸿博股份', 'HBGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002230', '科大讯飞', 'KDXF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002231', '奥维通信', 'AWTX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002232', '启明信息', 'QMXX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002233', '塔牌集团', 'TPJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002234', '民和股份', 'MHGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002235', '安妮股份', 'ANGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002236', '大华股份', 'DHGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002237', '恒邦股份', 'HBGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002238', '天威视讯', 'TWSX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002239', '奥特佳', 'ATJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002240', '威华股份', 'WHGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002241', '歌尔股份', 'GEGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002242', '九阳股份', 'JYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002243', '通产丽星', 'TCLX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002244', '滨江集团', 'BJJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002245', '澳洋顺昌', 'AYSC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002246', '北化股份', 'BHGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002247', '帝龙文化', 'DLWH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002248', '华东数控', 'HDSK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002249', '大洋电机', 'DYDJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002250', '联化科技', 'LHKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002251', '步 步 高', 'B B G', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002252', '上海莱士', 'SHLS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002253', '川大智胜', 'CDZS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002254', '泰和新材', 'THXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002255', '海陆重工', 'HLZG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002256', '兆新股份', 'ZXGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002258', '利尔化学', 'LEHX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002259', '升达林业', 'SDLY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002260', '*ST德奥', '*STDA', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002261', '拓维信息', 'TWXX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002262', '恩华药业', 'EHYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002263', '*ST东南', '*STDN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002264', '新 华 都', 'X H D', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002265', '西仪股份', 'XYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002266', '浙富控股', 'ZFKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002267', '陕天然气', 'STRQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002268', '卫 士 通', 'W S T', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002269', '美邦服饰', 'MBFS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002270', '华明装备', 'HMZB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002271', '东方雨虹', 'DFYH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002272', '川润股份', 'CRGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002273', '水晶光电', 'SJGD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002274', '华昌化工', 'HCHG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002275', '桂林三金', 'GLSJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002276', '万马股份', 'WMGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002277', '友阿股份', 'YAGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002278', '神开股份', 'SKGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002279', '久其软件', 'JQRJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002280', '联络互动', 'LLHD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002281', '光迅科技', 'GXKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002282', '博深工具', 'BSGJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002283', '天润曲轴', 'TRQZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002284', '亚太股份', 'YTGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002285', '世联行', 'SLX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002286', '保龄宝', 'BLB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002287', '奇正藏药', 'QZCY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002288', '超华科技', 'CHKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002289', '宇顺电子', 'YSDZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002290', '中科新材', 'ZKXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002291', '星期六', 'XQL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002292', '奥飞娱乐', 'AFYL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002293', '罗莱生活', 'LLSH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002294', '信立泰', 'XLT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002295', '精艺股份', 'JYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002296', '辉煌科技', 'HHKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002297', '博云新材', 'BYXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002298', '中电兴发', 'ZDXF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002299', '圣农发展', 'SNFZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002300', '太阳电缆', 'TYDL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002301', '齐心集团', 'QXJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002302', '西部建设', 'XBJS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002303', '美盈森', 'MYS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002304', '洋河股份', 'YHGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002305', '南国置业', 'NGZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002306', '*ST云网', '*STYW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002307', '北新路桥', 'BXLQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002308', '威创股份', 'WCGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002309', '中利集团', 'ZLJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002310', '东方园林', 'DFYL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002311', '海大集团', 'HDJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002312', '三泰控股', 'STKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002313', '日海智能', 'RHZN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002314', '南山控股', 'NSKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002315', '焦点科技', 'JDKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002316', '亚联发展', 'YLFZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002317', '众生药业', 'ZSYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002318', '久立特材', 'JLTC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002319', '乐通股份', 'LTGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002320', '海峡股份', 'HXGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002321', '华英农业', 'HYNY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002322', '理工环科', 'LGHK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002323', '*ST百特', '*STBT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002324', '普利特', 'PLT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002325', '洪涛股份', 'HTGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002326', '永太科技', 'YTKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002327', '富安娜', 'FAN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002328', '新朋股份', 'XPGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002329', '皇氏集团', 'HSJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002330', '得利斯', 'DLS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002331', '皖通科技', 'WTKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002332', '仙琚制药', 'X琚ZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002333', '罗普斯金', 'LPSJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002334', '英威腾', 'YWT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002335', '科华恒盛', 'KHHS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002336', '人人乐', 'RRL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002337', '赛象科技', 'SXKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002338', '奥普光电', 'APGD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002339', '积成电子', 'JCDZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002340', '格林美', 'GLM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002341', '新纶科技', 'XLKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002342', '巨力索具', 'JLSJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002343', '慈文传媒', 'CWCM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002344', '海宁皮城', 'HNPC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002345', '潮宏基', 'CHJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002346', '柘中股份', '柘ZGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002347', '泰尔股份', 'TEGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002348', '高乐股份', 'GLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002349', '精华制药', 'JHZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002350', '北京科锐', 'BJKR', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002351', '漫步者', 'MBZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002352', '顺丰控股', 'SFKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002353', '杰瑞股份', 'JRGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002354', '天神娱乐', 'TSYL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002355', '兴民智通', 'XMZT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002356', '赫美集团', 'HMJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002357', '富临运业', 'FLYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002358', '森源电气', 'SYDQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002359', '北讯集团', 'BXJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002360', '同德化工', 'TDHG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002361', '神剑股份', 'SJGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002362', '汉王科技', 'HWKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002363', '隆基机械', 'LJJX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002364', '中恒电气', 'ZHDQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002365', '永安药业', 'YAYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002366', '台海核电', 'THHD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002367', '康力电梯', 'KLDT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002368', '太极股份', 'TJGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002369', '卓翼科技', 'ZYKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002370', '亚太药业', 'YTYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002371', '北方华创', 'BFHC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002372', '伟星新材', 'WXXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002373', '千方科技', 'QFKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002374', '丽鹏股份', 'LPGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002375', '亚厦股份', 'YXGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002376', '新北洋', 'XBY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002377', '国创高新', 'GCGX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002378', '章源钨业', 'ZYWY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002379', '宏创控股', 'HCKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002380', '科远股份', 'KYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002381', '双箭股份', 'SJGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002382', '蓝帆医疗', 'LFYL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002383', '合众思壮', 'HZSZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002384', '东山精密', 'DSJM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002385', '大北农', 'DBN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002386', '天原集团', 'TYJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002387', '维信诺', 'WXN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002388', '新亚制程', 'XYZC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002389', '南洋科技', 'NYKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002390', '信邦制药', 'XBZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002391', '长青股份', 'CQGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002392', '北京利尔', 'BJLE', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002393', '力生制药', 'LSZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002394', '联发股份', 'LFGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002395', '双象股份', 'SXGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002396', '星网锐捷', 'XWRJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002397', '梦洁股份', 'MJGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002398', '建研集团', 'JYJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002399', '海普瑞', 'HPR', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002400', '省广集团', 'SGJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002401', '中远海科', 'ZYHK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002402', '和而泰', 'HET', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002403', '爱仕达', 'ASD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002404', '嘉欣丝绸', 'JXSC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002405', '四维图新', 'SWTX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002406', '远东传动', 'YDCD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002407', '多氟多', 'DFD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002408', '齐翔腾达', 'QXTD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002409', '雅克科技', 'YKKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002410', '广联达', 'GLD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002411', '必康股份', 'BKGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002412', '汉森制药', 'HSZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002413', '雷科防务', 'LKFW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002414', '高德红外', 'GDHW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002415', '海康威视', 'HKWS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002416', '爱施德', 'ASD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002417', '深南股份', 'SNGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002418', '康盛股份', 'KSGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002419', '天虹股份', 'THGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002420', '毅昌股份', 'YCGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002421', '达实智能', 'DSZN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002422', '科伦药业', 'KLYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002423', '中原特钢', 'ZYTG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002424', '贵州百灵', 'GZBL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002425', '凯撒文化', 'KSWH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002426', '胜利精密', 'SLJM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002427', '*ST尤夫', '*STYF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002428', '云南锗业', 'YNZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002429', '兆驰股份', 'ZCGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002430', '杭氧股份', 'HYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002431', '棕榈股份', 'Z榈GF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002432', '九安医疗', 'JAYL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002433', '太安堂', 'TAT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002434', '万里扬', 'WLY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002435', '长江润发', 'CJRF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002436', '兴森科技', 'XSKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002437', '誉衡药业', 'YHYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002438', '江苏神通', 'JSST', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002439', '启明星辰', 'QMXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002440', '闰土股份', 'RTGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002441', '众业达', 'ZYD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002442', '龙星化工', 'LXHG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002443', '金洲管道', 'JZGD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002444', '巨星科技', 'JXKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002445', '中南文化', 'ZNWH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002446', '盛路通信', 'SLTX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002447', '晨鑫科技', 'C鑫KJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002448', '中原内配', 'ZYNP', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002449', '国星光电', 'GXGD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002450', '康得新', 'KDX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002451', '摩恩电气', 'MEDQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002452', '长高集团', 'CGJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002453', '华软科技', 'HRKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002454', '松芝股份', 'SZGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002455', '百川股份', 'BCGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002456', '欧菲科技', 'OFKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002457', '青龙管业', 'QLGY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002458', '益生股份', 'YSGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002459', '天业通联', 'TYTL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002460', '赣锋锂业', 'GF锂Y', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002461', '珠江啤酒', 'ZJPJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002462', '嘉事堂', 'JST', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002463', '沪电股份', 'HDGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002464', '众应互联', 'ZYHL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002465', '海格通信', 'HGTX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002466', '天齐锂业', 'TQ锂Y', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002467', '二六三', 'ELS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002468', '申通快递', 'STKD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002469', '三维工程', 'SWGC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002470', '金正大', 'JZD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002471', '中超控股', 'ZCKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002472', '双环传动', 'SHCD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002473', '*ST圣莱', '*STSL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002474', '榕基软件', '榕JRJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002475', '立讯精密', 'LXJM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002476', '宝莫股份', 'BMGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002477', '雏鹰农牧', 'CYNM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002478', '常宝股份', 'CBGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002479', '富春环保', 'FCHB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002480', '新筑股份', 'XZGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002481', '双塔食品', 'STSP', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002482', '广田集团', 'GTJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002483', '润邦股份', 'RBGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002484', '江海股份', 'JHGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002485', '希努尔', 'XNE', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002486', '嘉麟杰', 'J麟J', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002487', '大金重工', 'DJZG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002488', '金固股份', 'JGGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002489', '浙江永强', 'ZJYQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002490', '山东墨龙', 'SDML', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002491', '通鼎互联', 'TDHL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002492', '恒基达鑫', 'HJD鑫', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002493', '荣盛石化', 'RSSH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002494', '华斯股份', 'HSGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002495', '佳隆股份', 'JLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002496', 'ST辉丰', 'STHF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002497', '雅化集团', 'YHJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002498', '汉缆股份', 'HLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002499', '科林环保', 'KLHB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002500', '山西证券', 'SXZQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002501', '利源精制', 'LYJZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002502', '骅威文化', '骅WWH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002503', '搜于特', 'SYT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002504', '弘高创意', 'HGCY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002505', '大康农业', 'DKNY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002506', '协鑫集成', 'X鑫JC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002507', '涪陵榨菜', 'FLZC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002508', '老板电器', 'LBDQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002509', '天广中茂', 'TGZM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002510', '天汽模', 'TQM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002511', '中顺洁柔', 'ZSJR', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002512', '达华智能', 'DHZN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002513', '蓝丰生化', 'LFSH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002514', '宝馨科技', 'B馨KJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002515', '金字火腿', 'JZHT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002516', '旷达科技', 'KDKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002517', '恺英网络', '恺YWL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002518', '科士达', 'KSD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002519', '银河电子', 'YHDZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002520', '日发精机', 'RFJJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002521', '齐峰新材', 'QFXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002522', '浙江众成', 'ZJZC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002523', '天桥起重', 'TQQZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002524', '光正集团', 'GZJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002526', '山东矿机', 'SDKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002527', '新时达', 'XSD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002528', '英飞拓', 'YFT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002529', '海源复材', 'HYFC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002530', '金财互联', 'JCHL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002531', '天顺风能', 'TSFN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002532', '新界泵业', 'XJBY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002533', '金杯电工', 'JBDG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002534', '杭锅股份', 'HGGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002535', '林州重机', 'LZZJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002536', '西泵股份', 'XBGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002537', '海联金汇', 'HLJH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002538', '司尔特', 'SET', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002539', '云图控股', 'YTKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002540', '亚太科技', 'YTKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002541', '鸿路钢构', 'HLGG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002542', '中化岩土', 'ZHYT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002543', '万和电气', 'WHDQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002544', '杰赛科技', 'JSKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002545', '东方铁塔', 'DFTT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002546', '新联电子', 'XLDZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002547', '春兴精工', 'CXJG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002548', '金新农', 'JXN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002549', '凯美特气', 'KMTQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002550', '千红制药', 'QHZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002551', '尚荣医疗', 'SRYL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002552', '*ST宝鼎', '*STBD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002553', '南方轴承', 'NFZC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002554', '惠博普', 'HBP', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002555', '三七互娱', 'SQHY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002556', '辉隆股份', 'HLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002557', '洽洽食品', 'QQSP', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002558', '巨人网络', 'JRWL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002559', '亚威股份', 'YWGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002560', '通达股份', 'TDGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002561', '徐家汇', 'XJH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002562', '兄弟科技', 'XDKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002563', '森马服饰', 'SMFS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002564', '天沃科技', 'TWKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002565', '顺灏股份', 'S灏GF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002566', '益盛药业', 'YSYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002567', '唐人神', 'TRS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002568', '百润股份', 'BRGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002569', '步森股份', 'BSGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002570', '*ST因美', '*STYM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002571', '德力股份', 'DLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002572', '索菲亚', 'SFY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002573', '清新环境', 'QXHJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002574', '明牌珠宝', 'MPZB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002575', '群兴玩具', 'QXWJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002576', '通达动力', 'TDDL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002577', '雷柏科技', 'LBKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002578', '闽发铝业', 'MFLY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002579', '中京电子', 'ZJDZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002580', '圣阳股份', 'SYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002581', '未名医药', 'WMYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002582', '好想你', 'HXN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002583', '海能达', 'HND', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002584', '西陇科学', 'XLKX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002585', '双星新材', 'SXXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002586', '围海股份', 'WHGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002587', '奥拓电子', 'ATDZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002588', '史丹利', 'SDL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002589', '瑞康医药', 'RKYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002590', '万安科技', 'WAKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002591', '恒大高新', 'HDGX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002592', '八菱科技', 'BLKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002593', '日上集团', 'RSJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002594', '比亚迪', 'BYD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002595', '豪迈科技', 'HMKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002596', '海南瑞泽', 'HNRZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002597', '金禾实业', 'JHSY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002598', '山东章鼓', 'SDZG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002599', '盛通股份', 'STGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002600', '领益智造', 'LYZZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002601', '龙蟒佰利', 'L蟒BL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002602', '世纪华通', 'SJHT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002603', '以岭药业', 'YLYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002604', '*ST龙力', '*STLL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002605', '姚记扑克', 'YJPK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002606', '大连电瓷', 'DLDC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002607', '亚夏汽车', 'YXQC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002608', '江苏国信', 'JSGX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002609', '捷顺科技', 'JSKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002610', '爱康科技', 'AKKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002611', '东方精工', 'DFJG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002612', '朗姿股份', 'LZGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002613', '北玻股份', 'BBGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002614', '奥佳华', 'AJH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002615', '哈尔斯', 'HES', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002616', '长青集团', 'CQJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002617', '露笑科技', 'LXKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002618', '丹邦科技', 'DBKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002619', '艾格拉斯', 'AGLS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002620', '瑞和股份', 'RHGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002621', '三垒股份', 'SLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002622', '融钰集团', 'R钰JT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002623', '亚玛顿', 'YMD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002624', '完美世界', 'WMSJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002625', '光启技术', 'GQJS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002626', '金达威', 'JDW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002627', '宜昌交运', 'YCJY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002628', '成都路桥', 'CDLQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002629', '仁智股份', 'RZGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002630', '华西能源', 'HXNY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002631', '德尔未来', 'DEWL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002632', '道明光学', 'DMGX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002633', '申科股份', 'SKGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002634', '棒杰股份', 'BJGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002635', '安洁科技', 'AJKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002636', '金安国纪', 'JAGJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002637', '赞宇科技', 'ZYKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002638', '勤上股份', 'QSGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002639', '雪人股份', 'XRGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002640', '跨境通', 'KJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002641', '永高股份', 'YGGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002642', '荣之联', 'RZL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002643', '万润股份', 'WRGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002644', '佛慈制药', 'FCZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002645', '华宏科技', 'HHKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002646', '青青稞酒', 'QQ稞J', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002647', '仁东控股', 'RDKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002648', '卫星石化', 'WXSH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002649', '博彦科技', 'BYKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002650', '加加食品', 'JJSP', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002651', '利君股份', 'LJGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002652', '扬子新材', 'YZXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002653', '海思科', 'HSK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002654', '万润科技', 'WRKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002655', '共达电声', 'GDDS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002656', '摩登大道', 'MDDD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002657', '中科金财', 'ZKJC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002658', '雪迪龙', 'XDL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002659', '凯文教育', 'KWJY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002660', '茂硕电源', 'MSDY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002661', '克明面业', 'KMMY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002662', '京威股份', 'JWGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002663', '普邦股份', 'PBGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002664', '长鹰信质', 'CYXZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002665', '首航节能', 'SHJN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002666', '德联集团', 'DLJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002667', '鞍重股份', 'AZGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002668', '奥马电器', 'AMDQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002669', '康达新材', 'KDXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002670', '国盛金控', 'GSJK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002671', '龙泉股份', 'LQGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002672', '东江环保', 'DJHB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002673', '西部证券', 'XBZQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002674', '兴业科技', 'XYKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002675', '东诚药业', 'DCYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002676', '顺威股份', 'SWGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002677', '浙江美大', 'ZJMD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002678', '珠江钢琴', 'ZJGQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002679', '福建金森', 'FJJS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002680', 'ST长生', 'STCS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002681', '奋达科技', 'FDKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002682', '龙洲股份', 'LZGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002683', '宏大爆破', 'HDBP', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002684', '猛狮科技', 'MSKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002685', '华东重机', 'HDZJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002686', '亿利达', 'YLD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002687', '乔治白', 'QZB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002688', '金河生物', 'JHSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002689', '远大智能', 'YDZN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002690', '美亚光电', 'MYGD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002691', '冀凯股份', 'JKGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002692', '睿康股份', '睿KGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002693', '双成药业', 'SCYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002694', '顾地科技', 'GDKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002695', '煌上煌', 'HSH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002696', '百洋股份', 'BYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002697', '红旗连锁', 'HQLS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002698', '博实股份', 'BSGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002699', '美盛文化', 'MSWH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002700', '新疆浩源', 'XJHY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002701', '奥瑞金', 'ARJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002702', '海欣食品', 'HXSP', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002703', '浙江世宝', 'ZJSB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002705', '新宝股份', 'XBGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002706', '良信电器', 'LXDQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002707', '众信旅游', 'ZXLY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002708', '光洋股份', 'GYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002709', '天赐材料', 'TCCL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002711', '欧浦智网', 'OPZW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002712', '思美传媒', 'SMCM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002713', '东易日盛', 'DYRS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002714', '牧原股份', 'MYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002715', '登云股份', 'DYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002716', '金贵银业', 'JGYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002717', '岭南股份', 'LNGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002718', '友邦吊顶', 'YBDD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002719', '麦趣尔', 'MQE', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002721', '金一文化', 'JYWH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002722', '金轮股份', 'JLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002723', '金莱特', 'JLT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002724', '海洋王', 'HYW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002725', '跃岭股份', 'YLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002726', '龙大肉食', 'LDRS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002727', '一心堂', 'YXT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002728', '特一药业', 'TYYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002729', '好利来', 'HLL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002730', '电光科技', 'DGKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002731', '萃华珠宝', '萃HZB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002732', '燕塘乳业', 'YTRY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002733', '雄韬股份', 'X韬GF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002734', '利民股份', 'LMGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002735', '王子新材', 'WZXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002736', '国信证券', 'GXZQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002737', '葵花药业', 'KHYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002738', '中矿资源', 'ZKZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002739', '万达电影', 'WDDY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002740', '爱迪尔', 'ADE', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002741', '光华科技', 'GHKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002742', '三圣股份', 'SSGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002743', '富煌钢构', 'FHGG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002745', '木林森', 'MLS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002746', '仙坛股份', 'XTGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002747', '埃斯顿', 'ASD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002748', '世龙实业', 'SLSY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002749', '国光股份', 'GGGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002750', '龙津药业', 'LJYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002751', '易尚展示', 'YSZS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002752', '昇兴股份', '昇XGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002753', '永东股份', 'YDGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002755', '东方新星', 'DFXX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002756', '永兴特钢', 'YXTG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002757', '南兴装备', 'NXZB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002758', '华通医药', 'HTYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002759', '天际股份', 'TJGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002760', '凤形股份', 'FXGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002761', '多喜爱', 'DXA', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002762', '金发拉比', 'JFLB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002763', '汇洁股份', 'HJGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002765', '蓝黛传动', 'L黛CD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002766', '索菱股份', 'SLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002767', '先锋电子', 'XFDZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002768', '国恩股份', 'GEGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002769', '普路通', 'PLT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002770', '科迪乳业', 'KDRY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002771', '真视通', 'ZST', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002772', '众兴菌业', 'ZXJY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002773', '康弘药业', 'KHYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002774', '快意电梯', 'KYDT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002775', '文科园林', 'WKYL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002776', '柏堡龙', 'BBL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002777', '久远银海', 'JYYH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002778', '高科石化', 'GKSH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002779', '中坚科技', 'ZJKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002780', '三夫户外', 'SFHW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002781', '奇信股份', 'QXGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002782', '可立克', 'KLK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002783', '凯龙股份', 'KLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002785', '万里石', 'WLS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002786', '银宝山新', 'YBSX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002787', '华源控股', 'HYKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002788', '鹭燕医药', '鹭YYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002789', '建艺集团', 'JYJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002790', '瑞尔特', 'RET', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002791', '坚朗五金', 'JLWJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002792', '通宇通讯', 'TYTX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002793', '东音股份', 'DYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002795', '永和智控', 'YHZK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002796', '世嘉科技', 'SJKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002797', '第一创业', 'DYCY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002798', '帝欧家居', 'DOJJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002799', '环球印务', 'HQYW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002800', '天顺股份', 'TSGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002801', '微光股份', 'WGGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002802', '洪汇新材', 'HHXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002803', '吉宏股份', 'JHGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002805', '丰元股份', 'FYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002806', '华锋股份', 'HFGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002807', '江阴银行', 'JYYX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002808', '苏州恒久', 'SZHJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002809', '红墙股份', 'HQGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002810', '山东赫达', 'SDHD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002811', '亚泰国际', 'YTGJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002812', '创新股份', 'CXGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002813', '路畅科技', 'LCKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002815', '崇达技术', 'CDJS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002816', '和科达', 'HKD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002817', '黄山胶囊', 'HSJN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002818', '富森美', 'FSM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002819', '东方中科', 'DFZK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002820', '桂发祥', 'GFX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002821', '凯莱英', 'KLY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002822', '中装建设', 'ZZJS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002823', '凯中精密', 'KZJM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002824', '和胜股份', 'HSGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002825', '纳尔股份', 'NEGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002826', '易明医药', 'YMYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002827', '高争民爆', 'GZMB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002828', '贝肯能源', 'BKNY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002829', '星网宇达', 'XWYD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002830', '名雕股份', 'MDGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002831', '裕同科技', 'YTKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002832', '比音勒芬', 'BYLF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002833', '弘亚数控', 'HYSK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002835', '同为股份', 'TWGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002836', '新宏泽', 'XHZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002837', '英维克', 'YWK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002838', '道恩股份', 'DEGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002839', '张家港行', 'ZJGX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002840', '华统股份', 'HTGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002841', '视源股份', 'SYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002842', '翔鹭钨业', 'X鹭WY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002843', '泰嘉股份', 'TJGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002845', '同兴达', 'TXD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002846', '英联股份', 'YLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002847', '盐津铺子', 'YJPZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002848', '高斯贝尔', 'GSBE', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002849', '威星智能', 'WXZN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002850', '科达利', 'KDL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002851', '麦格米特', 'MGMT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002852', '道道全', 'DDQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002853', '皮阿诺', 'PAN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002855', '捷荣技术', 'JRJS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002856', '美芝股份', 'MZGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002857', '三晖电气', 'S晖DQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002858', '力盛赛车', 'LSSC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002859', '洁美科技', 'JMKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002860', '星帅尔', 'XSE', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002861', '瀛通通讯', '瀛TTX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002862', '实丰文化', 'SFWH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002863', '今飞凯达', 'JFKD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002864', '盘龙药业', 'PLYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002865', '钧达股份', 'JDGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002866', '传艺科技', 'CYKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002867', '周大生', 'ZDS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002868', '绿康生化', 'LKSH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002869', '金溢科技', 'JYKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002870', '香山股份', 'XSGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002871', '伟隆股份', 'WLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002872', '天圣制药', 'TSZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002873', '新天药业', 'XTYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002875', '安奈儿', 'ANE', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002876', '三利谱', 'SLP', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002877', '智能自控', 'ZNZK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002878', '元隆雅图', 'YLYT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002879', '长缆科技', 'CLKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002880', '卫光生物', 'WGSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002881', '美格智能', 'MGZN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002882', '金龙羽', 'JLY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002883', '中设股份', 'ZSGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002884', '凌霄泵业', 'LXBY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002885', '京泉华', 'JQH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002886', '沃特股份', 'WTGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002887', '绿茵生态', 'LYST', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002888', '惠威科技', 'HWKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002889', '东方嘉盛', 'DFJS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002890', '弘宇股份', 'HYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002891', '中宠股份', 'ZCGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002892', '科力尔', 'KLE', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002893', '华通热力', 'HTRL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002895', '川恒股份', 'CHGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002896', '中大力德', 'ZDLD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002897', '意华股份', 'YHGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002898', '赛隆药业', 'SLYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002899', '英派斯', 'YPS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002900', '哈三联', 'HSL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002901', '大博医疗', 'DBYL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002902', '铭普光磁', 'MPGC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002903', '宇环数控', 'YHSK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002905', '金逸影视', 'JYYS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002906', '华阳集团', 'HYJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002907', '华森制药', 'HSZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002908', '德生科技', 'DSKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002909', '集泰股份', 'JTGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002910', '庄园牧场', 'ZYMC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002911', '佛燃股份', 'FRGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002912', '中新赛克', 'ZXSK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002913', '奥士康', 'ASK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002915', '中欣氟材', 'ZXFC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002916', '深南电路', 'SNDL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002917', '金奥博', 'JAB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002918', '蒙娜丽莎', 'MNLS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002919', '名臣健康', 'MCJK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002920', '德赛西威', 'DSXW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002921', '联诚精密', 'LCJM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002922', '伊戈尔', 'YGE', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002923', '润都股份', 'RDGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002925', '盈趣科技', 'YQKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002926', '华西证券', 'HXZQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002927', '泰永长征', 'TYCZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002928', '华夏航空', 'HXHK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002929', '润建通信', 'RJTX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002930', '宏川智慧', 'HCZH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002931', '锋龙股份', 'FLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002932', '明德生物', 'MDSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002933', '新兴装备', 'XXZB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002935', '天奥电子', 'TADZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002936', '郑州银行', 'ZZYX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002937', '兴瑞科技', 'XRKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002938', '鹏鼎控股', 'PDKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002939', '长城证券', 'CCZQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002940', '昂利康', 'ALK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002941', '新疆交建', 'XJJJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002942', '新农股份', 'XNGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002943', '宇晶股份', 'YJGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002945', '华林证券', 'HLZQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('002948', '青岛银行', 'QDYX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200011', '深物业B', 'SWYB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200012', '南  玻Ｂ', 'N  BＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200016', '深康佳Ｂ', 'SKJＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200017', '深中华B', 'SZHB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200018', '神州B', 'SZB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200019', '深深宝Ｂ', 'SSBＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200020', '深华发Ｂ', 'SHFＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200022', '深赤湾Ｂ', 'SCWＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200024', '招商局Ｂ', 'ZSJＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200025', '特  力Ｂ', 'T  LＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200026', '飞亚达Ｂ', 'FYDＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200028', '一致Ｂ', 'YZＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200029', '深深房Ｂ', 'SSFＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200030', '富奥B', 'FAB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200037', '深南电B', 'SNDB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200045', '深纺织Ｂ', 'SFZＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200053', '深基地Ｂ', 'SJDＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200054', '建车B', 'JCB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200055', '方大Ｂ', 'FDＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200056', '皇庭B', 'HTB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200058', '深赛格B', 'SSGB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200152', '山  航Ｂ', 'S  HＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200160', '东沣B', 'D沣B', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200168', '舜喆B', 'S喆B', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200413', '东旭B', 'DXB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200418', '小天鹅Ｂ', 'XTEＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200429', '粤高速Ｂ', 'YGSＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200468', '宁通信B', 'NTXB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200488', '晨  鸣Ｂ', 'C  MＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200505', '京粮B', 'JLB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200512', '闽灿坤Ｂ', 'MCKＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200521', '虹美菱B', 'HMLB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200530', '大  冷Ｂ', 'D  LＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200539', '粤电力Ｂ', 'YDLＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200541', '粤照明Ｂ', 'YZMＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200550', '江  铃Ｂ', 'J  LＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200553', '沙隆达Ｂ', 'SLDＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200570', '苏常柴Ｂ', 'SCCＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200581', '苏威孚Ｂ', 'SW孚Ｂ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200596', '古井贡Ｂ', 'GJGＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200613', '大东海B', 'DDHB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200625', '长  安Ｂ', 'C  AＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200706', '瓦轴B', 'WZB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200725', '京东方Ｂ', 'JDFＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200726', '鲁  泰Ｂ', 'L  TＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200761', '本钢板Ｂ', 'BGBＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200770', '武锅B退', 'WGBT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200771', '杭汽轮Ｂ', 'HQLＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200869', '张  裕Ｂ', 'Z  YＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200986', '粤华包Ｂ', 'YHBＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('200992', '中  鲁Ｂ', 'Z  LＢ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300001', '特锐德', 'TRD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300002', '神州泰岳', 'SZTY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300003', '乐普医疗', 'LPYL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300004', '南风股份', 'NFGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300005', '探路者', 'TLZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300006', '莱美药业', 'LMYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300007', '汉威科技', 'HWKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300008', '天海防务', 'THFW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300009', '安科生物', 'AKSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300010', '立思辰', 'LSC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300011', '鼎汉技术', 'DHJS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300012', '华测检测', 'HCJC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300013', '新宁物流', 'XNWL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300014', '亿纬锂能', 'YW锂N', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300015', '爱尔眼科', 'AEYK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300016', '北陆药业', 'BLYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300017', '网宿科技', 'WSKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300018', '中元股份', 'ZYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300019', '硅宝科技', 'GBKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300020', '银江股份', 'YJGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300021', '大禹节水', 'DYJS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300022', '吉峰农机', 'JFNJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300023', '宝德股份', 'BDGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300024', '机器人', 'JQR', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300025', '华星创业', 'HXCY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300026', '红日药业', 'HRYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300027', '华谊兄弟', 'HYXD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300028', '金亚科技', 'JYKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300029', '天龙光电', 'TLGD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300030', '阳普医疗', 'YPYL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300031', '宝通科技', 'BTKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300032', '金龙机电', 'JLJD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300033', '同花顺', 'THS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300034', '钢研高纳', 'GYGN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300035', '中科电气', 'ZKDQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300036', '超图软件', 'CTRJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300037', '新宙邦', 'XZB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300038', '梅泰诺', 'MTN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300039', '上海凯宝', 'SHKB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300040', '九洲电气', 'JZDQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300041', '回天新材', 'HTXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300042', '朗科科技', 'LKKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300043', '星辉娱乐', 'XHYL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300044', '赛为智能', 'SWZN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300045', '华力创通', 'HLCT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300046', '台基股份', 'TJGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300047', '天源迪科', 'TYDK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300048', '合康新能', 'HKXN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300049', '福瑞股份', 'FRGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300050', '世纪鼎利', 'SJDL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300051', '三五互联', 'SWHL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300052', '中青宝', 'ZQB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300053', '欧比特', 'OBT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300054', '鼎龙股份', 'DLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300055', '万邦达', 'WBD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300056', '三维丝', 'SWS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300057', '万顺股份', 'WSGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300058', '蓝色光标', 'LSGB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300059', '东方财富', 'DFCF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300061', '康旗股份', 'KQGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300062', '中能电气', 'ZNDQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300063', '天龙集团', 'TLJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300064', '豫金刚石', 'YJGS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300065', '海兰信', 'HLX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300066', '三川智慧', 'SCZH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300067', '安诺其', 'ANQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300068', '南都电源', 'NDDY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300069', '金利华电', 'JLHD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300070', '碧水源', 'BSY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300071', '华谊嘉信', 'HYJX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300072', '三聚环保', 'SJHB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300073', '当升科技', 'DSKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300074', '华平股份', 'HPGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300075', '数字政通', 'SZZT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300076', 'GQY视讯', 'GQYSX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300077', '国民技术', 'GMJS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300078', '思创医惠', 'SCYH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300079', '数码科技', 'SMKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300080', '易成新能', 'YCXN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300081', '恒信东方', 'HXDF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300082', '奥克股份', 'AKGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300083', '劲胜智能', 'JSZN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300084', '海默科技', 'HMKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300085', '银之杰', 'YZJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300086', '康芝药业', 'KZYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300087', '荃银高科', '荃YGK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300088', '长信科技', 'CXKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300089', '文化长城', 'WHCC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300090', '盛运环保', 'SYHB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300091', '金通灵', 'JTL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300092', '科新机电', 'KXJD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300093', '金刚玻璃', 'JGBL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300094', '国联水产', 'GLSC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300095', '华伍股份', 'HWGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300096', '易联众', 'YLZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300097', '智云股份', 'ZYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300098', '高新兴', 'GXX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300099', '精准信息', 'JZXX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300100', '双林股份', 'SLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300101', '振芯科技', 'ZXKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300102', '乾照光电', 'QZGD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300103', '达刚路机', 'DGLJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300104', '乐视网', 'LSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300105', '龙源技术', 'LYJS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300106', '西部牧业', 'XBMY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300107', '建新股份', 'JXGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300108', '吉药控股', 'JYKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300109', '新开源', 'XKY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300110', '华仁药业', 'HRYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300111', '向日葵', 'XRK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300112', '万讯自控', 'WXZK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300113', '顺网科技', 'SWKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300114', '中航电测', 'ZHDC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300115', '长盈精密', 'CYJM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300116', '坚瑞沃能', 'JRWN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300117', '嘉寓股份', 'JYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300118', '东方日升', 'DFRS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300119', '瑞普生物', 'RPSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300120', '经纬辉开', 'JWHK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300121', '阳谷华泰', 'YGHT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300122', '智飞生物', 'ZFSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300123', '亚光科技', 'YGKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300124', '汇川技术', 'HCJS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300125', '易世达', 'YSD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300126', '锐奇股份', 'RQGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300127', '银河磁体', 'YHCT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300128', '锦富技术', 'JFJS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300129', '泰胜风能', 'TSFN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300130', '新国都', 'XGD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300131', '英唐智控', 'YTZK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300132', '青松股份', 'QSGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300133', '华策影视', 'HCYS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300134', '大富科技', 'DFKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300135', '宝利国际', 'BLGJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300136', '信维通信', 'XWTX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300137', '先河环保', 'XHHB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300138', '晨光生物', 'CGSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300139', '晓程科技', 'XCKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300140', '中环装备', 'ZHZB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300141', '和顺电气', 'HSDQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300142', '沃森生物', 'WSSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300143', '星普医科', 'XPYK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300144', '宋城演艺', 'SCYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300145', '中金环境', 'ZJHJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300146', '汤臣倍健', 'TCBJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300147', '香雪制药', 'XXZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300148', '天舟文化', 'TZWH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300149', '量子生物', 'LZSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300150', '世纪瑞尔', 'SJRE', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300151', '昌红科技', 'CHKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300152', '科融环境', 'KRHJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300153', '科泰电源', 'KTDY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300154', '瑞凌股份', 'RLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300155', '安居宝', 'AJB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300156', '神雾环保', 'SWHB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300157', '恒泰艾普', 'HTAP', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300158', '振东制药', 'ZDZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300159', '新研股份', 'XYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300160', '秀强股份', 'XQGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300161', '华中数控', 'HZSK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300162', '雷曼股份', 'LMGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300163', '先锋新材', 'XFXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300164', '通源石油', 'TYSY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300165', '天瑞仪器', 'TRYQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300166', '东方国信', 'DFGX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300167', '迪威迅', 'DWX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300168', '万达信息', 'WDXX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300169', '天晟新材', 'T晟XC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300170', '汉得信息', 'HDXX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300171', '东富龙', 'DFL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300172', '中电环保', 'ZDHB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300173', '智慧松德', 'ZHSD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300174', '元力股份', 'YLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300175', '朗源股份', 'LYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300176', '鸿特科技', 'HTKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300177', '中海达', 'ZHD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300178', '腾邦国际', 'TBGJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300179', '四方达', 'SFD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300180', '华峰超纤', 'HFCX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300181', '佐力药业', 'ZLYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300182', '捷成股份', 'JCGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300183', '东软载波', 'DRZB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300184', '力源信息', 'LYXX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300185', '通裕重工', 'TYZG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300186', '大华农', 'DHN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300187', '永清环保', 'YQHB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300188', '美亚柏科', 'MYBK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300189', '神农基因', 'SNJY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300190', '维尔利', 'WEL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300191', '潜能恒信', 'QNHX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300192', '科斯伍德', 'KSWD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300193', '佳士科技', 'JSKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300194', '福安药业', 'FAYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300195', '长荣股份', 'CRGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300196', '长海股份', 'CHGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300197', '铁汉生态', 'THST', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300198', '纳川股份', 'NCGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300199', '翰宇药业', 'HYYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300200', '高盟新材', 'GMXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300201', '海伦哲', 'HLZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300202', '聚龙股份', 'JLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300203', '聚光科技', 'JGKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300204', '舒泰神', 'STS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300205', '天喻信息', 'TYXX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300206', '理邦仪器', 'LBYQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300207', '欣旺达', 'XWD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300208', '恒顺众昇', 'HSZ昇', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300209', '天泽信息', 'TZXX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300210', '森远股份', 'SYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300211', '亿通科技', 'YTKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300212', '易华录', 'YHL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300213', '佳讯飞鸿', 'JXFH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300214', '日科化学', 'RKHX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300215', '电科院', 'DKY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300216', '千山药机', 'QSYJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300217', '东方电热', 'DFDR', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300218', '安利股份', 'ALGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300219', '鸿利智汇', 'HLZH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300220', '金运激光', 'JYJG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300221', '银禧科技', 'Y禧KJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300222', '科大智能', 'KDZN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300223', '北京君正', 'BJJZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300224', '正海磁材', 'ZHCC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300225', '金力泰', 'JLT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300226', '上海钢联', 'SHGL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300227', '光韵达', 'GYD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300228', '富瑞特装', 'FRTZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300229', '拓尔思', 'TES', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300230', '永利股份', 'YLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300231', '银信科技', 'YXKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300232', '洲明科技', 'ZMKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300233', '金城医药', 'JCYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300234', '开尔新材', 'KEXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300235', '方直科技', 'FZKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300236', '上海新阳', 'SHXY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300237', '美晨生态', 'MCST', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300238', '冠昊生物', 'G昊SW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300239', '东宝生物', 'DBSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300240', '飞力达', 'FLD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300241', '瑞丰光电', 'RFGD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300242', '佳云科技', 'JYKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300243', '瑞丰高材', 'RFGC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300244', '迪安诊断', 'DAZD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300245', '天玑科技', 'T玑KJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300246', '宝莱特', 'BLT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300247', '乐金健康', 'LJJK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300248', '新开普', 'XKP', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300249', '依米康', 'YMK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300250', '初灵信息', 'CLXX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300251', '光线传媒', 'GXCM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300252', '金信诺', 'JXN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300253', '卫宁健康', 'WNJK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300254', '仟源医药', 'QYYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300255', '常山药业', 'CSYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300256', '星星科技', 'XXKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300257', '开山股份', 'KSGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300258', '精锻科技', 'JDKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300259', '新天科技', 'XTKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300260', '新莱应材', 'XLYC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300261', '雅本化学', 'YBHX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300262', '巴安水务', 'BASW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300263', '隆华节能', 'LHJN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300264', '佳创视讯', 'JCSX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300265', '通光线缆', 'TGXL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300266', '兴源环境', 'XYHJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300267', '尔康制药', 'EKZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300268', '佳沃股份', 'JWGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300269', '联建光电', 'LJGD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300270', '中威电子', 'ZWDZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300271', '华宇软件', 'HYRJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300272', '开能健康', 'KNJK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300273', '和佳股份', 'HJGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300274', '阳光电源', 'YGDY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300275', '梅安森', 'MAS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300276', '三丰智能', 'SFZN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300277', '海联讯', 'HLX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300278', '华昌达', 'HCD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300279', '和晶科技', 'HJKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300280', '紫天科技', 'ZTKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300281', '金明精机', 'JMJJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300282', '三盛教育', 'SSJY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300283', '温州宏丰', 'WZHF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300284', '苏交科', 'SJK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300285', '国瓷材料', 'GCCL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300286', '安科瑞', 'AKR', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300287', '飞利信', 'FLX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300288', '朗玛信息', 'LMXX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300289', '利德曼', 'LDM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300290', '荣科科技', 'RKKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300291', '华录百纳', 'HLBN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300292', '吴通控股', 'WTKG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300293', '蓝英装备', 'LYZB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300294', '博雅生物', 'BYSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300295', '三六五网', 'SLWW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300296', '利亚德', 'LYD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300297', '蓝盾股份', 'LDGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300298', '三诺生物', 'SNSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300299', '富春股份', 'FCGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300300', '汉鼎宇佑', 'HDYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300301', '长方集团', 'CFJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300302', '同有科技', 'TYKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300303', '聚飞光电', 'JFGD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300304', '云意电气', 'YYDQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300305', '裕兴股份', 'YXGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300306', '远方信息', 'YFXX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300307', '慈星股份', 'CXGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300308', '中际旭创', 'ZJXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300309', '吉艾科技', 'JAKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300310', '宜通世纪', 'YTSJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300311', '任子行', 'RZX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300312', '邦讯技术', 'BXJS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300313', '天山生物', 'TSSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300314', '戴维医疗', 'DWYL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300315', '掌趣科技', 'ZQKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300316', '晶盛机电', 'JSJD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300317', '珈伟股份', '珈WGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300318', '博晖创新', 'B晖CX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300319', '麦捷科技', 'MJKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300320', '海达股份', 'HDGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300321', '同大股份', 'TDGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300322', '硕贝德', 'SBD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300323', '华灿光电', 'HCGD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300324', '旋极信息', 'XJXX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300325', '德威新材', 'DWXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300326', '凯利泰', 'KLT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300327', '中颖电子', 'ZYDZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300328', '宜安科技', 'YAKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300329', '海伦钢琴', 'HLGQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300330', '华虹计通', 'HHJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300331', '苏大维格', 'SDWG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300332', '天壕环境', 'THHJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300333', '兆日科技', 'ZRKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300334', '津膜科技', 'JMKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300335', '迪森股份', 'DSGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300336', '新文化', 'XWH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300337', '银邦股份', 'YBGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300338', '开元股份', 'KYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300339', '润和软件', 'RHRJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300340', '科恒股份', 'KHGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300341', '麦迪电气', 'MDDQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300342', '天银机电', 'TYJD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300343', '联创互联', 'LCHL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300344', '太空智造', 'TKZZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300345', '红宇新材', 'HYXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300346', '南大光电', 'NDGD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300347', '泰格医药', 'TGYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300348', '长亮科技', 'CLKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300349', '金卡智能', 'JKZN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300350', '华鹏飞', 'HPF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300351', '永贵电器', 'YGDQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300352', '北信源', 'BXY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300353', '东土科技', 'DTKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300354', '东华测试', 'DHCS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300355', '蒙草生态', 'MCST', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300356', '光一科技', 'GYKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300357', '我武生物', 'WWSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300358', '楚天科技', 'CTKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300359', '全通教育', 'QTJY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300360', '炬华科技', 'JHKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300362', '天翔环境', 'TXHJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300363', '博腾股份', 'BTGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300364', '中文在线', 'ZWZX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300365', '恒华科技', 'HHKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300366', '创意信息', 'CYXX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300367', '东方网力', 'DFWL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300368', '汇金股份', 'HJGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300369', '绿盟科技', 'LMKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300370', '安控科技', 'AKKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300371', '汇中股份', 'HZGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300372', '欣泰退', 'XTT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300373', '扬杰科技', 'YJKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300374', '恒通科技', 'HTKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300375', '鹏翎股份', 'P翎GF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300376', '易事特', 'YST', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300377', '赢时胜', 'YSS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300378', '鼎捷软件', 'DJRJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300379', '东方通', 'DFT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300380', '安硕信息', 'ASXX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300381', '溢多利', 'YDL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300382', '斯莱克', 'SLK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300383', '光环新网', 'GHXW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300384', '三联虹普', 'SLHP', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300385', '雪浪环境', 'XLHJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300386', '飞天诚信', 'FTCX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300387', '富邦股份', 'FBGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300388', '国祯环保', 'G祯HB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300389', '艾比森', 'ABS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300390', '天华超净', 'THCJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300391', '康跃科技', 'KYKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300392', '腾信股份', 'TXGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300393', '中来股份', 'ZLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300394', '天孚通信', 'T孚TX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300395', '菲利华', 'FLH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300396', '迪瑞医疗', 'DRYL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300397', '天和防务', 'THFW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300398', '飞凯材料', 'FKCL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300399', '京天利', 'JTL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300400', '劲拓股份', 'JTGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300401', '花园生物', 'HYSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300402', '宝色股份', 'BSGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300403', '地尔汉宇', 'DEHY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300404', '博济医药', 'BJYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300405', '科隆股份', 'KLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300406', '九强生物', 'JQSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300407', '凯发电气', 'KFDQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300408', '三环集团', 'SHJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300409', '道氏技术', 'DSJS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300410', '正业科技', 'ZYKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300411', '金盾股份', 'JDGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300412', '迦南科技', '迦NKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300413', '芒果超媒', 'MGCM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300414', '中光防雷', 'ZGFL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300415', '伊之密', 'YZM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300416', '苏试试验', 'SSSY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300417', '南华仪器', 'NHYQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300418', '昆仑万维', 'KLWW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300419', '浩丰科技', 'HFKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300420', '五洋停车', 'WYTC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300421', '力星股份', 'LXGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300422', '博世科', 'BSK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300423', '鲁亿通', 'LYT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300424', '航新科技', 'HXKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300425', '环能科技', 'HNKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300426', '唐德影视', 'TDYS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300427', '红相股份', 'HXGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300428', '四通新材', 'STXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300429', '强力新材', 'QLXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300430', '诚益通', 'CYT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300431', '暴风集团', 'BFJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300432', '富临精工', 'FLJG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300433', '蓝思科技', 'LSKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300434', '金石东方', 'JSDF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300435', '中泰股份', 'ZTGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300436', '广生堂', 'GST', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300437', '清水源', 'QSY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300438', '鹏辉能源', 'PHNY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300439', '美康生物', 'MKSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300440', '运达科技', 'YDKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300441', '鲍斯股份', 'BSGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300442', '普丽盛', 'PLS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300443', '金雷风电', 'JLFD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300444', '双杰电气', 'SJDQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300445', '康斯特', 'KST', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300446', '乐凯新材', 'LKXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300447', '全信股份', 'QXGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300448', '浩云科技', 'HYKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300449', '汉邦高科', 'HBGK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300450', '先导智能', 'XDZN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300451', '创业软件', 'CYRJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300452', '山河药辅', 'SHYF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300453', '三鑫医疗', 'S鑫YL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300454', '深信服', 'SXF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300455', '康拓红外', 'KTHW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300456', '耐威科技', 'NWKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300457', '赢合科技', 'YHKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300458', '全志科技', 'QZKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300459', '金科文化', 'JKWH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300460', '惠伦晶体', 'HLJT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300461', '田中精机', 'TZJJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300462', '华铭智能', 'HMZN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300463', '迈克生物', 'MKSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300464', '星徽精密', 'XHJM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300465', '高伟达', 'GWD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300466', '赛摩电气', 'SMDQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300467', '迅游科技', 'XYKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300468', '四方精创', 'SFJC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300469', '信息发展', 'XXFZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300470', '日机密封', 'RJMF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300471', '厚普股份', 'HPGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300472', '新元科技', 'XYKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300473', '德尔股份', 'DEGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300474', '景嘉微', 'JJW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300475', '聚隆科技', 'JLKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300476', '胜宏科技', 'SHKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300477', '合纵科技', 'HZKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300478', '杭州高新', 'HZGX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300479', '神思电子', 'SSDZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300480', '光力科技', 'GLKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300481', '濮阳惠成', '濮YHC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300482', '万孚生物', 'W孚SW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300483', '沃施股份', 'WSGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300484', '蓝海华腾', 'LHHT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300485', '赛升药业', 'SSYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300486', '东杰智能', 'DJZN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300487', '蓝晓科技', 'LXKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300488', '恒锋工具', 'HFGJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300489', '中飞股份', 'ZFGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300490', '华自科技', 'HZKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300491', '通合科技', 'THKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300492', '山鼎设计', 'SDSJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300493', '润欣科技', 'RXKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300494', '盛天网络', 'STWL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300495', '美尚生态', 'MSST', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300496', '中科创达', 'ZKCD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300497', '富祥股份', 'FXGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300498', '温氏股份', 'WSGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300499', '高澜股份', 'GLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300500', '启迪设计', 'QDSJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300501', '海顺新材', 'HSXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300502', '新易盛', 'XYS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300503', '昊志机电', '昊ZJD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300504', '天邑股份', 'TYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300505', '川金诺', 'CJN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300506', '名家汇', 'MJH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300507', '苏奥传感', 'SACG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300508', '维宏股份', 'WHGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300509', '新美星', 'XMX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300510', '金冠股份', 'JGGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300511', '雪榕生物', 'X榕SW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300512', '中亚股份', 'ZYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300513', '恒泰实达', 'HTSD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300514', '友讯达', 'YXD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300515', '三德科技', 'SDKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300516', '久之洋', 'JZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300517', '海波重科', 'HBZK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300518', '盛讯达', 'SXD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300519', '新光药业', 'XGYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300520', '科大国创', 'KDGC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300521', '爱司凯', 'ASK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300522', '世名科技', 'SMKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300523', '辰安科技', 'CAKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300525', '博思软件', 'BSRJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300526', '中潜股份', 'ZQGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300527', '中国应急', 'ZGYJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300528', '幸福蓝海', 'XFLH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300529', '健帆生物', 'JFSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300530', '达志科技', 'DZKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300531', '优博讯', 'YBX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300532', '今天国际', 'JTGJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300533', '冰川网络', 'BCWL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300534', '陇神戎发', 'LSRF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300535', '达威股份', 'DWGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300536', '农尚环境', 'NSHJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300537', '广信材料', 'GXCL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300538', '同益股份', 'TYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300539', '横河模具', 'HHMJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300540', '深冷股份', 'SLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300541', '先进数通', 'XJST', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300542', '新晨科技', 'XCKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300543', '朗科智能', 'LKZN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300545', '联得装备', 'LDZB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300546', '雄帝科技', 'XDKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300547', '川环科技', 'CHKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300548', '博创科技', 'BCKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300549', '优德精密', 'YDJM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300550', '和仁科技', 'HRKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300551', '古鳌科技', 'G鳌KJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300552', '万集科技', 'WJKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300553', '集智股份', 'JZGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300554', '三超新材', 'SCXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300555', '路通视信', 'LTSX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300556', '丝路视觉', 'SLSJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300557', '理工光科', 'LGGK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300558', '贝达药业', 'BDYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300559', '佳发教育', 'JFJY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300560', '中富通', 'ZFT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300561', '汇金科技', 'HJKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300562', '乐心医疗', 'LXYL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300563', '神宇股份', 'SYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300565', '科信技术', 'KXJS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300566', '激智科技', 'JZKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300567', '精测电子', 'JCDZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300568', '星源材质', 'XYCZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300569', '天能重工', 'TNZG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300570', '太辰光', 'TCG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300571', '平治信息', 'PZXX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300572', '安车检测', 'ACJC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300573', '兴齐眼药', 'XQYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300575', '中旗股份', 'ZQGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300576', '容大感光', 'RDGG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300577', '开润股份', 'KRGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300578', '会畅通讯', 'HCTX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300579', '数字认证', 'SZRZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300580', '贝斯特', 'BST', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300581', '晨曦航空', 'C曦HK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300582', '英飞特', 'YFT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300583', '赛托生物', 'STSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300584', '海辰药业', 'HCYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300585', '奥联电子', 'ALDZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300586', '美联新材', 'MLXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300587', '天铁股份', 'TTGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300588', '熙菱信息', 'XLXX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300589', '江龙船艇', 'JLCT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300590', '移为通信', 'YWTX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300591', '万里马', 'WLM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300592', '华凯创意', 'HKCY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300593', '新雷能', 'XLN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300595', '欧普康视', 'OPKS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300596', '利安隆', 'LAL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300597', '吉大通信', 'JDTX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300598', '诚迈科技', 'CMKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300599', '雄塑科技', 'XSKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300600', '瑞特股份', 'RTGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300601', '康泰生物', 'KTSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300602', '飞荣达', 'FRD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300603', '立昂技术', 'LAJS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300604', '长川科技', 'CCKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300605', '恒锋信息', 'HFXX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300606', '金太阳', 'JTY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300607', '拓斯达', 'TSD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300608', '思特奇', 'STQ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300609', '汇纳科技', 'HNKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300610', '晨化股份', 'CHGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300611', '美力科技', 'MLKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300612', '宣亚国际', 'XYGJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300613', '富瀚微', 'F瀚W', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300615', '欣天科技', 'XTKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300616', '尚品宅配', 'SPZP', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300617', '安靠智电', 'AKZD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300618', '寒锐钴业', 'HR钴Y', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300619', '金银河', 'JYH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300620', '光库科技', 'GKKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300621', '维业股份', 'WYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300622', '博士眼镜', 'BSYJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300623', '捷捷微电', 'JJWD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300624', '万兴科技', 'WXKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300625', '三雄极光', 'SXJG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300626', '华瑞股份', 'HRGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300627', '华测导航', 'HCDH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300628', '亿联网络', 'YLWL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300629', '新劲刚', 'XJG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300630', '普利制药', 'PLZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300631', '久吾高科', 'JWGK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300632', '光莆股份', 'GPGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300633', '开立医疗', 'KLYL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300634', '彩讯股份', 'CXGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300635', '达安股份', 'DAGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300636', '同和药业', 'THYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300637', '扬帆新材', 'YFXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300638', '广和通', 'GHT', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300639', '凯普生物', 'KPSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300640', '德艺文创', 'DYWC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300641', '正丹股份', 'ZDGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300642', '透景生命', 'TJSM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300643', '万通智控', 'WTZK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300644', '南京聚隆', 'NJJL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300645', '正元智慧', 'ZYZH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300647', '超频三', 'CPS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300648', '星云股份', 'XYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300649', '杭州园林', 'HZYL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300650', '太龙照明', 'TLZM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300651', '金陵体育', 'JLTY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300652', '雷迪克', 'LDK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300653', '正海生物', 'ZHSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300654', '世纪天鸿', 'SJTH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300655', '晶瑞股份', 'JRGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300656', '民德电子', 'MDDZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300657', '弘信电子', 'HXDZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300658', '延江股份', 'YJGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300659', '中孚信息', 'Z孚XX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300660', '江苏雷利', 'JSLL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300661', '圣邦股份', 'SBGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300662', '科锐国际', 'KRGJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300663', '科蓝软件', 'KLRJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300664', '鹏鹞环保', 'P鹞HB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300665', '飞鹿股份', 'FLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300666', '江丰电子', 'JFDZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300667', '必创科技', 'BCKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300668', '杰恩设计', 'JESJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300669', '沪宁股份', 'HNGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300670', '大烨智能', 'D烨ZN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300671', '富满电子', 'FMDZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300672', '国科微', 'GKW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300673', '佩蒂股份', 'PDGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300674', '宇信科技', 'YXKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300675', '建科院', 'JKY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300676', '华大基因', 'HDJY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300677', '英科医疗', 'YKYL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300678', '中科信息', 'ZKXX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300679', '电连技术', 'DLJS', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300680', '隆盛科技', 'LSKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300681', '英搏尔', 'YBE', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300682', '朗新科技', 'LXKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300683', '海特生物', 'HTSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300684', '中石科技', 'ZSKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300685', '艾德生物', 'ADSW', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300686', '智动力', 'ZDL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300687', '赛意信息', 'SYXX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300688', '创业黑马', 'CYHM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300689', '澄天伟业', 'CTWY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300690', '双一科技', 'SYKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300691', '联合光电', 'LHGD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300692', '中环环保', 'ZHHB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300693', '盛弘股份', 'SHGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300694', '蠡湖股份', '蠡HGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300695', '兆丰股份', 'ZFGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300696', '爱乐达', 'ALD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300697', '电工合金', 'DGHJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300698', '万马科技', 'WMKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300699', '光威复材', 'GWFC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300700', '岱勒新材', '岱LXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300701', '森霸传感', 'SBCG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300702', '天宇股份', 'TYGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300703', '创源文化', 'CYWH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300705', '九典制药', 'JDZY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300706', '阿石创', 'ASC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300707', '威唐工业', 'WTGY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300708', '聚灿光电', 'JCGD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300709', '精研科技', 'JYKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300710', '万隆光电', 'WLGD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300711', '广哈通信', 'GHTX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300712', '永福股份', 'YFGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300713', '英可瑞', 'YKR', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300715', '凯伦股份', 'KLGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300716', '国立科技', 'GLKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300717', '华信新材', 'HXXC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300718', '长盛轴承', 'CSZC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300719', '安达维尔', 'ADWE', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300720', '海川智能', 'HCZN', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300721', '怡达股份', '怡DGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300722', '新余国科', 'XYGK', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300723', '一品红', 'YPH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300724', '捷佳伟创', 'JJWC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300725', '药石科技', 'YSKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300726', '宏达电子', 'HDDZ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300727', '润禾材料', 'RHCL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300729', '乐歌股份', 'LGGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300730', '科创信息', 'KCXX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300731', '科创新源', 'KCXY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300732', '设研院', 'SYY', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300733', '西菱动力', 'XLDL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300735', '光弘科技', 'GHKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300736', '百华悦邦', 'BHYB', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300737', '科顺股份', 'KSGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300738', '奥飞数据', 'AFSJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300739', '明阳电路', 'MYDL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300740', '御家汇', 'YJH', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300741', '华宝股份', 'HBGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300742', '越博动力', 'YBDL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300743', '天地数码', 'TDSM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300745', '欣锐科技', 'XRKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300746', '汉嘉设计', 'HJSJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300747', '锐科激光', 'RKJG', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300748', '金力永磁', 'JLYC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300749', '顶固集创', 'DGJC', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300750', '宁德时代', 'NDSD', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300751', '迈为股份', 'MWGF', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300752', '隆利科技', 'LLKJ', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300753', '爱朋医疗', 'APYL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300755', '华致酒行', 'HZJX', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300756', '中山金马', 'ZSJM', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('300760', '迈瑞医疗', 'MRYL', 'SZ', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600000', '浦发银行', 'PFYX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600004', '白云机场', 'BYJC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600005', '武钢股份', 'WGGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600006', '东风汽车', 'DFQC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600007', '中国国贸', 'ZGGM', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600008', '首创股份', 'SCGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600009', '上海机场', 'SHJC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600010', '包钢股份', 'BGGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600011', '华能国际', 'HNGJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600012', '皖通高速', 'WTGS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600015', '华夏银行', 'HXYX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600016', '民生银行', 'MSYX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600017', '日照港', 'RZG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600018', '上港集团', 'SGJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600019', '宝钢股份', 'BGGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600020', '中原高速', 'ZYGS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600021', '上海电力', 'SHDL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600022', '山东钢铁', 'SDGT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600023', '浙能电力', 'ZNDL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600025', '华能水电', 'HNSD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600026', '中远海能', 'ZYHN', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600027', '华电国际', 'HDGJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600028', '中国石化', 'ZGSH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600029', '南方航空', 'NFHK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600030', '中信证券', 'ZXZQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600031', '三一重工', 'SYZG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600033', '福建高速', 'FJGS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600035', '楚天高速', 'CTGS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600036', '招商银行', 'ZSYX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600037', '歌华有线', 'GHYX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600038', '中直股份', 'ZZGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600039', '四川路桥', 'SCLQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600048', '保利地产', 'BLDC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600050', '中国联通', 'ZGLT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600051', '宁波联合', 'NBLH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600052', '浙江广厦', 'ZJGX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600053', '九鼎投资', 'JDTZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600054', '黄山旅游', 'HSLY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600055', '万东医疗', 'WDYL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600056', '中国医药', 'ZGYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600057', '厦门象屿', 'XMXY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600058', '五矿发展', 'WKFZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600059', '古越龙山', 'GYLS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600060', '海信电器', 'HXDQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600061', '国投资本', 'GTZB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600062', '华润双鹤', 'HRSH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600063', '皖维高新', 'WWGX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600064', '南京高科', 'NJGK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600066', '宇通客车', 'YTKC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600067', '冠城大通', 'GCDT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600068', '葛洲坝', 'GZB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600069', '银鸽投资', 'YGTZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600070', '浙江富润', 'ZJFR', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600071', '凤凰光学', 'FHGX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600072', '中船科技', 'ZCKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600073', '上海梅林', 'SHML', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600074', '*ST保千', '*STBQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600075', '新疆天业', 'XJTY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600076', '康欣新材', 'KXXC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600077', '宋都股份', 'SDGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600078', '澄星股份', 'CXGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600079', '人福医药', 'RFYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600080', '金花股份', 'JHGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600081', '东风科技', 'DFKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600082', '海泰发展', 'HTFZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600083', '博信股份', 'BXGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600084', '中葡股份', 'ZPGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600085', '同仁堂', 'TRT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600086', '东方金钰', 'DFJ钰', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600088', '中视传媒', 'ZSCM', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600089', '特变电工', 'TBDG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600090', '同济堂', 'TJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600091', 'ST明科', 'STMK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600093', '易见股份', 'YJGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600094', '大名城', 'DMC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600095', '哈高科', 'HGK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600096', '云天化', 'YTH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600097', '开创国际', 'KCGJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600098', '广州发展', 'GZFZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600099', '林海股份', 'LHGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600100', '同方股份', 'TFGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600101', '明星电力', 'MXDL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600103', '青山纸业', 'QSZY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600104', '上汽集团', 'SQJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600105', '永鼎股份', 'YDGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600106', '重庆路桥', 'ZQLQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600107', '美尔雅', 'MEY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600108', '亚盛集团', 'YSJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600109', '国金证券', 'GJZQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600110', '诺德股份', 'NDGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600111', '北方稀土', 'BFXT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600112', '天成控股', 'TCKG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600113', '浙江东日', 'ZJDR', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600114', '东睦股份', 'DMGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600115', '东方航空', 'DFHK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600116', '三峡水利', 'SXSL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600117', '西宁特钢', 'XNTG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600118', '中国卫星', 'ZGWX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600119', '长江投资', 'CJTZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600120', '浙江东方', 'ZJDF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600121', '郑州煤电', 'ZZMD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600122', '宏图高科', 'HTGK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600123', '兰花科创', 'LHKC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600125', '铁龙物流', 'TLWL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600126', '杭钢股份', 'HGGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600127', '金健米业', 'JJMY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600128', '弘业股份', 'HYGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600129', '太极集团', 'TJJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600130', '波导股份', 'BDGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600131', '岷江水电', '岷JSD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600132', '重庆啤酒', 'ZQPJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600133', '东湖高新', 'DHGX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600135', '乐凯胶片', 'LKJP', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600136', '当代明诚', 'DDMC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600137', '浪莎股份', 'LSGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600138', '中青旅', 'ZQL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600139', '西部资源', 'XBZY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600141', '兴发集团', 'XFJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600143', '金发科技', 'JFKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600145', '*ST新亿', '*STXY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600146', '商赢环球', 'SYHQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600148', '长春一东', 'CCYD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600149', 'ST坊展', 'STFZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600150', '*ST船舶', '*STCB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600151', '航天机电', 'HTJD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600152', '维科技术', 'WKJS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600153', '建发股份', 'JFGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600155', '华创阳安', 'HCYA', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600156', '华升股份', 'HSGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600157', '永泰能源', 'YTNY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600158', '中体产业', 'ZTCY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600159', '大龙地产', 'DLDC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600160', '巨化股份', 'JHGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600161', '天坛生物', 'TTSW', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600162', '香江控股', 'XJKG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600163', '中闽能源', 'ZMNY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600165', '新日恒力', 'XRHL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600166', '福田汽车', 'FTQC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600167', '联美控股', 'LMKG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600168', '武汉控股', 'WHKG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600169', '太原重工', 'TYZG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600170', '上海建工', 'SHJG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600171', '上海贝岭', 'SHBL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600172', '黄河旋风', 'HHXF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600173', '卧龙地产', 'WLDC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600175', '美都能源', 'MDNY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600176', '中国巨石', 'ZGJS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600177', '雅戈尔', 'YGE', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600178', '东安动力', 'DADL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600179', '安通控股', 'ATKG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600180', '瑞茂通', 'RMT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600182', 'S佳通', 'SJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600183', '生益科技', 'SYKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600184', '光电股份', 'GDGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600185', '格力地产', 'GLDC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600186', '莲花健康', 'LHJK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600187', '国中水务', 'GZSW', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600188', '兖州煤业', '兖ZMY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600189', '吉林森工', 'JLSG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600190', '锦州港', 'JZG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600191', '华资实业', 'HZSY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600192', '长城电工', 'CCDG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600193', '*ST创兴', '*STCX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600195', '中牧股份', 'ZMGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600196', '复星医药', 'FXYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600197', '伊力特', 'YLT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600198', '*ST大唐', '*STDT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600199', '金种子酒', 'JZZJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600200', '江苏吴中', 'JSWZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600201', '生物股份', 'SWGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600202', '*ST哈空', '*STHK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600203', '福日电子', 'FRDZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600206', '有研新材', 'YYXC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600207', '安彩高科', 'ACGK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600208', '新湖中宝', 'XHZB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600209', '*ST罗顿', '*STLD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600210', '紫江企业', 'ZJQY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600211', '西藏药业', 'XCYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600212', '江泉实业', 'JQSY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600213', '亚星客车', 'YXKC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600215', '长春经开', 'CCJK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600216', '浙江医药', 'ZJYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600217', '中再资环', 'ZZZH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600218', '全柴动力', 'QCDL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600219', '南山铝业', 'NSLY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600220', '江苏阳光', 'JSYG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600221', '海航控股', 'HHKG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600222', '太龙药业', 'TLYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600223', '鲁商置业', 'LSZY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600225', '天津松江', 'TJSJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600226', '瀚叶股份', '瀚YGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600227', '圣济堂', 'SJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600228', 'ST昌九', 'STCJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600229', '城市传媒', 'CSCM', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600230', '沧州大化', 'CZDH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600231', '凌钢股份', 'LGGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600232', '金鹰股份', 'JYGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600233', '圆通速递', 'YTSD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600234', 'ST山水', 'STSS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600235', '民丰特纸', 'MFTZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600236', '桂冠电力', 'GGDL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600237', '铜峰电子', 'TFDZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600238', '*ST椰岛', '*STYD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600239', '云南城投', 'YNCT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600240', '华业资本', 'HYZB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600241', '时代万恒', 'SDWH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600242', '中昌数据', 'ZCSJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600243', '青海华鼎', 'QHHD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600246', '万通地产', 'WTDC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600247', '*ST成城', '*STCC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600248', '延长化建', 'YCHJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600249', '两面针', 'LMZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600250', '南纺股份', 'NFGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600251', '冠农股份', 'GNGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600252', '中恒集团', 'ZHJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600255', '梦舟股份', 'MZGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600256', '广汇能源', 'GHNY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600257', '大湖股份', 'DHGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600258', '首旅酒店', 'SLJD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600259', '广晟有色', 'G晟YS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600260', '凯乐科技', 'KLKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600261', '阳光照明', 'YGZM', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600262', '北方股份', 'BFGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600265', 'ST景谷', 'STJG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600266', '北京城建', 'BJCJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600267', '海正药业', 'HZYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600268', '国电南自', 'GDNZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600269', '赣粤高速', 'GYGS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600270', '外运发展', 'WYFZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600271', '航天信息', 'HTXX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600272', '开开实业', 'KKSY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600273', '嘉化能源', 'JHNY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600275', 'ST昌鱼', 'STCY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600276', '恒瑞医药', 'HRYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600277', '亿利洁能', 'YLJN', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600278', '东方创业', 'DFCY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600279', '重庆港九', 'ZQGJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600280', '中央商场', 'ZYSC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600281', '太化股份', 'THGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600282', '南钢股份', 'NGGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600283', '钱江水利', 'QJSL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600284', '浦东建设', 'PDJS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600285', '羚锐制药', 'LRZY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600287', '江苏舜天', 'JSST', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600288', '大恒科技', 'DHKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600289', '*ST信通', '*STXT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600290', '华仪电气', 'HYDQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600291', '西水股份', 'XSGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600292', '远达环保', 'YDHB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600293', '三峡新材', 'SXXC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600295', '鄂尔多斯', 'EEDS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600297', '广汇汽车', 'GHQC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600298', '安琪酵母', 'A琪JM', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600299', '安迪苏', 'ADS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600300', '维维股份', 'WWGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600301', 'ST南化', 'STNH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600302', '标准股份', 'BZGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600303', '曙光股份', 'SGGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600305', '恒顺醋业', 'HSCY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600306', '商业城', 'SYC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600307', '酒钢宏兴', 'JGHX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600308', '华泰股份', 'HTGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600309', '万华化学', 'WHHX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600310', '桂东电力', 'GDDL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600311', '荣华实业', 'RHSY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600312', '平高电气', 'PGDQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600313', '农发种业', 'NFZY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600315', '上海家化', 'SHJH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600316', '洪都航空', 'HDHK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600317', '营口港', 'YKG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600318', '新力金融', 'XLJR', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600319', '亚星化学', 'YXHX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600320', '振华重工', 'ZHZG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600321', '*ST正源', '*STZY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600322', '天房发展', 'TFFZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600323', '瀚蓝环境', '瀚LHJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600325', '华发股份', 'HFGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600326', '西藏天路', 'XCTL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600327', '大东方', 'DDF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600328', '兰太实业', 'LTSY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600329', '中新药业', 'ZXYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600330', '天通股份', 'TTGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600331', '宏达股份', 'HDGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600332', '白云山', 'BYS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600333', '长春燃气', 'CCRQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600335', '国机汽车', 'GJQC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600336', '澳柯玛', 'AKM', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600337', '美克家居', 'MKJJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600338', '西藏珠峰', 'XCZF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600339', '中油工程', 'ZYGC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600340', '华夏幸福', 'HXXF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600343', '航天动力', 'HTDL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600345', '长江通信', 'CJTX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600346', '恒力股份', 'HLGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600348', '阳泉煤业', 'YQMY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600350', '山东高速', 'SDGS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600351', '亚宝药业', 'YBYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600352', '浙江龙盛', 'ZJLS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600353', '旭光股份', 'XGGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600354', '敦煌种业', 'DHZY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600355', '精伦电子', 'JLDZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600356', '恒丰纸业', 'HFZY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600358', '国旅联合', 'GLLH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600359', '新农开发', 'XNKF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600360', '华微电子', 'HWDZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600361', '华联综超', 'HLZC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600362', '江西铜业', 'JXTY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600363', '联创光电', 'LCGD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600365', '通葡股份', 'TPGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600366', '宁波韵升', 'NBYS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600367', '红星发展', 'HXFZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600368', '五洲交通', 'WZJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600369', '西南证券', 'XNZQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600370', '三房巷', 'SFX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600371', '万向德农', 'WXDN', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600372', '中航电子', 'ZHDZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600373', '中文传媒', 'ZWCM', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600375', '华菱星马', 'HLXM', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600376', '首开股份', 'SKGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600377', '宁沪高速', 'NHGS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600378', '天科股份', 'TKGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600379', '宝光股份', 'BGGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600380', '健康元', 'JKY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600381', '青海春天', 'QHCT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600382', '广东明珠', 'GDMZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600383', '金地集团', 'JDJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600385', '山东金泰', 'SDJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600386', '北巴传媒', 'BBCM', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600387', '海越能源', 'HYNY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600388', '龙净环保', 'LJHB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600389', '江山股份', 'JSGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600390', '五矿资本', 'WKZB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600391', '航发科技', 'HFKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600392', '盛和资源', 'SHZY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600393', '粤泰股份', 'YTGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600395', '盘江股份', 'PJGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600396', '金山股份', 'JSGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600397', '*ST安煤', '*STAM', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600398', '海澜之家', 'HLZJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600399', '*ST抚钢', '*STFG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600400', '红豆股份', 'HDGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600401', '*ST海润', '*STHR', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600403', '大有能源', 'DYNY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600405', '动力源', 'DLY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600406', '国电南瑞', 'GDNR', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600408', '*ST安泰', '*STAT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600409', '三友化工', 'SYHG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600410', '华胜天成', 'HSTC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600415', '小商品城', 'XSPC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600416', '湘电股份', 'XDGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600418', '江淮汽车', 'JHQC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600419', '天润乳业', 'TRRY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600420', '现代制药', 'XDZY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600421', 'ST仰帆', 'STYF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600422', '昆药集团', 'KYJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600423', '*ST柳化', '*STLH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600425', '青松建化', 'QSJH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600426', '华鲁恒升', 'HLHS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600428', '中远海特', 'ZYHT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600429', '三元股份', 'SYGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600432', '退市吉恩', 'TSJE', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600433', '冠豪高新', 'GHGX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600435', '北方导航', 'BFDH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600436', '片仔癀', 'PZ癀', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600438', '通威股份', 'TWGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600439', '瑞贝卡', 'RBK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600444', '国机通用', 'GJTY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600446', '金证股份', 'JZGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600448', '华纺股份', 'HFGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600449', '宁夏建材', 'NXJC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600452', '涪陵电力', 'FLDL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600455', '博通股份', 'BTGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600456', '宝钛股份', 'B钛GF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600458', '时代新材', 'SDXC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600459', '贵研铂业', 'GYBY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600460', '士兰微', 'SLW', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600461', '洪城水业', 'HCSY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600462', '九有股份', 'JYGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600463', '空港股份', 'KGGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600466', '蓝光发展', 'LGFZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600467', '好当家', 'HDJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600468', '百利电气', 'BLDQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600469', '风神股份', 'FSGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600470', '六国化工', 'LGHG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600475', '华光股份', 'HGGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600476', '湘邮科技', 'XYKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600477', '杭萧钢构', 'HXGG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600478', '科力远', 'KLY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600479', '千金药业', 'QJYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600480', '凌云股份', 'LYGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600481', '双良节能', 'SLJN', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600482', '中国动力', 'ZGDL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600483', '福能股份', 'FNGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600485', '信威集团', 'XWJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600486', '扬农化工', 'YNHG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600487', '亨通光电', 'HTGD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600488', '天药股份', 'TYGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600489', '中金黄金', 'ZJHJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600490', '鹏欣资源', 'PXZY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600491', '龙元建设', 'LYJS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600493', '凤竹纺织', 'FZFZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600495', '晋西车轴', 'JXCZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600496', '精工钢构', 'JGGG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600497', '驰宏锌锗', 'CHXZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600498', '烽火通信', 'FHTX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600499', '科达洁能', 'KDJN', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600500', '中化国际', 'ZHGJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600501', '航天晨光', 'HTCG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600502', '安徽水利', 'AHSL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600503', '华丽家族', 'HLJZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600505', '西昌电力', 'XCDL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600506', '香梨股份', 'XLGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600507', '方大特钢', 'FDTG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600508', '上海能源', 'SHNY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600509', '天富能源', 'TFNY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600510', '黑牡丹', 'HMD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600511', '国药股份', 'GYGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600512', '腾达建设', 'TDJS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600513', '联环药业', 'LHYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600515', '海航基础', 'HHJC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600516', '方大炭素', 'FDTS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600517', '置信电气', 'ZXDQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600518', '康美药业', 'KMYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600519', '贵州茅台', 'GZMT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600520', '文一科技', 'WYKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600521', '华海药业', 'HHYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600522', '中天科技', 'ZTKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600523', '贵航股份', 'GHGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600525', '长园集团', 'CYJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600526', '菲达环保', 'FDHB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600527', '江南高纤', 'JNGX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600528', '中铁工业', 'ZTGY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600529', '山东药玻', 'SDYB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600530', '交大昂立', 'JDAL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600531', '豫光金铅', 'YGJQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600532', '宏达矿业', 'HDKY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600533', '栖霞建设', 'QXJS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600535', '天士力', 'TSL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600536', '中国软件', 'ZGRJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600537', '亿晶光电', 'YJGD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600538', '国发股份', 'GFGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600539', '*ST狮头', '*STST', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600540', '新赛股份', 'XSGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600543', '莫高股份', 'MGGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600545', '卓郎智能', 'ZLZN', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600546', '山煤国际', 'SMGJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600547', '山东黄金', 'SDHJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600548', '深高速', 'SGS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600549', '厦门钨业', 'XMWY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600550', '保变电气', 'BBDQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600551', '时代出版', 'SDCB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600552', '凯盛科技', 'KSKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600555', '海航创新', 'HHCX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600556', 'ST慧球', 'STHQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600557', '康缘药业', 'KYYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600558', '大西洋', 'DXY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600559', '老白干酒', 'LBGJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600560', '金自天正', 'JZTZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600561', '江西长运', 'JXCY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600562', '国睿科技', 'G睿KJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600563', '法拉电子', 'FLDZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600565', '迪马股份', 'DMGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600566', '济川药业', 'JCYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600567', '山鹰纸业', 'SYZY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600568', '中珠医疗', 'ZZYL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600569', '安阳钢铁', 'AYGT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600570', '恒生电子', 'HSDZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600571', '信雅达', 'XYD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600572', '康恩贝', 'KEB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600573', '惠泉啤酒', 'HQPJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600575', '皖江物流', 'WJWL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600576', '祥源文化', 'XYWH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600577', '精达股份', 'JDGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600578', '京能电力', 'JNDL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600579', '天华院', 'THY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600580', '卧龙电气', 'WLDQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600581', '八一钢铁', 'BYGT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600582', '天地科技', 'TDKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600583', '海油工程', 'HYGC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600584', '长电科技', 'CDKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600585', '海螺水泥', 'HLSN', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600586', '金晶科技', 'JJKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600587', '新华医疗', 'XHYL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600588', '用友网络', 'YYWL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600589', '广东榕泰', 'GD榕T', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600590', '泰豪科技', 'THKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600592', '龙溪股份', 'LXGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600593', '大连圣亚', 'DLSY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600594', '益佰制药', 'YBZY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600595', '中孚实业', 'Z孚SY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600596', '新安股份', 'XAGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600597', '光明乳业', 'GMRY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600598', '北大荒', 'BDH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600599', '熊猫金控', 'XMJK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600600', '青岛啤酒', 'QDPJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600601', '方正科技', 'FZKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600602', '云赛智联', 'YSZL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600603', '广汇物流', 'GHWL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600604', '市北高新', 'SBGX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600605', '汇通能源', 'HTNY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600606', '绿地控股', 'LDKG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600608', 'ST沪科', 'STHK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600609', '金杯汽车', 'JBQC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600610', '*ST毅达', '*STYD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600611', '大众交通', 'DZJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600612', '老凤祥', 'LFX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600613', '神奇制药', 'SQZY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600614', '鹏起科技', 'PQKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600615', '丰华股份', 'FHGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600616', '金枫酒业', 'JFJY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600617', '国新能源', 'GXNY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600618', '氯碱化工', 'LJHG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600619', '海立股份', 'HLGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600620', '天宸股份', 'T宸GF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600621', '华鑫股份', 'H鑫GF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600622', '光大嘉宝', 'GDJB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600623', '华谊集团', 'HYJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600624', '复旦复华', 'FDFH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600626', '申达股份', 'SDGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600628', '新世界', 'XSJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600629', '华建集团', 'HJJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600630', '龙头股份', 'LTGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600633', '浙数文化', 'ZSWH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600634', '*ST富控', '*STFK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600635', '大众公用', 'DZGY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600636', '三爱富', 'SAF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600637', '东方明珠', 'DFMZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600638', '新黄浦', 'XHP', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600639', '浦东金桥', 'PDJQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600640', '号百控股', 'HBKG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600641', '万业企业', 'WYQY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600642', '申能股份', 'SNGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600643', '爱建集团', 'AJJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600644', '乐山电力', 'LSDL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600645', '中源协和', 'ZYXH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600647', '同达创业', 'TDCY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600648', '外高桥', 'WGQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600649', '城投控股', 'CTKG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600650', '锦江投资', 'JJTZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600651', '飞乐音响', 'FLYX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600652', '游久游戏', 'YJYX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600653', '申华控股', 'SHKG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600654', 'ST中安', 'STZA', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600655', '豫园股份', 'YYGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600656', '退市博元', 'TSBY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600657', '信达地产', 'XDDC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600658', '电子城', 'DZC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600660', '福耀玻璃', 'FYBL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600661', '新南洋', 'XNY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600662', '强生控股', 'QSKG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600663', '陆家嘴', 'LJZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600664', '哈药股份', 'HYGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600665', '天地源', 'TDY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600666', '奥瑞德', 'ARD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600667', '太极实业', 'TJSY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600668', '尖峰集团', 'JFJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600671', '天目药业', 'TMYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600673', '东阳光科', 'DYGK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600674', '川投能源', 'CTNY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600675', '中华企业', 'ZHQY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600676', '交运股份', 'JYGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600677', '航天通信', 'HTTX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600678', '四川金顶', 'SCJD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600679', '上海凤凰', 'SHFH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600680', '*ST上普', '*STSP', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600681', '百川能源', 'BCNY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600682', '南京新百', 'NJXB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600683', '京投发展', 'JTFZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600684', '珠江实业', 'ZJSY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600685', '中船防务', 'ZCFW', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600686', '金龙汽车', 'JLQC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600687', '刚泰控股', 'GTKG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600688', '上海石化', 'SHSH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600689', '上海三毛', 'SHSM', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600690', '青岛海尔', 'QDHE', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600691', '阳煤化工', 'YMHG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600692', '亚通股份', 'YTGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600693', '东百集团', 'DBJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600694', '大商股份', 'DSGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600695', '绿庭投资', 'LTTZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600696', 'ST岩石', 'STYS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600697', '欧亚集团', 'OYJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600698', '湖南天雁', 'HNTY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600699', '均胜电子', 'JSDZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600701', '*ST工新', '*STGX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600702', '舍得酒业', 'SDJY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600703', '三安光电', 'SAGD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600704', '物产中大', 'WCZD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600705', '中航资本', 'ZHZB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600706', '曲江文旅', 'QJWL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600707', '彩虹股份', 'CHGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600708', '光明地产', 'GMDC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600710', '苏美达', 'SMD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600711', '盛屯矿业', 'STKY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600712', '南宁百货', 'NNBH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600713', '南京医药', 'NJYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600714', '金瑞矿业', 'JRKY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600715', '文投控股', 'WTKG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600716', '凤凰股份', 'FHGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600717', '天津港', 'TJG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600718', '东软集团', 'DRJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600719', '大连热电', 'DLRD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600720', '祁连山', 'QLS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600721', '百花村', 'BHC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600722', '金牛化工', 'JNHG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600723', '首商股份', 'SSGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600724', '宁波富达', 'NBFD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600725', 'ST云维', 'STYW', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600726', '华电能源', 'HDNY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600727', '鲁北化工', 'LBHG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600728', '佳都科技', 'JDKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600729', '重庆百货', 'ZQBH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600730', '中国高科', 'ZGGK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600731', '湖南海利', 'HNHL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600732', 'ST新梅', 'STXM', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600733', 'S蓝谷', 'SLG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600734', '实达集团', 'SDJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600735', '新华锦', 'XHJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600736', '苏州高新', 'SZGX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600737', '中粮糖业', 'ZLTY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600738', '兰州民百', 'LZMB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600739', '辽宁成大', 'LNCD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600740', '山西焦化', 'SXJH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600741', '华域汽车', 'HYQC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600742', '一汽富维', 'YQFW', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600743', '华远地产', 'HYDC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600744', '华银电力', 'HYDL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600745', '闻泰科技', 'WTKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600746', '江苏索普', 'JSSP', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600747', 'ST大控', 'STDK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600748', '上实发展', 'SSFZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600749', '*ST藏旅', '*STCL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600750', '江中药业', 'JZYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600751', '海航科技', 'HHKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600753', '东方银星', 'DFYX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600754', '锦江股份', 'JJGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600755', '厦门国贸', 'XMGM', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600756', '浪潮软件', 'LCRJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600757', '长江传媒', 'CJCM', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600758', '红阳能源', 'HYNY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600759', '洲际油气', 'ZJYQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600760', '中航沈飞', 'ZHSF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600761', '安徽合力', 'AHHL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600763', '通策医疗', 'TCYL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600764', '中国海防', 'ZGHF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600765', '中航重机', 'ZHZJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600766', '园城黄金', 'YCHJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600767', 'ST运盛', 'STYS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600768', '宁波富邦', 'NBFB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600769', '祥龙电业', 'XLDY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600770', '综艺股份', 'ZYGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600771', '广誉远', 'GYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600773', '西藏城投', 'XCCT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600774', '汉商集团', 'HSJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600775', '南京熊猫', 'NJXM', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600776', '东方通信', 'DFTX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600777', '新潮能源', 'XCNY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600778', '*ST友好', '*STYH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600779', '水井坊', 'SJF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600780', '通宝能源', 'TBNY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600781', '辅仁药业', 'FRYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600782', '新钢股份', 'XGGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600783', '鲁信创投', 'LXCT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600784', '鲁银投资', 'LYTZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600785', '新华百货', 'XHBH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600787', '中储股份', 'ZCGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600789', '鲁抗医药', 'LKYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600790', '轻纺城', 'QFC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600791', '京能置业', 'JNZY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600792', '云煤能源', 'YMNY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600793', '宜宾纸业', 'YBZY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600794', '保税科技', 'BSKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600795', '国电电力', 'GDDL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600796', '钱江生化', 'QJSH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600797', '浙大网新', 'ZDWX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600798', '宁波海运', 'NBHY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600800', '天津磁卡', 'TJCK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600801', '华新水泥', 'HXSN', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600802', '福建水泥', 'FJSN', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600803', '新奥股份', 'XAGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600804', '鹏博士', 'PBS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600805', '悦达投资', 'YDTZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600806', '退市昆机', 'TSKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600807', '*ST天业', '*STTY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600808', '马钢股份', 'MGGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600809', '山西汾酒', 'SXFJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600810', '神马股份', 'SMGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600811', '东方集团', 'DFJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600812', '华北制药', 'HBZY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600814', '杭州解百', 'HZJB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600815', '厦工股份', 'XGGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600816', '安信信托', 'AXXT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600817', 'ST宏盛', 'STHS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600818', '中路股份', 'ZLGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600819', '耀皮玻璃', 'YPBL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600820', '隧道股份', 'SDGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600821', '津劝业', 'JQY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600822', '上海物贸', 'SHWM', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600823', '世茂股份', 'SMGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600824', '益民集团', 'YMJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600825', '新华传媒', 'XHCM', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600826', '兰生股份', 'LSGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600827', '百联股份', 'BLGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600828', '茂业商业', 'MYSY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600829', '人民同泰', 'RMTT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600830', '香溢融通', 'XYRT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600831', '广电网络', 'GDWL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600832', '东方明珠', 'DFMZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600833', '第一医药', 'DYYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600834', '申通地铁', 'STDT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600835', '上海机电', 'SHJD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600836', '界龙实业', 'JLSY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600837', '海通证券', 'HTZQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600838', '上海九百', 'SHJB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600839', '四川长虹', 'SCCH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600841', '上柴股份', 'SCGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600843', '上工申贝', 'SGSB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600844', '丹化科技', 'DHKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600845', '宝信软件', 'BXRJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600846', '同济科技', 'TJKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600847', '万里股份', 'WLGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600848', '上海临港', 'SHLG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600850', '华东电脑', 'HDDN', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600851', '海欣股份', 'HXGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600853', '龙建股份', 'LJGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600854', '春兰股份', 'CLGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600855', '航天长峰', 'HTCF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600856', '中天能源', 'ZTNY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600857', '宁波中百', 'NBZB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600858', '银座股份', 'YZGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600859', '王府井', 'WFJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600860', '京城股份', 'JCGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600861', '北京城乡', 'BJCX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600862', '中航高科', 'ZHGK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600863', '内蒙华电', 'NMHD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600864', '哈投股份', 'HTGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600865', '百大集团', 'BDJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600866', '星湖科技', 'XHKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600867', '通化东宝', 'THDB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600868', '梅雁吉祥', 'MYJX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600869', '智慧能源', 'ZHNY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600870', '*ST厦华', '*STXH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600871', '*ST油服', '*STYF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600872', '中炬高新', 'ZJGX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600873', '梅花生物', 'MHSW', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600874', '创业环保', 'CYHB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600875', '东方电气', 'DFDQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600876', '洛阳玻璃', 'LYBL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600877', 'ST嘉陵', 'STJL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600879', '航天电子', 'HTDZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600880', '博瑞传播', 'BRCB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600881', '亚泰集团', 'YTJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600882', '广泽股份', 'GZGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600883', '博闻科技', 'BWKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600884', '杉杉股份', 'SSGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600885', '宏发股份', 'HFGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600886', '国投电力', 'GTDL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600887', '伊利股份', 'YLGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600888', '新疆众和', 'XJZH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600889', '南京化纤', 'NJHX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600890', '中房股份', 'ZFGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600891', '秋林集团', 'QLJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600892', '大晟文化', 'D晟WH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600893', '航发动力', 'HFDL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600894', '广日股份', 'GRGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600895', '张江高科', 'ZJGK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600896', '*ST海投', '*STHT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600897', '厦门空港', 'XMKG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600898', '国美通讯', 'GMTX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600900', '长江电力', 'CJDL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600901', '江苏租赁', 'JSZL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600903', '贵州燃气', 'GZRQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600908', '无锡银行', 'WXYX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600909', '华安证券', 'HAZQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600917', '重庆燃气', 'ZQRQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600919', '江苏银行', 'JSYX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600926', '杭州银行', 'HZYX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600929', '湖南盐业', 'HNYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600933', '爱柯迪', 'AKD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600936', '广西广电', 'GXGD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600939', '重庆建工', 'ZQJG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600958', '东方证券', 'DFZQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600959', '江苏有线', 'JSYX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600960', '渤海汽车', 'BHQC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600961', '株冶集团', 'ZYJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600962', '国投中鲁', 'GTZL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600963', '岳阳林纸', 'YYLZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600965', '福成股份', 'FCGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600966', '博汇纸业', 'BHZY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600967', '内蒙一机', 'NMYJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600969', '郴电国际', 'CDGJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600970', '中材国际', 'ZCGJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600971', '恒源煤电', 'HYMD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600973', '宝胜股份', 'BSGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600975', '新五丰', 'XWF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600976', '健民集团', 'JMJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600977', '中国电影', 'ZGDY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600978', '宜华生活', 'YHSH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600979', '广安爱众', 'GAAZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600980', '北矿科技', 'BKKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600981', '汇鸿集团', 'HHJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600982', '宁波热电', 'NBRD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600983', '惠而浦', 'HEP', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600984', '建设机械', 'JSJX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600985', '雷鸣科化', 'LMKH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600986', '科达股份', 'KDGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600987', '航民股份', 'HMGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600988', '赤峰黄金', 'CFHJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600990', '四创电子', 'SCDZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600992', '贵绳股份', 'GSGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600993', '马应龙', 'MYL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600995', '文山电力', 'WSDL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600996', '贵广网络', 'GGWL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600997', '开滦股份', 'KLGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600998', '九州通', 'JZT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('600999', '招商证券', 'ZSZQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601000', '唐山港', 'TSG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601001', '大同煤业', 'DTMY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601002', '晋亿实业', 'JYSY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601003', '柳钢股份', 'LGGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601005', '重庆钢铁', 'ZQGT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601006', '大秦铁路', 'DQTL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601007', '金陵饭店', 'JLFD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601008', '连云港', 'LYG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601009', '南京银行', 'NJYX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601010', '文峰股份', 'WFGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601011', '宝泰隆', 'BTL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601012', '隆基股份', 'LJGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601015', '陕西黑猫', 'SXHM', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601016', '节能风电', 'JNFD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601018', '宁波港', 'NBG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601019', '山东出版', 'SDCB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601020', '华钰矿业', 'H钰KY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601021', '春秋航空', 'CQHK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601028', '玉龙股份', 'YLGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601038', '一拖股份', 'YTGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601058', '赛轮金宇', 'SLJY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601066', '中信建投', 'ZXJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601068', '中铝国际', 'ZLGJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601069', '西部黄金', 'XBHJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601086', '国芳集团', 'GFJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601088', '中国神华', 'ZGSH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601098', '中南传媒', 'ZNCM', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601099', '太平洋', 'TPY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601100', '恒立液压', 'HLYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601101', '昊华能源', '昊HNY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601106', '中国一重', 'ZGYZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601107', '四川成渝', 'SCCY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601108', '财通证券', 'CTZQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601111', '中国国航', 'ZGGH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601113', '华鼎股份', 'HDGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601116', '三江购物', 'SJGW', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601117', '中国化学', 'ZGHX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601118', '海南橡胶', 'HNXJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601126', '四方股份', 'SFGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601127', '小康股份', 'XKGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601128', '常熟银行', 'CSYX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601137', '博威合金', 'BWHJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601138', '工业富联', 'GYFL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601139', '深圳燃气', 'S圳RQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601155', '新城控股', 'XCKG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601158', '重庆水务', 'ZQSW', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601162', '天风证券', 'TFZQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601163', '三角轮胎', 'SJLT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601166', '兴业银行', 'XYYX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601168', '西部矿业', 'XBKY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601169', '北京银行', 'BJYX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601177', '杭齿前进', 'HCQJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601179', '中国西电', 'ZGXD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601186', '中国铁建', 'ZGTJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601188', '龙江交通', 'LJJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601198', '东兴证券', 'DXZQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601199', '江南水务', 'JNSW', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601200', '上海环境', 'SHHJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601208', '东材科技', 'DCKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601211', '国泰君安', 'GTJA', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601212', '白银有色', 'BYYS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601216', '君正集团', 'JZJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601218', '吉鑫科技', 'J鑫KJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601222', '林洋能源', 'LYNY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601225', '陕西煤业', 'SXMY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601226', '华电重工', 'HDZG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601228', '广州港', 'GZG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601229', '上海银行', 'SHYX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601231', '环旭电子', 'HXDZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601233', '桐昆股份', 'TKGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601238', '广汽集团', 'GQJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601258', '庞大集团', 'PDJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601288', '农业银行', 'NYYX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601299', '中国北车', 'ZGBC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601311', '骆驼股份', 'LTGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601318', '中国平安', 'ZGPA', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601319', '中国人保', 'ZGRB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601326', '秦港股份', 'QGGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601328', '交通银行', 'JTYX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601330', '绿色动力', 'LSDL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601333', '广深铁路', 'GSTL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601336', '新华保险', 'XHBX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601339', '百隆东方', 'BLDF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601360', '三六零', 'SLL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601366', '利群股份', 'LQGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601368', '绿城水务', 'LCSW', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601369', '陕鼓动力', 'SGDL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601375', '中原证券', 'ZYZQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601377', '兴业证券', 'XYZQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601388', '怡球资源', '怡QZY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601390', '中国中铁', 'ZGZT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601398', '工商银行', 'GSYX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601500', '通用股份', 'TYGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601515', '东风股份', 'DFGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601518', '吉林高速', 'JLGS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601519', '大智慧', 'DZH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601555', '东吴证券', 'DWZQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601558', 'ST锐电', 'STRD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601566', '九牧王', 'JMW', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601567', '三星医疗', 'SXYL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601577', '长沙银行', 'CSYX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601579', '会稽山', 'HJS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601588', '北辰实业', 'BCSY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601595', '上海电影', 'SHDY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601599', '鹿港文化', 'LGWH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601600', '中国铝业', 'ZGLY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601601', '中国太保', 'ZGTB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601606', '长城军工', 'CCJG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601607', '上海医药', 'SHYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601608', '中信重工', 'ZXZG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601611', '中国核建', 'ZGHJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601616', '广电电气', 'GDDQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601618', '中国中冶', 'ZGZY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601619', '嘉泽新能', 'JZXN', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601628', '中国人寿', 'ZGRS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601633', '长城汽车', 'CCQC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601636', '旗滨集团', 'QBJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601666', '平煤股份', 'PMGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601668', '中国建筑', 'ZGJZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601669', '中国电建', 'ZGDJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601677', '明泰铝业', 'MTLY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601678', '滨化股份', 'BHGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601688', '华泰证券', 'HTZQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601689', '拓普集团', 'TPJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601699', '潞安环能', 'LAHN', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601700', '风范股份', 'FFGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601717', '郑煤机', 'ZMJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601718', '际华集团', 'JHJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601727', '上海电气', 'SHDQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601766', '中国中车', 'ZGZC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601777', '力帆股份', 'LFGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601788', '光大证券', 'GDZQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601789', '宁波建工', 'NBJG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601798', '*ST蓝科', '*STLK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601799', '星宇股份', 'XYGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601800', '中国交建', 'ZGJJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601801', '皖新传媒', 'WXCM', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601808', '中海油服', 'ZHYF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601811', '新华文轩', 'XHWX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601818', '光大银行', 'GDYX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601828', '美凯龙', 'MKL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601838', '成都银行', 'CDYX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601857', '中国石油', 'ZGSY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601858', '中国科传', 'ZGKC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601860', '紫金银行', 'ZJYX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601866', '中远海发', 'ZYHF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601869', '长飞光纤', 'CFGX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601872', '招商轮船', 'ZSLC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601877', '正泰电器', 'ZTDQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601878', '浙商证券', 'ZSZQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601880', '大连港', 'DLG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601881', '中国银河', 'ZGYH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601882', '海天精工', 'HTJG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601886', '江河集团', 'JHJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601888', '中国国旅', 'ZGGL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601890', '亚星锚链', 'YXML', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601898', '中煤能源', 'ZMNY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601899', '紫金矿业', 'ZJKY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601900', '南方传媒', 'NFCM', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601901', '方正证券', 'FZZQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601908', '京运通', 'JYT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601918', '新集能源', 'XJNY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601919', '中远海控', 'ZYHK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601928', '凤凰传媒', 'FHCM', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601929', '吉视传媒', 'JSCM', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601933', '永辉超市', 'YHCS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601939', '建设银行', 'JSYX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601949', '中国出版', 'ZGCB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601952', '苏垦农发', 'SKNF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601958', '金钼股份', 'J钼GF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601965', '中国汽研', 'ZGQY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601966', '玲珑轮胎', 'L珑LT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601968', '宝钢包装', 'BGBZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601969', '海南矿业', 'HNKY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601985', '中国核电', 'ZGHD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601988', '中国银行', 'ZGYX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601989', '中国重工', 'ZGZG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601990', '南京证券', 'NJZQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601991', '大唐发电', 'DTFD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601992', '金隅集团', 'JYJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601996', '丰林集团', 'FLJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601997', '贵阳银行', 'GYYX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601998', '中信银行', 'ZXYX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('601999', '出版传媒', 'CBCM', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603000', '人民网', 'RMW', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603001', '奥康国际', 'AKGJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603002', '宏昌电子', 'HCDZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603003', '龙宇燃油', 'LYRY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603005', '晶方科技', 'JFKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603006', '联明股份', 'LMGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603007', '花王股份', 'HWGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603008', '喜临门', 'XLM', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603009', '北特科技', 'BTKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603010', '万盛股份', 'WSGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603011', '合锻智能', 'HDZN', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603012', '创力集团', 'CLJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603013', '亚普股份', 'YPGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603015', '弘讯科技', 'HXKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603016', '新宏泰', 'XHT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603017', '中衡设计', 'ZHSJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603018', '中设集团', 'ZSJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603019', '中科曙光', 'ZKSG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603020', '爱普股份', 'APGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603021', '山东华鹏', 'SDHP', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603022', '新通联', 'XTL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603023', '威帝股份', 'WDGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603025', '大豪科技', 'DHKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603026', '石大胜华', 'SDSH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603027', '千禾味业', 'QHWY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603028', '赛福天', 'SFT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603029', '天鹅股份', 'TEGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603030', '全筑股份', 'QZGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603031', '安德利', 'ADL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603032', '德新交运', 'DXJY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603033', '三维股份', 'SWGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603035', '常熟汽饰', 'CSQS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603036', '如通股份', 'RTGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603037', '凯众股份', 'KZGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603038', '华立股份', 'HLGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603039', '泛微网络', 'FWWL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603040', '新坐标', 'XZB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603041', '美思德', 'MSD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603042', '华脉科技', 'HMKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603043', '广州酒家', 'GZJJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603045', '福达合金', 'FDHJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603050', '科林电气', 'KLDQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603055', '台华新材', 'THXC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603056', '德邦股份', 'DBGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603058', '永吉股份', 'YJGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603059', '倍加洁', 'BJJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603060', '国检集团', 'GJJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603063', '禾望电气', 'HWDQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603066', '音飞储存', 'YFCC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603067', '振华股份', 'ZHGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603069', '海汽集团', 'HQJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603076', '乐惠国际', 'LHGJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603077', '和邦生物', 'HBSW', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603078', '江化微', 'JHW', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603079', '圣达生物', 'SDSW', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603080', '新疆火炬', 'XJHJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603081', '大丰实业', 'DFSY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603083', '剑桥科技', 'JQKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603085', '天成自控', 'TCZK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603086', '先达股份', 'XDGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603088', '宁波精达', 'NBJD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603089', '正裕工业', 'ZYGY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603090', '宏盛股份', 'HSGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603096', '新经典', 'XJD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603098', '森特股份', 'STGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603099', '长白山', 'CBS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603100', '川仪股份', 'CYGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603101', '汇嘉时代', 'HJSD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603103', '横店影视', 'HDYS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603105', '芯能科技', 'XNKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603106', '恒银金融', 'HYJR', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603108', '润达医疗', 'RDYL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603110', '东方材料', 'DFCL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603111', '康尼机电', 'KNJD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603113', '金能科技', 'JNKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603116', '红蜻蜓', 'H蜻蜓', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603117', '万林股份', 'WLGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603118', '共进股份', 'GJGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603121', '华培动力', 'HPDL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603123', '翠微股份', 'CWGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603126', '中材节能', 'ZCJN', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603127', '昭衍新药', 'ZYXY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603128', '华贸物流', 'HMWL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603129', '春风动力', 'CFDL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603131', '上海沪工', 'SHHG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603133', '碳元科技', 'TYKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603136', '天目湖', 'TMH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603138', '海量数据', 'HLSJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603139', '康惠制药', 'KHZY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603156', '养元饮品', 'YYYP', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603157', '拉夏贝尔', 'LXBE', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603158', '腾龙股份', 'TLGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603159', '上海亚虹', 'SHYH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603160', '汇顶科技', 'HDKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603161', '科华控股', 'KHKG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603165', '荣晟环保', 'R晟HB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603166', '福达股份', 'FDGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603167', '渤海轮渡', 'BHLD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603168', '莎普爱思', 'SPAS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603169', '兰石重装', 'LSZZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603177', '德创环保', 'DCHB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603178', '圣龙股份', 'SLGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603179', '新泉股份', 'XQGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603180', '金牌厨柜', 'JPCG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603181', '皇马科技', 'HMKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603183', '建研院', 'JYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603185', '上机数控', 'SJSK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603186', '华正新材', 'HZXC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603187', '海容冷链', 'HRLL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603188', 'ST亚邦', 'STYB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603189', '网达软件', 'WDRJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603192', '汇得科技', 'HDKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603196', '日播时尚', 'RBSS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603197', '保隆科技', 'BLKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603198', '迎驾贡酒', 'YJGJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603199', '九华旅游', 'JHLY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603200', '上海洗霸', 'SHXB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603203', '快克股份', 'KKGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603208', '江山欧派', 'JSOP', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603214', '爱婴室', 'AYS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603218', '日月股份', 'RYGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603220', '贝通信', 'BTX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603222', '济民制药', 'JMZY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603223', '恒通股份', 'HTGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603225', '新凤鸣', 'XFM', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603226', '菲林格尔', 'FLGE', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603227', '雪峰科技', 'XFKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603228', '景旺电子', 'JWDZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603229', '奥翔药业', 'AXYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603232', '格尔软件', 'GERJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603233', '大参林', 'DCL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603238', '诺邦股份', 'NBGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603239', '浙江仙通', 'ZJXT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603258', '电魂网络', 'DHWL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603259', '药明康德', 'YMKD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603260', '合盛硅业', 'HSGY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603266', '天龙股份', 'TLGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603268', '松发股份', 'SFGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603269', '海鸥股份', 'HOGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603277', '银都股份', 'YDGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603278', '大业股份', 'DYGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603283', '赛腾股份', 'STGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603286', '日盈电子', 'RYDZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603288', '海天味业', 'HTWY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603289', '泰瑞机器', 'TRJQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603297', '永新光学', 'YXGX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603298', '杭叉集团', 'HCJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603299', '井神股份', 'JSGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603300', '华铁科技', 'HTKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603301', '振德医疗', 'ZDYL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603303', '得邦照明', 'DBZM', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603305', '旭升股份', 'XSGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603306', '华懋科技', 'H懋KJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603308', '应流股份', 'YLGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603309', '维力医疗', 'WLYL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603311', '金海环境', 'JHHJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603313', '梦百合', 'MBH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603315', '福鞍股份', 'FAGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603316', '诚邦股份', 'CBGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603318', '派思股份', 'PSGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603319', '湘油泵', 'XYB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603320', '迪贝电气', 'DBDQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603321', '梅轮电梯', 'MLDT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603322', '超讯通信', 'CXTX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603323', '吴江银行', 'WJYX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603326', '我乐家居', 'WLJJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603328', '依顿电子', 'YDDZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603329', '上海雅仕', 'SHYS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603330', '上海天洋', 'SHTY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603331', '百达精工', 'BDJG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603333', '明星电缆', 'MXDL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603335', '迪生力', 'DSL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603336', '宏辉果蔬', 'HHGS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603337', '杰克股份', 'JKGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603338', '浙江鼎力', 'ZJDL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603339', '四方科技', 'SFKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603345', '安井食品', 'AJSP', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603348', '文灿股份', 'WCGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603355', '莱克电气', 'LKDQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603356', '华菱精工', 'HLJG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603357', '设计总院', 'SJZY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603358', '华达科技', 'HDKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603359', '东珠生态', 'DZST', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603360', '百傲化学', 'BAHX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603363', '傲农生物', 'ANSW', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603365', '水星家纺', 'SXJF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603366', '日出东方', 'RCDF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603367', '辰欣药业', 'CXYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603368', '柳药股份', 'LYGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603369', '今世缘', 'JSY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603377', '东方时尚', 'DFSS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603378', '亚士创能', 'YSCN', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603380', '易德龙', 'YDL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603383', '顶点软件', 'DDRJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603385', '惠达卫浴', 'HDWY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603386', '广东骏亚', 'GDJY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603387', '基蛋生物', 'JDSW', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603388', '元成股份', 'YCGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603389', '亚振家居', 'YZJJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603393', '新天然气', 'XTRQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603396', '金辰股份', 'JCGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603398', '邦宝益智', 'BBYZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603399', '吉翔股份', 'JXGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603416', '信捷电气', 'XJDQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603421', '鼎信通讯', 'DXTX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603429', '集友股份', 'JYGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603444', '吉比特', 'JBT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603456', '九洲药业', 'JZYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603458', '勘设股份', 'KSGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603466', '风语筑', 'FYZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603477', '振静股份', 'ZJGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603486', '科沃斯', 'KWS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603488', '展鹏科技', 'ZPKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603496', '恒为科技', 'HWKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603499', '翔港科技', 'XGKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603500', '祥和实业', 'XHSY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603501', '韦尔股份', 'WEGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603505', '金石资源', 'JSZY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603506', '南都物业', 'NDWY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603507', '振江股份', 'ZJGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603508', '思维列控', 'SWLK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603515', '欧普照明', 'OPZM', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603516', '淳中科技', 'CZKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603517', '绝味食品', 'JWSP', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603518', '维格娜丝', 'WGNS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603519', '立霸股份', 'LBGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603520', '司太立', 'STL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603527', '众源新材', 'ZYXC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603528', '多伦科技', 'DLKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603533', '掌阅科技', 'ZYKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603535', '嘉诚国际', 'JCGJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603536', '惠发股份', 'HFGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603538', '美诺华', 'MNH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603555', '贵人鸟', 'GRN', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603556', '海兴电力', 'HXDL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603557', '起步股份', 'QBGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603558', '健盛集团', 'JSJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603559', '中通国脉', 'ZTGM', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603566', '普莱柯', 'PLK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603567', '珍宝岛', 'ZBD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603568', '伟明环保', 'WMHB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603569', '长久物流', 'CJWL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603577', '汇金通', 'HJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603578', '三星新材', 'SXXC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603579', '荣泰健康', 'RTJK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603580', '艾艾精工', 'AAJG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603583', '捷昌驱动', 'JCQD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603585', '苏利股份', 'SLGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603586', '金麒麟', 'J麒麟', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603587', '地素时尚', 'DSSS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603588', '高能环境', 'GNHJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603589', '口子窖', 'KZJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603590', '康辰药业', 'KCYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603595', '东尼电子', 'DNDZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603596', '伯特利', 'BTL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603598', '引力传媒', 'YLCM', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603599', '广信股份', 'GXGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603600', '永艺股份', 'YYGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603601', '再升科技', 'ZSKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603602', '纵横通信', 'ZHTX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603603', '博天环境', 'BTHJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603605', '珀莱雅', '珀LY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603606', '东方电缆', 'DFDL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603607', '京华激光', 'JHJG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603608', '天创时尚', 'TCSS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603609', '禾丰牧业', 'HFMY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603611', '诺力股份', 'NLGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603612', '索通发展', 'STFZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603615', '茶花股份', 'CHGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603616', '韩建河山', 'HJHS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603617', '君禾股份', 'JHGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603618', '杭电股份', 'HDGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603619', '中曼石油', 'ZMSY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603626', '科森科技', 'KSKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603628', '清源股份', 'QYGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603629', '利通电子', 'LTDZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603630', '拉芳家化', 'LFJH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603633', '徕木股份', '徕MGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603636', '南威软件', 'NWRJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603637', '镇海股份', 'ZHGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603638', '艾迪精密', 'ADJM', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603639', '海利尔', 'HLE', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603648', '畅联股份', 'CLGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603650', '彤程新材', 'TCXC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603655', '朗博科技', 'LBKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603656', '泰禾光电', 'THGD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603657', '春光科技', 'CGKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603658', '安图生物', 'ATSW', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603659', '璞泰来', '璞TL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603660', '苏州科达', 'SZKD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603661', '恒林股份', 'HLGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603663', '三祥新材', 'SXXC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603665', '康隆达', 'KLD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603666', '亿嘉和', 'YJH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603667', '五洲新春', 'WZXC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603668', '天马科技', 'TMKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603669', '灵康药业', 'LKYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603676', '卫信康', 'WXK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603677', '奇精机械', 'QJJX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603678', '火炬电子', 'HJDZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603679', '华体科技', 'HTKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603680', '今创集团', 'JCJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603683', '晶华新材', 'JHXC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603685', '晨丰科技', 'CFKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603686', '龙马环卫', 'LMHW', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603688', '石英股份', 'SYGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603689', '皖天然气', 'WTRQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603690', '至纯科技', 'ZCKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603693', '江苏新能', 'JSXN', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603696', '安记食品', 'AJSP', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603698', '航天工程', 'HTGC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603699', '纽威股份', 'NWGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603701', '德宏股份', 'DHGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603703', '盛洋科技', 'SYKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603706', '东方环宇', 'DFHY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603707', '健友股份', 'JYGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603708', '家家悦', 'JJY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603709', '中源家居', 'ZYJJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603711', '香飘飘', 'XPP', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603712', '七一二', 'QYE', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603713', '密尔克卫', 'MEKW', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603716', '塞力斯', 'SLS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603717', '天域生态', 'TYST', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603718', '海利生物', 'HLSW', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603721', '中广天择', 'ZGTZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603722', '阿科力', 'AKL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603725', '天安新材', 'TAXC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603726', '朗迪集团', 'LDJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603727', '博迈科', 'BMK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603728', '鸣志电器', 'MZDQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603729', '龙韵股份', 'LYGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603730', '岱美股份', '岱MGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603733', '仙鹤股份', 'XHGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603737', '三棵树', 'SKS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603738', '泰晶科技', 'TJKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603757', '大元泵业', 'DYBY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603758', '秦安股份', 'QAGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603766', '隆鑫通用', 'L鑫TY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603767', '中马传动', 'ZMCD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603768', '常青股份', 'CQGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603773', '沃格光电', 'WGGD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603776', '永安行', 'YAX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603777', '来伊份', 'LYF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603778', '乾景园林', 'QJYL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603779', '威龙股份', 'WLGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603787', '新日股份', 'XRGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603788', '宁波高发', 'NBGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603789', '星光农机', 'XGNJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603790', '雅运股份', 'YYGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603797', '联泰环保', 'LTHB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603798', '康普顿', 'KPD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603799', '华友钴业', 'HY钴Y', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603800', '道森股份', 'DSGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603801', '志邦家居', 'ZBJJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603803', '瑞斯康达', 'RSKD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603806', '福斯特', 'FST', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603808', '歌力思', 'GLS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603809', '豪能股份', 'HNGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603810', 'N丰山', 'NFS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603811', '诚意药业', 'CYYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603813', '原尚股份', 'YSGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603816', '顾家家居', 'GJJJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603817', '海峡环保', 'HXHB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603818', '曲美家居', 'QMJJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603819', '神力股份', 'SLGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603822', '嘉澳环保', 'JAHB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603823', '百合花', 'BHH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603825', '华扬联众', 'HYLZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603826', '坤彩科技', 'KCKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603828', '柯利达', 'KLD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603829', '洛凯股份', 'LKGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603833', '欧派家居', 'OPJJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603838', '四通股份', 'STGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603839', '安正时尚', 'AZSS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603843', '正平股份', 'ZPGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603848', '好太太', 'HTT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603855', '华荣股份', 'HRGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603856', '东宏股份', 'DHGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603858', '步长制药', 'BCZY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603859', '能科股份', 'NKGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603860', '中公高科', 'ZGGK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603861', '白云电器', 'BYDQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603866', '桃李面包', 'TLMB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603868', '飞科电器', 'FKDQ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603869', '新智认知', 'XZRZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603871', '嘉友国际', 'JYGJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603876', '鼎胜新材', 'DSXC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603877', '太平鸟', 'TPN', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603878', '武进不锈', 'WJBX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603879', '永悦科技', 'YYKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603880', '南卫股份', 'NWGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603881', '数据港', 'SJG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603882', '金域医学', 'JYYX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603883', '老百姓', 'LBX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603885', '吉祥航空', 'JXHK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603886', '元祖股份', 'YZGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603887', '城地股份', 'CDGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603888', '新华网', 'XHW', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603889', '新澳股份', 'XAGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603890', '春秋电子', 'CQDZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603895', '天永智能', 'TYZN', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603896', '寿仙谷', 'SXG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603897', '长城科技', 'CCKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603898', '好莱客', 'HLK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603899', '晨光文具', 'CGWJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603900', '莱绅通灵', 'LSTL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603901', '永创智能', 'YCZN', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603903', '中持股份', 'ZCGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603906', '龙蟠科技', 'L蟠KJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603908', '牧高笛', 'MGD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603909', '合诚股份', 'HCGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603912', '佳力图', 'JLT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603916', '苏博特', 'SBT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603917', '合力科技', 'HLKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603918', '金桥信息', 'JQXX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603919', '金徽酒', 'JHJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603920', '世运电路', 'SYDL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603922', '金鸿顺', 'JHS', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603926', '铁流股份', 'TLGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603928', '兴业股份', 'XYGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603929', '亚翔集成', 'YXJC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603933', '睿能科技', '睿NKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603936', '博敏电子', 'BMDZ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603937', '丽岛新材', 'LDXC', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603938', '三孚股份', 'S孚GF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603939', '益丰药房', 'YFYF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603955', '大千生态', 'DQST', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603958', '哈森股份', 'HSGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603959', '百利科技', 'BLKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603960', '克来机电', 'KLJD', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603963', '大理药业', 'DLYY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603966', '法兰泰克', 'FLTK', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603968', '醋化股份', 'CHGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603969', '银龙股份', 'YLGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603970', '中农立华', 'ZNLH', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603976', '正川股份', 'ZCGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603977', '国泰集团', 'GTJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603978', '深圳新星', 'S圳XX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603979', '金诚信', 'JCX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603980', '吉华集团', 'JHJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603985', '恒润股份', 'HRGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603986', '兆易创新', 'ZYCX', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603987', '康德莱', 'KDL', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603988', '中电电机', 'ZDDJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603989', '艾华集团', 'AHJT', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603990', '麦迪科技', 'MDKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603991', '至正股份', 'ZZGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603993', '洛阳钼业', 'LY钼Y', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603996', '中新科技', 'ZXKJ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603997', '继峰股份', 'JFGF', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603998', '方盛制药', 'FSZY', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('603999', '读者传媒', 'DZCM', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900901', '云赛Ｂ股', 'YSＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900902', '市北B股', 'SBBG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900903', '大众Ｂ股', 'DZＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900904', '神奇B股', 'SQBG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900905', '老凤祥Ｂ', 'LFXＢ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900906', '*ST毅达B', '*STYDB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900907', '鹏起Ｂ股', 'PQＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900908', '氯碱Ｂ股', 'LJＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900909', '华谊B股', 'HYBG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900910', '海立Ｂ股', 'HLＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900911', '金桥Ｂ股', 'JQＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900912', '外高Ｂ股', 'WGＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900913', '国新B股', 'GXBG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900914', '锦投Ｂ股', 'JTＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900915', '中路Ｂ股', 'ZLＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900916', '凤凰B股', 'FHBG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900917', '海欣Ｂ股', 'HXＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900918', '耀皮Ｂ股', 'YPＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900919', '绿庭B股', 'LTBG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900920', '上柴Ｂ股', 'SCＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900921', '丹科B股', 'DKBG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900922', '三毛B股', 'SMBG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900923', '百联Ｂ股', 'BLＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900924', '上工Ｂ股', 'SGＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900925', '机电Ｂ股', 'JDＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900926', '宝信Ｂ', 'BXＢ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900927', '物贸Ｂ股', 'WMＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900928', '临港B股', 'LGBG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900929', '锦旅Ｂ股', 'JLＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900930', '*ST沪普B', '*STHPB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900932', '陆家Ｂ股', 'LJＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900933', '华新Ｂ股', 'HXＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900934', '锦江Ｂ股', 'JJＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900935', '阳晨Ｂ股', 'YCＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900936', '鄂资Ｂ股', 'EZＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900937', '华电Ｂ股', 'HDＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900938', '海科B', 'HKB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900939', '汇丽B', 'HLB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900940', '大名城B', 'DMCB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900941', '东信Ｂ股', 'DXＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900942', '黄山Ｂ股', 'HSＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900943', '开开Ｂ股', 'KKＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900945', '海控Ｂ股', 'HKＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900946', '天雁B股', 'TYBG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900947', '振华Ｂ股', 'ZHＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900948', '伊泰Ｂ股', 'YTＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900950', '新城Ｂ股', 'XCＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900951', 'ST大化B', 'STDHB', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900952', '锦港Ｂ股', 'JGＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900953', '凯马Ｂ', 'KMＢ', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900955', '海创B股', 'HCBG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900956', '东贝Ｂ股', 'DBＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);
INSERT INTO `sm_stock_para` VALUES ('900957', '凌云Ｂ股', 'LYＢG', 'SH', '1', '1', '1', '1', '0', '0', '0', null, null);

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
  `Title` varchar(50) NOT NULL COMMENT '标题',
  `Content` varchar(255) NOT NULL COMMENT '内容',
  `Time` datetime NOT NULL COMMENT '创建时间',
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
  `Number` varchar(30) NOT NULL COMMENT '交易单号',
  `TradeType` varchar(30) NOT NULL COMMENT '交易类型, 平仓，持仓',
  `MemberID` varchar(64) DEFAULT NULL COMMENT '会员ID',
  `TickerSymbol` varchar(30) NOT NULL COMMENT '股票代码',
  `TickerName` varchar(30) NOT NULL COMMENT '股票名称',
  `UnitPrice` double NOT NULL COMMENT '单价',
  `Hands` int(11) unsigned NOT NULL COMMENT '手数',
  `Amount` double NOT NULL COMMENT '交易金额',
  `Time` datetime NOT NULL COMMENT '时间',
  `OpID` varchar(64) DEFAULT NULL COMMENT '操作人',
  `Note` varchar(255) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`Number`),
  KEY `FK_Reference_10` (`MemberID`),
  KEY `TradeType` (`TradeType`),
  CONSTRAINT `FK_Reference_10` FOREIGN KEY (`MemberID`) REFERENCES `sm_user_member` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='交易账单表';

-- ----------------------------
-- Records of sm_trade_bill
-- ----------------------------

-- ----------------------------
-- Table structure for sm_trade_type
-- ----------------------------
DROP TABLE IF EXISTS `sm_trade_type`;
CREATE TABLE `sm_trade_type` (
  `ID` int(5) unsigned NOT NULL COMMENT '购买类型，0多，1空',
  `Description` varchar(255) NOT NULL COMMENT '描述，多，空',
  `Coefficient` int(11) NOT NULL COMMENT '系数 多1 空-1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sm_trade_type
-- ----------------------------
INSERT INTO `sm_trade_type` VALUES ('0', '多', '1');
INSERT INTO `sm_trade_type` VALUES ('1', '空', '-1');

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
  `RoleID` varchar(64) NOT NULL COMMENT '用户类型ID',
  `Lock` tinyint(1) unsigned zerofill NOT NULL,
  PRIMARY KEY (`ID`,`LoginName`),
  KEY `FK_Reference_4` (`RoleID`),
  CONSTRAINT `FK_Reference_4` FOREIGN KEY (`RoleID`) REFERENCES `sm_user_role` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户表';

-- ----------------------------
-- Records of sm_user
-- ----------------------------
INSERT INTO `sm_user` VALUES ('1', 'superadmin', 'superadmin', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', '2019-07-10 14:42:39', '2019-07-28 22:42:47', null, '0', 'eabbb5362bedec4981e460c40e60a55b', '0');

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
  `Margin` double NOT NULL COMMENT '保证金',
  `TestMargin` double NOT NULL COMMENT '测试保证金',
  `CommissionRatio` double DEFAULT NULL COMMENT '交易佣金分成',
  `ExchangeRate` double DEFAULT NULL COMMENT '人民币与股币兑换',
  `MemberPrefix` varchar(255) DEFAULT NULL COMMENT '会员账号前缀',
  `MemberNum` int(10) unsigned zerofill NOT NULL COMMENT '当前会员数量',
  `MemberMaximum` int(11) unsigned zerofill NOT NULL COMMENT '可创建会员数量限制',
  `Bank` varchar(255) DEFAULT NULL COMMENT '收款银行',
  `BankAccount` varchar(30) NOT NULL COMMENT '银行账号',
  `Cardholder` varchar(30) DEFAULT NULL COMMENT '银行账户名',
  `OpeningBank` varchar(30) DEFAULT NULL COMMENT '开户行',
  `WithdrawPassWord` varchar(64) NOT NULL COMMENT '取款密码',
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
  `Time` datetime NOT NULL COMMENT '发生时间',
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
  `Margin` double NOT NULL COMMENT '保证金',
  `Earning` double NOT NULL DEFAULT '0' COMMENT '客户总盈亏',
  `PhoneNum` varchar(20) DEFAULT NULL COMMENT '手机号码',
  `BuyFeeRate` double NOT NULL COMMENT '买入手续费',
  `SellFeeRate` double NOT NULL COMMENT '卖出手续费',
  `RiseFallSpreadRate` double NOT NULL COMMENT '涨跌点差率',
  `Bank` varchar(255) DEFAULT NULL COMMENT '收款银行',
  `BankAccount` varchar(30) NOT NULL COMMENT '银行账户',
  `Cardholder` varchar(30) DEFAULT NULL COMMENT '银行账户名',
  `OpeningBank` varchar(30) DEFAULT NULL COMMENT '开户行',
  `WithdrawPassWord` varchar(64) NOT NULL COMMENT '取款密码',
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
