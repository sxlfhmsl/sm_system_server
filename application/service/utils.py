# -*- coding:utf-8 -*-
"""
通用函数
"""

from hashlib import md5, sha256


class BaseService:

    from .model_convert import model_to_dict_by_dict

    @staticmethod
    def md5_generator(content: str):
        """
         生成md5字符串
        :param content: 待摘要的内容
        :return:
        """
        return md5(content.encode()).hexdigest()

    @staticmethod
    def sha256_generator(content: str):
        """
         生成sha256字符串
        :param content: 待摘要的内容
        :return:
        """
        return sha256(content.encode()).hexdigest()

