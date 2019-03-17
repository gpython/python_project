import timeit
import numpy as np
import  random

price = [round(random.uniform(10, 20), 2) for _ in range(20)]
num = [random.randint(1, 10) for _ in range(20)]

def total_sum():
  sum = 0
  for i, j in zip(price, num):
    sum += i*j
  return sum


price_np = np.array(price)
num_np = np.array(num)
total = np.dot(price_np, num_np)

print(total)
