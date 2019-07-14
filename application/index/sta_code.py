# -*- coding:utf-8 -*-
"""
状态码，此处存放返回值前端的状态码
"""


# 请求成功
def SUCCESS(data):
    return {'code': 0, 'data': data, 'msg': '请求成功!'}


# 系统错误-----10000以下为系统内部错误代码
URL_NOTFOUND_ERROR = {'code': 404, 'msg': '请求不存在'}
INS_ERROR = {'code': 500, 'msg': '系统内部错误'}


# 基础错误-----其为一些共性错误，如参数提交错误等 (10001-11000)
POST_PARA_ERROR = {'code': 10001, 'msg': '提交参数错误'}
OTHER_ERROR = {'code': 10002, 'msg': '其他错误'}
PERMISSION_DENIED_ERROR = {'code': 10003, 'msg': '权限不足'}


# 用户相关操作错误-----登录，查询，新建等( 11001-13000)

#     登录错误
USER_NAME_PASS_WRONG_ERROR = {'code': 11001, 'msg': '用户名或密码错误'}
USER_FORBIDDEN_ERROR = {'code': 11002, 'msg': '用户被禁用'}
USER_LOCK_ERROR = {'code': 11003, 'msg': '账户被锁定'}

