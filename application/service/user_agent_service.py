# -*- coding:utf-8 -*-
"""
代理相关service
"""
import datetime
from flask import current_app
from sqlalchemy import and_

from ..dao.models import db, SmUser, SmUserAdmin, SmUserAgent, SmUserRole, SmUserLog
from .utils import BaseService


class SmUserAgentService(BaseService):
    """
    代理 业务逻辑代码
    """

    @classmethod
    def info_by_id(cls, uid):
        """
        获取代理用户信息
        :param uid:
        :return:
        """
        try:
            result = cls.model_to_dict_by_dict(SmUserAgent.query.filter(
                and_(SmUserAgent.ID == uid, SmUserAgent.Forbidden == 0, SmUserAgent.Lock < 6)).first())
            return result
        except Exception as e:
            current_app.logger.error(e)
            return None

    @classmethod
    def insert(cls, token_data, **para):
        date_time_now = datetime.datetime.now()
        para['Password'] = cls.sha256_generator(para['Password'])
        try:
            # 确定用户名是否存在
            user = SmUser.query.filter(SmUser.LoginName == para['LoginName']).first()
            if user:
                return 1
            agent = None                                                                       # 待创建代理
            log = None                                                                         # 日志
            # 获取role-----agent
            role = SmUserRole.query.filter(SmUserRole.Name == 'Agent').first()
            if token_data['u_role_name'] == 'Admin':
                # 获取创建者
                creator = SmUserAdmin.query.filter(SmUserAdmin.ID == token_data['u_id']).first()
                agent = SmUserAgent(
                    ID=cls.md5_generator('sm_user_agent' + str(date_time_now)), CreatorID=token_data['u_id'],
                    AgentLevel=1, CreateTime=date_time_now, RoleID=role.ID, Forbidden=0, Lock=0, **para)
                log = SmUserLog(
                    ID=cls.md5_generator('sm_user_log' + str(date_time_now)), UserID=token_data['u_id'],
                    Type=role.Description, Model='创建代理', Time=date_time_now,
                    Note='管理员' + creator.LoginName + '创建代理' + para['LoginName']
                )
            elif token_data['u_role_name'] == 'Agent':
                # 获取创建者
                creator = SmUserAgent.query.filter(SmUserAgent.ID == token_data['u_id']).first()
                if creator.AgentLevel >= 4:
                    # 创建者等级过低
                    return 2
                agent = SmUserAgent(
                    ID=cls.md5_generator('sm_user_agent' + str(date_time_now)), CreatorID=token_data['u_id'], Lock=0,
                    AgentLevel=creator.AgentLevel + 1, CreateTime=date_time_now, RoleID=role.ID, Forbidden=0, **para)
                log = SmUserLog(
                    ID=cls.md5_generator('sm_user_log' + str(date_time_now)), UserID=token_data['u_id'], Model='创建代理',
                    Type=role.Description,Time=date_time_now, Note='管理员' + creator.LoginName + '创建代理' + para['LoginName']
                )
            db.session.add(agent)
            db.session.add(log)
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            current_app.logger.error(e)
            return 1
        return 0

