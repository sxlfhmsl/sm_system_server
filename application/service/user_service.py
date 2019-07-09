# -*- coding:utf-8 -*-
"""
用户service,<class 'sqlalchemy.util._collections.result'>
"""
import datetime
from flask import current_app
from sqlalchemy import and_
from sqlalchemy.orm import aliased, outerjoin
from hashlib import sha256

from .auth import encode_auth_token
from .model_convert import model_to_dict_by_dict
from ..dao.models import db, SmUser, SmUserLog, SmUserAdmin, SmUserAgent, SmUserMember
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
        # 获取当前时间
        date_time_now = datetime.datetime.now()
        try:
            # 查询记录
            result = SmUser.query.filter(and_(SmUser.LoginName == login_name, SmUser.Password == password)).first()
            if result:
                result.LastLogonTime = date_time_now
                # 创建并插入更新日志
                log = SmUserLog(UserID=result.ID, Type='管理员', Model='登录', Time=date_time_now, Note='管理员登录')
                db.session.add(log)
                db.session.commit()
                token = encode_auth_token(uid=result.ID, utype=result.RoleID)
                token_key = sha256(token.encode()).hexdigest()
                RedisOp().set_normal(token_key, token, 3600)
                # 返回验证码，然后据此获取需求
                return token_key
            else:
                current_app.logger.warning("用户" + login_name + "登录失败")
                return None
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
        result = model_to_dict_by_dict(SmUserAdmin.query.filter(
            and_(SmUserAdmin.ID == uid, SmUserAdmin.Forbidden == 0)).first())
        result.pop('Password')
        return result

    @classmethod
    def agent_info_id(cls, uid):
        """
        通过uid获取agent用户信息
        :param uid: 用户id
        :return:
        """
        result = model_to_dict_by_dict(SmUserAgent.query.filter(
            and_(SmUserAgent.ID == uid, SmUserAgent.Forbidden == 0, SmUserAgent.Lock == 0)).first())
        result.pop('Password')
        return result

    @classmethod
    def member_info_id(cls, uid):
        """
        通过uid获取member用户信息
        :param uid: 用户id
        :return:
        """
        mid = SmUserMember.query.filter(
            and_(SmUserMember.ID == uid, SmUserMember.Forbidden == 0, SmUserMember.Lock == 0)).first()
        result = model_to_dict_by_dict(mid)
        result.pop('Password')
        result['AgentName'] = mid.sm_user_agent.LoginName
        result['ClerkName'] = mid.sm_user_agent.NickName
        return result

