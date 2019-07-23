# -*- coding:utf-8 -*-
"""
会员处理接口， 通过id查询信息，通过id删除， 增加会员记录
"""

from flask.blueprints import Blueprint
from flask import jsonify, abort, current_app, request

from .utils import PermissionView
from .sta_code import SUCCESS, USER_SAME_LOGIN_NAME, OTHER_ERROR, POST_PARA_ERROR, USER_AGENT_NOT_ENOUGH_MEMBER
from ..service.user_member_service import SmUserMemberService


user_member_bp = Blueprint('user/member', __name__)


class CreateMember(PermissionView):
    """
    创建会员操作
    """
    para_legal_list_recv = [
        'AgentID', 'LoginName', 'NickName', 'ClerkID', 'Password', 'Margin', 'PhoneNum', 'BuyFeeRate',
        'SellFeeRate', 'RiseFallSpreadRate', 'Bank', 'BankAccount', 'Cardholder', 'OpeningBank',
        'WithdrawPassWord', 'QQNum', 'Type']

    def response_admin(self):
        try:
            result = SmUserMemberService.admin_create_member(self.user, **self.unpack_para(request.json))
            if result == 0:                                                        # 添加成功
                return jsonify(SUCCESS())
            if result == 1:                                                        # 相同登录名
                return jsonify(USER_SAME_LOGIN_NAME)
            elif result == 2:                                                      # 其他错误
                return jsonify(OTHER_ERROR)
            elif result == 3:
                return jsonify(USER_AGENT_NOT_ENOUGH_MEMBER)
            elif result == 4:
                return jsonify(POST_PARA_ERROR)
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)
        return jsonify(OTHER_ERROR)

    def response_agent(self):
        try:
            result = SmUserMemberService.agent_create_member(self.user, **self.unpack_para(request.json))
            if result == 0:                                                        # 添加成功
                return jsonify(SUCCESS())
            if result == 1:                                                        # 相同登录名
                return jsonify(USER_SAME_LOGIN_NAME)
            elif result == 2:                                                      # 成员不足
                return jsonify(USER_AGENT_NOT_ENOUGH_MEMBER)
            elif result == 3:
                return jsonify(OTHER_ERROR)
            elif result == 4:
                return jsonify(POST_PARA_ERROR)
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)
        return jsonify(OTHER_ERROR)


class QueryAllMember(PermissionView):
    """
    查询所有的会员
    """
    para_legal_list_recv = ['AgentID', 'LoginName', 'NickName', 'Page', 'PageSize', 'ClerkID']
    para_legal_list_return = ['Password', 'CreatorID', 'RoleID', 'WithdrawPassWord', 'Cardholder', 'Bank', 'BuyFeeRate'
                              'SellFeeRate', 'RiseFallSpreadRate', 'OpeningBank', 'Type', 'AgentID', 'ClerkID']

    def response_admin(self):
        try:
            code, data = SmUserMemberService.admin_query_member(**self.unpack_para(request.json))
            if code == 0:
                self.pop_no_need(data['rows'])
                return jsonify(SUCCESS(data))
            elif code == 1:
                return jsonify(POST_PARA_ERROR)
        except Exception as e:    # 参数解析错误
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)
        return jsonify(OTHER_ERROR)

    def response_agent(self):
        try:
            code, data = SmUserMemberService.agent_query_member(self.user, **self.unpack_para(request.json))
            if code == 0:
                self.pop_no_need(data['rows'])
                return jsonify(SUCCESS(data))
            elif code == 1:
                return jsonify(POST_PARA_ERROR)
        except Exception as e:    # 参数解析错误
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)
        return jsonify(OTHER_ERROR)


user_member_bp.add_url_rule('/create', methods=['POST'], view_func=CreateMember.as_view('create_member'))
user_member_bp.add_url_rule('/all', methods=['POST'], view_func=QueryAllMember.as_view('all_member'))

