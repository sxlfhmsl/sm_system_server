# -*- coding:utf-8 -*-
"""
配置参数获取service
"""
from datetime import datetime
from flask import current_app

from .utils import BaseService
from ..dao.models import db, SmSysConf
from ..dao.utils import RedisOp


class SmSysConfService(BaseService):
    """
    系统参数配置services
    """
    BaseModel = SmSysConf

    @classmethod
    def create_sys_conf(cls, admin_user, key, value, des):
        """
        添加配置参数
        :param admin_user: 管理员
        :param key: 键
        :param value: 值
        :param des: 描述
        :return:
        """
        try:
            sys_conf = SmSysConf(Key=key, Value=value, Description=des)
            db.session.add(sys_conf)
            cls.create_log(admin_user.ID, '系统参数', '创建系统参数', datetime.now(), '管理员' + admin_user.LoginName + '创建系统参数 ' + des)
            RedisOp().set_normal(key, value)
            return True
        except Exception as e:
            current_app.logger.error(e)
            return False

    @classmethod
    def get_sys_conf(cls, key):
        """
        获取单个系统参数
        :param key: 键
        :return: 值
        """
        try:
            result = RedisOp().get_normal(key).decode('UTF8')
            if result is not None:
                return result
            else:
                result = SmSysConf.query.filter(SmSysConf.Key == key).first()
                if result is not None:
                    RedisOp().set_normal(key, result.Value)
                    return result.Value
        except Exception as e:
            current_app.logger.error(e)
        return None

    @classmethod
    def get_sys_multi_conf(cls, *keys):
        """
        获取多个系统参数
        :param keys: 键
        :return:
        """
        result = {}
        try:
            for key in keys:
                buf = RedisOp().get_normal(key).decode('UTF8')
                if buf is None:
                    buf = SmSysConf.query.filter(SmSysConf.Key == key).first()
                    if buf is not None:
                        result[key] = buf.Value
                        RedisOp().set_normal(key, buf.Value)
                else:
                    result[key] = buf
        except Exception as e:
            current_app.logger.error(e)
        return result

