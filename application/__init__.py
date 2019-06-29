# -*- coding:utf-8 -*-
import os
import logging
from logging.handlers import RotatingFileHandler
from flask import Flask
from flask_wtf import CSRFProtect
from flask_migrate import Migrate
import pymysql
from .dao.utils import db, flask_redis

pymysql.install_as_MySQLdb()


# 增加日志模块
def setup_log(config):
    # 设置日志等级
    logging.basicConfig(level=config.LOG_LEVEL)
    # 创建日志记录器，指明日志保存的路径、每个日志文件的最大大小、保存的日志文件个数上限
    file_log_handler = RotatingFileHandler('log/log', maxBytes=1024 * 1024 * 300, backupCount=10)
    # 创建日志记录的格式 日志等级 输入日志信息的文件名 行数 日志信息
    formatter = logging.Formatter('%(asctime)s %(levelname)s %(filename)s:%(lineno)d %(message)s')
    # 为刚创建的日志记录器设置日志记录格式
    file_log_handler.setFormatter(formatter)
    # 为全局的日志工具对象（flask app使用的）添加日志记录器
    logging.getLogger().addHandler(file_log_handler)


def create_app(test_config=None):
    # create and configure the app
    app = Flask(__name__, instance_relative_config=True)
    if test_config is None:
        # load the instance config, if it exists, when not testing
        app.config.from_pyfile('config.py', silent=True)
    else:
        # load the test config if passed in
        app.config.from_object(test_config)

    # ensure the instance folder exists
    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass

    # 开启CSRF防范功能
    CSRFProtect(app)

    # 配置数据库
    db.init_app(app)
    flask_redis.init_app(app)
    Migrate(app, db)

    # 启用日志
    setup_log(test_config)

    # a simple page that says hello
    @app.route('/hello')
    def hello():
        return '<html>Hello, World!</html>'
    return app

