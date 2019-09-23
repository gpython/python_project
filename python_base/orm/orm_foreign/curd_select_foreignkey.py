from python_base.orm.orm_foreign.create_table_Foreignkey import engine, Student, School
from sqlalchemy.orm import sessionmaker

Session = sessionmaker(engine)
session = Session()

sch_obj = session.query(School).filter(School.name=="LINUX").first()
print(sch_obj.students)

for obj in sch_obj.students:
  print(obj.id, obj.name, obj.school.name)
  
  
stu_obj = session.query(Student).filter(Student.id==2).first()
print(stu_obj.school)
print(stu_obj.school.id, stu_obj.school.name)