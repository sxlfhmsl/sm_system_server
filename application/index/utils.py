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
        token = RedisOp().get_normal(auth)
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

