# -*- coding:utf-8 -*-
"""
定义一些基础东西
"""
from flask.views import View


class BaseView(View):
    """
    基础View，拦截未登录，进行预处理
    """

    def dispatch_request(self):
        pass

