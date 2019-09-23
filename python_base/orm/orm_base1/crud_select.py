# select * from table;

#创建查询窗口
from python_base.orm.orm_base1.create_table import engine, Suser
from sqlalchemy.orm import sessionmaker

Session = sessionmaker(engine)
session = Session()

#查询数据

user_obj = session.query(Suser).first()
print(user_obj)
print(user_obj.id, user_obj.name)

#list
user_obj_list = session.query(Suser).all()
print(user_obj_list)
for obj in user_obj_list:
  print(obj.id, obj.name)
  
#条件筛选 filter(表达式)
user_obj_list = session.query(Suser).filter(Suser.id<=2).all()
print(user_obj_list)
for obj in user_obj_list:
  print(obj.id, obj.name)
  
user_obj_list = session.query(Suser).filter(Suser.id<=2, Suser.name == "googl").all()
print(user_obj_list)
for obj in user_obj_list:
  print(obj.id, obj.name)
  
#filter_by
user_obj_list = session.query(Suser).filter_by(id=1, name="googl").all()
print(user_obj_list)
for obj in user_obj_list:
  print(obj.id, obj.name)