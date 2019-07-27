# -*- coding:utf-8 -*-
"""
资金相关操作蓝图，充值，提款，查流水等
"""

from flask.blueprints import Blueprint
from flask import jsonify,current_app, request

from .utils import PermissionView
from .sta_code import SUCCESS, POST_PARA_ERROR, OTHER_ERROR, NOT_ENOUGH_MONEY, WRONG_WITHDRAW_PASS
from ..service.recharge_services import SmRechargeService
from ..service.member_drawing_service import SmMemberDrawingService
from ..service.agent_drawing_service import SmAgentDrawingService

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


class RechargeRecordFund(PermissionView):
    """
    银证转账，充值，https://baike.baidu.com/item/%E9%93%B6%E8%AF%81%E8%BD%AC%E8%B4%A6/8643750?fr=aladdin
    """
    para_legal_list_recv = ['LoginName', 'DepositStatus', 'StartTime', 'EndTime', 'Page', 'PageSize']

    def response_admin(self):
        try:
            result = SmRechargeService.query_all(**self.unpack_para(request.json))
            return jsonify(SUCCESS(result)) if result else jsonify(SUCCESS({'total': 0, 'rows': []}))
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(SUCCESS({'total': 0, 'rows': []}))

    def response_agent(self):
        try:
            result = SmRechargeService.query_all(AgentID=self.u_id, **self.unpack_para(request.json))
            return jsonify(SUCCESS(result)) if result else jsonify(SUCCESS({'total': 0, 'rows': []}))
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(SUCCESS({'total': 0, 'rows': []}))

    def response_member(self):
        try:
            result = SmRechargeService.query_all(MemberID=self.u_id, **self.unpack_para(request.json))
            return jsonify(SUCCESS(result['rows'])) if result else jsonify(SUCCESS([]))
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(SUCCESS([]))


class WithdrawFund(PermissionView):
    """
    会员或者代理提款
    """
    para_legal_list_recv = ['WithdrawPassWord', 'DrawingValue', 'Bank', 'BankOfDeposit', 'BankAccountName', 'BankAccount']

    def response_agent(self):
        """
        代理提款
        :return:
        """
        try:
            result = SmAgentDrawingService.withdraw(self.user, **self.unpack_para(request.json))
            if result == 0:
                return jsonify(SUCCESS())
            elif result == 1:
                return jsonify(WRONG_WITHDRAW_PASS)
            elif result == 2:
                return jsonify(NOT_ENOUGH_MONEY)
            return jsonify(OTHER_ERROR)
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)

    def response_member(self):
        """
        会员提款
        :return:
        """
        try:
            result = SmMemberDrawingService.withdraw(self.user, **self.unpack_para(request.json))
            if result == 0:
                return jsonify(SUCCESS())
            elif result == 1:
                return jsonify(WRONG_WITHDRAW_PASS)
            elif result == 2:
                return jsonify(NOT_ENOUGH_MONEY)
            return jsonify(OTHER_ERROR)
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)


class MemberWithdrawRecordFund(PermissionView):
    """
    查询提款流水__会员提款
    """
    para_legal_list_recv = ['LoginName', 'BankAccountName', 'Page', 'PageSize']

    def response_admin(self):
        try:
            result = SmMemberDrawingService.query_withdraw_all(**self.unpack_para(request.json))
            return jsonify(SUCCESS(result)) if result else jsonify(SUCCESS({'total': 0, 'rows': []}))
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(SUCCESS({'total': 0, 'rows': []}))

    def response_agent(self):
        try:
            result = SmMemberDrawingService.query_withdraw_all(AgentID=self.u_id, **self.unpack_para(request.json))
            return jsonify(SUCCESS(result)) if result else jsonify(SUCCESS({'total': 0, 'rows': []}))
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(SUCCESS({'total': 0, 'rows': []}))

    def response_member(self):
        try:
            result = SmMemberDrawingService.query_withdraw_all(MemberID=self.u_id, **self.unpack_para(request.json))
            return jsonify(SUCCESS(result['rows'])) if result else jsonify(SUCCESS([]))
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(SUCCESS([]))


# 充值创建
fund_bp.add_url_rule('/recharge', methods=['POST'], view_func=RechargeFund.as_view('fund_recharge'))
# 转账流水
fund_bp.add_url_rule('/recharge_record', methods=['POST'], view_func=RechargeRecordFund.as_view('fund_recharge_record'))
# 提款
fund_bp.add_url_rule('/withdraw', methods=['POST'], view_func=WithdrawFund.as_view('fund_withdraw'))
# 提款
fund_bp.add_url_rule('/withdraw_record', methods=['POST'], view_func=MemberWithdrawRecordFund.as_view('fund_withdraw_record_member'))

