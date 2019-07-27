# -*- coding:utf-8 -*-
"""
会员提款service
"""
from datetime import datetime
from flask import current_app
from sqlalchemy.orm import aliased

from ..dao.models import db, SmMemberDrawing, SmUserMember, SmDrawingStatu
from .utils import BaseService


class SmMemberDrawingService(BaseService):
    """
    会员提款
    """
    BaseModel = SmMemberDrawing

    @classmethod
    def withdraw(cls, member_user, WithdrawPassWord, DrawingValue):
        """
        发起会员提款
        :param member_user: 会员
        :param WithdrawPassWord: 密码
        :param DrawingValue: 提款金额
        :return: 返回结果            阐述
                 0                   提款成功
                 1                   提款密码错误
                 2                   余额不足
                 3                   其他错误
        """
        date_time_now = datetime.now()
        try:
            session = db.session
            if member_user.WithdrawPassWord != cls.sha256_generator(WithdrawPassWord):
                return 1
            if member_user.Margin < DrawingValue:
                return 2
            draw = SmMemberDrawing(ID=cls.md5_generator('sm_member_drawing' + str(date_time_now)), MemberID=member_user.ID,
                                   DrawingTime=date_time_now, DrawingValue=DrawingValue, Bank=member_user.Bank,
                                   BankOfDeposit=member_user.OpeningBank, BankAccountName=member_user.Cardholder,
                                   BankAccount=member_user.BankAccount, DrawingStatus=1)
            member_user.Margin -= DrawingValue
            session.add(draw)
            cls.create_log(member_user.ID, '资金', '会员提款', date_time_now, '会员' + member_user.LoginName + '发起提款' + str(DrawingValue))
            return 0
        except Exception as e:
            current_app.logger.error(e)
            return 3

    @classmethod
    def query_withdraw_all(cls, MemberID=None, AgentID=None, LoginName=None, BankAccountName=None, Page=None, PageSize=None):
        """
        查询所有的会员提款
        :param MemberID: 会员id
        :param AgentID: 代理id
        :param LoginName: 登录名
        :param BankAccountName: 账户名
        :param Page: 分页起始
        :param PageSize: 分页大小
        :return: 执行结果list
        """
        if Page is None or PageSize is None:
            Page = 1
            PageSize = 1000
        try:
            filter_list = []
            if AgentID is not None:
                filter_list.append(SmUserMember.AgentID == AgentID)
            if MemberID is not None:
                filter_list.append(SmMemberDrawing.MemberID == MemberID)
            if LoginName is not None:
                filter_list.append(SmUserMember.LoginName.like('%' + LoginName + '%'))
            if BankAccountName is not None:
                filter_list.append(SmMemberDrawing.BankAccountName.like('%' + BankAccountName + '%'))
            page_result = db.session.query(
                SmMemberDrawing, SmDrawingStatu.Description.label('DrawingStatusName'),
                SmUserMember.LoginName.label('MemberNumber')).outerjoin(
                SmUserMember, SmMemberDrawing.MemberID == SmUserMember.ID
            ).outerjoin(SmDrawingStatu, SmDrawingStatu.ID == SmMemberDrawing.DrawingStatus).filter(*filter_list).\
                order_by(SmMemberDrawing.DrawingTime.desc()).paginate(Page, PageSize)
            return {"total": page_result.total, "rows": cls.result_to_dict(page_result.items)}
        except Exception as e:
            current_app.logger.error(e)
            return None
