# -*- coding:utf-8 -*-
"""
固表相关操作蓝图
"""

from flask.blueprints import Blueprint
from flask import current_app, jsonify, request

from .utils import PermissionView
from ..service.stock_trade_service import StockTradeService
from .sta_code import SUCCESS, POST_PARA_ERROR, STOCK_CANNOT_BUY, STOCK_BUY_NOT_ENOUGH_HANDS, STOCK_BUY_NOT_ENOUGH_MONEY
from .sta_code import OTHER_ERROR, PERMISSION_DENIED_ERROR

stock_bp = Blueprint('stock', __name__)


class StockBuyView(PermissionView):
    """
    购买股票，原来代码涉及存储过程
    """
    para_legal_list_recv = ['TickerSymbol', 'BuyType', 'Hands']

    def response_member(self):
        try:
            result = StockTradeService.buy_stock(self.user, **self.unpack_para(request.json))
            if result == 0:
                return jsonify(SUCCESS())
            elif result == 1:
                return jsonify(STOCK_CANNOT_BUY)
            elif result == 2:
                return jsonify(STOCK_BUY_NOT_ENOUGH_HANDS)
            elif result == 3:
                return jsonify(STOCK_BUY_NOT_ENOUGH_MONEY)
            return jsonify(OTHER_ERROR)
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)


class StockBuyRecordView(PermissionView):
    """
    查询用户持仓记录
    """
    para_legal_list_recv = ['AgentID', 'ClerkID', 'MemberID', 'Page', 'PageSize']

    def response_admin(self):
        try:
            result = StockTradeService.query_buy_record(**self.unpack_para(request.json))
            return jsonify(SUCCESS(result)) if result else jsonify(SUCCESS({'total': 0, 'rows': []}))
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(SUCCESS({'total': 0, 'rows': []}))

    def response_agent(self):
        try:
            result = StockTradeService.query_buy_record(AgentID=self.u_id, **self.unpack_para(request.json))
            return jsonify(SUCCESS(result)) if result else jsonify(SUCCESS({'total': 0, 'rows': []}))
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(SUCCESS({'total': 0, 'rows': []}))

    def response_member(self):
        try:
            result = StockTradeService.query_buy_record(AgentID=self.user.AgentID, ClerkID=self.user.ClerkID,
                                                        MemberID=self.u_id, **self.unpack_para(request.json))
            return jsonify(SUCCESS(result['rows'])) if result else jsonify(SUCCESS([]))
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(SUCCESS([]))


class StockSellView(PermissionView):
    """
    股票平仓，原来代码涉及存储过程
    """
    # 购买单号    买价平仓（管理员）
    para_legal_list_recv = ['Number', 'BuyPrSell']

    def response_admin(self):
        try:
            result = StockTradeService.sell_stock(user=self.user, **self.unpack_para(request.json))
            if result == 0:
                return jsonify(SUCCESS())
            elif result == 1:
                return jsonify(PERMISSION_DENIED_ERROR)
            return jsonify(OTHER_ERROR)
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)

    def response_agent(self):
        try:
            result = StockTradeService.sell_stock(user=self.user, BuyPrSell=False, agent_user=self.user, **self.unpack_para(request.json))
            if result == 0:
                return jsonify(SUCCESS())
            elif result == 1:
                return jsonify(PERMISSION_DENIED_ERROR)
            return jsonify(OTHER_ERROR)
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)

    def response_member(self):
        try:
            result = StockTradeService.sell_stock(user=self.user, BuyPrSell=False, **self.unpack_para(request.json))
            if result == 0:
                return jsonify(SUCCESS())
            elif result == 1:
                return jsonify(PERMISSION_DENIED_ERROR)
            return jsonify(OTHER_ERROR)
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)


# 买入股票
stock_bp.add_url_rule('/buy', methods=['POST'], view_func=StockBuyView.as_view('buy_stock'))
# 查询买入
stock_bp.add_url_rule('/buy_record', methods=['POST'], view_func=StockBuyRecordView.as_view('buy_record_stock'))
# 买入股票
stock_bp.add_url_rule('/sell', methods=['POST'], view_func=StockSellView.as_view('sell_stock'))


