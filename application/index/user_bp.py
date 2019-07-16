# -*- coding:utf-8 -*-
"""
用户登录接口
"""
from flask.blueprints import Blueprint
from flask import request, jsonify, abort, current_app

from .utils import BaseView, PermissionView
from .sta_code import SUCCESS, USER_NAME_PASS_WRONG_ERROR, USER_FORBIDDEN_ERROR, USER_LOCK_ERROR, OTHER_ERROR
from .sta_code import PERMISSION_DENIED_ERROR, USER_SAME_LOGIN_NAME, POST_PARA_ERROR, USER_AGENT_LEVEL_LOW
from .sta_code import USER_AGENT_NOT_ENOUGH_MEMBER
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

    def response_admin(self):
        result = SmUserAdminService.info_by_id(self.user)
        if result:
            return jsonify(SUCCESS(result))
        return jsonify(PERMISSION_DENIED_ERROR)

    def response_agent(self):
        result = SmUserAgentService.info_by_id(self.user)
        if result:
            return jsonify(SUCCESS(result))
        return jsonify(PERMISSION_DENIED_ERROR)

    def response_member(self):
        result = SmUserMemberService.info_by_id(self.user)
        if result:
            return jsonify(SUCCESS(result))
        return jsonify(PERMISSION_DENIED_ERROR)


class CreateAdmin(PermissionView):
    """
    创建管理员
    """

    def response_admin(self):
        try:
            result = SmUserAdminService.create_admin(CreatorID=self.u_id, **request.json)
            if result == 0:
                return jsonify(SUCCESS())
            elif result == 1:
                return jsonify(USER_SAME_LOGIN_NAME)
            elif result == 2:
                return jsonify(OTHER_ERROR)
        except Exception as e:    # 参数解析错误
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)
        return jsonify(OTHER_ERROR)

    def response_agent(self):
        abort(404)

    def response_member(self):
        abort(404)


class QueryAllAdmin(PermissionView):
    """
    查询所有的管理员
    """

    def response_admin(self):
        try:
            code, data = SmUserAdminService.query_admin(**request.json)
            if code == 0:
                return jsonify(SUCCESS(data))
            elif code == 1:
                return jsonify(OTHER_ERROR)
        except Exception as e:    # 参数解析错误
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)
        return jsonify(OTHER_ERROR)

    def response_agent(self):
        abort(404)

    def response_member(self):
        abort(404)


class CreateAgent(PermissionView):
    """
    创建代理
    """
    def response_admin(self):
        try:
            result = SmUserAgentService.admin_create_agent(self.user, **request.json)
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
            result = SmUserAgentService.agent_create_agent(self.user, **request.json)
            if result == 0:                                                        # 添加成功
                return jsonify(SUCCESS())
            elif result == 1:                                                      # 相同用户名
                return jsonify(USER_SAME_LOGIN_NAME)
            elif result == 2:                                                      # 代理等级过低
                return jsonify(USER_AGENT_LEVEL_LOW)
            elif result == 3:                                                      # 其他错误
                return jsonify(OTHER_ERROR)
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)
        return jsonify(OTHER_ERROR)

    def response_member(self):
        abort(404)


class CreateMember(PermissionView):
    """
    创建会员操作
    """

    def response_admin(self):
        try:
            result = SmUserMemberService.admin_create_member(self.user, **request.json)
            if result == 0:                                                        # 添加成功
                return jsonify(SUCCESS())
            if result == 1:                                                        # 相同登录名
                return jsonify(USER_SAME_LOGIN_NAME)
            elif result == 2:                                                      # 其他错误
                return jsonify(OTHER_ERROR)
            elif result == 3:
                return jsonify(USER_AGENT_NOT_ENOUGH_MEMBER)
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)
        return jsonify(OTHER_ERROR)

    def response_agent(self):
        try:
            result = SmUserMemberService.agent_create_member(self.user, **request.json)
            if result == 0:                                                        # 添加成功
                return jsonify(SUCCESS())
            if result == 1:                                                        # 相同登录名
                return jsonify(USER_SAME_LOGIN_NAME)
            elif result == 2:                                                      # 成员不足
                return jsonify(USER_AGENT_NOT_ENOUGH_MEMBER)
            elif result == 3:
                return jsonify(OTHER_ERROR)
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)
        return jsonify(OTHER_ERROR)

    def response_member(self):
        abort(404)


user_bp.add_url_rule('/login', methods=['POST'], view_func=UserLoginView.as_view('user_login'))
user_bp.add_url_rule('/logout', methods=['POST'], view_func=UserLogoutView.as_view('user_logout'))
user_bp.add_url_rule('/info', methods=['POST'], view_func=UserInfoView.as_view('user_info'))
user_bp.add_url_rule('/create_admin', methods=['POST'], view_func=CreateAdmin.as_view('create_admin'))
user_bp.add_url_rule('/query_admins', methods=['POST'], view_func=QueryAllAdmin.as_view('query_admins'))
user_bp.add_url_rule('/create_agent', methods=['POST'], view_func=CreateAgent.as_view('create_agent'))
user_bp.add_url_rule('/create_member', methods=['POST'], view_func=CreateMember.as_view('create_member'))

