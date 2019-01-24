#encoding:utf-8

class Car:
  def __init__(self, mark, speed, color, price):
    self.mark = mark
    self.speed = speed
    self.color = color
    self.price = price


class CarInfo:
  def __init__(self):
    self.lst = []

  def addCar(self, car:Car):
    self.lst.append(car)

  def getall(self):
    return self.lst

ci = CarInfo()
car = Car('bwm', 400, 'black', 100)
ci.addCar(car)

ci.getall()