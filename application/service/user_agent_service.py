# -*- coding:utf-8 -*-
"""
代理相关service
"""
import datetime
from flask import current_app
from sqlalchemy.orm import aliased
from sqlalchemy import and_

from ..dao.models import db, SmUser, SmUserAgent
from .utils import BaseService


class SmUserAgentService(BaseService):
    """
    代理 业务逻辑代码
    """
    BaseModel = SmUserAgent

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

    @classmethod
    def query_agent(cls, agent_id=None, Page=None, PageSize=None):
        """
        查询所有管理员，按照分页，因无搜索关键字，故不作匹配，同时不查询管理员创建者的名字
        :param Page: 第几页
        :param PageSize: 每页的数量
        :return: 代码    返回结果            阐述
                 0       分页查询结果        登陆成功{total, rows}
                 1       None                其他错误
        """
        if Page is None or PageSize is None:
            Page = 1
            PageSize = 1000
        try:
            # 返回分页结果  items当前页结果 total数量
            user_t1 = aliased(SmUser)
            search_sql = and_()
            if agent_id:
                search_sql = and_(SmUserAgent.CreatorID == agent_id)
            query_sql = [SmUserAgent, user_t1.LoginName.label('CreatorName')]
            page_result = db.session.query(*query_sql).outerjoin(user_t1, user_t1.ID == SmUserAgent.CreatorID).order_by(SmUserAgent.CreateTime.desc()).filter(search_sql).paginate(Page, PageSize)
            return 0, {"total": page_result.total, "rows": cls.result_to_dict(page_result.items)}
        except Exception as e:
            current_app.logger.error(e)
            return 1, None

    @classmethod
    def change_withdraw_pass(cls, user, old_pass, new_pass):
        """"
        修改提款密码
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

    @classmethod
    def get_by_id(cls, m_id, user_id=None):
        """
        查询代理，通过id
        :param m_id: id
        :param user_id: 查询者的id
        :return: 结果
        """
        try:
            search_sql = and_(SmUserAgent.ID == m_id) if not user_id else and_(SmUserAgent.ID == m_id, SmUserAgent.CreatorID == user_id)
            user_t1 = aliased(SmUser)
            result = db.session.query(
                SmUserAgent, user_t1.LoginName.label('CreatorName')).outerjoin(
                user_t1, user_t1.ID == SmUserAgent.CreatorID).filter(search_sql).first()
            if len(result) == 0:
                return None
            return cls.result_to_dict(result)
        except Exception as e:
            current_app.logger.error(e)
            return None

