# -*- coding:utf-8 -*-
"""
用户登录接口
"""
from flask.blueprints import Blueprint
from flask import request, jsonify, abort

from .utils import BaseView, PermissionView
from .sta_code import SUCCESS, USER_NAME_PASS_WRONG_ERROR, USER_FORBIDDEN_ERROR, USER_LOCK_ERROR, OTHER_ERROR
from .sta_code import PERMISSION_DENIED_ERROR
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


class UserInfoView(PermissionView):
    """
    获取用户信息
    """

    def response_admin(self):
        result = SmUserAdminService.info_by_id(self.u_id)
        if result:
            return jsonify(SUCCESS(result))
        return jsonify(PERMISSION_DENIED_ERROR)

    def response_agent(self):
        result = SmUserAgentService.info_by_id(self.u_id)
        if result:
            return jsonify(SUCCESS(result))
        return jsonify(PERMISSION_DENIED_ERROR)

    def response_member(self):
        result = SmUserMemberService.info_by_id(self.u_id)
        if result:
            return jsonify(SUCCESS(result))
        return jsonify(PERMISSION_DENIED_ERROR)


class CreateAdmin(PermissionView):
    """
    创建管理员
    """

    def response_admin(self):
        try:
            if SmUserAdminService.insert(CreatorID=self.u_id, **request.json) != 0:
                return jsonify(ERROR_BASE['POST_PARA_ERROR'])
            else:
                return jsonify(SUCCESS())
        except:
            return jsonify(ERROR_BASE['POST_PARA_ERROR'])

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
            result = SmUserAgentService.insert(self._token_data, **request.json)
            if result == 0:                                                        # 添加成功
                return jsonify(SUCCESS())
            if result == 1:                                                        # 参数错误
                return jsonify(ERROR_BASE['POST_PARA_ERROR'])
        except Exception:
            return jsonify(ERROR_BASE['POST_PARA_ERROR'])

    def response_agent(self):
        try:
            result = SmUserAgentService.insert(self._token_data, **request.json)
            if result == 0:                                                        # 添加成功
                return jsonify(SUCCESS())
            if result == 1:                                                        # 参数错误
                return jsonify(ERROR_BASE['POST_PARA_ERROR'])
            if result == 2:                                                        # 权限不足----最大4级代理
                abort(404)
        except Exception:
            return jsonify(ERROR_BASE['POST_PARA_ERROR'])

    def response_member(self):
        abort(404)


class CreateMember(PermissionView):
    """
    创建会员操作
    """

    def response_admin(self):
        try:
            result = SmUserMemberService.insert(self._token_data, **request.json)
            if result == 0:                                                        # 添加成功
                return jsonify(SUCCESS())
            if result == 1:                                                        # 参数错误
                return jsonify(ERROR_BASE['POST_PARA_ERROR'])
        except Exception:
            return jsonify(ERROR_BASE['POST_PARA_ERROR'])

    def response_agent(self):
        abort(404)

    def response_member(self):
        abort(404)


user_bp.add_url_rule('/login', methods=['POST'], view_func=UserLoginView.as_view('user_login'))
user_bp.add_url_rule('/info', methods=['POST'], view_func=UserInfoView.as_view('user_info'))
user_bp.add_url_rule('/create_admin', methods=['POST'], view_func=CreateAdmin.as_view('create_admin'))
user_bp.add_url_rule('/create_agent', methods=['POST'], view_func=CreateAgent.as_view('create_agent'))
user_bp.add_url_rule('/create_member', methods=['POST'], view_func=CreateMember.as_view('create_member'))

