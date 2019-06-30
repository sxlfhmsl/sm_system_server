# -*- coding:utf-8 -*-
"""
状态码，此处存放返回值前端的状态码
"""
from copy import deepcopy

# 请求成功
SUCCESS = deepcopy({'code': 0, 'msg': '请求成功!'})

# 系统错误
ERROR_URL_NOTFOUND = {'code': 404, 'msg': '请求不存在'}
ERROR_IN = {'code': 500, 'msg': '请检查提交参数'}

