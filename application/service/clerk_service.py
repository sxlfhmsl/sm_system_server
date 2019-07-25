# -*- coding:utf-8 -*-
"""
业务员相关service
"""
from datetime import datetime
from flask import current_app

from .utils import BaseService
from ..dao.models import db, SmClerk


class SmClerkService(BaseService):
    """
    业务员相关逻辑代码
    """

    @classmethod
    def create_clerk(cls, user, user_type, **para):
        """
        创建业务员
        :param user: 发起用户
        :param user_type: 发起用户类型
        :param para: 参数
        :return: 执行结果
        """
        date_time_now = datetime.now()    # 获取当前时间
        session = db.session
        try:
            if SmClerk.query.filter(SmClerk.NickName == para['NickName']).first():
                return 1
            clerk = SmClerk(ID=cls.md5_generator('sm_clerk' + str(date_time_now)), AgentID=para['AgentID'],
                            NickName=para['NickName'], Forbidden=0)
            cls.create_log(user.ID, user_type, '创建业务员', date_time_now, user_type + user.LoginName + '创建业务员' + para['NickName'])
            session.add(clerk)
            session.commit()
            return 0
        except Exception as e:
            session.rollback()
            current_app.logger.error(e)
            return 1

