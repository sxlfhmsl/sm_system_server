# -*- coding:utf-8 -*-
"""
用户service,<class 'sqlalchemy.util._collections.result'>
"""
import datetime
from flask import current_app

from .auth import encode_auth_token
from .utils import BaseService
from ..dao.models import db, SmUser, SmUserRole
from ..dao.utils import RedisOp


class SmUserService(BaseService):
    """
    用户service
    """

    @classmethod
    def login(cls, login_name, password):
        """
        登录接口，成功返回响应user的token,否则返回None
        :param login_name: 登录名
        :param password: 密码
        :return: 代码    返回结果            阐述
                 0       token(用户auth)     登陆成功
                 1       None                用户名或密码错误
                 2       None                账户被禁用
                 3       None                账户被锁定
                 4       None                其他错误
        """
        password = cls.sha256_generator(password)
        # 获取当前时间
        date_time_now = datetime.datetime.now()
        try:
            # 查询账号密码符合的账户
            result = SmUser.query.filter(SmUser.LoginName == login_name).first()
            if result is None:
                return 1, None                       # 用户名或密码错误
            if result.ID != '1' and result.Forbidden != 0:
                return 2, None                       # 用户被禁止登录
            if result.ID != '1':
                if result.Lock >= 6:
                    return 3, None                   # 账户被锁定
            if result.Password != password:
                if result.ID != 1:
                    result.Lock += 1
                    db.session.commit()
                return 1, None                       # 用户名或密码错误
            result.LastLogonTime = date_time_now
            role = SmUserRole.query.filter(SmUserRole.ID == result.RoleID).first()
            # 创建并插入更新日志
            cls.create_log(result.ID, role.Description, '登录', date_time_now, result.LoginName + role.Description + '登录')
            token = encode_auth_token(u_id=result.ID, u_login_name=result.LoginName, u_nick_name=result.NickName,
                                      u_role_id=role.ID, u_role_name=role.Name)
            token_key = cls.sha256_generator(token)
            RedisOp().set_normal(token_key, token, 3600)
            # 返回验证码，然后据此获取需求
            return 0, token_key
        except Exception as e:
            current_app.logger.error(e)
            return 4, None

