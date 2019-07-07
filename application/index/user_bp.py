# -*- coding:utf-8 -*-
"""
用户登录接口
"""
from flask.blueprints import Blueprint
from flask import request, jsonify

from .utils import BaseView
from .sta_code import SUCCESS, ERROR_USER_PASSWORD_ERROR
from ..service.user_service import SmUserService

user_bp = Blueprint('user', __name__)


class UserLoginView(BaseView):
    """
    用户登录
    """

    def dispatch_request(self):
        token = SmUserService.login(request.json['LoginName'], request.json['Password'])
        if token:
            success = SUCCESS()
            success['data'] = {'token': token}
            return jsonify(success)
        else:
            return jsonify(ERROR_USER_PASSWORD_ERROR)


user_bp.add_url_rule('/login', methods=['POST'], view_func=UserLoginView.as_view('user_login'))

