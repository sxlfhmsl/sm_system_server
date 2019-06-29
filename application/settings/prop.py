# -*- coding:utf-8 -*-

from . import FlaskConfig


class ProductionConfig(FlaskConfig):
    """生产模式下的配置"""
    DEBUG = False

