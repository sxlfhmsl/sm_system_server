# -*- coding:utf-8 -*-
"""
请求外部信息
"""
from urllib import request
from json import loads


class BaseRequest:
    """
    基础请求
    """
    BASE_URL = ''

    @classmethod
    def http_get_json(cls, api_url, **url_para):
        """
        建立http请求
        :param api_url: api层级的url
        :param url_para: 参数
        :return: 结果json
        """
        params = '&'.join([key + '=' + str(url_para[key]) for key in url_para.keys()])
        print('http://' + cls.BASE_URL + api_url + '?' + params)
        with request.urlopen('http://' + cls.BASE_URL + api_url + '?' + params) as url_open:
            return loads(url_open.read().decode('UTF8'))


class DataApi51Request(BaseRequest):
    """
    请求51
    """
    BASE_URL = 'data.api51.cn'
    TOKEN = '12a9788cb7c2cc96111ce6d567af660f'

    @classmethod
    def get_stock_real(cls, *stock_list):
        """
        prod_code	String	32	产品代码
        prod_name	String	60	产品名称
        update_time	Integer	10	最后更新时间戳
        open_px	Integer	10	开盘价
        high_px	Integer	10	最高价
        low_px	Integer	10	最低价
        last_px	Integer	10	最新价
        preclose_px	Integer	10	昨收价
        bid_grp	String	255	委买档位
        offer_grp	String	255	委卖档位
        week_52_low	Integer	10	52周最低价
        week_52_high	Integer	10	52周最高价
        px_change	Integer	10	涨跌额
        px_change_rate	Integer	10	涨跌率
        market_value	Float	16.2	总市值
        circulation_value	Integer	16	流通市值
        dyn_pb_rate	Integer	8	动态市净率
        dyn_pe	Integer	10	市盈率
        turnover_ratio	Integer	10	换手率
        turnover_volume	Integer	10	成交量
        turnover_value	Integer	10	成交额
        amplitude	Integer	10	振幅
        trade_status	String	16	交易状态
        business_amount_in	Integer	16	内盘成交量
        business_amount_out	Integer	16	外盘成交量
        bps	Integer	10	每股净资产
        pe_rate	Float	10	市盈率TTM
        volume_ratio	Integer	10	量比
        circulation_shares	Integer	10	流通股本
        total_shares	Integer	10	总股本
        请求实时价格
        :param stock_list: 股票代码列表
        :return: 结果
        """
        api_url = '/apis/integration/real/'
        fields_list = []
        url_para = {
            'token': cls.TOKEN,
            'fields': '%2C'.join(fields_list),
            'prod_code': ','.join(stock_list)
        }
        result = cls.http_get_json(api_url, **url_para)
        fields = result['data']['fields']
        snapshot = result['data']['snapshot']
        for key in snapshot.keys():
            buf = snapshot[key]
            snapshot[key] = {key: value for key, value in zip(fields, buf)}
        return snapshot if len(snapshot) > 1 else snapshot[stock_list[0]]

