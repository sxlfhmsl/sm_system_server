# -*- coding:utf-8 -*-
import os
import logging
from logging.handlers import RotatingFileHandler
from flask import Flask
from flask_wtf import CSRFProtect
from flask_migrate import Migrate
import pymysql

from .dao.utils import flask_redis
from .dao.models import db
from .dao.utils import RedisOp

pymysql.install_as_MySQLdb()


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
    # CSRFProtect(app)

    # 配置数据库
    db.init_app(app)
    flask_redis.init_app(app)
    Migrate(app, db)

    # 启用日志
    setup_log(test_config)

    # 添加蓝图
    reg_blueprint(app)

    # 初始化redis
    init_redis_value()

    # a simple page that says hello
    @app.route('/hello')
    def hello():
        return '<html>Hello, World!</html>'
    return app


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


def reg_blueprint(app):
    """
    添加蓝图函数
    :return: None
    """
    from .index.user_bp import user_bp
    from .index.user_admin_bp import user_admin_bp
    from .index.user_agent_bp import user_agent_bp
    from .index.user_member_bp import user_member_bp
    from .index.exception_bp import exception_bp
    from .index.clerk_bp import clerk_bp
    from .index.system_bp import system_bp
    from .index.stock_bp import stock_bp
    from .index.fund_bp import fund_bp

    # 用户相关蓝图接口
    app.register_blueprint(user_bp, url_prefix='/user')
    # 管理员相关接口
    app.register_blueprint(user_admin_bp, url_prefix='/user/admin')
    # 代理相关接口
    app.register_blueprint(user_agent_bp, url_prefix='/user/agent')
    # 会员相关接口
    app.register_blueprint(user_member_bp, url_prefix='/user/member')
    # 业务员相关接口
    app.register_blueprint(clerk_bp, url_prefix='/clerk')
    # 股票相关接口
    app.register_blueprint(stock_bp, url_prefix='/stock')
    # 资金相关接口
    app.register_blueprint(fund_bp, url_prefix='/fund')
    # 系统相关接口
    app.register_blueprint(system_bp, url_prefix='/system')
    # 异常拦截
    app.register_blueprint(exception_bp, url_prefix='/exception')


def init_redis_value():
    """
    初始化redis中的值
    :return:
    """
    path = os.getcwd() + '/application/static/'
    # 设置交易规则标题
    file = open(path + 'trade_role_title', encoding='utf8')
    RedisOp().set_normal('system_trade_role_title', file.read())
    file.close()
    # 设置交易规则内容
    file = open(path + 'trade_role_content', encoding='utf8')
    RedisOp().set_normal('system_trade_role_content', file.read())
    file.close()
