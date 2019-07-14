# -*- coding:utf-8 -*-
"""
状态码，此处存放返回值前端的状态码
"""


# 请求成功
def SUCCESS():
    return {'code': 0, 'msg': '请求成功!'}


# 系统错误-----10000以下为系统内部错误代码
URL_NOTFOUND_ERROR = {'code': 404, 'msg': '请求不存在'}
INS_ERROR = {'code': 500, 'msg': '系统内部错误'}

# 基础错误-----提交参数不匹配等
ERROR_BASE = {
    'POST_PARA_ERROR': {'code': 10100, 'msg': '提交参数错误'}
}

# 用户登录失败
ERROR_USER_LOGIN = {
    'PARA_ERROR': {'code': 10201, 'msg': '用户名或密码错误'},
    'FORBIDDEN_ERROR': {'code': 10202, 'msg': '用户被禁用'},
    'LOCK_ERROR': {'code': 10203, 'msg': '账户被锁定'},
    'OP_ERROR': {'code': 10204, 'msg': '操作非法'},
}

