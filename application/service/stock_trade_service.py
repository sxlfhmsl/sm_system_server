# -*- coding:utf-8 -*-
"""
股票交易service，平仓, 持仓等, 涉及多表
"""

from flask import current_app
from sqlalchemy.orm import aliased
from sqlalchemy import or_
from datetime import datetime
from decimal import Decimal

from .utils import BaseService
from ..dao.models import db, SmStockPara, SmBuyTrade, SmTradeBill, SmUserMember, SmUserAgent, SmClerk, SmTradeType
from ..dao.models import SmSellTrade, SmUser
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
            # 0.0006为留仓费率
            buy_trade = SmBuyTrade(Number=number, MemberID=member_user.ID, TradeTime=time_now,
                                   TickerSymbol=TickerSymbol, Price=price, Hands=Hands, BuyType=BuyType,
                                   BuyFeeRate=member_user.BuyFeeRate, StoreFeeRate=0.0006, RiseFallSpreadRate=member_user.RiseFallSpreadRate)
            bill = SmTradeBill(Number=number, TradeType='买入', MemberID=member_user.ID, TickerSymbol=TickerSymbol,
                               TickerName=stock.Name, UnitPrice=price, Hands=Hands, Amount=price * Hands * 100,
                               Time=time_now, OpID=member_user.ID, Note='发生购买股票行为')
            member_user.Margin = member_user.Margin - Decimal(price * Hands * 100 / 10)
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
            page_result = session.query(SmBuyTrade, SmUserAgent.LoginName.label('AgentName'),
                                        SmClerk.NickName.label('ClerkName'), SmStockPara.Name.label('TickerName'),
                                        SmUserMember.LoginName.label('MemberName'),
                                        SmTradeType.Description.label('BuyTypeDes')). \
                outerjoin(SmTradeType, SmTradeType.ID == SmBuyTrade.BuyType). \
                outerjoin(SmStockPara, SmStockPara.TickerSymbol == SmBuyTrade.TickerSymbol). \
                outerjoin(SmUserMember, SmUserMember.ID == SmBuyTrade.MemberID).\
                outerjoin(SmUserAgent, SmUserMember.AgentID == SmUserAgent.ID).\
                outerjoin(SmClerk, SmUserMember.ClerkID == SmClerk.ID).order_by(SmBuyTrade.Number.desc()).\
                filter(*filter_list).paginate(Page, PageSize)
            return {"total": page_result.total, "rows": cls.result_to_dict(page_result.items)}
        except Exception as e:
            current_app.logger.error(e)
            return None

    @classmethod
    def sell_stock(cls, Number, user, BuyPrSell, agent_user=None):
        """
        平仓操作
        :param agent_user: 代理用户
        :param Number: 买单号
        :param BuyPrSell: 是否买价平仓
        :param user: 操作者
        :return: 代码    返回结果
                 0       平仓成功
                 1       非法操作
                 2       其他错误
        """
        session = db.session
        time_now = datetime.now()
        try:
            # 获取持仓单
            buy_trade = session.query(SmBuyTrade, SmStockPara.Type.label('StockType'), SmStockPara.Name.label('StockName'),
                                      SmTradeType.Coefficient.label('k'), SmUserMember.LoginName.label('MemberName')).\
                outerjoin(SmStockPara, SmStockPara.TickerSymbol == SmBuyTrade.TickerSymbol). \
                outerjoin(SmTradeType, SmTradeType.ID == SmBuyTrade.BuyType). \
                outerjoin(SmUserMember, SmUserMember.ID == SmBuyTrade.MemberID). \
                filter(SmBuyTrade.Number == Number).first()
            if buy_trade is None:
                return 1
            sm_buy_trade = buy_trade[0]
            buy_trade = cls.result_to_dict(buy_trade)
            if user.RoleID == cls.get_role('Member')['ID'] and user.ID != buy_trade['MemberID']:
                return 1
            member_user = SmUserMember.query.filter(SmUserMember.ID == buy_trade['MemberID']).first()
            if agent_user and (member_user is None or member_user.AgentID != agent_user.ID):
                return 1
            # 获取售出价格
            sell_price = buy_trade['Price'] if BuyPrSell else DataApi51Request.get_stock_real(
                buy_trade['TickerSymbol'] + '.' + buy_trade['StockType'])['last_px']
            sell_sum, buy_sum = sell_price * buy_trade['Hands'] * 100, buy_trade['Price'] * buy_trade['Hands'] * 100
            sell_fee, buy_fee = sell_sum * buy_trade['BuyFeeRate'], buy_sum * buy_trade['BuyFeeRate']    # 卖出手续费， 买入手续费
            interest,  stamp_duty = sell_sum * 0.0024, sell_sum * 0.0010    # 融资利息，印花税
            profit = (sell_sum - buy_sum) * buy_trade['k']
            sell_trade = SmSellTrade(SellNumber=cls.create_order_id(time_now), MemberID=buy_trade['MemberID'],
                                     TickerSymbol=buy_trade['TickerSymbol'], BuyNumber=buy_trade['Number'], BuyTime=buy_trade['TradeTime'],
                                     BuyPrice=buy_trade['Price'], SellTime=time_now, SellPrice=sell_price, BuyType=buy_trade['BuyType'],
                                     Fee=sell_fee + buy_fee, Interest=interest, StampDuty=stamp_duty, Profit=profit, Hands=buy_trade['Hands'])
            note = '会员' + buy_trade['MemberName'] + '平仓 市价:' + str(sell_price) + ' 买入手续费:' + str(buy_fee) + \
                   ' 卖出手续费:' + str(sell_fee) + ' 融资利息:' + str(interest) + ' 印花税:' + str(stamp_duty) + ' 收益' + str(profit)
            sell_bill = SmTradeBill(Number=cls.create_order_id(time_now), TradeType='平仓', MemberID=buy_trade['MemberID'],
                                    TickerSymbol=buy_trade['TickerSymbol'], TickerName=buy_trade['StockName'],
                                    UnitPrice=sell_price, Hands=buy_trade['Hands'], Amount=sell_sum, Time=time_now,
                                    Note=note, OpID=user.ID)
            member_user.Margin = member_user.Margin + Decimal(buy_sum / 10 + profit - sell_fee - buy_fee - interest - stamp_duty)
            session.delete(sm_buy_trade)
            session.add(sell_trade)
            session.add(sell_bill)
            cls.create_log(user.ID, "股票", '平仓', time_now, '会员:' + buy_trade['MemberName'] + '平仓单号:' + cls.create_order_id(time_now) + '创建')
            return 0
        except Exception as e:
            session.rollback()
            current_app.logger.error(e)
            return 2

    @classmethod
    def query_sell_record(cls, AgentID=None, MemberID=None, MemberName=None, StartTime=None, EndTime=None, Page=None, PageSize=None):
        """
        查询所有平仓记录
        :param AgentID: 代理id
        :param MemberID: 会员id
        :param MemberName: 会员名称
        :param StartTime: 开始时间
        :param EndTime: 结束时间
        :param Page: 分页位置
        :param PageSize: 每页数量
        :return: 执行结果
        """
        if Page is None or PageSize is None:
            Page = 1
            PageSize = 1000
        session = db.session
        try:
            filter_list = []
            if AgentID is not None:
                filter_list.append(SmUserMember.AgentID == AgentID)
            if MemberID is not None:
                filter_list.append(SmSellTrade.MemberID == MemberID)
            if MemberName is not None:
                filter_list.append(SmUserMember.LoginName.like('%' + MemberName + '%'))
            if StartTime is not None:
                filter_list.append(SmSellTrade.SellTime >= StartTime)
            if EndTime is not None:
                filter_list.append(SmSellTrade.SellTime <= EndTime)
            page_result = session.query(SmSellTrade, SmUserAgent.LoginName.label('AgentName'),
                                        SmUserMember.LoginName.label('MemberName'), SmStockPara.Name.label('TickerName'),
                                        SmTradeType.Description.label('BuyTypeDes')). \
                outerjoin(SmTradeType, SmTradeType.ID == SmSellTrade.BuyType). \
                outerjoin(SmStockPara, SmStockPara.TickerSymbol == SmSellTrade.TickerSymbol). \
                outerjoin(SmUserMember, SmUserMember.ID == SmSellTrade.MemberID). \
                outerjoin(SmUserAgent, SmUserMember.AgentID == SmUserAgent.ID). \
                order_by(SmSellTrade.SellNumber.desc()). \
                filter(*filter_list).paginate(Page, PageSize)
            return {"total": page_result.total, "rows": cls.result_to_dict(page_result.items)}
        except Exception as e:
            current_app.logger.error(e)
            return None

    @classmethod
    def query_record_trade_bill(cls, TradeType=None, Number=None, MemberName=None, TickerSymbol=None, TickerName=None,
                                Hands=None, StartTime=None, EndTime=None, Page=None, PageSize=None, agent_user=None,
                                MemberID=None):
        """
        查询所有记录_____暂时按照交易账单处理，资金明细也一致
        :param TradeType: 交易类型
        :param Number: 单号
        :param MemberName: 会员名称
        :param TickerSymbol: 股票代码
        :param TickerName: 股票名称
        :param Hands: 手数
        :param StartTime: 起始时间
        :param EndTime: 结束时间
        :param Page: 页数
        :param PageSize: 每页数量
        :param agent_user: 代理
        :param MemberID: 会员id
        :return:
        """
        if Page is None or PageSize is None:
            Page = 1
            PageSize = 1000
        session = db.session
        try:
            filter_list = []
            if TradeType is not None:
                filter_list.append(SmTradeBill.TradeType == TradeType)
            if Number is not None:
                filter_list.append(or_(SmTradeBill.Number.like('%' + Number + '%')))
            if MemberName is not None:
                filter_list.append(SmUserMember.LoginName.like('%' + MemberName + '%'))
            if TickerSymbol is not None:
                filter_list.append(SmTradeBill.TickerSymbol.like('%' + TickerSymbol + '%'))
            if TickerName is not None:
                filter_list.append(SmTradeBill.TickerName.like('%' + TickerName + '%'))
            if Hands is not None:
                filter_list.append(SmTradeBill.Hands == Hands)
            if StartTime is not None:
                filter_list.append(SmTradeBill.SellTime >= StartTime)
            if EndTime is not None:
                filter_list.append(SmTradeBill.SellTime <= EndTime)
            if agent_user is not None:
                filter_list.append(SmUserMember.AgentID == agent_user.ID)
            if MemberID is not None:
                filter_list.append(SmTradeBill.MemberID == MemberID)
            user_t = aliased(SmUser)
            page_result = session.query(SmTradeBill, SmUserMember.LoginName.label('MemberName'),
                                        user_t.LoginName.label('OperatorName')). \
                outerjoin(SmUserMember, SmTradeBill.MemberID == SmUserMember.ID). \
                outerjoin(user_t, SmTradeBill.OpID == user_t.ID). \
                order_by(SmTradeBill.Number.desc()). \
                filter(*filter_list).paginate(Page, PageSize)
            return {"total": page_result.total, "rows": cls.result_to_dict(page_result.items)}
        except Exception as e:
            current_app.logger.error(e)
            return None

