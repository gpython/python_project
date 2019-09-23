from sqlalchemy.orm import sessionmaker
from python_base.orm.orm_foreign.create_table_Foreignkey import engine, School, Student

Session = sessionmaker(engine)
session = Session()

#增加数据
# sch_obj = School(name="YAHOO")
# session.add(sch_obj)
# session.commit()
#
# print(sch_obj.id)
#
# stu_obj = Student(name="Gxxxoxox", school_id=sch_obj.id)
# session.add(stu_obj)
# session.commit()

#正向添加
stu_obj = Student(name="676f5", school=School(name="GOOGLE"))
session.add(stu_obj)
session.commit()

#反向添加
sch_obj = School(name="LINUX")
sch_obj.students = [Student(name="Linuxxxxx"), Student(name="opppppp")]
session.add(sch_obj)
session.commit()