# -*- coding:utf-8 -*-
"""
系统管理相关蓝图，获取和设置交易规则，获取和查看公告。。。
"""

from flask.blueprints import Blueprint
from flask import jsonify

from .utils import PermissionView
from .sta_code import SUCCESS
from ..dao.utils import RedisOp

system_bp = Blueprint('system', __name__)


class QueryTradeRole(PermissionView):
    """
    获取交易规则
    """

    @staticmethod
    def get_role():
        return jsonify(SUCCESS({
            'title': RedisOp().get_normal('system_trade_role_title').decode(encoding='utf8'),
            'content': RedisOp().get_normal('system_trade_role_content').decode(encoding='utf8')
        }))

    def response_admin(self):
        return self.get_role()

    def response_agent(self):
        return self.get_role()

    def response_member(self):
        return self.get_role()


# 获取交易规则
system_bp.add_url_rule('/traderole', methods=['POST'], view_func=QueryTradeRole.as_view('system_traderole'))

