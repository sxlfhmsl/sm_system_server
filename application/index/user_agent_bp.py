# -*- coding:utf-8 -*-
"""
代理处理接口， 通过id查询信息，通过id删除， 增加代理记录
"""

from flask.blueprints import Blueprint
from flask import jsonify, current_app, request

from .utils import PermissionView
from .sta_code import SUCCESS, USER_SAME_LOGIN_NAME, OTHER_ERROR, POST_PARA_ERROR, USER_AGENT_LEVEL_LOW, QUERY_NO_RESULT
from .sta_code import USER_AGENT_NOT_ENOUGH_MEMBER, USER_AGENT_MEMBER_NOT_NULL, PERMISSION_DENIED_ERROR
from ..service.user_agent_service import SmUserAgentService

user_agent_bp = Blueprint('user/agent', __name__)


class CreateAgent(PermissionView):
    """
    创建代理
    """
    para_legal_list_recv = [
        'LoginName', 'NickName', 'Password', 'Margin', 'TestMargin', 'CommissionRatio', 'ExchangeRate',
        'MemberPrefix', 'MemberMaximum', 'Bank', 'BankAccount', 'Cardholder', 'WithdrawPassWord',
        'Type']

    def response_admin(self):
        try:
            result = SmUserAgentService.admin_create_agent(self.user, **self.unpack_para(request.json))
            if result == 0:                                                        # 添加成功
                return jsonify(SUCCESS())
            elif result == 1:                                                      # 相同用户名
                return jsonify(USER_SAME_LOGIN_NAME)
            elif result == 2:
                return jsonify(OTHER_ERROR)
        except Exception as e:    # 参数解析错误
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)
        return jsonify(OTHER_ERROR)

    def response_agent(self):
        try:
            result = SmUserAgentService.agent_create_agent(self.user, **self.unpack_para(request.json))
            if result == 0:                                                        # 添加成功
                return jsonify(SUCCESS())
            elif result == 1:                                                      # 相同用户名
                return jsonify(USER_SAME_LOGIN_NAME)
            elif result == 2:                                                      # 代理等级过低
                return jsonify(USER_AGENT_LEVEL_LOW)
            elif result == 3:                                                      # 其他错误
                return jsonify(OTHER_ERROR)
            elif result == 4:                                                      # 可创建会员数量不足
                return jsonify(USER_AGENT_NOT_ENOUGH_MEMBER)
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)
        return jsonify(OTHER_ERROR)


class QueryAllAgent(PermissionView):
    """
    查询所有的代理
    """
    para_legal_list_recv = ['Page', 'PageSize']
    para_legal_list_return = ['Password', 'CreatorID', 'RoleID', 'WithdrawPassWord', 'Cardholder', 'BankAccount', 'Bank']

    def response_admin(self):
        try:
            code, data = SmUserAgentService.admin_query_agent(**self.unpack_para(request.json))
            if code == 0:
                self.pop_no_need(data['rows'])
                return jsonify(SUCCESS(data))
            elif code == 1:
                return jsonify(OTHER_ERROR)
        except Exception as e:    # 参数解析错误
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)
        return jsonify(OTHER_ERROR)

    def response_agent(self):
        try:
            code, data = SmUserAgentService.agent_query_agent(self.user, **request.json)
            if code == 0:
                self.pop_no_need(data['rows'])
                return jsonify(SUCCESS(data))
            elif code == 1:
                return jsonify(OTHER_ERROR)
        except Exception as e:    # 参数解析错误
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)
        return jsonify(OTHER_ERROR)


class QueryAgentByID(PermissionView):
    """
    查询指定id的代理
    """
    para_legal_list_return = ['Password', 'CreatorID', 'RoleID', 'WithdrawPassWord']

    def __init__(self):
        super(QueryAgentByID, self).__init__()
        self.agent_id = None    # 带查询的代理id

    def dispatch_request(self, token_dict: dict, agent_id):
        self.agent_id = agent_id
        return super(QueryAgentByID, self).dispatch_request(token_dict)

    def response_admin(self):
        result = SmUserAgentService.get_by_id(self.agent_id)
        if result:
            self.pop_no_need(result)
            return jsonify(SUCCESS(result))
        else:
            return jsonify(QUERY_NO_RESULT)

    def response_agent(self):
        result = SmUserAgentService.agent_query_by_id(self.user, self.agent_id)
        if result:
            self.pop_no_need(result)
            return jsonify(SUCCESS(result))
        else:
            return jsonify(QUERY_NO_RESULT)


class ChangeAgentByID(PermissionView):
    """
    通过id更新代理信息， 管理员可以任意修改，代理只可修改自身次级代理
    """
    para_legal_list_recv = ['LoginName', 'NickName', 'Margin', 'TestMargin', 'CommissionRatio', 'ExchangeRate',
                            'MemberPrefix', 'MemberMaximum', 'Bank', 'BankAccount', 'Cardholder']

    def __init__(self):
        super(ChangeAgentByID, self).__init__()
        self.agent_id = None    # 带查询的代理id

    def dispatch_request(self, token_dict: dict, agent_id):
        self.agent_id = agent_id
        return super(ChangeAgentByID, self).dispatch_request(token_dict)

    def response_admin(self):
        result = 0
        try:
            result = SmUserAgentService.update_by_id(self.agent_id, **self.unpack_para(request.json))
        except Exception as e:
            result = 3
            current_app.logger.error(e)
        if result == 0:
            return jsonify(SUCCESS())
        elif result == 1:
            return jsonify(USER_SAME_LOGIN_NAME)
        elif result == 2:
            return jsonify(USER_AGENT_NOT_ENOUGH_MEMBER)
        elif result == 3:
            return jsonify(POST_PARA_ERROR)
        return jsonify(OTHER_ERROR)

    def response_agent(self):
        result = 0
        try:
            result = SmUserAgentService.agent_update_by_id(self.user, **self.unpack_para(request.json))
        except Exception as e:
            result = 4
            current_app.logger.error(e)
        if result == 0:
            return jsonify(SUCCESS())
        elif result == 1:
            return jsonify(USER_SAME_LOGIN_NAME)
        elif result == 2:
            return jsonify(USER_AGENT_LEVEL_LOW)
        elif result == 3:
            return jsonify(USER_AGENT_NOT_ENOUGH_MEMBER)
        elif result == 4:
            return jsonify(POST_PARA_ERROR)
        return jsonify(OTHER_ERROR)


class DeleteAgentByID(PermissionView):

    def __init__(self):
        super(DeleteAgentByID, self).__init__()
        self.agent_id = None    # 带查询的管理员id

    def dispatch_request(self, token_dict: dict, agent_id):
        self.agent_id = agent_id
        return super(DeleteAgentByID, self).dispatch_request(token_dict)

    def response_admin(self):
        result = 0
        try:
            result = SmUserAgentService.admin_delete_by_id(self.agent_id)
        except Exception as e:
            result = 3
            current_app.logger.error(e)
        if result == 0:
            return jsonify(SUCCESS())
        elif result == 1:
            return jsonify(USER_AGENT_MEMBER_NOT_NULL)
        elif result == 2:
            return jsonify(POST_PARA_ERROR)
        else:
            return jsonify(OTHER_ERROR)

    def response_agent(self):
        result = 0
        try:
            result = SmUserAgentService.agent_delete_by_id(self.user, self.agent_id)
        except Exception as e:
            result = 4
            current_app.logger.error(e)
        if result == 0:
            return jsonify(SUCCESS())
        elif result == 1:
            return jsonify(PERMISSION_DENIED_ERROR)
        elif result == 2:
            return jsonify(USER_AGENT_MEMBER_NOT_NULL)
        elif result == 3:
            return jsonify(POST_PARA_ERROR)
        else:
            return jsonify(OTHER_ERROR)


# 创建代理
user_agent_bp.add_url_rule('/create', methods=['POST'], view_func=CreateAgent.as_view('create_agent'))
# 查询所有代理
user_agent_bp.add_url_rule('/all', methods=['POST'], view_func=QueryAllAgent.as_view('all_agent'))
# 查询单个代理，通过id
user_agent_bp.add_url_rule('/query/<agent_id>', methods=['POST'], view_func=QueryAgentByID.as_view('query_agent_by_id'))
# 通过id修改代理
user_agent_bp.add_url_rule('/update/<agent_id>', methods=['POST'], view_func=ChangeAgentByID.as_view('update_agent_by_id'))
# 通过id删除代理
user_agent_bp.add_url_rule('/delete/<agent_id>', methods=['POST'], view_func=DeleteAgentByID.as_view('delete_agent_by_id'))
