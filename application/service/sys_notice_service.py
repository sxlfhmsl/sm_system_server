# -*- coding:utf-8 -*-
"""
公告service
"""
from flask import current_app
from sqlalchemy.orm import aliased

from .utils import BaseService
from ..dao.models import db, SmSysNotice, SmUser


class SmSysNoticeService(BaseService):
    """
    notice管理service
    """
    BaseModel = SmSysNotice


    @classmethod
    def query_all_notice(cls, user_type='admin', Page=None, PageSize=None):
        """
        查询所有notice
        :param user_type: 用户类型
        :param Page: 页数
        :param PageSize: 每页数量
        :return: 结果
        """
        if Page is None or PageSize is None:
            Page = 1
            PageSize = 1000
        try:
            filter_list = []
            if user_type == 'agent':
                filter_list.append(SmSysNotice.AgentDisable == 0)
            else:
                filter_list.append(SmSysNotice.MemberDisable == 0)
            user_table = aliased(SmUser)
            page_result = db.session.query(SmSysNotice, user_table.LoginName.label('CreatorName')).\
                outerjoin(user_table, user_table.ID == SmSysNotice.CreatorID).filter(*filter_list).\
                order_by(SmSysNotice.Time.desc()).paginate(Page, PageSize)
            return {"total": page_result.total, "rows": cls.result_to_dict(page_result.items)}
        except Exception as e:
            current_app.logger.error(e)
            return {"total": 0, "rows": []}

