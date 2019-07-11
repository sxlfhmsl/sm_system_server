# -*- coding:utf-8 -*-
"""
用户service,<class 'sqlalchemy.util._collections.result'>
"""
import datetime
from flask import current_app
from sqlalchemy import and_
from sqlalchemy.orm import aliased, outerjoin

from .auth import encode_auth_token
from .utils import md5_generator, sha256_generator
from .model_convert import model_to_dict_by_dict
from ..dao.models import db, SmUser, SmUserLog, SmUserAdmin, SmUserAgent, SmUserMember, SmUserRole
from ..dao.utils import RedisOp


class SmUserService:
    """
    用户service
    """

    @classmethod
    def login(cls, login_name, password):
        """
        登录接口，成功返回响应user的token,否则返回None
        :param login_name: 登录名
        :param password: 密码
        :return: token
        """
        password = sha256_generator(password)
        # 获取当前时间
        date_time_now = datetime.datetime.now()
        try:
            # 查询账号密码符合的账户
            result = SmUser.query.filter(SmUser.LoginName == login_name).first()
            if result is None:
                return 0                             # 用户名或密码错误
            if result.Forbidden != 0:
                return 1                             # 用户被禁止登录
            if result.ID != '1':
                if result.Lock >= 6:
                    return 2                         # 账户被锁定
            if result.Password != password:
                if result.ID != 1:
                    result.Lock += 1
                    db.session.commit()
                return 0                             # 用户名或密码错误
            result.LastLogonTime = date_time_now
            role = SmUserRole.query.filter(SmUserRole.ID == result.RoleID).first()
            # 创建并插入更新日志
            log = SmUserLog(
                ID=md5_generator("sm_user_log" + str(date_time_now)),
                UserID=result.ID,
                Type=role.Description,
                Model='登录',
                Time=date_time_now,
                Note=role.Description + '登录'
            )
            db.session.add(log)
            db.session.commit()
            token = encode_auth_token(uid=result.ID, utype=role.Name)
            token_key = sha256_generator(token)
            RedisOp().set_normal(token_key, token, 3600)
            # 返回验证码，然后据此获取需求
            return token_key
        except Exception as e:
            db.session.rollback()
            current_app.logger.error(e)
            return None

    @classmethod
    def admin_info_id(cls, uid):
        """
        通过uid获取admin用户信息
        :param uid: 用户id
        :return:
        """
        try:
            print(uid.__class__)
            result = model_to_dict_by_dict(SmUserAdmin.query.filter(
                and_(SmUserAdmin.ID == uid, SmUserAdmin.Forbidden == 0, SmUserAdmin.Lock < 6)).first())
            result.pop('Password')
            return result
        except Exception as e:
            current_app.logger.error(e)
            return None

    @classmethod
    def agent_info_id(cls, uid):
        """
        通过uid获取agent用户信息
        :param uid: 用户id
        :return:
        """
        try:
            result = model_to_dict_by_dict(SmUserAgent.query.filter(
                and_(SmUserAgent.ID == uid, SmUserAgent.Forbidden == 0, SmUserAgent.Lock < 6)).first())
            result.pop('Password')
            return result
        except Exception as e:
            current_app.logger.error(e)
            return None

    @classmethod
    def member_info_id(cls, uid):
        """
        通过uid获取member用户信息
        :param uid: 用户id
        :return:
        """
        try:
            mid = SmUserMember.query.filter(
                and_(SmUserMember.ID == uid, SmUserMember.Forbidden == 0, SmUserMember.Lock < 6)).first()
            result = model_to_dict_by_dict(mid)
            result.pop('Password')
            result['AgentName'] = mid.sm_user_agent.LoginName
            result['ClerkName'] = mid.sm_user_agent.NickName
            return result
        except Exception as e:
            current_app.logger.error(e)
            return None

    @classmethod
    def create_admin(cls, **para):
        """
        创建管理员
        :param para: 参数
        :return:
        """
        if para.get('LoginName', None) is None or para.get('NickName', None) is None or para.get('Password', None) is None:
            return 1
        para['Password'] = sha256_generator(para['Password'])
        date_time_now = datetime.datetime.now()
        try:
            # 确定用户名是否存在
            user = SmUser.query.filter(SmUser.LoginName == para['LoginName']).first()
            if user is not None:
                return 1
            role = SmUserRole.query.filter(SmUserRole.Name == 'Admin').first()
            user = SmUserAdmin(
                ID=md5_generator('sm_user' + str(date_time_now)),
                CreateTime=date_time_now, RoleID=role.ID, Forbidden=0, Lock=0, **para)
            log = SmUserLog(
                ID=md5_generator('sm_user_log' + str(date_time_now)),
                UserID=para['CreatorID'],
                Type=role.Description,
                Model='创建管理员',
                Time=date_time_now,
                Note=role.Description + '创建管理员'
            )
            db.session.add(user)
            db.session.add(log)
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            current_app.logger.error(e)
            return 1
        return 0

