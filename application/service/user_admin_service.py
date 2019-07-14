# -*- coding:utf-8 -*-
"""
会员相关service
"""
import datetime
from flask import current_app

from ..dao.models import db, SmUser, SmUserAdmin
from .utils import BaseService


class SmUserAdminService(BaseService):
    """
    管理员相关service
    """

    @classmethod
    def info_by_id(cls, user):
        """
        获取管理员相关信息
        :param user: 管理员
        :return: 成功返回对应字典对象，否者返回None
        """
        try:
            return cls.model_to_dict_by_dict(user)
        except Exception as e:
            current_app.logger.error(e)
            return None

    @classmethod
    def add_admin_to_db(cls, **para):
        """
        插入管理员到数据库
        :param para: 参数
        :return: None
        """
        session = db.session
        try:
            user = SmUserAdmin(ID=cls.md5_generator('sm_user_admin' + str(para['CreateTime'])), **para)
            session.add(user)
            session.commit()
        except Exception as e:
            session.rollback()
            raise e

    @classmethod
    def create_admin(cls, **para):
        """
        创建新的管理员
        :param para: 相关参数
        :return: 返回结果            阐述
                 0                   管理员创建成功
                 1                   存在相同的用户名
                 2                   其他错误
        """
        date_time_now = datetime.datetime.now()     # 获取当前时间
        try:
            para['Password'] = cls.sha256_generator(para['Password'])
            user = SmUser.query.filter(SmUser.LoginName == para['LoginName']).first()     # 确定是否存在同名用户 LoginName
            if user:     # 存在相同的用户名
                return 1
            role = cls.get_role('Admin')     # 获取管理员权限
            cls.add_admin_to_db(CreateTime=date_time_now, RoleID=role['ID'], Forbidden=0, Lock=0, **para)
            cls.create_log(para['CreatorID'], role['Description'], '创建管理员', date_time_now, role['Description'] + '创建管理员')
        except Exception as e:
            current_app.logger.error(e)
            return 2
        return 0

