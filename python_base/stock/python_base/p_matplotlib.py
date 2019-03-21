import  matplotlib as mpl
import numpy as np
import matplotlib.pyplot as plt

# y = np.random.standard_normal(20)
y = np.arange(20, 40)
# x = range(len(y))
# print(y)
# print(x)

# plt.plot(x, y)
# plt.show()

# plt.plot(y.cumsum())
# plt.grid(True)
# plt.axis('tight')
# plt.show()


# plt.plot(x, y.cumsum())
# plt.grid(True)
# plt.xlim(-1, 20)
# plt.ylim( np.min(y.cumsum())-10, np.max(y.cumsum())+10 )
# plt.show()


# plt.figure(figsize=(7,4))
# #蓝线 线宽1.5
# plt.plot(y.cumsum(), 'b', lw=1.5)
# #线 数据点 红点
# plt.plot(y.cumsum(), 'ro')
# #网格
# plt.grid(True)
# plt.axis('tight')
# plt.xlabel('index')
# plt.ylabel('value')
# plt.title('A simple plot')
# plt.show()

y = np.random.standard_normal((20, 2)).cumsum(axis=0)
print(y)

# plt.figure(figsize=(10, 10))
# plt.plot(y, lw=1.5)
# plt.plot(y, 'ro')
#
# plt.grid(True)
# plt.axis('tight')
#
# plt.xlabel('index')
# plt.ylabel('value')
# plt.title('A simple Plot')
# plt.show()

# plt.figure(figsize=(10, 10))
# plt.plot(y[:, 0], lw=1.5, label='1st')
# plt.plot(y[:, 1], lw=1.5, label='2nd')
# plt.plot(y, 'ro')
# #网格
# plt.grid(True)
# plt.axis('tight')
# #注释
# plt.legend(loc=0)
#
# plt.xlabel('index')
# plt.ylabel('value')
# plt.title('A Simple Plot')
# plt.show()

plt.figure(figsize=(10,10))
plt.hist(y, label=['1st', '2nd'], bins=25)

plt.grid(True)
plt.legend(loc=0)

plt.xlabel('value')
plt.ylabel('frequency')
plt.title('Histogram')
plt.show()