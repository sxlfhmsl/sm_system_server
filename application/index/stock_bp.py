# -*- coding:utf-8 -*-
"""
固表相关操作蓝图
"""

from flask.blueprints import Blueprint
from flask import current_app, jsonify, request

from .utils import PermissionView
from ..service.stock_trade_service import StockTradeService
from .sta_code import SUCCESS, POST_PARA_ERROR, STOCK_CANNOT_BUY, STOCK_BUY_NOT_ENOUGH_HANDS, STOCK_BUY_NOT_ENOUGH_MONEY
from .sta_code import OTHER_ERROR

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


# 充值创建
stock_bp.add_url_rule('/buy', methods=['POST'], view_func=StockBuyView.as_view('buy_stock'))

