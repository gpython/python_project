#ORM
#1. class => obj
#2. 创建数据库引擎
#3. 将所有class序列化成数据表
#4. ORM 操作


#1. 创建一个class

from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

#Base orm模型基类
#orm模型 obj里边的属性 == table中创建的字段
#       obj定义table的操作方式和属性


from sqlalchemy import  Column, Integer, VARCHAR, String

class Suser(Base):
  __tablename__ = "suser"
  id = Column(Integer, primary_key=True, autoincrement=True)
  name = Column(String(32), index=True)
  
#2 创建数据引擎
from sqlalchemy import create_engine
engine = create_engine("mysql+pymysql://pretty:pretty@192.168.1.99:3306/pretty?charset=utf8")


#3. 将所有继承Base的class序列化成数据表
Base.metadata.create_all(engine)











