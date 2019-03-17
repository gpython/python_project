from abupy import ABuSymbolPd, ABuMarketDrawing
import matplotlib.pyplot as plt
import tushare as ts
import pandas as pd
import numpy as np



tsla_df = ABuSymbolPd.make_kl_df('usTSLA', n_folds=2)

print(tsla_df.tail())
print(tsla_df.keys())
print(tsla_df.columns)
print(tsla_df.index)
print(tsla_df.info())
print(tsla_df.describe())

#配合行名称 获取指定列 数据
print(tsla_df.loc['2017-08-10':'2017-08-30', 'open'])

#loc 不传入列名称 默认获取所有列
print(tsla_df.loc['2018-11-01':'2018-11-30'])

#iloc 配合行索引 列索引数值选取切片
print(tsla_df.iloc[1:5, 2:6])

print(tsla_df.iloc[:, 2:6])

print(tsla_df.iloc[35:37, :])

print(tsla_df.open[:10])

print(tsla_df.close[:10])

print(tsla_df[['open', 'high', 'low', 'close']][:10])

#按行 处理
tsla_df.apply(lambda x: x['close'], axis=1)

#通过 ix 一个一个的拿数据
for K_ind in np.arange(0, tsla_df.shape[0]):
  t = tsla_df.ix[k_ind]
  print(t)

#涨跌幅大于8%的交易日
print(tsla_df[np.abs(tsla_df.p_change)>8][['date', 'open', 'high', 'low', 'close']])


#涨跌幅 大于8% 并且成交量大于均值2.5倍
t = tsla_df[(np.abs(tsla_df.p_change)>8) & (tsla_df.volume > 2.5 * tsla_df.volume.mean()) ]
print(t)

#升序排序 从小到大 涨跌幅前 10
t = tsla_df.sort_index(by='p_change')[:10][['open', 'close', 'p_change', 'volume']]

#降序排序 从大到小 涨跌幅前 10
t = tsla_df.sort_index(by='p_change', ascending=False)[:10][['date', 'open', 'close', 'p_change']]



#pct_change() 函数 对序列 从第二项开始 向前做 减法后再除以前一项
#pct_chnage针对 close价格序列 的操作结果 即是 涨跌幅序列
#np.round() 保留小数点后 位数

t = tsla_df.close.pct_change()[:10]

t = np.round(tsla_df.close[:10].pct_change().fillna(0)*100, 2)

format = lambda x: "%.2f" %(x*100)
tsla_df.close[:10].pct_change().fillna(0).map(format)

tsla_df.p_change.hist(bins=10)
plt.show()


#qcut() 将涨跌幅数据进行平均分类 这里分10份
cats = pd.qcut(np.abs(tsla_df.p_change), 10)
#qcut和value_counts结合使用 直观显示分离结果
cats.value_counts()

#手动 分类准则 使用pd.cut() 传入bins
bins = [-np.inf, -7, -5, -3, 0, 3, 5, 7, np.inf]
cats = pd.cut(tsla_df.p_change, bins)
cats.value_counts()

#pd.get_dummies()  将数据由连续数值类型变成离散类型 即数据离散化
p_change_dummies = pd.get_dummies(cats, prefix="cr_dummies")
p_change_dummies.tail()

#p_change_dummies 表格和 tsls_df 进行合并 concat() 合并函数


tsla_df['positive'] = np.where(tsla_df.p_change > 0, 1, 0)

#构建 交叉表 行date_week信息 列positive
#date_week信息 对应的 positive 的数量总和
xt = pd.crosstab(tsla_df.date_week, tsla_df.positive)

#求出所占比例  pd.crosstab 通常与div配合使用
#统计处某个交易日 交易的胜率
#最大的胜率的一天
#只要从不同的市场 不同股票 不同时间段内找到足够多的交易机会
#执行足够多的次数 最后一定盈利 统计套利的核心思想
xt_pct = xt.div(xt.sum(1).astype(float), axis=0)

#构建 透视表 pivot_table()
#date_week 对应的positive=1的 占比
tsla_df.pivot_table(['positive'], index=['date_week'])

tsla_df.groupby(['date_week', 'positive'])['positive'].count()


xt_pct.plot(
  figsize = (8, 5),
  kind = 'bar',
  stacked = True,
  title = "date_week -> positive"
)

plt.xlabel('date_week')
plt.ylabel('positive')

plt.show()










# tsla_df[['close', 'volume']].plot(subplots=True, style=['r', 'g'], grid=True)

# df = ts.get_hist_data("000001")
# print(df)
# print(df.index)
# print(df.tail())
# print(df.head())

