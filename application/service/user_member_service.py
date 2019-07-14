# -*- coding:utf-8 -*-
"""
会员相关service
"""
from flask import current_app
from sqlalchemy import and_

from ..dao.models import SmUserMember
from .utils import BaseService


class SmUserMemberService(BaseService):
    """
    代理业务逻辑代码
    """

    @classmethod
    def info_by_id(cls, uid):
        """
        获取会员信息
        :param uid: 目标id
        :return:
        """
        try:
            mid = SmUserMember.query.filter(
                and_(SmUserMember.ID == uid, SmUserMember.Forbidden == 0, SmUserMember.Lock < 6)).first()
            result = cls.model_to_dict_by_dict(mid)
            result['AgentName'] = mid.sm_user_agent.LoginName
            result['ClerkName'] = mid.sm_user_agent.NickName
            return result
        except Exception as e:
            current_app.logger.error(e)
            return None
