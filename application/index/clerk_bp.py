# -*- coding:utf-8 -*-
"""
业务员接口， 查询等。。。
"""
from flask import request, current_app, jsonify
from flask.blueprints import Blueprint

from .utils import PermissionView
from ..service.clerk_service import SmClerkService
from .sta_code import POST_PARA_ERROR, SUCCESS, OTHER_ERROR

clerk_bp = Blueprint('clerk', __name__)


class ClerkCreateView(PermissionView):
    """
    创建业务员
    """

    para_legal_list_recv = ['AgentID', 'NickName']

    def response_admin(self):
        try:
            result = SmClerkService.create_clerk(self.user, '管理员', **self.unpack_para(request.json))
            if result == 0:
                return jsonify(SUCCESS())
            else:
                return jsonify(OTHER_ERROR)
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)

    def response_agent(self):
        try:
            para = self.unpack_para(request.json)
            para['AgentID'] = self.u_id
            result = SmClerkService.create_clerk(self.user, '代理', **para)
            if result == 0:
                return jsonify(SUCCESS())
            else:
                return jsonify(OTHER_ERROR)
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)


clerk_bp.add_url_rule('/create', methods=['POST'], view_func=ClerkCreateView.as_view('clerk_create'))
