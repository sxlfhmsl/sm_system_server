# -*- coding:utf-8 -*-
"""
定义一些基础东西
"""
import functools
from flask.views import View
from flask import abort, request

from ..dao.utils import RedisOp
from ..service.auth import decode_auth_token


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
        self._uid = None
        self._u_type = None

    def response_admin(self):
        raise NotImplementedError

    def response_agent(self):
        raise NotImplementedError

    def response_member(self):
        raise NotImplementedError

    def dispatch_request(self, token_dict: dict):
        self._token_data = token_dict['data']
        self._uid = self._token_data['uid']
        self._u_type = self._token_data['utype']
        if self._u_type == 'Admin':
            return self.response_admin()
        elif self._u_type == 'Agent':
            return self.response_agent()
        elif self._u_type == 'Member':
            return self.response_member()

