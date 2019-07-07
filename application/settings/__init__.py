# -*- coding:utf-8 -*-
from hashlib import sha256


class FlaskConfig:
    """
    flask配置类
    """
    # Flask设置
    DEBUG = True

    # todo 配置日志
    LOG_LEVEL = "DEBUG"

    # flask_sqlalchemy配置
    # mysql连接信息
    SQLALCHEMY_DATABASE_URI = "mysql://root:admin123@127.0.0.1:3306/sm_system?charset=utf8"
    # 动态追踪修改设置，如未设置只会提示警告
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    # 查询时会显示原始SQL语句
    SQLALCHEMY_ECHO = False
    # 客户端盐值
    SECRET_KEY = sha256("zxcvbnm123.".encode('utf8')).hexdigest()
    # 剩余时间
    JWT_LIFETIME = 3600

    # redis redis://[:password]@localhost:6379/0
    REDIS_URL = "redis://:admin123@localhost:6379/0"

