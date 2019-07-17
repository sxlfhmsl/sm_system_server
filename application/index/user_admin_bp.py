# -*- coding:utf-8 -*-
"""
管理员处理接口， 通过id查询信息，通过id删除， 增加管理员记录
"""

from flask.blueprints import Blueprint
from flask import jsonify, abort, current_app, request

from .utils import PermissionView
from .sta_code import SUCCESS, USER_SAME_LOGIN_NAME, OTHER_ERROR, POST_PARA_ERROR, QUERY_NO_RESULT
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


class QueryAdminByID(PermissionView):

    def __init__(self):
        super(QueryAdminByID, self).__init__()
        self.admin_id = None    # 带查询的管理员id

    def dispatch_request(self, token_dict: dict, admin_id):
        self.admin_id = admin_id
        return super(QueryAdminByID, self).dispatch_request(token_dict)

    def response_admin(self):
        result = SmUserAdminService.get_by_id(self.admin_id)
        if result:
            return jsonify(SUCCESS(result))
        else:
            return jsonify(QUERY_NO_RESULT)

    def response_agent(self):
        abort(404)

    def response_member(self):
        abort(404)


user_admin_bp.add_url_rule('/create', methods=['POST'], view_func=CreateAdmin.as_view('create_admin'))
user_admin_bp.add_url_rule('/all', methods=['POST'], view_func=QueryAllAdmin.as_view('all_admin'))
user_admin_bp.add_url_rule('/query_sig/<admin_id>', methods=['POST'], view_func=QueryAdminByID.as_view('query_admin_by_id'))

