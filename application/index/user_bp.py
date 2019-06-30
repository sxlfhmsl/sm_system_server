# -*- coding:utf-8 -*-
"""
用户登录接口
"""
from flask.blueprints import Blueprint
from .utils import BaseView

user_bp = Blueprint('user', __name__)


class UserLoginView(BaseView):
    """
    用户登录
    """
    pass


user_bp.add_url_rule('/login', methods=['GET'], view_func=UserLoginView.as_view('user_login'))

