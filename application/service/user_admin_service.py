# -*- coding:utf-8 -*-
"""
会员相关service
"""
import datetime
from flask import current_app
from sqlalchemy import and_

from ..dao.models import db, SmUser, SmUserAdmin, SmUserRole, SmUserLog
from .utils import BaseService


class SmUserAdminService(BaseService):
    """
    管理员相关service
    """

    @classmethod
    def info_by_id(cls, uid):
        """
        获取管理员相关信息
        :param uid: 管理员id
        :return:
        """
        try:
            result = cls.model_to_dict_by_dict(SmUserAdmin.query.filter(
                and_(SmUserAdmin.ID == uid, SmUserAdmin.Forbidden == 0, SmUserAdmin.Lock < 6)).first())
            return result
        except Exception as e:
            current_app.logger.error(e)
            return None

    @classmethod
    def insert(cls, **para):
        """
        创建新的管理员
        :param para: 相关参数
        :return:
        """
        # 获取当前时间
        date_time_now = datetime.datetime.now()
        try:
            para['Password'] = cls.sha256_generator(para['Password'])
            # 确定是否存在同名用户 LoginName
            user = SmUser.query.filter(SmUser.LoginName == para['LoginName']).first()
            if user:
                return 1
            # 获取管理员权限
            role = SmUserRole.query.filter(SmUserRole.Name == 'Admin').first()
            # 待添加用户
            user = SmUserAdmin(ID=cls.md5_generator('sm_admin_user' + str(date_time_now)),
                               CreateTime=date_time_now, RoleID=role.ID, Forbidden=0, Lock=0, **para)
            # 添加日志
            log = SmUserLog(ID=cls.md5_generator('sm_user_log' + str(date_time_now)), UserID=para['CreatorID'],
                            Type=role.Description, Model='创建管理员', Time=date_time_now, Note=role.Description + '创建管理员')
            db.session.add(user)
            db.session.add(log)
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            current_app.logger.error(e)
            return 1
        return 0

