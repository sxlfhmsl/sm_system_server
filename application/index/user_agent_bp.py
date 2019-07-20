# -*- coding:utf-8 -*-
"""
代理处理接口， 通过id查询信息，通过id删除， 增加代理记录
"""

from flask.blueprints import Blueprint
from flask import jsonify, abort, current_app, request

from .utils import PermissionView
from .sta_code import SUCCESS, USER_SAME_LOGIN_NAME, OTHER_ERROR, POST_PARA_ERROR, USER_AGENT_LEVEL_LOW, QUERY_NO_RESULT
from ..service.user_agent_service import SmUserAgentService

user_agent_bp = Blueprint('user/agent', __name__)


class CreateAgent(PermissionView):
    """
    创建代理
    """
    def response_admin(self):
        try:
            result = SmUserAgentService.admin_create_agent(self.user, **request.json)
            if result == 0:                                                        # 添加成功
                return jsonify(SUCCESS())
            elif result == 1:                                                      # 相同用户名
                return jsonify(USER_SAME_LOGIN_NAME)
            elif result == 2:
                return jsonify(OTHER_ERROR)
        except Exception as e:    # 参数解析错误
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)
        return jsonify(OTHER_ERROR)

    def response_agent(self):
        try:
            result = SmUserAgentService.agent_create_agent(self.user, **request.json)
            if result == 0:                                                        # 添加成功
                return jsonify(SUCCESS())
            elif result == 1:                                                      # 相同用户名
                return jsonify(USER_SAME_LOGIN_NAME)
            elif result == 2:                                                      # 代理等级过低
                return jsonify(USER_AGENT_LEVEL_LOW)
            elif result == 3:                                                      # 其他错误
                return jsonify(OTHER_ERROR)
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)
        return jsonify(OTHER_ERROR)


class QueryAllAgent(PermissionView):
    """
    查询所有的代理
    """

    def response_admin(self):
        try:
            code, data = SmUserAgentService.query_agent(agent_id=None, **request.json)
            if code == 0:
                return jsonify(SUCCESS(data))
            elif code == 1:
                return jsonify(OTHER_ERROR)
        except Exception as e:    # 参数解析错误
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)
        return jsonify(OTHER_ERROR)

    def response_agent(self):
        try:
            code, data = SmUserAgentService.query_agent(agent_id=self.u_id, **request.json)
            if code == 0:
                return jsonify(SUCCESS(data))
            elif code == 1:
                return jsonify(OTHER_ERROR)
        except Exception as e:    # 参数解析错误
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)
        return jsonify(OTHER_ERROR)


class QueryAgentByID(PermissionView):
    """
    查询指定id的代理
    """
    def __init__(self):
        super(QueryAgentByID, self).__init__()
        self.agent_id = None    # 带查询的代理id

    def dispatch_request(self, token_dict: dict, agent_id):
        self.agent_id = agent_id
        return super(QueryAgentByID, self).dispatch_request(token_dict)

    def response_admin(self):
        result = SmUserAgentService.get_by_id(self.agent_id)
        if result:
            return jsonify(SUCCESS(result))
        else:
            return jsonify(QUERY_NO_RESULT)

    def response_agent(self):
        result = SmUserAgentService.get_by_id(self.agent_id, self.u_id)
        if result:
            return jsonify(SUCCESS(result))
        else:
            return jsonify(QUERY_NO_RESULT)


# 创建代理
user_agent_bp.add_url_rule('/create', methods=['POST'], view_func=CreateAgent.as_view('create_agent'))
# 查询所有代理
user_agent_bp.add_url_rule('/all', methods=['POST'], view_func=QueryAllAgent.as_view('all_agent'))
# 查询单个代理，通过id
user_agent_bp.add_url_rule('/query/<agent_id>', methods=['POST'], view_func=QueryAgentByID.as_view('query_agent_by_id'))

