# -*- coding:utf-8 -*-
"""
管理员处理接口， 通过id查询信息，通过id删除， 增加管理员记录
"""

from flask.blueprints import Blueprint
from flask import jsonify, abort, current_app, request

from .utils import PermissionView
from .sta_code import SUCCESS, USER_SAME_LOGIN_NAME, OTHER_ERROR, POST_PARA_ERROR
from ..service.user_admin_service import SmUserAdminService

user_admin_bp = Blueprint('user/admin', __name__)


class CreateAdmin(PermissionView):
    """
    创建管理员
    """

    def response_admin(self):
        try:
            result = SmUserAdminService.create_admin(CreatorID=self.u_id, **request.json)
            if result == 0:
                return jsonify(SUCCESS())
            elif result == 1:
                return jsonify(USER_SAME_LOGIN_NAME)
            elif result == 2:
                return jsonify(OTHER_ERROR)
        except Exception as e:    # 参数解析错误
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)
        return jsonify(OTHER_ERROR)

    def response_agent(self):
        abort(404)

    def response_member(self):
        abort(404)


class QueryAllAdmin(PermissionView):
    """
    查询所有的管理员
    """

    def response_admin(self):
        try:
            code, data = SmUserAdminService.query_admin(**request.json)
            if code == 0:
                return jsonify(SUCCESS(data))
            elif code == 1:
                return jsonify(OTHER_ERROR)
        except Exception as e:    # 参数解析错误
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)
        return jsonify(OTHER_ERROR)

    def response_agent(self):
        abort(404)

    def response_member(self):
        abort(404)


user_admin_bp.add_url_rule('/create', methods=['POST'], view_func=CreateAdmin.as_view('create_admin'))
user_admin_bp.add_url_rule('/all', methods=['POST'], view_func=QueryAllAdmin.as_view('all_admin'))

