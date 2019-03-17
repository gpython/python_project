#np.argmax() 纵向寻找某一直股票在某个交易日涨幅最大 数字序列 寻找对应股票

#pandas  DataFrames Series

import  numpy as np
import pandas as pd
import  matplotlib.pyplot as plt

stock_cnt = 200
view_days = 504

stock_day_change = np.random.standard_normal((stock_cnt, view_days))

df = pd.DataFrame(stock_day_change)

print(df.head())
print(df.head(5))
print(df[:5])


stock_symbols = ["Stock"+ str(x) for x in range(stock_day_change.shape[0])]
days = pd.date_range("2017-01-01", periods=stock_day_change.shape[1], freq="1d")
df = pd.DataFrame(stock_day_change, index=stock_symbols, columns=days)
# print(df)
print(df.head(10))

#行列索引转制 df.T
df = df.T

#对df进行重新采样 以21天为周期 对21天内的时间求平均值
df_20 = df.resample("21D").mean()

print(df_20)
df_stock_0 = df_20["Stock0"]
print(type(df_stock_0))
df_stock_0_3 = df_20[["Stock0", "Stock3"]]
print(type(df_stock_0_3))
# print(df_20[["Stock0", "Stock3"]])

#Series类型 可以理解为Series是 只有一列数据 的DataFrame对象


# df_stock_0.cumsum().plot()
# plt.show()

print(df["Stock0"].cumsum())
# df["Stock0"].cumsum().plot()
# plt.show()


df_stock0 = df["Stock0"]
#以5天为周期 重新采样 open high low close 值
df_stock0_5 = df_stock0.cumsum().resample("5D").ohlc()
#以21天为周期 采样 月K
df_stock0_21 = df_stock_0.cumsum().resample('21D').ohlc()

print(df_stock0_21.head())
print(df_stock0_21['open'].values)
print(df_stock0_21['high'].values)
print(df_stock0_21['low'].values)
print(df_stock0_21['close'].values)

#
from abupy import ABuMarketDrawing
ABuMarketDrawing.plot_candle_form_klpd(
  df_stock0_5.index,
  df_stock0_5['open'].values,
  df_stock0_5['high'].values,
  df_stock0_5['low'].values,
  df_stock0_5['close'].values,
  np.random.random(len(df_stock0_5)),
  None, "Stock", days_sum=False, html_bk=False, save=False
)


#pct_change() 函数对序列 从第二项 开始 向前做 减法 后再 除以 前一项
