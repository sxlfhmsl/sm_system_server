pip freeze > requirements.txt		生成requirements
pip install -r requirements.txt		安装requirements.txt依赖

# 数据库模型地址
Navicat\Premium\profiles

1. 初始化数据迁移的目录
-m flask db init
​
2. 数据库的数据迁移版本初始化
-m flask db migrate -m 'initial migration'
​
3. 升级版本[创建表]
-m flask db upgrade
​
4. 降级版本[删除表]
-m flask db  downgrade