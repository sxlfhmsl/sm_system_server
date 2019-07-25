# -*- coding:utf-8 -*-
"""
业务员接口， 查询等。。。
"""
from flask import request, current_app, jsonify
from flask.blueprints import Blueprint

from .utils import PermissionView
from ..service.clerk_service import SmClerkService
from .sta_code import POST_PARA_ERROR, SUCCESS, OTHER_ERROR, PERMISSION_DENIED_ERROR, QUERY_NO_RESULT, CLERK_SAME_NAME

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


class DeleteClerkByID(PermissionView):
    """
    通过id删除管理员
    """

    def __init__(self):
        super(DeleteClerkByID, self).__init__()
        self.clerk_id = None    # 带查询的管理员id

    def dispatch_request(self, token_dict: dict, clerk_id):
        self.clerk_id = clerk_id
        return super(DeleteClerkByID, self).dispatch_request(token_dict)

    def response_admin(self):
        try:
            result = SmClerkService.delete_by_id(self.clerk_id)
            if result == 0:
                return jsonify(SUCCESS())
            else:
                return jsonify(POST_PARA_ERROR)
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)

    def response_agent(self):
        try:
            result = SmClerkService.agent_delete_clerk(self.user, self.clerk_id)
            if result == 0:
                return jsonify(SUCCESS())
            elif result == 1:
                return jsonify(POST_PARA_ERROR)
            elif result == 2:
                return jsonify(PERMISSION_DENIED_ERROR)
            return jsonify(OTHER_ERROR)
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)


class UpdateClerkByID(PermissionView):
    """
    通过id删除管理员
    """
    para_legal_list_recv = ['AgentID', 'NickName']

    def __init__(self):
        super(UpdateClerkByID, self).__init__()
        self.clerk_id = None    # 带查询的管理员id

    def dispatch_request(self, token_dict: dict, clerk_id):
        self.clerk_id = clerk_id
        return super(UpdateClerkByID, self).dispatch_request(token_dict)

    def response_admin(self):
        try:
            result = SmClerkService.admin_update_clerk(self.clerk_id, **self.unpack_para(request.json))
            if result == 0:
                return jsonify(SUCCESS())
            elif result == 1:
                return jsonify(POST_PARA_ERROR)
            elif result == 2:
                return jsonify(CLERK_SAME_NAME)
            return jsonify(OTHER_ERROR)
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)

    def response_agent(self):
        try:
            result = SmClerkService.admin_update_clerk(self.clerk_id, **self.unpack_para(request.json))
            if result == 0:
                return jsonify(SUCCESS())
            elif result == 1:
                return jsonify(POST_PARA_ERROR)
            elif result == 2:
                return jsonify(CLERK_SAME_NAME)
            elif result == 3:
                return jsonify(PERMISSION_DENIED_ERROR)
            return jsonify(OTHER_ERROR)
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)


# 创建业务员
clerk_bp.add_url_rule('/create', methods=['POST'], view_func=ClerkCreateView.as_view('clerk_create'))
# 删除业务员-----通过id
clerk_bp.add_url_rule('/delete/<clerk_id>', methods=['POST'], view_func=DeleteClerkByID.as_view('clerk_delete'))
# 更新业务员-----通过id
clerk_bp.add_url_rule('/update/<clerk_id>', methods=['POST'], view_func=UpdateClerkByID.as_view('clerk_update'))
