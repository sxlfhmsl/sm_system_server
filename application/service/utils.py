# -*- coding:utf-8 -*-
"""
通用函数
"""

from hashlib import md5, sha256


def md5_generator(content: str):
    """
     生成md5字符串
    :param content: 待摘要的内容
    :return:
    """
    return md5(content.encode()).hexdigest()


def sha256_generator(content: str):
    """
     生成sha256字符串
    :param content: 待摘要的内容
    :return:
    """
    return sha256(content.encode()).hexdigest()
