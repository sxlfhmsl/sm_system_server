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
                 4                   可创建会员数量不足
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
            if agent_user.MemberMaximum < agent_user.MemberNum + para['MemberMaximum']:    # 可用数量不足
                return 4
            agent_user.MemberNum += para['MemberMaximum']
            cls.add_agent_to_db(CreatorID=agent_user.ID, MemberNum=0, AgentLevel=agent_user.AgentLevel + 1, CreateTime=date_time_now, RoleID=role['ID'], Forbidden=0, Lock=0, **para)
            cls.create_log(agent_user.ID, role['Description'], '创建代理', date_time_now, '代理' + agent_user.LoginName + '创建次级代理' + para['LoginName'])
        except Exception as e:
            current_app.logger.error(e)
            return 3
        return 0

    @classmethod
    def admin_query_agent(cls, Page=None, PageSize=None):
        """
        管理员查询所有代理，按照分页，因无搜索关键字，故不作匹配，同时不查询管理员创建者的名字
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
            user_t1 = aliased(SmUser)
            # 返回分页结果  items当前页结果 total数量
            page_result = db.session.query(SmUserAgent, user_t1.LoginName.label('CreatorName'))\
                .outerjoin(user_t1, user_t1.ID == SmUserAgent.CreatorID).order_by(SmUserAgent.CreateTime.desc())\
                .filter().paginate(Page, PageSize)
            return 0, {"total": page_result.total, "rows": cls.result_to_dict(page_result.items)}
        except Exception as e:
            current_app.logger.error(e)
            return 1, None

    @classmethod
    def agent_query_agent(cls, agent_user, Page=None, PageSize=None):
        """
        代理查询代理(
            只能是其创建的次级代理
            即，只能查儿子，不能查询多级代理
        )，按照分页，因无搜索关键字，故不作匹配，同时不查询管理员创建者的名字
        :param agent_user: 查询的代理用户
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
            user_t1 = aliased(SmUser)
            # 返回分页结果  items当前页结果 total数量
            page_result = db.session.query(SmUserAgent, user_t1.LoginName.label('CreatorName')) \
                .outerjoin(user_t1, user_t1.ID == SmUserAgent.CreatorID).order_by(SmUserAgent.CreateTime.desc()) \
                .filter(SmUserAgent.CreatorID == agent_user.ID).paginate(Page, PageSize)
            return 0, {"total": page_result.total, "rows": cls.result_to_dict(page_result.items)}
        except Exception as e:
            current_app.logger.error(e)
            return 1, None

    @classmethod
    def get_by_id(cls, s_id):
        """
        查询代理，通过id，管理员特供
        :param s_id: 带查询的id
        :return: 结果
        """
        try:
            user_t1 = aliased(SmUser)
            result = db.session.query(SmUserAgent, user_t1.LoginName.label('CreatorName'))\
                .outerjoin(user_t1, user_t1.ID == SmUserAgent.CreatorID)\
                .filter(SmUserAgent.ID == s_id).first()
            return cls.result_to_dict(result)
        except Exception as e:
            current_app.logger.error(e)
            return None

    @classmethod
    def agent_query_by_id(cls, agent_user, s_id):
        """
        代理查询次级代理通过id
        :param agent_user: 父代理用户
        :param s_id: 子代理用户
        :return: 查询结果，查到或没有
        """
        result = cls.get_by_id(s_id)
        if not result or result['CreatorID'] != agent_user.ID:
            return None
        else:
            return result

    @classmethod
    def update_by_id(cls, s_id, **para):
        """
        通过id更新代理员
        :param s_id: 待修改代理的id
        :param para: 待修改代理的参数
        :return: 代码    返回结果
                 0       修改完成
                 1       登录名重名
                 2       可使用的会员数不足
                 3       参数错误
        """
        # 校验用户名是否重复
        try:
            result = SmUser.query.filter(SmUser.LoginName == para['LoginName']).first()     # 确定是否存在重名
            if result and result.ID != s_id:
                return 1
            target = SmUserAgent.query.filter(SmUserAgent.ID == s_id).first()     # 获取欲修改目标
            if para['MemberMaximum'] < target.MemberNum:     # 确定是否拥有足够的会员容纳量
                return 2
            if target.AgentLevel != 1:     # 确定是否拥有足够的会员容纳量
                father = SmUserAgent.query.filter(SmUserAgent.ID == target.CreatorID).first()
                if father.MemberMaximum < father.MemberNum + para['MemberMaximum'] - target.MemberMaximum:
                    return 2
                father.MemberNum = father.MemberNum + para['MemberMaximum'] - target.MemberMaximum
            return super(SmUserAgentService, cls).update_by_id(s_id, **para)
        except Exception as e:
            current_app.logger.error(e)
            return 3
        return 0

    @classmethod
    def agent_update_by_id(cls, agent_user, s_id, **para):
        """
        通过id更新代理员
        :param agent_user: 发起操作的代理
        :param s_id: 待修改代理的id
        :param para: 待修改代理的参数
        :return: 代码    返回结果
                 0       修改完成
                 1       重名-----登录名
                 2       权限不足
                 3       可操作会员数不足
                 4       提交参数错误
        """
        try:
            result = SmUser.query.filter(SmUser.LoginName == para['LoginName']).first()     # 确定是否存在重名
            if result and result.ID != s_id:
                return 1
            target = SmUserAgent.query.filter(SmUserAgent.ID == s_id).first()     # 获取欲修改目标
            if target.CreatorID != agent_user.ID:
                return 2
            if para['MemberMaximum'] < target.MemberNum:     # 确定是否拥有足够的会员容纳量
                return 3
            if agent_user.MemberMaximum < agent_user.MemberNum + para['MemberMaximum'] - target.MemberMaximum:
                return 3
            agent_user.MemberNum = agent_user.MemberNum + para['MemberMaximum'] - target.MemberMaximum
            return super(SmUserAgentService, cls).update_by_id(s_id, **para)
        except Exception as e:
            current_app.logger.error(e)
            return 4
        return 0

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

