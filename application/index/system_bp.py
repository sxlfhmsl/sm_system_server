# -*- coding:utf-8 -*-
"""
系统管理相关蓝图，获取和设置交易规则，获取和查看公告。。。
"""

from flask.blueprints import Blueprint
from flask import jsonify, request, current_app

from ..service.system_service import SystemService
from ..service.sys_notice_service import SmSysNoticeService
from .utils import PermissionView
from .sta_code import SUCCESS, OTHER_ERROR, POST_PARA_ERROR

system_bp = Blueprint('system', __name__)


class QueryTradeRole(PermissionView):
    """
    获取交易规则
    """

    @staticmethod
    def get_role():
        return jsonify(SUCCESS(SystemService.get_trade_role()))

    def response_admin(self):
        return self.get_role()

    def response_agent(self):
        return self.get_role()

    def response_member(self):
        return self.get_role()


class SetTradeRole(PermissionView):
    """
    获取交易规则
    """
    para_legal_list_recv = ['title', 'content']

    def response_admin(self):
        try:
            if SystemService.set_trade_role(**self.unpack_para(request.json)) == 0:
                return jsonify(SUCCESS())
            else:
                return jsonify(OTHER_ERROR)
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)


class QueryAllNotice(PermissionView):
    """
    获取所有可用公告
    """
    para_legal_list_recv = ['Page', 'PageSize']
    para_legal_list_return = ['AgentDisable', 'MemberDisable']

    def response_admin(self):
        result = SmSysNoticeService.query_all_notice(**self.unpack_para(request.json))
        return jsonify(SUCCESS(result))

    def response_agent(self):
        result = SmSysNoticeService.query_all_notice(user_type='agent', **self.unpack_para(request.json))
        self.pop_no_need(result['rows'])
        return jsonify(SUCCESS(result))

    def response_member(self):
        result = SmSysNoticeService.query_all_notice(user_type='member')
        self.pop_no_need(result['rows'])
        return jsonify(SUCCESS(result['rows']))


class CreateNotice(PermissionView):
    """
    获取所有可用公告
    """
    para_legal_list_recv = ['Title', 'Content', 'AgentDisable', 'MemberDisable']

    def response_admin(self):
        try:
            if SmSysNoticeService.create_sys_notice(self.user, **self.unpack_para(request.json)) == 0:
                return jsonify(SUCCESS())
            else:
                return jsonify(POST_PARA_ERROR)
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)


class UpdateNoticeByID(PermissionView):
    """
    通过id更新公告
    """
    para_legal_list_recv = ['Title', 'Content', 'AgentDisable', 'MemberDisable']

    def __init__(self):
        super(UpdateNoticeByID, self).__init__()
        self.notice_id = None    # 带查询的管理员id

    def dispatch_request(self, token_dict: dict, notice_id):
        self.notice_id = notice_id
        return super(UpdateNoticeByID, self).dispatch_request(token_dict)

    def response_admin(self):
        try:
            if SmSysNoticeService.update_by_id(self.notice_id, **self.unpack_para(request.json)) == 0:
                return jsonify(SUCCESS())
            else:
                return jsonify(POST_PARA_ERROR)
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)


class QueryNoticeByID(PermissionView):
    """
    通过id更新公告
    """
    para_legal_list_return = ['ID', 'CreatorID', 'Time', 'AgentDisable', 'MemberDisable']

    def __init__(self):
        super(QueryNoticeByID, self).__init__()
        self.notice_id = None    # 带查询的管理员id

    def dispatch_request(self, token_dict: dict, notice_id):
        self.notice_id = notice_id
        return super(QueryNoticeByID, self).dispatch_request(token_dict)

    def response_admin(self):
        try:
            result = SmSysNoticeService.get_by_id(self.notice_id)
            if not result:
                return jsonify(POST_PARA_ERROR)
            self.pop_no_need(result)
            return jsonify(SUCCESS(result))
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)

    def response_agent(self):
        try:
            result = SmSysNoticeService.get_by_id(self.notice_id)
            if not result or result['AgentDisable'] != 0:
                return jsonify(POST_PARA_ERROR)
            self.pop_no_need(result)
            return jsonify(SUCCESS(result))
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)

    def response_member(self):
        try:
            result = SmSysNoticeService.get_by_id(self.notice_id)
            if not result or result['MemberDisable'] != 0:
                return jsonify(POST_PARA_ERROR)
            self.pop_no_need(result)
            return jsonify(SUCCESS(result))
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)


class DeleteNoticeByID(PermissionView):
    """
    通过id更新公告
    """
    para_legal_list_recv = ['Title', 'Content', 'AgentDisable', 'MemberDisable']

    def __init__(self):
        super(DeleteNoticeByID, self).__init__()
        self.notice_id = None    # 带查询的管理员id

    def dispatch_request(self, token_dict: dict, notice_id):
        self.notice_id = notice_id
        return super(DeleteNoticeByID, self).dispatch_request(token_dict)

    def response_admin(self):
        try:
            if SmSysNoticeService.delete_by_id(self.notice_id) == 0:
                return jsonify(SUCCESS())
            else:
                return jsonify(POST_PARA_ERROR)
        except Exception as e:
            current_app.logger.error(e)
            return jsonify(POST_PARA_ERROR)


# 获取交易规则
system_bp.add_url_rule('/traderole', methods=['POST'], view_func=QueryTradeRole.as_view('system_traderole'))
# 设置交易规则
system_bp.add_url_rule('/set_traderole', methods=['POST'], view_func=SetTradeRole.as_view('system_set_traderole'))
# 获取公告
system_bp.add_url_rule('/notice', methods=['POST'], view_func=QueryAllNotice.as_view('system_all_notice'))
# 添加公告
system_bp.add_url_rule('/notice/create', methods=['POST'], view_func=CreateNotice.as_view('system_create_notice'))
# 更新公告
system_bp.add_url_rule('/notice/update/<notice_id>', methods=['POST'], view_func=UpdateNoticeByID.as_view('system_update_notice'))
# 通过id查询公告
system_bp.add_url_rule('/notice/query/<notice_id>', methods=['POST'], view_func=QueryNoticeByID.as_view('system_query_notice'))
# 通过id删除公告
system_bp.add_url_rule('/notice/delete/<notice_id>', methods=['POST'], view_func=DeleteNoticeByID.as_view('system_delete_notice'))

