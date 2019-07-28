# -*- coding:utf-8 -*-
"""
固表相关操作蓝图
"""

from flask.blueprints import Blueprint
from flask import current_app, jsonify, request

from .utils import PermissionView
from .sta_code import SUCCESS, POST_PARA_ERROR

stock_bp = Blueprint('stock', __name__)


class StockBuyView(PermissionView):
    """
    购买股票，原来代码涉及存储过程
    """
    para_legal_list_recv = ['MemberID', 'TickerSymbol', 'BuyType', 'Hands']

    def response_admin(self):
        return self.get_role()

    def response_agent(self):
        return self.get_role()

    def response_member(self):
        return self.get_role()

