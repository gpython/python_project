#update table set name=123 where id=1;

#创建查询窗口

from python_base.orm.orm_base1.create_table import engine, Suser
from sqlalchemy.orm import sessionmaker

Session = sessionmaker(engine)
session = Session()


#更新
user_obj = session.query(Suser).filter(Suser.id>2).update({"name":"xxxxxxxx"})
print(user_obj)
session.commit()


user_obj = session.query(Suser).filter(Suser.id == 1).update({"name":"yyyyyyyyy"})
print(user_obj)
session.commit()
