# -*- coding:utf-8 -*-
"""
用户登录接口
"""
from flask.blueprints import Blueprint
from flask import request, jsonify, abort

from .utils import BaseView, PermissionView
from .sta_code import SUCCESS, ERROR_USER_LOGIN, POST_PARA_ERROR
from ..service.user_service import SmUserService

user_bp = Blueprint('user', __name__)


class UserLoginView(BaseView):
    """
    用户登录
    """

    def dispatch_request(self):
        token = SmUserService.login(request.json['LoginName'], request.json['Password'])
        if not isinstance(token, int):
            success = SUCCESS()
            success['data'] = {'token': token}
            return jsonify(success)
        else:
            return jsonify(ERROR_USER_LOGIN[token])


class UserInfoView(PermissionView):
    """
    获取用户信息
    """

    def response_admin(self):
        success = SUCCESS()
        success['data'] = SmUserService.admin_info_id(self._uid)
        return jsonify(success)

    def response_agent(self):
        success = SUCCESS()
        success['data'] = SmUserService.agent_info_id(self._uid)
        return jsonify(success)

    def response_member(self):
        success = SUCCESS()
        success['data'] = SmUserService.member_info_id(self._uid)
        return jsonify(success)


class CreateAdmin(PermissionView):
    """
    创建管理员
    """

    def response_admin(self):
        if request.json is None or len(request.json) == 0:
            return jsonify(POST_PARA_ERROR)
        if SmUserService.create_admin(
                CreatorID=self._uid,
                LoginName=request.json.get('LoginName', None),
                NickName=request.json.get('NickName', None),
                Password=request.json.get('Password', None)
        ) != 0:
            return jsonify(POST_PARA_ERROR)
        else:
            return jsonify(SUCCESS())

    def response_agent(self):
        abort(404)

    def response_member(self):
        abort(404)


class CreateAgent(PermissionView):
    """
    创建代理
    """

    def create_para(self):
        """
        封装参数
        :return: dict
        """
        return dict(
            LoginName=request.json.get('LoginName', None),                     # 登录名
            NickName=request.json.get('NickName', None),                       # 昵称，名称
            Password=request.json.get('Password', None),                       # 密码
            Margin=request.json.get('Margin', None),                           # 保证金
            TestMargin=request.json.get('TestMargin', None),                   # 测试保证金
            CommissionRatio=request.json.get('CommissionRatio', None),         # 交易佣金分成
            ExchangeRate=request.json.get('ExchangeRate', None),               # 人民币与股币兑换
            MemberPrefix=request.json.get('MemberPrefix', None),               # 会员账号前缀
            MemberMaximum=request.json.get('MemberMaximum', None),             # 可创建会员数量限制
            Bank=request.json.get('Bank', None),                               # 收款银行
            BankAccount=request.json.get('BankAccount', None),                 # 银行账户
            Cardholder=request.json.get('Cardholder', None),                   # 银行账户名
            WithdrawPassWord=request.json.get('WithdrawPassWord', None),       # 取款密码
            Type=request.json.get('Type', None),                               # 正式，测试，其他
        )

    def response_admin(self):
        if request.json is None or len(request.json) == 0:
            return jsonify(POST_PARA_ERROR)
        result = SmUserService.create_agent(self._uid, self._u_type, **self.create_para())
        if result == 0:                                                        # 添加成功
            return jsonify(SUCCESS())
        if result == 1:                                                        # 参数错误
            return jsonify(POST_PARA_ERROR)

    def response_agent(self):
        if request.json is None or len(request.json) == 0:
            return jsonify(POST_PARA_ERROR)
        result = SmUserService.create_agent(self._uid, self._u_type, **self.create_para())
        if result == 0:                                                        # 添加成功
            return jsonify(SUCCESS())
        if result == 1:                                                        # 参数错误
            return jsonify(POST_PARA_ERROR)
        if result == 2:                                                        # 权限不足----最大4级代理
            abort(404)

    def response_member(self):
        abort(404)


user_bp.add_url_rule('/login', methods=['POST'], view_func=UserLoginView.as_view('user_login'))
user_bp.add_url_rule('/info', methods=['POST'], view_func=UserInfoView.as_view('user_info'))
user_bp.add_url_rule('/create_admin', methods=['POST'], view_func=CreateAdmin.as_view('create_admin'))
user_bp.add_url_rule('/create_agent', methods=['POST'], view_func=CreateAgent.as_view('create_agent'))

