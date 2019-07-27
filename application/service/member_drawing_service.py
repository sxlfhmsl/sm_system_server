# -*- coding:utf-8 -*-
"""
会员提款service
"""
from datetime import datetime
from flask import current_app

from ..dao.models import db, SmMemberDrawing
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
