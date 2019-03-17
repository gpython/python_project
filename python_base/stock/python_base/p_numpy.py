import numpy as np
import matplotlib.pyplot as plt

stock_cnt = 200

view_days = 504

#生成服从正态分布 均值期望0 标准差1 的序列
#200行 504列的序列
stock_day_change = np.random.standard_normal((stock_cnt, view_days))

print(stock_day_change.shape)
#选取前几只股票的 的 多少列 数据显示
print(stock_day_change[0:5, :5])
#选取最后两只股票 的 最后5个交易日的涨跌幅数据
print(stock_day_change[-2:, -5:])

#类型转换
x = stock_day_change[-2:, -5:].astype(int)
print(x)
print(stock_day_change[-2:, -5:])

#保留指定位数的小数
y = np.around(stock_day_change[-2:, -5:], 3)
print(y)
print(stock_day_change[-2:, -5:])

tmp = stock_day_change[-2:, -5:].copy()
tmp[0][0] = np.nan
print(tmp)

#nan_to_num 函数用0 来填充na
#pandas中 dropna()和fillna() 方式更适合na处理
print(np.nan_to_num(tmp))

mask = stock_day_change[-2:, -5:] > 0.5
print(mask)

print(stock_day_change[-2:, -5:][stock_day_change[-2:, -5:]>0.5])
###
print("*"*60)
tmp = stock_day_change[-2:, -10:]
print(tmp[tmp>0.3])

#np.all()
np.all(stock_day_change[-2:, -5:]>0)

#np.any()
np.any(stock_day_change[-2:, -5:]>0)

print("*"*60)
print(stock_day_change[:2, :5])
print(stock_day_change[-2:, -5:])

#两个序列 对应元素 两两比较 结果集取最大 minimun 结果集取最小
print(np.maximum(stock_day_change[:2, :5], stock_day_change[-2:, -5:]))

#np.unique
change_int= stock_day_change[:2, :5].astype(int)
print(np.unique(change_int))

print("*"*60)
#diff执行操作是前后两个临近数值进行减法运算
#axis=1横向 后一个减去前一个
#axis=0纵向 下一个减去上一个
print(stock_day_change[:2, :5])
print(np.diff(stock_day_change[:2, :5], axis=1))
print(np.diff(stock_day_change[:3, :5], axis=0))

print("*"*60)
#np.where 三目条件预算符
#np.logical_and np.logical_or
print(stock_day_change[:2, :5])
tmp = stock_day_change[:2, :5]
print(np.where(tmp>0.5, 1, 0))
print(np.where(tmp>0.5, 1, tmp))

print(np.where(np.logical_and(tmp>0.5, tmp<1), 1, 0))
print(np.where(np.logical_or(tmp>0.5, tmp<-0.5), 1, 0))

#数据本地序列化 save内部自动生成.npy后缀的文件
# np.save("./gen/stock_day_change", stock_day_change)

#读取 使用np.load函数即可 注意文件名后要加上.npy
# stock_day_change = np.load("./gen/stock_day_change.npy")
# print(stock_day_change.shape)

#
print("*"*60)
stock_day_change_four = np.around(stock_day_change[:4, :5], 3)
print(stock_day_change_four)
print(np.max(stock_day_change_four, axis=1))

print("最大跌幅 {}".format(np.min(stock_day_change_four, axis=1)))
print("振幅幅度 {}".format(np.std(stock_day_change_four, axis=1)))
print("平均涨跌 {}".format(np.mean(stock_day_change_four, axis=1)))


#mean 期望值 平均值大小
#方差 衡量一组数据的离散程度
#标准差 为方差的算术平方根   振幅

#正态分布 数据的标准差越大 数据分布离散程度越大
#对于正态分布 数据的期望位于曲线的对称轴中心

print(stock_day_change[0].mean())

a_investor = np.random.normal(loc=100, scale=50, size=(100, 1))
b_investor = np.random.normal(loc=100, scale=20, size=(100, 1))

print("a交易者期望{0:.2f} 标准差{1:.2f} 方差{2:.2f}".format(
  a_investor.mean(), a_investor.std(), a_investor.var()
))
print("b交易者期望{0:.2f} 标准差{1:.2f} 方差{2:.2f}".format(
  b_investor.mean(), b_investor.std(), b_investor.var()
))

########
# a_mean = a_investor.mean()
# a_std = a_investor.std()
# plt.plot(a_investor)
# plt.axhline(a_mean+a_std, color="r")
# plt.axhline(a_mean, color="y")
# plt.axhline(a_mean-a_std, color="g")
# plt.show()


#单行 多行 取某几列 数值 序列 注意
x = np.arange(100).reshape(10, 10)
#单行 某几列数值 序列
print(x[4][3:5])
#不同多行 某几列数值 序列
print(x[[4,6,7]][:, 3:5])

#np.argmax() 纵向寻找 哪一只股票在某个交易日涨幅最大