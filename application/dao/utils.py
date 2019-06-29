# -*- coding:utf-8 -*-
"""
数据库实例相关文件
"""
import redis
from flask_sqlalchemy import SQLAlchemy
from flask_redis import FlaskRedis

from application.settings import FlaskConfig


class RedisOp:
    """
    redis操作类
    """
    __pool = None
    __instance = None

    def __new__(cls, *args, **kwargs):
        if not cls.__instance:
            cls.__instance = super(RedisOp, cls).__new__(cls, *args, **kwargs)
        return cls.__instance

    def __init__(self):
        if hasattr(self, '_db_pool'):
            return
        self._db_pool = redis.ConnectionPool.from_url(FlaskConfig.REDIS_URL)

    def _get_coon(self):
        return redis.StrictRedis(connection_pool=self._db_pool)

    def update_expire(self, name, time):
        coon = self._get_coon()
        res = coon.expire(name, time)
        return res

    def set_normal(self, key, value, time=None):
        coon = self._get_coon()
        # 非空即真非0即真
        if time:
            res = coon.setex(key, time, value)
        else:
            res = coon.set(key, value)
        return res

    def get_normal(self, key):
        coon = self._get_coon()
        res = coon.get(key)
        return res

    def remove_items(self, *key):
        coon = self._get_coon()
        res = coon.delete(*key)
        return res

    """
    hash类型，{'name':{'key':'value'}} redis操作
    """

    def set_hash(self, name, key, value):
        coon = self._get_coon()
        res = coon.hset(name, key, value)
        return res

    def get_hash(self, name, key=None):
        coon = self._get_coon()
        # 判断key是否我为空，不为空，获取指定name内的某个key的value; 为空则获取name对应的所有value
        if key:
            res = coon.hget(name, key)
        else:
            res = coon.hgetall(name)
        return res

    def del_hash(self, name, key=None):
        coon = self._get_coon()
        if key:
            res = coon.hdel(name, key)
        else:
            res = coon.delete(name)
        return res

    def get_keys(self):
        coon = self._get_coon()
        res = coon.keys()
        return res

    def r_push_value(self, key, *args):
        coon = self._get_coon()
        res = coon.rpush(key, *args)
        return res

    # 发送消息
    def public(self, channel, msg):
        coon = self._get_coon()
        coon.publish(channel, msg)
        return True

    # 订阅
    def subscribe(self, channel):
        coon = self._get_coon()
        # 打开收音机
        pub = coon.pubsub()
        # 调频道
        pub.subscribe(channel)
        # 准备接收
        pub.parse_response()
        return pub


# 数据库连接
db = SQLAlchemy()
# redis
redis_op = RedisOp()
flask_redis = FlaskRedis()
