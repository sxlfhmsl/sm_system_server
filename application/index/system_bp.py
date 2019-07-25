# -*- coding:utf-8 -*-
"""
系统管理相关蓝图，获取和设置交易规则，获取和查看公告。。。
"""

from flask.blueprints import Blueprint
from flask import jsonify, request, current_app

from ..service.system_service import SystemService
from .utils import PermissionView
from .sta_code import SUCCESS, OTHER_ERROR, POST_PARA_ERROR

system_bp = Blueprint('system', __name__)


class QueryTradeRole(PermissionView):
    """
    获取交易规则
    """

    @staticmethod
    def get_role():
        return jsonify(SUCCESS(SystemService.get_trade_role()))

    def response_admin(self):
        return self.get_role()

    def response_agent(self):
        return self.get_role()

    def response_member(self):
        return self.get_role()


class SetTradeRole(PermissionView):
    """
    获取交易规则
    """
    para_legal_list_recv = ['title', 'content']

    def response_admin(self):
        try:
            if SystemService.set_trade_role(**self.unpack_para(request.json)) == 0:
                return jsonify(SUCCESS())
            else:
                return jsonify(OTHER_ERROR)
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)


# 获取交易规则
system_bp.add_url_rule('/traderole', methods=['POST'], view_func=QueryTradeRole.as_view('system_traderole'))
# 设置交易规则
system_bp.add_url_rule('/set_traderole', methods=['POST'], view_func=SetTradeRole.as_view('system_set_traderole'))

