# -*- coding:utf-8 -*-
"""
用户登录接口
"""
from flask.blueprints import Blueprint
from flask import request, jsonify, abort, current_app

from .utils import BaseView, PermissionView
from .sta_code import SUCCESS, USER_NAME_PASS_WRONG_ERROR, USER_FORBIDDEN_ERROR, USER_LOCK_ERROR, OTHER_ERROR
from .sta_code import PERMISSION_DENIED_ERROR, POST_PARA_ERROR
from .sta_code import USER_WRONG_PASS
from ..service.user_service import SmUserService
from ..service.user_admin_service import SmUserAdminService
from ..service.user_agent_service import SmUserAgentService
from ..service.user_member_service import SmUserMemberService

user_bp = Blueprint('user', __name__)


class UserLoginView(BaseView):
    """
    用户登录
    """

    def dispatch_request(self):
        code, token = SmUserService.login(request.json['LoginName'], request.json['Password'])
        if code == 0:                                        # 登录成功
            return jsonify(SUCCESS({'auth': token}))
        elif code == 1:                                      # 账户或者密码错误
            return jsonify(USER_NAME_PASS_WRONG_ERROR)
        elif code == 2:                                      # 用户被禁用
            return jsonify(USER_FORBIDDEN_ERROR)
        elif code == 3:                                      # 用户被锁定
            return jsonify(USER_LOCK_ERROR)
        elif code == 4:                                      # 其他错误
            return jsonify(OTHER_ERROR)


class UserLogoutView(PermissionView):
    """
    退出登录接口
    """

    def logout(self):
        SmUserService.logout(request.headers.get('auth', None), self.u_id)
        return jsonify(SUCCESS())

    def response_admin(self):
        return self.logout()

    def response_agent(self):
        return self.logout()

    def response_member(self):
        return self.logout()


class UserInfoView(PermissionView):
    """
    获取用户信息
    """
    para_legal_list = ['Password', 'Forbidden', 'RoleID', 'Lock', 'CreatorID']

    def response_admin(self):
        result = SmUserAdminService.get_by_id(self.u_id)
        self.pop_no_need(result)
        if result:
            return jsonify(SUCCESS(result))
        return jsonify(PERMISSION_DENIED_ERROR)

    def response_agent(self):
        result = SmUserAgentService.get_by_id(self.u_id)
        self.pop_no_need(result)
        if result:
            return jsonify(SUCCESS(result))
        return jsonify(PERMISSION_DENIED_ERROR)

    def response_member(self):
        result = SmUserMemberService.get_by_id(self.u_id)
        self.pop_no_need(result)
        if result:
            return jsonify(SUCCESS(result))
        return jsonify(PERMISSION_DENIED_ERROR)


class UserChangePassView(PermissionView):
    """
    修改密码，Pass
    """

    def response_admin(self):
        try:
            result = SmUserService.change_login_pass(self.user, request.json.get('Old', None), request.json.get('New', None))
            if result == 0:
                return jsonify(SUCCESS())
            elif result == 1:
                return jsonify(USER_WRONG_PASS)
            elif result == 2:
                return jsonify(OTHER_ERROR)
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)

    def response_agent(self):
        try:
            result = None
            if request.json.get('Type', None) == 2:
                result = SmUserAdminService.change_withdraw_pass(self.user, request.json.get('Old', None), request.json.get('New', None))
            else:
                result = SmUserService.change_login_pass(self.user, request.json.get('Old', None), request.json.get('New', None))
            if result == 0:
                return jsonify(SUCCESS())
            elif result == 1:
                return jsonify(USER_WRONG_PASS)
            elif result == 2:
                return jsonify(OTHER_ERROR)
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)

    def response_member(self):
        try:
            result = None
            if request.json.get('Type', None) == 2:
                result = SmUserMemberService.change_withdraw_pass(self.user, request.json.get('Old', None), request.json.get('New', None))
            else:
                result = SmUserService.change_login_pass(self.user, request.json.get('Old', None), request.json.get('New', None))
            if result == 0:
                return jsonify(SUCCESS())
            elif result == 1:
                return jsonify(USER_WRONG_PASS)
            elif result == 2:
                return jsonify(OTHER_ERROR)
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)


user_bp.add_url_rule('/login', methods=['POST'], view_func=UserLoginView.as_view('user_login'))
user_bp.add_url_rule('/logout', methods=['POST'], view_func=UserLogoutView.as_view('user_logout'))
user_bp.add_url_rule('/info', methods=['POST'], view_func=UserInfoView.as_view('user_info'))
user_bp.add_url_rule('/change_pass', methods=['POST'], view_func=UserChangePassView.as_view('user_change_pass'))

