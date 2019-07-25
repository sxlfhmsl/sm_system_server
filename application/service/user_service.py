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
    BaseModel = SmUser

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

    @classmethod
    def logout(cls, token_key, user_id):
        """
        退出登录
        :param token_key: token key
        :param user_id: 用户id
        :return:
        """
        if RedisOp().get_normal(token_key):
            RedisOp().remove_items(token_key)
            user = SmUser.query.filter(SmUser.ID == user_id)
            user.LastLogonTime = datetime.datetime.now()
            db.session.commit()

    @classmethod
    def change_login_pass(cls, user, old_pass, new_pass):
        """
        修改登录密码
        :param user: 目标用户
        :param old_pass: 旧密码
        :param new_pass: 新密码
        :return: 执行结果    0: 执行成功， 1: 错误旧密码    2: 其他错误
        """
        try:
            old_pass = cls.sha256_generator(old_pass)
            if old_pass != user.Password:
                return 1
            user.Password = cls.sha256_generator(new_pass)
            db.session.commit()
        except Exception as e:
            current_app.logger.error(e)
            return 2
        return 0

    @classmethod
    def reset_login_pass(cls, user_id, new_pass):
        """
        重置登录密码
        :param user_id: 目标用户
        :param new_pass: 新密码
        :return: 执行结果    0: 执行成功， 1: 用户不存在    2: 其他错误
        """
        try:
            user = SmUser.query.filter(SmUser.ID == user_id).first()
            if not user:
                return 1
            user.Password = cls.sha256_generator(new_pass)
            db.session.commit()
        except Exception as e:
            current_app.logger.error(e)
            return 2
        return 0

    @classmethod
    def change_user_flag(cls, user_id, Forbidden=None, Lock=None):
        """
        通过id，修改账号状态，锁定，禁用等
        :param user_id: 用户id
        :param flag: 相关状态
        :return: 代码    返回结果
                 0       修改完成
                 1       查询不到结果
        """
        try:
            target = SmUser.query.filter(SmUser.ID == user_id).first()
            if Forbidden is not None:
                target.Forbidden = 1 if Forbidden else 0
            if Lock is not None:
                target.Lock = 6 if Lock else 0
            db.session.commit()
        except Exception as e:
            current_app.logger.error(e)
            return 1
        return 0

