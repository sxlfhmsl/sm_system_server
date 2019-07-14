# -*- coding:utf-8 -*-
"""
通用函数
"""

from datetime import datetime
from hashlib import md5, sha256

from ..dao.models import db, SmUserLog, SmUserAdmin, SmUserAgent, SmUserMember


class BaseService:

    from .model_convert import model_to_dict_by_dict

    @staticmethod
    def create_log(user_id: str, user_type: str, model: str, time: datetime, note: str):
        """
        创建日志到数据库
        :param user_id: 创建日志的用户的id
        :param user_type: 类型
        :param model: 模块
        :param time: 时间
        :param note: 记录值
        :return: None
        """
        try:
            log = SmUserLog(ID=BaseService.md5_generator('sm_user_log' + str(time)), UserID=user_id, Type=user_type,
                            Time=time, Model=model, Note=note)
            db.session.add(log)
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            raise e

    @staticmethod
    def is_forbidden(user_id, user_type):
        """
        验证用户是否被禁用
        :param user_id: 用户id
        :param user_type: 用户类型， Admin, Agent, Member
        :return: 未禁用返回用户model否则None
        """
        result = None
        if user_type == 'Admin':
            result = SmUserAdmin.query.filter(SmUserAdmin.ID == user_id).first()
        elif user_type == 'Agent':
            result = SmUserAgent.query.filter(SmUserAgent.ID == user_id).first()
        elif user_type == 'Member':
            result = SmUserMember.query.filter(SmUserMember.ID == user_id).first()
        if result and result.Forbidden != 0 and result.ID != '1':
            return None
        return result


    @staticmethod
    def md5_generator(content: str):
        """
         生成md5字符串
        :param content: 待摘要的内容
        :return:
        """
        return md5(content.encode()).hexdigest()

    @staticmethod
    def sha256_generator(content: str):
        """
         生成sha256字符串
        :param content: 待摘要的内容
        :return:
        """
        return sha256(content.encode()).hexdigest()

