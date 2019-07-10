# -*- coding:utf-8 -*-
"""
用户登录接口
"""
from flask.blueprints import Blueprint
from flask import request, jsonify

from .utils import BaseView, PermissionView
from .sta_code import SUCCESS, ERROR_USER_LOGIN
from ..service.user_service import SmUserService

user_bp = Blueprint('user', __name__)


class UserLoginView(BaseView):
    """
    用户登录
    """

    def dispatch_request(self):
        token = SmUserService.login(request.json['LoginName'], request.json['Password'])
        if not isinstance(token, int):
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
        success['data'] = SmUserService.admin_info_id(self._uid)
        return jsonify(success)

    def response_agent(self):
        success = SUCCESS()
        success['data'] = SmUserService.agent_info_id(self._uid)
        return jsonify(success)

    def response_member(self):
        success = SUCCESS()
        success['data'] = SmUserService.member_info_id(self._uid)
        return jsonify(success)


user_bp.add_url_rule('/login', methods=['POST'], view_func=UserLoginView.as_view('user_login'))
user_bp.add_url_rule('/info', methods=['POST'], view_func=UserInfoView.as_view('user_info'))

