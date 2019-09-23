#delete from table where id=1

#
from python_base.orm.orm_base1.create_table import engine, Suser
from sqlalchemy.orm import  sessionmaker

Session = sessionmaker(engine)
session = Session()

#

user_delete_obj = session.query(Suser).filter(Suser.id==3).delete()
print(user_delete_obj)
session.commit()