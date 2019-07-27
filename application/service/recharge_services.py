# -*- coding:utf-8 -*-
"""
充值管理service
"""
from flask import current_app
from sqlalchemy.orm import aliased
from datetime import datetime

from .utils import BaseService
from ..dao.models import db, SmRecharge


class SmRechargeService(BaseService):
    """
    充值管理，单号等自动生成因为一些问题，未接入服务，仅仅测试
    """
    BaseModel = SmRecharge

    @classmethod
    def member_recharge(cls, member_user, ip, Value, VendorNumber=None):
        """
        会员充值
        :param member_user: 会员
        :param ip: ip
        :param Value: 金额
        :param VendorNumber: 商家号
        :return:
        """
        time_now = datetime.now()
        try:
            recharge = SmRecharge(Number=cls.create_order_id(time_now), MemberID=member_user.ID, Value=Value, OrderIP=ip,
                                  CreateTime=time_now, VendorNumber=VendorNumber, DepositStatus='等待付款',
                                  Note='[' + member_user.LoginName + '][' + member_user.NickName+ ']银行转账，未支付')
            db.session.add(recharge)
            cls.create_log(member_user.ID, '充值下单', '银行转账', time_now, '会员' + member_user.LoginName + ' ' + member_user.NickName + '充值下单 ' + str(Value))
            return 0
        except Exception as e:
            current_app.logger.error(e)
            return 1


