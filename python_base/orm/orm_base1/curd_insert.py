#1 选中数据库 创建数据库引擎 导入数据库引擎
#2 创建查询窗口 必须是选中的数据库窗口
#3 创建sql语句
#4 点击运行

#1 选中数据库 创建数据库引擎 导入数据库引擎
from python_base.orm.orm_base1.create_table import engine

#2 创建查询窗口 必须是选中数据库的查询窗口
from sqlalchemy.orm import sessionmaker
Session_window = sessionmaker(engine)

#打开查询窗口
db_session = Session_window()

#3 创建sql语句
# 增加数据 创建sql语句
#insert into table(suser) values("google")

# from python_base.orm.orm_base1.create_table import Suser
#
# # 创建sql语句
# user_obj = Suser(name="google")
#
# print(user_obj)
#
# #将sql语句粘贴到查询窗口
# db_session.add(user_obj)
#
# #执行全部的sql语句
# db_session.commit()
#
# #关闭窗口
# db_session.close()


from python_base.orm.orm_base1.create_table import Suser
user_obj_list= [Suser(name='yahpoo'), Suser(name="python")]
db_session.add_all(user_obj_list)

db_session.commit()
db_session.close()
