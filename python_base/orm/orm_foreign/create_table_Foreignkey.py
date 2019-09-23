from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import create_engine
from sqlalchemy import Column, Integer, VARCHAR, ForeignKey
from sqlalchemy.orm import relationship


#创建引擎
engine = create_engine("mysql+pymysql://pretty:pretty@192.168.1.99:3306/pretty?charset=utf8")

#模型基类
Base = declarative_base()

class Student(Base):
  __tablename__ = "student"
  id = Column(Integer, primary_key=True)
  name = Column(VARCHAR(32))
  school_id = Column(Integer, ForeignKey("school.id"))
  school = relationship("School", backref="students")
 
class School(Base):
  __tablename__ = "school"
  id = Column(Integer, primary_key=True)
  name = Column(VARCHAR(32))
  
  
#连接引擎 创建所有的表
Base.metadata.create_all(engine)
#Base.metadata.drop_all(engine)

  

