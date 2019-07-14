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
    from .sta_code import ERROR_SYSTEM
    return jsonify(ERROR_SYSTEM['NOTFOUND_ERROR'])


@exception_bp.app_errorhandler(500)
def exception_500(error):
    """
    500
    :return:
    """
    from .sta_code import ERROR_SYSTEM
    return jsonify(ERROR_SYSTEM['INS_ERROR'])

