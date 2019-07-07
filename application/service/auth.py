# -*- coding:utf-8 -*-
"""
生成token，或解密token
"""
import datetime
import jwt

from ..settings import FlaskConfig


def encode_auth_token(**data):
    """
    创建token   jwt
    :param data: 放置到token中的数据
    :return:
    """
    try:
        payload = {
            'exp': datetime.datetime.utcnow() + datetime.timedelta(days=0, seconds=FlaskConfig.JWT_LIFETIME),
            'iat': datetime.datetime.utcnow(),
            'iss': 's4202',
            'data': data
        }
        return jwt.encode(
            payload,
            FlaskConfig.SECRET_KEY,
            algorithm='HS256'
        ).decode()
    except Exception as e:
        return None


def decode_auth_token(token: str):
    """
    解析token
    :param token: 待解析的token
    :return: 解析后的字符串
    """
    return jwt.decode(
        token,
        FlaskConfig.SECRET_KEY,
        algorithms='HS256'
    )

