ALTER TABLE `sm_user_admin` DROP FOREIGN KEY `FK_Reference_1`;
ALTER TABLE `sm_user_agent` DROP FOREIGN KEY `FK_Reference_2`;
ALTER TABLE `sm_user_member` DROP FOREIGN KEY `FK_Reference_3`;
ALTER TABLE `sm_user` DROP FOREIGN KEY `FK_Reference_4`;
ALTER TABLE `sm_clerk` DROP FOREIGN KEY `FK_Reference_5`;
ALTER TABLE `sm_user_member` DROP FOREIGN KEY `FK_Reference_6`;
ALTER TABLE `sm_user_member` DROP FOREIGN KEY `FK_Reference_7`;
ALTER TABLE `sm_buy_trade` DROP FOREIGN KEY `FK_Reference_8`;
ALTER TABLE `sm_sell_trade` DROP FOREIGN KEY `FK_Reference_9`;
ALTER TABLE `sm_trade_bill` DROP FOREIGN KEY `FK_Reference_10`;
ALTER TABLE `sm_user_log` DROP FOREIGN KEY `FK_Reference_11`;
ALTER TABLE `sm_sys_notice` DROP FOREIGN KEY `FK_Reference_12`;
ALTER TABLE `sm_close_plan` DROP FOREIGN KEY `FK_Reference_13`;
ALTER TABLE `sm_manual_trade` DROP FOREIGN KEY `FK_Reference_14`;
ALTER TABLE `sm_manual_trade` DROP FOREIGN KEY `FK_Reference_15`;
ALTER TABLE `sm_recharge` DROP FOREIGN KEY `FK_Reference_16`;
ALTER TABLE `sm_agent_drawing` DROP FOREIGN KEY `FK_Reference_17`;
ALTER TABLE `sm_member_drawing` DROP FOREIGN KEY `FK_Reference_18`;

DROP TABLE `sm_user` CASCADE;
DROP TABLE `sm_user_admin` CASCADE;
DROP TABLE `sm_user_agent` CASCADE;
DROP TABLE `sm_user_member` CASCADE;
DROP TABLE `sm_user_role` CASCADE;
DROP TABLE `sm_clerk` CASCADE;
DROP TABLE `sm_buy_trade` CASCADE;
DROP TABLE `sm_sell_trade` CASCADE;
DROP TABLE `sm_trade_bill` CASCADE;
DROP TABLE `sm_user_log` CASCADE;
DROP TABLE `sm_sys_notice` CASCADE;
DROP TABLE `sm_close_plan` CASCADE;
DROP TABLE `sm_sys_conf` CASCADE;
DROP TABLE `sm_stock_para` CASCADE;
DROP TABLE `sm_manual_trade` CASCADE;
DROP TABLE `sm_recharge` CASCADE;
DROP TABLE `sm_agent_drawing` CASCADE;
DROP TABLE `sm_member_drawing` CASCADE;

CREATE TABLE `sm_user` (
`ID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '管理员表ID主键',
`LoginName` varchar(64) NOT NULL COMMENT '登录名',
`NickName` varchar(64) NOT NULL COMMENT '昵称',
`Password` varchar(255) NOT NULL COMMENT '密码',
`CreateTime` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
`LastLogonTime` datetime NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '上次登录时间',
`CreatorID` int(11) UNSIGNED NULL COMMENT '创建者ID',
`Forbidden` tinyint(1) NOT NULL COMMENT '是否禁用， 默认不禁用',
`RoleID` int(11) UNSIGNED NULL COMMENT '用户类型ID',
PRIMARY KEY (`ID`, `LoginName`) 
)
COMMENT = '用户表';

CREATE TABLE `sm_user_admin` (
`ID` int(11) UNSIGNED NOT NULL COMMENT '管理员ID',
PRIMARY KEY (`ID`) 
)
COMMENT = '管理员表';

CREATE TABLE `sm_user_agent` (
`ID` int(11) UNSIGNED NOT NULL COMMENT '代理ID',
`Margin` double NULL COMMENT '保证金',
`TestMargin` double NULL COMMENT '测试保证金',
`CommissionRatio` double NULL COMMENT '交易佣金分成',
`ExchangeRate` double NULL COMMENT '人民币与股币兑换',
`MemberPrefix` varchar(255) NULL COMMENT '会员账号前缀',
`MemberMaximum` int(11) UNSIGNED NULL COMMENT '可创建会员数量限制',
`Bank` varchar(255) NULL COMMENT '收款银行',
`BankAccount` varchar(30) NULL COMMENT '银行账号',
`Cardholder` varchar(30) NULL COMMENT '银行账户名',
`WithdrawPassWord` varchar(30) NULL COMMENT '取款密码',
`Type` int(11) NULL COMMENT '账户类型，正式，测试，其他',
`AgentLevel` int(11) UNSIGNED NOT NULL COMMENT '代理用户等级（甄别多级代理）',
`Lock` tinyint(1) NOT NULL COMMENT '锁定',
PRIMARY KEY (`ID`) 
)
COMMENT = '代理表';

CREATE TABLE `sm_user_member` (
`ID` int(11) UNSIGNED NOT NULL COMMENT '会员ID',
`AgentID` int(11) UNSIGNED NOT NULL COMMENT '归属的代理账号id',
`ClerkID` int(11) UNSIGNED NULL COMMENT '业务员ID',
`CustomerName` varchar(30) NULL COMMENT '客户姓名',
`Margin` double NULL COMMENT '保证金',
`PhoneNum` varchar(20) NULL COMMENT '手机号码',
`BuyFeeRate` double NULL COMMENT '买入手续费',
`SellFeeRate` double NULL COMMENT '卖出手续费',
`RiseFallSpreadRate` double NULL COMMENT '涨跌点差率',
`Bank` varchar(255) NULL COMMENT '收款银行',
`BankAccount` varchar(30) NULL COMMENT '银行账户',
`Cardholder` varchar(30) NULL COMMENT '银行账户名',
`OpeningBank` varchar(30) NULL COMMENT '开户行',
`WithdrawPassWord` varchar(30) NULL COMMENT '取款密码',
`EmailAddress` varchar(50) NULL COMMENT '邮箱地址',
`QQNum` varchar(20) NULL COMMENT 'QQ号',
`Type` int(11) NULL COMMENT '账户类型，正式，测试，其他',
`Lock` tinyint(1) NULL COMMENT '是否锁定',
PRIMARY KEY (`ID`) 
)
COMMENT = '会员表';

CREATE TABLE `sm_user_role` (
`ID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户类型id',
`Name` char(50) NOT NULL COMMENT '名称',
`Description` varchar(255) NULL COMMENT '描述',
PRIMARY KEY (`ID`) 
)
COMMENT = '用户组表';

CREATE TABLE `sm_clerk` (
`ID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '业务员ID',
`AgentID` int(11) UNSIGNED NOT NULL COMMENT '创建的代理的ID',
`NickName` varchar(255) NULL COMMENT '名称',
`Forbidden` tinyint(1) NULL COMMENT '是否禁用，默认不禁用',
PRIMARY KEY (`ID`) 
)
COMMENT = '业务员表';

CREATE TABLE `sm_buy_trade` (
`ID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '持仓id',
`Number` varchar(30) NOT NULL COMMENT '单号',
`MemberID` int(11) UNSIGNED NULL COMMENT '会员ID',
`TradeTime` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '购买时间',
`TickerSymbol` varchar(30) NOT NULL COMMENT '股票代码',
`Price` double NOT NULL COMMENT '购买价格',
`Hands` int(11) UNSIGNED NOT NULL COMMENT '手数',
`BuyType` int(5) UNSIGNED NOT NULL COMMENT '购买类型（多/空）',
`BuyFeeRate` double NULL COMMENT '买入手续费',
`StoreFeeRate` double NULL COMMENT '留仓费',
`RiseFallSpreadRate` double NULL COMMENT '点差费',
PRIMARY KEY (`ID`) 
)
COMMENT = '用户持仓表';

CREATE TABLE `sm_sell_trade` (
`ID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '平仓ID',
`MemberID` int(11) UNSIGNED NULL COMMENT '会员ID',
`TickerSymbol` varchar(30) NOT NULL COMMENT '股票代码',
`BuyNumber` varchar(30) NOT NULL COMMENT '购买单号',
`BuyTime` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '购买时间',
`BuyPrice` double NOT NULL COMMENT '购买价格',
`SellNumber` varchar(30) NOT NULL COMMENT '售出编码',
`SellTime` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '售出时间',
`SellPrice` double NOT NULL COMMENT '售出价格',
`BuyType` int(5) UNSIGNED NOT NULL COMMENT '购买类型（多/空）',
`Fee` double NOT NULL COMMENT '手续费',
`Interest` double NOT NULL COMMENT '融资利息',
`StampDuty` double NOT NULL COMMENT '印花税',
`Profit` double NOT NULL COMMENT '收益',
PRIMARY KEY (`ID`) 
)
COMMENT = '用户平仓表';

CREATE TABLE `sm_trade_bill` (
`ID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '交易账单ID',
`Number` varchar(30) NOT NULL COMMENT '交易单号',
`TradeType` int(5) UNSIGNED NOT NULL COMMENT '交易类型',
`MemberID` int(11) UNSIGNED NULL COMMENT '会员ID',
`TickerSymbol` varchar(30) NOT NULL COMMENT '股票代码',
`TickerName` varchar(30) NOT NULL COMMENT '股票名称',
`UnitPrice` double NOT NULL COMMENT '单价',
`Hands` int(11) UNSIGNED NOT NULL COMMENT '手数',
`Amount` double NOT NULL COMMENT '交易金额',
`Time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '时间',
`OpID` int(11) UNSIGNED NULL COMMENT '操作人',
`Note` varchar(255) NULL COMMENT '备注',
PRIMARY KEY (`ID`) 
)
COMMENT = '交易账单表';

CREATE TABLE `sm_user_log` (
`ID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '日志id',
`UserID` int(11) UNSIGNED NULL COMMENT '操作者',
`Type` varchar(50) NULL COMMENT '操作类型',
`Model` varchar(50) NULL COMMENT '操作模块',
`Time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '发生时间',
`Note` varchar(255) NULL COMMENT '操作记录',
PRIMARY KEY (`ID`) 
)
COMMENT = '用户日志记录';

CREATE TABLE `sm_sys_notice` (
`ID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '公告编号',
`CreatorID` int(11) UNSIGNED NOT NULL COMMENT '创建者ID',
`Title` varchar(50) NULL COMMENT '标题',
`Content` varchar(255) NULL COMMENT '内容',
`Time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
`AgentDisable` tinyint(1) NOT NULL COMMENT '代理不显示',
`MemberDisable` tinyint(1) NOT NULL COMMENT '成员不显示',
PRIMARY KEY (`ID`) 
)
COMMENT = '系统公告表';

CREATE TABLE `sm_close_plan` (
`ID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '编号',
`CreatorID` int(11) UNSIGNED NULL COMMENT '管理员ID',
`PlanDate` date NOT NULL COMMENT '休市日期',
`Time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
`Note` varchar(255) NULL COMMENT '备注',
PRIMARY KEY (`ID`) 
)
COMMENT = '休市安排';

CREATE TABLE `sm_sys_conf` (
`Key` varchar(100) NOT NULL COMMENT '配置的键值',
`Value` varchar(255) NOT NULL COMMENT '值',
`Description` varchar(255) NULL COMMENT '描述',
PRIMARY KEY (`Key`) 
)
COMMENT = '系统配置表';

CREATE TABLE `sm_stock_para` (
`TickerSymbol` varchar(30) NOT NULL COMMENT '股票代码',
`Name` varchar(50) NULL COMMENT '股票名称',
`Abridge` varchar(30) NULL COMMENT '拼音缩写',
`Type` varchar(30) NULL COMMENT '股票类型',
`BuyByBullish` tinyint(1) NULL DEFAULT 1 COMMENT '可买多',
`BuyByBearish` tinyint(1) NULL DEFAULT 1 COMMENT '可买空',
`Buiable` tinyint(1) NULL DEFAULT 1 COMMENT '可买的',
`Sellable` tinyint(1) NULL DEFAULT 1 COMMENT '可卖的',
`Close` tinyint(1) NULL COMMENT '关盘',
`Suspend` tinyint(1) NULL COMMENT '停牌',
`SuspendTime` datetime NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '停牌时间',
`Forbidden` tinyint(1) NULL COMMENT '禁用',
`Note` varchar(255) NULL COMMENT '备注',
PRIMARY KEY (`TickerSymbol`) 
);

CREATE TABLE `sm_manual_trade` (
`ID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
`MemberID` int(11) UNSIGNED NULL COMMENT '会员id',
`OpType` varchar(20) NULL COMMENT '操作类型',
`DetailType` varchar(50) NULL,
`CreatorID` int(11) UNSIGNED NULL COMMENT '管理员ID',
`CreateTime` datetime NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
`Value` int(11) UNSIGNED NOT NULL COMMENT '金额',
`Note` varchar(255) NULL COMMENT '备注',
PRIMARY KEY (`ID`) 
)
COMMENT = '手动入扣款';

CREATE TABLE `sm_recharge` (
`Number` varchar(50) NOT NULL COMMENT '订单号',
`MemberID` int(11) UNSIGNED NULL COMMENT '参与者',
`Value` double NULL COMMENT '充值金额',
`OrderIP` varchar(30) NULL COMMENT '下单的IP',
`CreateTime` datetime NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
`SNumber` varchar(50) NULL COMMENT '流水号',
`VendorNumber` varchar(50) NULL COMMENT '商家号',
`Bank` varchar(50) NULL COMMENT '银行',
`DepositIP` varchar(30) NULL COMMENT '存款IP',
`DepositTime` datetime NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '存款时间',
`DepositStatus` varchar(50) NULL COMMENT '存款状态',
`Note` varchar(255) NULL COMMENT '备注',
PRIMARY KEY (`Number`) 
)
COMMENT = '充值管理表';

CREATE TABLE `sm_agent_drawing` (
`ID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '提款ID',
`AgentID` int(11) UNSIGNED NOT NULL COMMENT '目标账户ID',
`DrawingTime` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '提款日期',
`DrawingValue` double NOT NULL COMMENT '提款金额',
`Bank` varchar(50) NULL COMMENT '银行',
`BankOfDeposit` varchar(50) NULL COMMENT '开户行',
`BankAccount` varchar(50) NOT NULL COMMENT '银行账户',
`DrawingStatus` int(5) NOT NULL COMMENT '提款状态',
`ChangeTime` datetime NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '处理时间',
PRIMARY KEY (`ID`) 
)
COMMENT = '代理提款';

CREATE TABLE `sm_member_drawing` (
`ID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '会员提款ID',
`MemberID` int(11) UNSIGNED NULL COMMENT '会员ID',
`DrawingTime` datetime NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '提款日期',
`DrawingValue` double NOT NULL COMMENT '提款金额',
`Bank` varchar(50) NULL COMMENT '银行',
`BankOfDeposit` varchar(50) NULL COMMENT '开户行',
`BankAccountName` varchar(20) NULL COMMENT '账户名',
`BankAccount` varchar(50) NOT NULL COMMENT '银行账户',
`DrawingStatus` int(5) NOT NULL COMMENT '提款状态',
`ChangeTime` datetime NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '处理时间',
`Note` varchar(255) NULL COMMENT '备注',
PRIMARY KEY (`ID`) 
)
COMMENT = '会员提款表';


ALTER TABLE `sm_user_admin` ADD CONSTRAINT `FK_Reference_1` FOREIGN KEY (`ID`) REFERENCES `sm_user` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `sm_user_agent` ADD CONSTRAINT `FK_Reference_2` FOREIGN KEY (`ID`) REFERENCES `sm_user` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `sm_user_member` ADD CONSTRAINT `FK_Reference_3` FOREIGN KEY (`ID`) REFERENCES `sm_user` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `sm_user` ADD CONSTRAINT `FK_Reference_4` FOREIGN KEY (`RoleID`) REFERENCES `sm_user_role` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `sm_clerk` ADD CONSTRAINT `FK_Reference_5` FOREIGN KEY (`AgentID`) REFERENCES `sm_user_agent` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `sm_user_member` ADD CONSTRAINT `FK_Reference_6` FOREIGN KEY (`ClerkID`) REFERENCES `sm_clerk` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE `sm_user_member` ADD CONSTRAINT `FK_Reference_7` FOREIGN KEY (`AgentID`) REFERENCES `sm_user_agent` (`ID`) ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE `sm_buy_trade` ADD CONSTRAINT `FK_Reference_8` FOREIGN KEY (`MemberID`) REFERENCES `sm_user_member` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `sm_sell_trade` ADD CONSTRAINT `FK_Reference_9` FOREIGN KEY (`MemberID`) REFERENCES `sm_user_member` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `sm_trade_bill` ADD CONSTRAINT `FK_Reference_10` FOREIGN KEY (`MemberID`) REFERENCES `sm_user_member` (`ID`) ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE `sm_user_log` ADD CONSTRAINT `FK_Reference_11` FOREIGN KEY (`UserID`) REFERENCES `sm_user` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE `sm_sys_notice` ADD CONSTRAINT `FK_Reference_12` FOREIGN KEY (`CreatorID`) REFERENCES `sm_user_admin` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE `sm_close_plan` ADD CONSTRAINT `FK_Reference_13` FOREIGN KEY (`CreatorID`) REFERENCES `sm_user_admin` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE `sm_manual_trade` ADD CONSTRAINT `FK_Reference_14` FOREIGN KEY (`MemberID`) REFERENCES `sm_user_member` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE `sm_manual_trade` ADD CONSTRAINT `FK_Reference_15` FOREIGN KEY (`CreatorID`) REFERENCES `sm_user_admin` (`ID`) ON DELETE SET NULL ON UPDATE SET NULL;
ALTER TABLE `sm_recharge` ADD CONSTRAINT `FK_Reference_16` FOREIGN KEY (`MemberID`) REFERENCES `sm_user_member` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE `sm_agent_drawing` ADD CONSTRAINT `FK_Reference_17` FOREIGN KEY (`AgentID`) REFERENCES `sm_user_agent` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `sm_member_drawing` ADD CONSTRAINT `FK_Reference_18` FOREIGN KEY (`MemberID`) REFERENCES `sm_user_member` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

