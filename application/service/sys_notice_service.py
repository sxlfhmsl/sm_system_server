# -*- coding:utf-8 -*-
"""
公告service
"""
from flask import current_app
from sqlalchemy.orm import aliased
from datetime import datetime

from .utils import BaseService
from ..dao.models import db, SmSysNotice, SmUser


class SmSysNoticeService(BaseService):
    """
    notice管理service
    """
    BaseModel = SmSysNotice

    @classmethod
    def create_sys_notice(cls, admin_user, **para):
        """
        创建系统公告
        :param admin_user: 管理员
        :param para: 参数
        :return: 返回结果            阐述
                 0                   公告创建成功
                 1                   参数错误
        """
        date_time_now = datetime.now()     # 获取当前时间
        session = db.session
        try:
            notice = SmSysNotice(ID=cls.md5_generator('sm_sys_notice' + str(date_time_now)), Time=date_time_now,
                                 CreatorID=admin_user.ID, **para)
            session.add(notice)
            session.commit()
            cls.create_log(admin_user.ID, '公告', '创建公告', date_time_now, '管理员' + admin_user.LoginName + '创建公告')
            return 0
        except Exception as e:
            current_app.logger.error(e)
            return 1


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

