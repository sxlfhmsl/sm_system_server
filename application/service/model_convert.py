# -*- coding:utf-8 -*-
"""
将model转换为dict或者list
"""
from collections import Iterable
from datetime import datetime as cdatetime     # 有时候会返回datatime类型
from datetime import date, time
from flask_sqlalchemy import Model
from sqlalchemy import DateTime, Numeric, Date, Time    # 有时又是DateTime


def query_to_dict(models):
    if isinstance(models, list):
        if isinstance(models[0], Model):
            lst = []
            for model in models:
                gen = model_to_dict(model)
                dit = dict((g[0], g[1]) for g in gen)
                lst.append(dit)
            return lst
        else:
            res = result_to_dict(models)
            return res
    else:
        if isinstance(models, Model):
            gen = model_to_dict(models)
            dit = dict((g[0], g[1]) for g in gen)
            return dit
        else:
            res = dict(zip(models.keys(), models))
            find_datetime(res)
            return res


# 当结果为result对象列表时，result有key()方法
def result_to_dict(result):
    try:
        if isinstance(result, Iterable):
            res = [dict(zip(r.keys(), r)) for r in result]
            # 这里r为一个字典，对象传递直接改变字典属性
            for r in res:
                find_datetime(r)
        else:
            res = dict(zip(result.keys(), result))
            find_datetime(res)
        return res
    except BaseException as e:
        print(e.args)
        return None


def model_to_dict_by_dict(result):
    # 转换完成后，删除  '_sa_instance_state' 特殊属性
    try:
        if isinstance(result, Iterable):
            tmp = [dict(zip(res.__dict__.keys(), res.__dict__.values())) for res in result]
            for t in tmp:
                t.pop('_sa_instance_state')
                find_datetime(t)
        else:
            tmp = dict(zip(result.__dict__.keys(), result.__dict__.values()))
            tmp.pop('_sa_instance_state')
            find_datetime(tmp)
        return tmp
    except BaseException as e:
        print(e.args)
        return None


def sig_model_to_dict(model, *columns):
    result = {}
    for col in columns:
        if isinstance(col.type, DateTime):
            value = convert_datetime(getattr(model, col.name))
            print(value)
        elif isinstance(col.type, Numeric):
            value = float(getattr(model, col.name))
        else:
            value = getattr(model, col.name)
        result[col.name] = value
    return result


def model_to_dict(model):      # 这段来自于参考资源
    for col in model.__table__.columns:
        if isinstance(col.type, DateTime):
            value = convert_datetime(getattr(model, col.name))
        elif isinstance(col.type, Numeric):
            value = float(getattr(model, col.name))
        else:
            value = getattr(model, col.name)
        yield (col.name, value)


def find_datetime(value):
    for v in value:
        if isinstance(value[v], cdatetime):
            value[v] = convert_datetime(value[v])   # 这里原理类似，修改的字典对象，不用返回即可修改


def convert_datetime(value):
    if value:
        if isinstance(value, (cdatetime, DateTime)):
            return value.strftime("%Y-%m-%d %H:%M:%S")
        elif isinstance(value, (date, Date)):
            return value.strftime("%Y-%m-%d")
        elif isinstance(value, (Time, time)):
            return value.strftime("%H:%M:%S")
    else:
        return ""

