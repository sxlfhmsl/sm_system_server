# -*- coding:utf-8 -*-
"""
通用函数
"""

from datetime import datetime
from hashlib import md5, sha256
from flask import current_app

from ..dao.models import db, SmUserLog, SmUserAdmin, SmUserAgent, SmUserMember, SmUserRole


class BaseService:

    from .model_convert import model_to_dict_by_dict
    AdminRole = None
    AgentRole = None
    MemberRole = None
    BaseModel = None

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
        session = db.session
        try:
            log = SmUserLog(ID=BaseService.md5_generator('sm_user_log' + str(time)), UserID=user_id, Type=user_type,
                            Time=time, Model=model, Note=note)
            session.add(log)
            session.commit()
        except Exception as e:
            session.rollback()
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

    @classmethod
    def get_role(cls, name: str):
        """
        获取role
        :param name: role的名字， Admin, Agent, Member
        :return:
        """
        if name == 'Admin':
            if not cls.AdminRole:
                cls.AdminRole = cls.model_to_dict_by_dict(SmUserRole.query.filter(SmUserRole.Name == 'Admin').first())
            return cls.AdminRole
        elif name == 'Agent':
            if not cls.AgentRole:
                cls.AgentRole = cls.model_to_dict_by_dict(SmUserRole.query.filter(SmUserRole.Name == 'Agent').first())
            return cls.AgentRole
        elif name == 'Member':
            if not cls.MemberRole:
                cls.MemberRole = cls.model_to_dict_by_dict(SmUserRole.query.filter(SmUserRole.Name == 'Member').first())
            return cls.MemberRole

    @classmethod
    def delete_by_id(cls, m_id):
        """
        通过id删除记录
        :param m_id: id
        :return:
        """
        cls.BaseModel.query.filter(cls.BaseModel.ID == m_id).delete()

    @classmethod
    def get_by_id(cls, m_id):
        """
        通过id查询记录
        :param m_id:
        :return:
        """
        return cls.model_to_dict_by_dict(cls.BaseModel.query.filter(cls.BaseModel.ID == m_id).first())

    @classmethod
    def update_by_id(cls, m_id, **para):
        """
        通过id更新数据
        :param m_id: 数据id
        :param para: 参数
        :return: 0: 成功， 1: 提交参数有误
        """
        session = db.session
        try:
            cls.BaseModel.query.filter(cls.BaseModel.ID == m_id).update(para)
            session.commit()     # 提交记录
        except Exception as e:
            session.rollback()     # 回滚
            current_app.logger.error(e)
            return 1
        return 0

