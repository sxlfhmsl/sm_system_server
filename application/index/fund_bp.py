# -*- coding:utf-8 -*-
"""
资金相关操作蓝图，充值，提款，查流水等
"""

from flask.blueprints import Blueprint
from flask import jsonify,current_app, request

from .utils import PermissionView
from .sta_code import SUCCESS, POST_PARA_ERROR
from ..service.recharge_services import SmRechargeService

fund_bp = Blueprint('fund', __name__)


class RechargeFund(PermissionView):
    """
    银证转账，充值，https://baike.baidu.com/item/%E9%93%B6%E8%AF%81%E8%BD%AC%E8%B4%A6/8643750?fr=aladdin
    """
    para_legal_list_recv = ['Value', 'VendorNumber', 'Bank']

    def response_member(self):
        try:
            if SmRechargeService.member_recharge(self.user, str(request.remote_addr), **self.unpack_para(request.json)) == 0:
                return jsonify(SUCCESS())
            else:
                return jsonify(POST_PARA_ERROR)
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)


# 充值创建
fund_bp.add_url_rule('/recharge', methods=['POST'], view_func=RechargeFund.as_view('fund_recharge'))

