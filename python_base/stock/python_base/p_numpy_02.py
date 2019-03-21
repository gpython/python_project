# from functools import reduce

import scipy.stats as scs
import  numpy as np
import matplotlib.pyplot as plt


stock_cnt = 200

view_days = 504

stock_day_change = np.random.standard_normal((stock_cnt, view_days))

def t1():
  stock_mean = stock_day_change[0].mean()

  stock_std = stock_day_change[0].std()

  print("股票0 mean 均值期望值:{:.3f}".format(stock_mean))
  print("股票0 std 振幅标准差:{:.3f}".format(stock_std))

  #绘制股票直方图
  plt.hist(stock_day_change[0], bins=50, density=True)

  fit_linspace = np.linspace(stock_day_change[0].min(), stock_day_change[0].max())
  print(fit_linspace)
  pdf = scs.norm(stock_mean, stock_std).pdf(fit_linspace)

  plt.plot(fit_linspace, pdf, lw=2, c='r')

  plt.show()

  #正太分布的最大特点 即为 他的数据会围绕某个期望均值附近上下摆动 摆动幅度为数据的标准差


def t2():
  keep_days = 50
  #统计 454天中 200只股票的涨跌数据 切片
  stock_day_change_t = stock_day_change[:stock_cnt, :view_days-keep_days]
  #打印出 前454天中跌幅最大的3只股票的 总跌幅通过np.sum() 函数计算
  # np.sort() 函数对结果排序
  print(np.sum(stock_day_change_t[:3], axis=1))
  print(np.sort(np.sum(stock_day_change_t, axis=1))[:3])
  
  #使用np.argsort()函数对股票涨跌幅进行排序 返回序号 即符合买入条件的股票序号
  stock_lower_array = np.argsort(np.sum(stock_day_change_t, axis=1))[:3]
  #3只跌幅最大的股票 前 454日总共下跌幅度 以及3只下跌最大股票的序号
  print(stock_lower_array)
  
  print("*"*60)
  print(stock_day_change[stock_lower_array])
  print(stock_day_change[stock_lower_array].cumsum())
  
  
  for stock_ind in stock_lower_array:
    #设置一行两列的 可视化图表
    _, axs = plt.subplots(nrows=1, ncols=2, figsize=(16,5))
    
    #view_days504 - keep_days50
    #绘制前454天股票走势 np.cumsum() 序列连续求和
    axs[0].plot(np.arange(0, view_days-keep_days), stock_day_change_t[stock_ind].cumsum())
    
    cs_buy = stock_day_change[stock_ind][ view_days-keep_days:view_days].cumsum()
    
    axs[1].plot(np.arange(view_days - keep_days, view_days), cs_buy)
    
    print(cs_buy[-1])
    plt.show()
    
  
  
if __name__ == "__main__":
  t2()
  



