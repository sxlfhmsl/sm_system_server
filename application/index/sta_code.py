# -*- coding:utf-8 -*-
"""
状态码，此处存放返回值前端的状态码
"""


# 请求成功
def SUCCESS():
    return {'code': 0, 'msg': '请求成功!'}


# 系统错误
ERROR_URL_NOTFOUND = {'code': 404, 'msg': '请求不存在'}
ERROR_IN = {'code': 500, 'msg': '请检查提交参数'}

# 用户登录失败
ERROR_USER_LOGIN = [
    {'code': 10001, 'msg': '用户名或密码错误'},
    {'code': 10002, 'msg': '用户被禁用'},
    {'code': 10003, 'msg': '账户被锁定'}
]

