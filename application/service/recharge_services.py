# -*- coding:utf-8 -*-
"""
充值管理service
"""
from flask import current_app
from sqlalchemy.orm import aliased
from datetime import datetime

from .utils import BaseService
from ..dao.models import db, SmRecharge, SmUserMember


class SmRechargeService(BaseService):
    """
    充值管理，单号等自动生成因为一些问题，未接入服务，仅仅测试
    """
    BaseModel = SmRecharge

    @classmethod
    def member_recharge(cls, member_user, ip, Value, VendorNumber=None, Bank=None):
        """
        会员充值
        :param member_user: 会员
        :param ip: ip
        :param Value: 金额
        :param VendorNumber: 商家号
        :param Bank: 银行
        :return:
        """
        time_now = datetime.now()
        try:
            recharge = SmRecharge(Number=cls.create_order_id(time_now), MemberID=member_user.ID, Value=Value, OrderIP=ip,
                                  CreateTime=time_now, VendorNumber=VendorNumber, DepositStatus='等待付款', Bank=Bank,
                                  Note='[' + member_user.LoginName + '][' + member_user.NickName + ']银行转账，未支付')
            db.session.add(recharge)
            cls.create_log(member_user.ID, '充值下单', '银行转账', time_now, '会员' + member_user.LoginName + ' ' + member_user.NickName + '充值下单 ' + str(Value))
            return 0
        except Exception as e:
            current_app.logger.error(e)
            return 1

    @classmethod
    def query_all(cls, MemberID=None, AgentID=None, LoginName=None, DepositStatus=None, StartTime=None, EndTime=None, Page=None, PageSize=None):
        """
        管理员查询所有银证转账
        :param MemberID: 会员id
        :param AgentID: 代理id
        :param LoginName: 登录名
        :param DepositStatus: 状态
        :param StartTime:开始时间
        :param EndTime:结束时间
        :param Page: 页数
        :param PageSize: 每页数量
        :return:
        """
        if Page is None or PageSize is None:
            Page = 1
            PageSize = 1000
        try:
            filter_list = []
            member_table = aliased(SmUserMember)
            if AgentID is not None:
                filter_list.append(member_table.AgentID == AgentID)
            if MemberID is not None:
                filter_list.append(SmRecharge.MemberID == MemberID)
            if StartTime is not None:
                filter_list.append(SmRecharge.CreateTime >= StartTime)
            if EndTime is not None:
                filter_list.append(SmRecharge.CreateTime <= EndTime)
            if LoginName is not None:
                filter_list.append(member_table.LoginName.like('%' + LoginName + '%'))
            if DepositStatus is not None:
                filter_list.append(SmRecharge.DepositStatus == DepositStatus)
            page_result = db.session.query(
                SmRecharge,
                member_table.LoginName.label('MemberLoginName'),
                member_table.NickName.label('MemberNickName')).outerjoin(
                member_table, SmRecharge.MemberID == member_table.ID
            ).filter(*filter_list).order_by(SmRecharge.CreateTime.desc()).paginate(Page, PageSize)
            return {"total": page_result.total, "rows": cls.result_to_dict(page_result.items)}
        except Exception as e:
            current_app.logger.error(e)
            return None

    @classmethod
    def agent_query_all(cls, agent_id, LoginName=None, DepositStatus=None, StartTime=None, EndTime=None, Page=None, PageSize=None):
        """
        代理查询所有银证转账
        :param LoginName: 登录名
        :param DepositStatus: 状态
        :param StartTime:开始时间
        :param EndTime:结束时间
        :param Page: 页数
        :param PageSize: 每页数量
        :return:
        """
        pass


