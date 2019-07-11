# -*- coding:utf-8 -*-
"""
用户登录接口
"""
from flask.blueprints import Blueprint
from flask import request, jsonify, abort

from .utils import BaseView, PermissionView
from .sta_code import SUCCESS, ERROR_USER_LOGIN, POST_PARA_ERROR
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


class CreateAdmin(PermissionView):
    """
    创建管理员
    """

    def response_admin(self):
        if request.json is None or len(request.json) == 0:
            return jsonify(POST_PARA_ERROR)
        if SmUserService.create_admin(
                CreatorID=self._uid,
                LoginName=request.json.get('LoginName', None),
                NickName=request.json.get('NickName', None),
                Password=request.json.get('Password', None)
        ) != 0:
            return jsonify(POST_PARA_ERROR)
        else:
            return jsonify(SUCCESS())

    def response_agent(self):
        abort(404)

    def response_member(self):
        abort(404)


user_bp.add_url_rule('/login', methods=['POST'], view_func=UserLoginView.as_view('user_login'))
user_bp.add_url_rule('/info', methods=['POST'], view_func=UserInfoView.as_view('user_info'))
user_bp.add_url_rule('/create_admin', methods=['POST'], view_func=CreateAdmin.as_view('create_admin'))

