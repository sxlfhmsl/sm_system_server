# -*- coding:utf-8 -*-
"""
会员处理接口， 通过id查询信息，通过id删除， 增加会员记录
"""

from flask.blueprints import Blueprint
from flask import jsonify, abort, current_app, request

from .utils import PermissionView
from .sta_code import SUCCESS, USER_SAME_LOGIN_NAME, OTHER_ERROR, POST_PARA_ERROR, USER_AGENT_NOT_ENOUGH_MEMBER, QUERY_NO_RESULT
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


class QueryMemberByID(PermissionView):
    """
    查询指定id的会员
    """
    para_legal_list_return = ['Password', 'CreatorID', 'RoleID', 'WithdrawPassWord']

    def __init__(self):
        super(QueryMemberByID, self).__init__()
        self.member_id = None    # 带查询的代理id

    def dispatch_request(self, token_dict: dict, member_id):
        self.member_id = member_id
        return super(QueryMemberByID, self).dispatch_request(token_dict)

    def response_admin(self):
        result = SmUserMemberService.get_by_id(self.member_id)
        if result:
            self.pop_no_need(result)
            return jsonify(SUCCESS(result))
        else:
            return jsonify(QUERY_NO_RESULT)

    def response_agent(self):
        result = SmUserMemberService.agent_query_by_id(self.user, self.member_id)
        if result:
            self.pop_no_need(result)
            return jsonify(SUCCESS(result))
        else:
            return jsonify(QUERY_NO_RESULT)


class ChangeMemberByID(PermissionView):
    """
    通过id更新代理信息， 管理员可以任意修改，代理只可修改自身次级代理
    """
    para_legal_list_recv = ['LoginName', 'ClerkID', 'NickName', 'Margin', 'BuyFeeRate', 'SellFeeRate', 'OpeningBank',
                            'RiseFallSpreadRate', 'Bank', 'BankAccount', 'Cardholder',  'PhoneNum', 'EmailAddress', 'QQNum']

    def __init__(self):
        super(ChangeMemberByID, self).__init__()
        self.member_id = None    # 带查询的代理id

    def dispatch_request(self, token_dict: dict, member_id):
        self.member_id = member_id
        return super(ChangeMemberByID, self).dispatch_request(token_dict)

    def response_admin(self):
        try:
            result = SmUserMemberService.update_by_id(self.member_id, **self.unpack_para(request.json))
            if result == 0:
                return jsonify(SUCCESS())
            elif result == 1:
                return jsonify(USER_SAME_LOGIN_NAME)
            elif result == 2:
                return jsonify(POST_PARA_ERROR)
        except Exception as e:    # 参数解析错误
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)
        return jsonify(OTHER_ERROR)

    def response_agent(self):
        try:
            result = SmUserMemberService.agent_update_by_id(self.user, self.member_id, **self.unpack_para(request.json))
            if result == 0:
                return jsonify(SUCCESS())
            elif result == 1:
                return jsonify(USER_SAME_LOGIN_NAME)
            elif result == 2:
                return jsonify(POST_PARA_ERROR)
        except Exception as e:    # 参数解析错误
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)
        return jsonify(OTHER_ERROR)


class DeleteMemberByID(PermissionView):

    def __init__(self):
        super(DeleteMemberByID, self).__init__()
        self.member_id = None    # 带查询的管理员id

    def dispatch_request(self, token_dict: dict, member_id):
        self.member_id = member_id
        return super(DeleteMemberByID, self).dispatch_request(token_dict)

    def response_admin(self):
        try:
            result = SmUserMemberService.admin_delete_by_id(self.member_id)
            if result == 0:
                return jsonify(SUCCESS())
            elif result == 1:
                return jsonify(QUERY_NO_RESULT)
            elif result == 2:
                return jsonify(OTHER_ERROR)
        except Exception as e:    # 参数解析错误
            current_app.logger.error(e)
            return jsonify(OTHER_ERROR)
        return jsonify(OTHER_ERROR)


# 创建会员
user_member_bp.add_url_rule('/create', methods=['POST'], view_func=CreateMember.as_view('create_member'))
# 查询所有会员
user_member_bp.add_url_rule('/all', methods=['POST'], view_func=QueryAllMember.as_view('all_member'))
# 查询单个会员，通过id
user_member_bp.add_url_rule('/query/<member_id>', methods=['POST'], view_func=QueryMemberByID.as_view('query_member_by_id'))
# 通过id修改会员
user_member_bp.add_url_rule('/update/<member_id>', methods=['POST'], view_func=ChangeMemberByID.as_view('update_member_by_id'))
# 通过id删除会员
user_member_bp.add_url_rule('/delete/<member_id>', methods=['POST'], view_func=DeleteMemberByID.as_view('delete_member_by_id'))

