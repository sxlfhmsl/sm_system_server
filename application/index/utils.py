# -*- coding:utf-8 -*-
"""
定义一些基础东西
"""
import functools
from flask.views import View
from flask import abort, request, jsonify

from .sta_code import PERMISSION_DENIED_ERROR
from ..dao.utils import RedisOp
from ..service.auth import decode_auth_token
from ..service.utils import BaseService


def check_auth(fn):
    @functools.wraps(fn)
    def wrapper(*args, **kwargs):
        auth = request.headers.get('auth', None)
        if auth is None:
            abort(404)
        token = RedisOp().get_normal(auth)
        print(auth)
        # 检测不到token
        if token is None:
            abort(404)
        try:
            token_dict = decode_auth_token(token)
        except Exception as e:
            print(e)
            abort(404)
        return fn(token_dict, *args, **kwargs)
    return wrapper


class BaseView(View):
    """
    基础View，拦截未登录，进行预处理
    """

    def dispatch_request(self):
        # 暂时404
        abort(404)


class PermissionView(BaseView):
    # 验证token
    decorators = (check_auth, )

    def __init__(self):
        self._token_data = None
        self.user = None
        self.u_id = None
        self.u_login_name = None
        self.u_nick_name = None
        self.u_role_id = None
        self.u_role_name = None

    def response_admin(self):
        raise NotImplementedError

    def response_agent(self):
        raise NotImplementedError

    def response_member(self):
        raise NotImplementedError

    def dispatch_request(self, token_dict: dict):
        self._token_data = token_dict['data']
        self.user = BaseService.is_forbidden(self._token_data['u_id'], self._token_data['u_role_name'])
        if self.user is None:
            return jsonify(PERMISSION_DENIED_ERROR)
        self.u_id = self._token_data['u_id']
        self.u_login_name = self._token_data['u_login_name']
        self.u_nick_name = self._token_data['u_nick_name']
        self.u_role_id = self._token_data['u_role_id']
        self.u_role_name = self._token_data['u_role_name']
        if self.u_role_name == 'Admin':
            return self.response_admin()
        elif self.u_role_name == 'Agent':
            return self.response_agent()
        elif self.u_role_name == 'Member':
            return self.response_member()

