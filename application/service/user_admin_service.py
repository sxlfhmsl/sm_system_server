# -*- coding:utf-8 -*-
"""
会员相关service
"""
import datetime
from flask import current_app
from sqlalchemy.orm import aliased

from ..dao.models import db, SmUser, SmUserAdmin
from .utils import BaseService


class SmUserAdminService(BaseService):
    """
    管理员相关service
    """
    BaseModel = SmUserAdmin

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

    @classmethod
    def query_admin(cls, Page=None, PageSize=None):
        """
        查询所有管理员，按照分页，因无搜索关键字，故不作匹配，同时不查询管理员创建者的名字
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
            # 返回分页结果  items当前页结果 total数量
            page_result = SmUserAdmin.query.filter(SmUserAdmin.ID != '1').order_by(SmUserAdmin.CreateTime.desc()).paginate(Page, PageSize)
            return 0, {"total": page_result.total, "rows": cls.model_to_dict_by_dict(page_result.items)}
        except Exception as e:
            current_app.logger.error(e)
            return 1, None

    @classmethod
    def get_by_id(cls, m_id):
        """
        通过id返回管理员信息
        :param m_id: 相关id
        :return: 查询结果
        """
        try:
            user_t1 = aliased(SmUser)
            result = db.session.query(
                SmUserAdmin.ID,
                SmUserAdmin.LoginName,
                SmUserAdmin.NickName,
                SmUserAdmin.CreateTime,
                SmUserAdmin.LastLogonTime,
                user_t1.LoginName.label('CreatorName')).outerjoin(user_t1, user_t1.ID == SmUserAdmin.CreatorID).filter(
                SmUserAdmin.ID != '1',
                SmUserAdmin.ID == m_id
            ).all()
            if len(result) == 0:
                return None
            return cls.result_to_dict(result)[0]
        except Exception as e:
            current_app.logger.error(e)
            return None

    @classmethod
    def update_by_id(cls, m_id, **para):
        """
        查询管理员
        :param m_id: 管理员id
        :param para: 提交参数
        :return:
        """
        # 校验用户名是否重复
        try:
            result = SmUser.query.filter(SmUser.LoginName == para['LoginName']).first()
            if result and result.ID != m_id:
                return 2
            return super(SmUserAdminService, cls).update_by_id(m_id, **para)
        except Exception as e:
            current_app.logger.error(e)
            return 1
        return 0



