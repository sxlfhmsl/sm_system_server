# -*- coding:utf-8 -*-
"""
异常拦截，蓝图
"""
from flask.blueprints import Blueprint
from flask.json import jsonify

exception_bp = Blueprint('exception', __name__)


@exception_bp.app_errorhandler(404)
def exception_404(error):
    """
    404
    :return:
    """
    from .sta_code import URL_NOTFOUND_ERROR
    return jsonify(URL_NOTFOUND_ERROR)


@exception_bp.app_errorhandler(500)
def exception_500(error):
    """
    500
    :return:
    """
    from .sta_code import INS_ERROR
    return jsonify(INS_ERROR)

