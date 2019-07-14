# -*- coding:utf-8 -*-
"""
用户登录接口
"""
from flask.blueprints import Blueprint
from flask import request, jsonify, abort

from .utils import BaseView, PermissionView
from .sta_code import SUCCESS, ERROR_USER_LOGIN, ERROR_BASE
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
        token = SmUserService.login(request.json['LoginName'], request.json['Password'])
        if len(token) == 64:
            success = SUCCESS()
            success['data'] = {'token': token}
            return jsonify(success)
        else:
            return jsonify(ERROR_USER_LOGIN[token])


class UserInfoView(PermissionView):
    """
    获取用户信息
    """

    def response_admin(self):
        success = SUCCESS()
        success['data'] = SmUserAdminService.info_by_id(self.u_id)
        return jsonify(success)

    def response_agent(self):
        success = SUCCESS()
        success['data'] = SmUserAgentService.info_by_id(self.u_id)
        return jsonify(success)

    def response_member(self):
        success = SUCCESS()
        success['data'] = SmUserMemberService.info_by_id(self.u_id)
        return jsonify(success)


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

