# coding: utf-8
from sqlalchemy import Column, Date, DateTime, Float, ForeignKey, Integer, String
from sqlalchemy.orm import relationship
from sqlalchemy.schema import FetchedValue
from flask_sqlalchemy import SQLAlchemy


db = SQLAlchemy()


class SmAgentDrawing(db.Model):
    __tablename__ = 'sm_agent_drawing'

    ID = db.Column(db.String(64), primary_key=True)
    AgentID = db.Column(db.ForeignKey('sm_user_agent.ID'), nullable=False, index=True)
    DrawingTime = db.Column(db.DateTime, nullable=False)
    DrawingValue = db.Column(db.Float(asdecimal=True), nullable=False)
    Bank = db.Column(db.String(50))
    BankOfDeposit = db.Column(db.String(50))
    BankAccount = db.Column(db.String(50), nullable=False)
    DrawingStatus = db.Column(db.Integer, nullable=False)
    ChangeTime = db.Column(db.DateTime)

    sm_user_agent = db.relationship('SmUserAgent', primaryjoin='SmAgentDrawing.AgentID == SmUserAgent.ID', backref='sm_agent_drawings')


class SmBuyTrade(db.Model):
    __tablename__ = 'sm_buy_trade'

    ID = db.Column(db.String(64), primary_key=True)
    Number = db.Column(db.String(30), nullable=False)
    MemberID = db.Column(db.ForeignKey('sm_user_member.ID'), nullable=False, index=True)
    TradeTime = db.Column(db.DateTime, nullable=False)
    TickerSymbol = db.Column(db.String(30), nullable=False)
    Price = db.Column(db.Float(asdecimal=True), nullable=False)
    Hands = db.Column(db.Integer, nullable=False)
    BuyType = db.Column(db.Integer, nullable=False)
    BuyFeeRate = db.Column(db.Float(asdecimal=True))
    StoreFeeRate = db.Column(db.Float(asdecimal=True))
    RiseFallSpreadRate = db.Column(db.Float(asdecimal=True))

    sm_user_member = db.relationship('SmUserMember', primaryjoin='SmBuyTrade.MemberID == SmUserMember.ID', backref='sm_buy_trades')


class SmClerk(db.Model):
    __tablename__ = 'sm_clerk'

    ID = db.Column(db.String(64), primary_key=True)
    AgentID = db.Column(db.ForeignKey('sm_user_agent.ID'), nullable=False, index=True)
    NickName = db.Column(db.String(255))
    Forbidden = db.Column(db.Integer)

    sm_user_agent = db.relationship('SmUserAgent', primaryjoin='SmClerk.AgentID == SmUserAgent.ID', backref='sm_clerks')


class SmClosePlan(db.Model):
    __tablename__ = 'sm_close_plan'

    ID = db.Column(db.String(64), primary_key=True)
    CreatorID = db.Column(db.ForeignKey('sm_user_admin.ID', ondelete='SET NULL', onupdate='CASCADE'), index=True)
    PlanDate = db.Column(db.Date, nullable=False)
    Time = db.Column(db.DateTime, nullable=False)
    Note = db.Column(db.String(255))

    sm_user_admin = db.relationship('SmUserAdmin', primaryjoin='SmClosePlan.CreatorID == SmUserAdmin.ID', backref='sm_close_plans')


class SmManualTrade(db.Model):
    __tablename__ = 'sm_manual_trade'

    ID = db.Column(db.String(64), primary_key=True)
    MemberID = db.Column(db.ForeignKey('sm_user_member.ID'), index=True)
    OpType = db.Column(db.String(20))
    DetailType = db.Column(db.String(50))
    CreatorID = db.Column(db.ForeignKey('sm_user_admin.ID'), index=True)
    CreateTime = db.Column(db.DateTime)
    Value = db.Column(db.Integer, nullable=False)
    Note = db.Column(db.String(255))

    sm_user_admin = db.relationship('SmUserAdmin', primaryjoin='SmManualTrade.CreatorID == SmUserAdmin.ID', backref='sm_manual_trades')
    sm_user_member = db.relationship('SmUserMember', primaryjoin='SmManualTrade.MemberID == SmUserMember.ID', backref='sm_manual_trades')


class SmMemberDrawing(db.Model):
    __tablename__ = 'sm_member_drawing'

    ID = db.Column(db.String(64), primary_key=True)
    MemberID = db.Column(db.ForeignKey('sm_user_member.ID'), nullable=False, index=True)
    DrawingTime = db.Column(db.DateTime)
    DrawingValue = db.Column(db.Float(asdecimal=True), nullable=False)
    Bank = db.Column(db.String(50))
    BankOfDeposit = db.Column(db.String(50))
    BankAccountName = db.Column(db.String(20))
    BankAccount = db.Column(db.String(50), nullable=False)
    DrawingStatus = db.Column(db.Integer, nullable=False)
    ChangeTime = db.Column(db.DateTime)
    Note = db.Column(db.String(255))

    sm_user_member = db.relationship('SmUserMember', primaryjoin='SmMemberDrawing.MemberID == SmUserMember.ID', backref='sm_member_drawings')


class SmRecharge(db.Model):
    __tablename__ = 'sm_recharge'

    Number = db.Column(db.String(64), primary_key=True)
    MemberID = db.Column(db.ForeignKey('sm_user_member.ID'), index=True)
    Value = db.Column(db.Float(asdecimal=True))
    OrderIP = db.Column(db.String(30))
    CreateTime = db.Column(db.DateTime)
    SNumber = db.Column(db.String(50))
    VendorNumber = db.Column(db.String(50))
    Bank = db.Column(db.String(50))
    DepositIP = db.Column(db.String(30))
    DepositTime = db.Column(db.DateTime)
    DepositStatus = db.Column(db.String(50))
    Note = db.Column(db.String(255))

    sm_user_member = db.relationship('SmUserMember', primaryjoin='SmRecharge.MemberID == SmUserMember.ID', backref='sm_recharges')


class SmSellTrade(db.Model):
    __tablename__ = 'sm_sell_trade'

    ID = db.Column(db.String(64), primary_key=True)
    MemberID = db.Column(db.ForeignKey('sm_user_member.ID', ondelete='SET NULL', onupdate='CASCADE'), index=True)
    TickerSymbol = db.Column(db.String(30), nullable=False)
    BuyNumber = db.Column(db.String(30), nullable=False)
    BuyTime = db.Column(db.DateTime, nullable=False)
    BuyPrice = db.Column(db.Float(asdecimal=True), nullable=False)
    SellNumber = db.Column(db.String(30), nullable=False)
    SellTime = db.Column(db.DateTime, nullable=False)
    SellPrice = db.Column(db.Float(asdecimal=True), nullable=False)
    BuyType = db.Column(db.Integer, nullable=False)
    Fee = db.Column(db.Float(asdecimal=True), nullable=False)
    Interest = db.Column(db.Float(asdecimal=True), nullable=False)
    StampDuty = db.Column(db.Float(asdecimal=True), nullable=False)
    Profit = db.Column(db.Float(asdecimal=True), nullable=False)

    sm_user_member = db.relationship('SmUserMember', primaryjoin='SmSellTrade.MemberID == SmUserMember.ID', backref='sm_sell_trades')


class SmStockPara(db.Model):
    __tablename__ = 'sm_stock_para'

    TickerSymbol = db.Column(db.String(64), primary_key=True)
    Name = db.Column(db.String(50))
    Abridge = db.Column(db.String(30))
    Type = db.Column(db.String(30))
    BuyByBullish = db.Column(db.Integer, server_default=db.FetchedValue())
    BuyByBearish = db.Column(db.Integer, server_default=db.FetchedValue())
    Buiable = db.Column(db.Integer, server_default=db.FetchedValue())
    Sellable = db.Column(db.Integer, server_default=db.FetchedValue())
    Close = db.Column(db.Integer)
    Suspend = db.Column(db.Integer)
    SuspendTime = db.Column(db.DateTime)
    Forbidden = db.Column(db.Integer)
    Note = db.Column(db.String(255))


class SmSysConf(db.Model):
    __tablename__ = 'sm_sys_conf'

    Key = db.Column(db.String(100), primary_key=True)
    Value = db.Column(db.String(255), nullable=False)
    Description = db.Column(db.String(255))


class SmSysNotice(db.Model):
    __tablename__ = 'sm_sys_notice'

    ID = db.Column(db.String(64), primary_key=True)
    CreatorID = db.Column(db.ForeignKey('sm_user_admin.ID', ondelete='SET NULL', onupdate='CASCADE'), index=True)
    Title = db.Column(db.String(50))
    Content = db.Column(db.String(255))
    Time = db.Column(db.DateTime, nullable=False)
    AgentDisable = db.Column(db.Integer, nullable=False)
    MemberDisable = db.Column(db.Integer, nullable=False)

    sm_user_admin = db.relationship('SmUserAdmin', primaryjoin='SmSysNotice.CreatorID == SmUserAdmin.ID', backref='sm_sys_notices')


class SmTradeBill(db.Model):
    __tablename__ = 'sm_trade_bill'

    ID = db.Column(db.String(64), primary_key=True)
    Number = db.Column(db.String(30), nullable=False)
    TradeType = db.Column(db.Integer, nullable=False)
    MemberID = db.Column(db.ForeignKey('sm_user_member.ID'), index=True)
    TickerSymbol = db.Column(db.String(30), nullable=False)
    TickerName = db.Column(db.String(30), nullable=False)
    UnitPrice = db.Column(db.Float(asdecimal=True), nullable=False)
    Hands = db.Column(db.Integer, nullable=False)
    Amount = db.Column(db.Float(asdecimal=True), nullable=False)
    Time = db.Column(db.DateTime, nullable=False)
    OpID = db.Column(db.Integer)
    Note = db.Column(db.String(255))

    sm_user_member = db.relationship('SmUserMember', primaryjoin='SmTradeBill.MemberID == SmUserMember.ID', backref='sm_trade_bills')


class SmUser(db.Model):
    __tablename__ = 'sm_user'

    ID = db.Column(db.String(64), primary_key=True, nullable=False)
    LoginName = db.Column(db.String(64), primary_key=True, nullable=False)
    NickName = db.Column(db.String(64), nullable=False)
    Password = db.Column(db.String(255), nullable=False)
    CreateTime = db.Column(db.DateTime, nullable=False)
    LastLogonTime = db.Column(db.DateTime)
    CreatorID = db.Column(db.String(64))
    Forbidden = db.Column(db.Integer, nullable=False)
    RoleID = db.Column(db.ForeignKey('sm_user_role.ID'), index=True)
    Lock = db.Column(db.Integer, nullable=False)

    sm_user_role = db.relationship('SmUserRole', primaryjoin='SmUser.RoleID == SmUserRole.ID', backref='sm_users')


class SmUserAdmin(SmUser):
    __tablename__ = 'sm_user_admin'

    ID = db.Column(db.ForeignKey('sm_user.ID', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True)


class SmUserAgent(SmUser):
    __tablename__ = 'sm_user_agent'

    ID = db.Column(db.ForeignKey('sm_user.ID', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True)
    Margin = db.Column(db.Float(asdecimal=True))
    TestMargin = db.Column(db.Float(asdecimal=True))
    CommissionRatio = db.Column(db.Float(asdecimal=True))
    ExchangeRate = db.Column(db.Float(asdecimal=True))
    MemberPrefix = db.Column(db.String(255))
    MemberMaximum = db.Column(db.Integer)
    Bank = db.Column(db.String(255))
    BankAccount = db.Column(db.String(30))
    Cardholder = db.Column(db.String(30))
    WithdrawPassWord = db.Column(db.String(30))
    Type = db.Column(db.Integer)
    AgentLevel = db.Column(db.Integer, nullable=False)


class SmUserMember(SmUser):
    __tablename__ = 'sm_user_member'

    ID = db.Column(db.ForeignKey('sm_user.ID', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True)
    AgentID = db.Column(db.ForeignKey('sm_user_agent.ID'), nullable=False, index=True)
    ClerkID = db.Column(db.ForeignKey('sm_clerk.ID', ondelete='SET NULL', onupdate='CASCADE'), index=True)
    CustomerName = db.Column(db.String(30))
    Margin = db.Column(db.Float(asdecimal=True))
    PhoneNum = db.Column(db.String(20))
    BuyFeeRate = db.Column(db.Float(asdecimal=True))
    SellFeeRate = db.Column(db.Float(asdecimal=True))
    RiseFallSpreadRate = db.Column(db.Float(asdecimal=True))
    Bank = db.Column(db.String(255))
    BankAccount = db.Column(db.String(30))
    Cardholder = db.Column(db.String(30))
    OpeningBank = db.Column(db.String(30))
    WithdrawPassWord = db.Column(db.String(30))
    EmailAddress = db.Column(db.String(50))
    QQNum = db.Column(db.String(20))
    Type = db.Column(db.Integer)

    sm_user_agent = db.relationship('SmUserAgent', primaryjoin='SmUserMember.AgentID == SmUserAgent.ID', backref='sm_user_members')
    sm_clerk = db.relationship('SmClerk', primaryjoin='SmUserMember.ClerkID == SmClerk.ID', backref='sm_user_members')


class SmUserLog(db.Model):
    __tablename__ = 'sm_user_log'

    ID = db.Column(db.String(64), primary_key=True)
    UserID = db.Column(db.ForeignKey('sm_user.ID', ondelete='SET NULL', onupdate='CASCADE'), index=True)
    Type = db.Column(db.String(50))
    Model = db.Column(db.String(50))
    Time = db.Column(db.DateTime, nullable=False)
    Note = db.Column(db.String(255))

    sm_user = db.relationship('SmUser', primaryjoin='SmUserLog.UserID == SmUser.ID', backref='sm_user_logs')


class SmUserRole(db.Model):
    __tablename__ = 'sm_user_role'

    ID = db.Column(db.String(64), primary_key=True)
    Name = db.Column(db.String(50), nullable=False)
    Description = db.Column(db.String(255))
