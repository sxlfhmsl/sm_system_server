# -*- coding:utf-8 -*-
"""
代理相关service
"""
import datetime
from flask import current_app

from ..dao.models import db, SmUser, SmUserAgent
from .utils import BaseService


class SmUserAgentService(BaseService):
    """
    代理 业务逻辑代码
    """

    @classmethod
    def info_by_id(cls, user):
        """
        获取代理用户信息
        :param user: 代理
        :return:
        """
        try:
            return cls.model_to_dict_by_dict(user)
        except Exception as e:
            current_app.logger.error(e)
            return None

    @classmethod
    def add_agent_to_db(cls, **para):
        """
        插入代理到数据库
        :param para: 参数
        :return:
        """
        session = db.session
        try:
            user = SmUserAgent(ID=cls.md5_generator('sm_user_agent' + str(para['CreateTime'])), **para)
            session.add(user)
            session.commit()
        except Exception as e:
            session.rollback()
            raise e

    @classmethod
    def admin_create_agent(cls, admin_user, **para):
        """
        管理员创建代理用户
        :param admin_user: 管理员用户Model
        :param para: 相关参数
        :return: 返回结果            阐述
                 0                   代理创建成功
                 1                   存在相同的用户名
                 2                   其他错误
        """
        date_time_now = datetime.datetime.now()
        para['Password'] = cls.sha256_generator(para['Password'])
        role = cls.get_role('Agent')
        try:
            user = SmUser.query.filter(SmUser.LoginName == para['LoginName']).first()
            if user:    # 存在相同登录名用户
                return 1
            cls.add_agent_to_db(CreatorID=admin_user.ID, MemberNum=0, AgentLevel=1, CreateTime=date_time_now, RoleID=role['ID'], Forbidden=0, Lock=0, **para)
            cls.create_log(admin_user.ID, role['Description'], '创建代理', date_time_now, '管理员' + admin_user.LoginName + '创建代理' + para['LoginName'])
        except Exception as e:
            current_app.logger.error(e)
            return 2
        return 0

    @classmethod
    def agent_create_agent(cls, agent_user, **para):
        """
        代理员创建代理用户, 暂时不加数量限制，后期加上，MemberMaximum和MemberNum
        父级代理创建子级代理时，子级代理的MemberMaximum会累加到父级的MemberNum，直至等于MemberMaximum
        :param agent_user: 代理用户Model
        :param para: 相关参数
        :return: 返回结果            阐述
                 0                   代理创建成功
                 1                   存在相同的用户名
                 2                   代理的等级过低
                 3                   其他错误
        """
        date_time_now = datetime.datetime.now()
        para['Password'] = cls.sha256_generator(para['Password'])
        role = cls.get_role('Agent')
        try:
            user = SmUser.query.filter(SmUser.LoginName == para['LoginName']).first()
            if user:    # 存在相同登录名用户
                return 1
            if agent_user.AgentLevel >= 4:    # 不允许低于4级的用户
                return 2
            cls.add_agent_to_db(CreatorID=agent_user.ID, MemberNum=0, AgentLevel=agent_user.AgentLevel + 1, CreateTime=date_time_now, RoleID=role['ID'], Forbidden=0, Lock=0, **para)
            cls.create_log(agent_user.ID, role['Description'], '创建代理', date_time_now, '代理' + agent_user.LoginName + '创建次级代理' + para['LoginName'])
        except Exception as e:
            current_app.logger.error(e)
            return 3
        return 0

