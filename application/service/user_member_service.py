# -*- coding:utf-8 -*-
"""
会员相关service
"""
import datetime
from flask import current_app

from ..dao.models import db, SmUserAgent, SmUserMember, SmUser
from .utils import BaseService


class SmUserMemberService(BaseService):
    """
    代理业务逻辑代码
    """
    BaseModel = SmUserMember

    @classmethod
    def add_member_to_db(cls, agent_user, **para):
        """
        插入会员到数据库
        :param agent_user: 代理
        :param para: 参数
        :return:
        """
        session = db.session
        try:
            user = SmUserMember(ID=cls.md5_generator('sm_user_member' + str(para['CreateTime'])), **para)
            agent_user.MemberNum = agent_user.MemberNum + 1
            session.add(user)
            session.commit()
        except Exception as e:
            session.rollback()
            raise e

    @classmethod
    def admin_create_member(cls, admin_user, **para):
        """
        管理员创建会员
        暂时不对代理允许创建的会员数量做出限制，后期进行限制
        :param admin_user: 管理员，Model
        :param para: 相关参数
        :return: 返回结果            阐述
                 0                   会员创建成功
                 1                   存在相同的用户名
                 2                   其他错误
                 3                   代理允许创建的会员不足
        """
        date_time_now = datetime.datetime.now()     # 获取当前时间
        para['Password'] = cls.sha256_generator(para['Password'])     # 修正密码
        para['WithdrawPassWord'] = cls.sha256_generator(para['WithdrawPassWord'])     # 修正提款密码
        role = cls.get_role('Member')
        try:
            user = SmUser.query.filter(SmUser.LoginName == para['LoginName']).first()
            if user:    # 存在相同登录名用户
                return 1
            agent = SmUserAgent.query.filter(SmUserAgent.ID == para['AgentID']).first()
            if agent.MemberNum >= agent.MemberMaximum:
                return 3
            cls.add_member_to_db(agent, CreatorID=admin_user.ID, Forbidden=0, Lock=0, CreateTime=date_time_now, RoleID=role['ID'], **para)
            cls.create_log(admin_user.ID, role['Description'], '创建会员', date_time_now, '管理员' + admin_user.LoginName + '创建会员' + para['LoginName'])
        except Exception as e:
            current_app.logger.error(e)
            return 2
        return 0

    @classmethod
    def agent_create_member(cls, agent_user, **para):
        """
        代理创建会员
        暂时不对代理允许创建的会员数量做出限制，后期进行限制
        :param agent_user: 代理，Model
        :param para: 相关参数
        :return: 返回结果            阐述
                 0                   会员创建成功
                 1                   存在相同的用户名
                 2                   可创建会员不足
                 3                   其他错误
        """
        date_time_now = datetime.datetime.now()     # 获取当前时间
        para['Password'] = cls.sha256_generator(para['Password'])     # 修正密码
        para['WithdrawPassWord'] = cls.sha256_generator(para['WithdrawPassWord'])     # 修正提款密码
        role = cls.get_role('Member')
        try:
            user = SmUser.query.filter(SmUser.LoginName == para['LoginName']).first()
            if user:    # 存在相同登录名用户
                return 1
            if agent_user.MemberNum >= agent_user.MemberMaximum:
                return 2
            cls.add_member_to_db(agent_user, AgentID=agent_user.ID, CreatorID=agent_user.ID, Forbidden=0, Lock=0, CreateTime=date_time_now, RoleID=role['ID'], **para)
            cls.create_log(agent_user.ID, role['Description'], '创建会员', date_time_now, '代理' + agent_user.LoginName + '创建会员' + para['LoginName'])
        except Exception as e:
            current_app.logger.error(e)
            return 3
        return 0

    @classmethod
    def change_withdraw_pass(cls, user, old_pass, new_pass):
        """"
        修改登录密码
        :param user: 目标用户
        :param old_pass: 旧密码
        :param new_pass: 新密码
        :return: 执行结果    0: 执行成功， 1: 错误旧密码    2: 其他错误
        """
        try:
            old_pass = cls.sha256_generator(old_pass)
            if old_pass != user.WithdrawPassWord:
                return 1
            user.WithdrawPassWord = cls.sha256_generator(new_pass)
            db.session.commit()
        except Exception as e:
            current_app.logger.error(e)
            return 2
        return 0

