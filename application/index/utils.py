# -*- coding:utf-8 -*-
"""
定义一些基础东西
"""
from flask.views import View
from flask import abort


class BaseView(View):
    """
    基础View，拦截未登录，进行预处理
    """

    def dispatch_request(self):
        # 暂时404
        abort(404)

