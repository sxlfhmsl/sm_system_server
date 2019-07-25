# -*- coding:utf-8 -*-
"""
系统相关service
"""
from flask import current_app

from .utils import BaseService
from ..dao.utils import RedisOp


class SystemService(BaseService):
    """
    系统相关service
    """

    @staticmethod
    def get_trade_role():
        return {
            'title': RedisOp().get_normal('system_trade_role_title').decode(encoding='utf8'),
            'content': RedisOp().get_normal('system_trade_role_content').decode(encoding='utf8')
        }

    @staticmethod
    def set_trade_role(title, content):
        """
        设置交易规则
        :param title: 标题
        :param content: 内容
        :return:
        """
        try:
            RedisOp().set_normal('system_trade_role_title', title)
            RedisOp().set_normal('system_trade_role_content', content)
            return 0
        except Exception as e:
            current_app.logger.error(e)
            return 1

