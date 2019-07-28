# -*- coding:utf-8 -*-
"""
股票交易service，平仓, 持仓等, 涉及多表
"""

from flask import current_app
from sqlalchemy.orm import aliased
from datetime import datetime
from decimal import Decimal

from .utils import BaseService
from ..dao.models import db, SmStockPara, SmBuyTrade, SmTradeBill, SmUserMember, SmUserAgent, SmClerk
from ..utils.request_data import DataApi51Request


class StockTradeService(BaseService):
    """
    股票交易service
    """

    @classmethod
    def buy_stock(cls, member_user, TickerSymbol, BuyType, Hands):
        """
        发生交易，持仓股票
        :param Member: 会员id
        :param TickerSymbol: 股票代码
        :param BuyType: 购买类型空或者其他
        :param Hands: 手数
        :return: 代码    返回结果
                 0       购买成功
                 1       股票被禁用，不可买，停牌或者关盘等
                 2       购买手数不足
                 3       资金不足
                 4       其他错误
        """
        session = db.session
        try:
            stock = SmStockPara.query.filter(SmStockPara.TickerSymbol == TickerSymbol).first()
            if stock is None or stock.Forbidden != 0 or stock.Buiable == 0 or stock.Close != 0 or stock.Suspend != 0:
                return 1
            if Hands < 10:
                return 2
            price = DataApi51Request.get_stock_real(stock.TickerSymbol + '.' + stock.Type)['last_px']
            if price * Hands * 100 > member_user.Margin * 10:
                return 3
            time_now = datetime.now()
            number = cls.create_order_id(time_now)
            buy_trade = SmBuyTrade(Number=number, MemberID=member_user.ID, TradeTime=time_now,
                                   TickerSymbol=TickerSymbol, Price=price, Hands=Hands, BuyType=BuyType,
                                   BuyFeeRate=member_user.BuyFeeRate, StoreFeeRate=0.06, RiseFallSpreadRate=member_user.RiseFallSpreadRate)
            bill = SmTradeBill(Number=number, TradeType='买入', MemberID=member_user.ID, TickerSymbol=TickerSymbol,
                               TickerName=stock.Name, UnitPrice=price, Hands=Hands, Amount=0-(price * Hands * 100),
                               Time=time_now, OpID=member_user.ID, Note='发生购买股票行为')
            member_user.Margin = member_user.Margin - Decimal(price * Hands * 100)
            session.add(buy_trade)
            session.add(bill)
            cls.create_log(member_user.ID, "股票", '买入', time_now, '买入单号:' + number + '创建')
            return 0
        except Exception as e:
            session.rollback()
            current_app.logger.error(e)
            return 4

    @classmethod
    def query_buy_record(cls, AgentID=None, ClerkID=None, MemberID=None, Page=None, PageSize=None):
        """
        查询所有股票买入记录
        :param AgentID: 代理id
        :param ClerkID: 业务员id
        :param MemberID: 会员id
        :param Page: 页数
        :param PageSize: 每页数量
        :return: 结果
        """
        print('fuck__________________')
        if Page is None or PageSize is None:
            Page = 1
            PageSize = 1000
        session = db.session
        try:
            filter_list = []
            if AgentID is not None:
                filter_list.append(SmUserMember.AgentID == AgentID)
            if ClerkID is not None:
                filter_list.append(SmUserMember.ClerkID == ClerkID)
            if MemberID is not None:
                filter_list.append(SmBuyTrade.MemberID == MemberID)
            page_result = session.query(SmBuyTrade, SmUserAgent.LoginName.label('AgentName'), SmClerk.NickName.label('ClerkName'), SmUserMember.LoginName.label('MemberName')).\
                outerjoin(SmUserMember, SmUserMember.ID == SmBuyTrade.MemberID).\
                outerjoin(SmUserAgent, SmUserMember.AgentID == SmUserAgent.ID).\
                outerjoin(SmClerk, SmUserMember.ClerkID == SmClerk.ID).order_by(SmBuyTrade.Number.desc()).\
                filter(*filter_list).paginate(Page, PageSize)
            return {"total": page_result.total, "rows": cls.result_to_dict(page_result.items)}
        except Exception as e:
            current_app.logger.error(e)
            return None
