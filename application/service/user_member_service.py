# -*- coding:utf-8 -*-
"""
会员相关service
"""
import datetime
from flask import current_app
from sqlalchemy.orm import aliased

from ..dao.models import db, SmUserAgent, SmUserMember, SmUser, SmClerk
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
            if para.get('ClerkID', None):
                clerk = SmClerk.query.filter(SmClerk.ID == para['ClerkID']).first()
                if clerk or clerk.AgentID != agent.ID:
                    return 4
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
        if para.get('ClerkID', None):
            clerk = SmClerk.query.filter(SmClerk.ID == para['ClerkID']).first()
            if clerk or clerk.AgentID != agent_user.ID:
                return 4
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

    @classmethod
    def reset_withdraw_pass(cls, member_id, new_pass):
        """"
        重置提款密码
        :param member_id: 会员id
        :param new_pass: 新密码
        :return: 执行结果    0: 执行成功， 1: 查询失败    2: 其他错误
        """
        try:
            member = SmUserMember.query.filter(SmUserMember.ID == member_id).first()
            if not member:
                return 1
            member.WithdrawPassWord = cls.sha256_generator(new_pass)
            db.session.commit()
        except Exception as e:
            current_app.logger.error(e)
            return 2
        return 0

    @classmethod
    def admin_query_member(cls, **params):
        """
        管理员查询会员信息
        :param params: 所有待使用参数
        :return: 代码    返回结果            阐述
                 0       分页查询结果        成功
                 1       None                参数错误
                 2       None                其他错误
        """
        query_filter_list = []
        try:
            # 提取必要参数
            page = 1 if params.get('Page', None) is None or params.get('PageSize', None) is None else params.get('Page')
            pagesize = 1000 if params.get('Page', None) is None or params.get('PageSize', None) is None else params.get('PageSize')
            if params.get('AgentID', None) is not None:                                          # 待查询代理的id
                query_filter_list.append(SmUserMember.AgentID == params['AgentID'])
            if params.get('LoginName', None) is not None:                                        # 登录名模糊
                query_filter_list.append(SmUserMember.LoginName.like('%' + params['LoginName'] + '%'))
            if params.get('NickName', None) is not None:                                         # 客户名模糊
                query_filter_list.append(SmUserMember.NickName.like('%' + params['NickName'] + '%'))
            table_user = aliased(SmUser)     # 查询代理登录名
            table_clerk = aliased(SmClerk)    # 业务员账号
            page_result = db.session.query(
                SmUserMember,
                table_user.LoginName.label('AgentName'),
                table_clerk.NickName.label('ClerkName')
            ).\
                outerjoin(table_user, table_user.ID == SmUserMember.AgentID).\
                outerjoin(table_clerk, table_clerk.ID == SmUserMember.ClerkID).\
                filter(*query_filter_list).order_by(SmUserMember.CreateTime.desc()).paginate(page, pagesize)
            return 0, {"total": page_result.total, "rows": cls.result_to_dict(page_result.items)}
        except Exception as e:
            current_app.logger.error(e)
            return 1, None
        return 2, None

    @classmethod
    def agent_query_member(cls, agent_user, **params):
        """
        代理查询会员信息
        :param agent_user: 代理用户
        :param params: 相关参数
        :return: 代码    返回结果            阐述
                 0       分页查询结果        成功
                 1       None                参数错误
                 2       None                其他错误
        """
        query_filter_list = []
        try:
            # 提取必要参数
            page = 1 if params.get('Page', None) is None or params.get('PageSize', None) is None else params.get('Page')
            pagesize = 1000 if params.get('Page', None) is None or params.get('PageSize', None) is None else params.get('PageSize')                                      # 待查询代理的id
            query_filter_list.append(SmUserMember.AgentID == agent_user.ID)
            if params.get('ClerkID', None) is not None:                                        # 业务员
                query_filter_list.append(SmUserMember.ClerkID == params['ClerkID'])
            if params.get('LoginName', None) is not None:                                        # 登录名模糊
                query_filter_list.append(SmUserMember.LoginName.like('%' + params['LoginName'] + '%'))
            if params.get('NickName', None) is not None:                                         # 客户名模糊
                query_filter_list.append(SmUserMember.NickName.like('%' + params['NickName'] + '%'))
            table_user = aliased(SmUser)     # 查询代理登录名
            table_clerk = aliased(SmClerk)    # 业务员账号
            page_result = db.session.query(
                SmUserMember,
                table_user.LoginName.label('AgentName'),
                table_clerk.NickName.label('ClerkName')
            ). \
                outerjoin(table_user, table_user.ID == SmUserMember.AgentID). \
                outerjoin(table_clerk, table_clerk.ID == SmUserMember.ClerkID). \
                filter(*query_filter_list).order_by(SmUserMember.CreateTime.desc()).paginate(page, pagesize)
            return 0, {"total": page_result.total, "rows": cls.result_to_dict(page_result.items)}
        except Exception as e:
            current_app.logger.error(e)
            return 1, None
        return 2, None

    @classmethod
    def get_by_id(cls, member_id):
        """
        管理员通过id查询会员
        :param member_id: 会员id
        :return:
        """
        try:
            table_user = aliased(SmUser)     # 查询代理登录名
            table_creator = aliased(SmUser)    # 创建者信息
            table_clerk = aliased(SmClerk)    # 业务员账号
            result = db.session.query(
                SmUserMember,
                table_user.LoginName.label('AgentName'),
                table_clerk.NickName.label('ClerkName'),
                table_creator.RoleID.label('CreatorRoleID')
            ). \
                outerjoin(table_user, table_user.ID == SmUserMember.AgentID). \
                outerjoin(table_clerk, table_clerk.ID == SmUserMember.ClerkID). \
                outerjoin(table_creator, table_creator.ID == SmUserMember.CreatorID).\
                filter(SmUserMember.ID == member_id).first()
            result = cls.result_to_dict(result)
            result['CreatorType'] = 'Admin' if result['CreatorRoleID'] == cls.get_role('Admin')['ID'] else 'Agent'
            return result
        except Exception as e:
            current_app.logger.error(e)
            return None

    @classmethod
    def agent_query_by_id(cls, agent_user, member_id):
        """
        管理员通过id查询会员
        :param agent_user: 代理
        :param member_id: 会员id
        :return:
        """
        result = cls.get_by_id(member_id)
        if not result or result['AgentID'] != agent_user.ID:
            return None
        return result

    @classmethod
    def update_by_id(cls, m_id, **para):
        """
        通过id更新会员, 后期确定明确买入手续费，卖出手续费，涨跌点差率等变化规则，再做出相应的限制，代理相同
        :param m_id: 待修改会员的id
        :param para: 待修改代理的参数
        :return: 代码    返回结果
                 0       修改完成
                 1       登录名重名
                 2       参数错误
        """
        try:
            member = SmUserMember.query.filter(SmUserMember.ID == m_id).first()
            clerk = SmClerk.query.filter(SmClerk.ID == para.get('ClerkID', None)).first()
            if not member or (para.get('ClerkID', None) and not clerk) or (clerk and member.AgentID != clerk.AgentID):     # 判断是否为同一代理之下
                return 2
            result = SmUser.query.filter(SmUser.LoginName == para['LoginName']).first()     # 确定是否存在重名
            if result and result.ID != m_id:
                return 1
            # 确定买入手续费，卖出手续费，涨跌点差率变化规律
            return super(SmUserMemberService, cls).update_by_id(m_id, **para)
        except Exception as e:
            current_app.logger.error(e)
            return 2
        return 0

    @classmethod
    def agent_update_by_id(cls, agent_user, m_id,  **para):
        """
        代理修改自己的会员信息
        :param agent_user: 代理用户
        :param m_id: 目标id
        :param para: 更新参数
        :return: 代码    返回结果
                 0       修改完成
                 1       登录名重名
                 2       参数错误
        """
        member = SmUserMember.query.filter(SmUserMember.ID == m_id).first()
        if member.AgentID != agent_user.ID:
            return 2
        return cls.update_by_id(m_id, **para)

    @classmethod
    def admin_delete_by_id(cls, s_id):
        """
        管理员通过id删除会员-----后期需加入资金处理等目标，如计算盈收等
        用户存在持仓情况下是否允许删除-----删除后操作
        :param s_id: 待处理会员id
        :return: 代码    返回结果
                 0       修改完成
                 1       查询不到结果
                 2       其他错误
        """
        try:
            target = SmUserMember.query.filter(SmUserMember.ID == s_id).first()     # 获取欲删除目标
            if target is None:
                return 1
            agent_id = target.AgentID
            if super(SmUserMemberService, cls).delete_by_id(s_id) == 1:     # 删除失败
                return 2
            agent = SmUserAgent.query.filter(SmUserAgent.ID == agent_id).first()
            if agent and agent.MemberNum > 0:
                agent.MemberNum -= 1
                db.session.commit()
        except Exception as e:
            current_app.logger.error(e)
            return 2
        return 0

