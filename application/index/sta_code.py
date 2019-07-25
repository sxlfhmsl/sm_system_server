# -*- coding:utf-8 -*-
"""
状态码，此处存放返回值前端的状态码
"""


# 请求成功
def SUCCESS(data=None):
    if data:
        return {'code': 0, 'data': data, 'msg': '请求成功!'}
    else:
        return {'code': 0, 'msg': '请求成功!'}


# 系统错误-----10000以下为系统内部错误代码
URL_NOTFOUND_ERROR = {'code': 404, 'msg': '请求不存在'}
INS_ERROR = {'code': 500, 'msg': '系统内部错误'}


# 基础错误-----其为一些共性错误，如参数提交错误等 (10001-11000)
POST_PARA_ERROR = {'code': 10001, 'msg': '提交参数错误'}
OTHER_ERROR = {'code': 10002, 'msg': '其他错误'}
PERMISSION_DENIED_ERROR = {'code': 10003, 'msg': '权限不足'}
QUERY_NO_RESULT = {'code': 10004, 'msg': '查询不到结果'}
DELETE_NOT_EXITS = {'code': 10005, 'msg': '目标不存在'}


# 用户相关操作错误-----登录，查询，新建等( 11001-13000)

#     登录错误
USER_NAME_PASS_WRONG_ERROR = {'code': 11001, 'msg': '用户名或密码错误'}
USER_FORBIDDEN_ERROR = {'code': 11002, 'msg': '用户被禁用'}
USER_LOCK_ERROR = {'code': 11003, 'msg': '账户被锁定'}

#     用户操作错误
USER_SAME_LOGIN_NAME = {'code': 11004, 'msg': '登录名已存在，请使用新的登录名'}
USER_AGENT_LEVEL_LOW = {'code': 11005, 'msg': '代理等级过低，无法完成操作'}
USER_AGENT_NOT_ENOUGH_MEMBER = {'code': 11006, 'msg': '代理可创建会员数量不足'}
USER_WRONG_PASS = {'code': 11007, 'msg': '密码错误'}
USER_DELETE_ERROR = {'code': 11008, 'msg': '禁止删除用户'}
USER_AGENT_MEMBER_NOT_NULL = {'code': 11009, 'msg': '代理名下会员不为空或者代理不存在'}
CLERK_SAME_NAME = {'code': 11010, 'msg': '业务员名称相同'}

