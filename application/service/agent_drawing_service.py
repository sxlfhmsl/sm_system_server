# -*- coding:utf-8 -*-
"""
代理提款service
"""
from datetime import datetime
from flask import current_app

from ..dao.models import db, SmAgentDrawing
from .utils import BaseService


class SmAgentDrawingService(BaseService):
    """
    会员提款
    """
    BaseModel = SmAgentDrawing

    @classmethod
    def withdraw(cls, agent_user, WithdrawPassWord, DrawingValue):
        """
        发起会员提款
        :param agent_user: 会员
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
            if agent_user.WithdrawPassWord != cls.sha256_generator(WithdrawPassWord):
                return 1
            if agent_user.Margin < DrawingValue:
                return 2
            draw = SmAgentDrawing(ID=cls.md5_generator('sm_agent_drawing' + str(date_time_now)), AgentID=agent_user.ID,
                                  DrawingTime=date_time_now, DrawingValue=DrawingValue, Bank=agent_user.Bank,
                                  BankOfDeposit=agent_user.OpeningBank, BankAccountName=agent_user.Cardholder,
                                  BankAccount=agent_user.BankAccount, DrawingStatus=1)
            agent_user.Margin -= DrawingValue
            session.add(draw)
            cls.create_log(agent_user.ID, '资金', '代理提款', date_time_now, '代理' + agent_user.LoginName + '发起提款' + str(DrawingValue))
            return 0
        except Exception as e:
            current_app.logger.error(e)
            return 3
