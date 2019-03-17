from abupy import  ABuSymbolPd
import  numpy as np
import  pandas as pd
import matplotlib.pyplot as plt
from abupy.MarketBu import ABuMarketDrawing

tsla_df = ABuSymbolPd.make_kl_df('usTSLA', n_folds=2)


jump_pd = pd.DataFrame()
#统计周期内收盘价格中位数 乘以 3%
jump_threshold = tsla_df.close.median()*0.03

def judge_jump(today):
  global jump_pd
  #当天收盘 上涨 涨幅大于0 最低价与昨日收盘价之差 大于 跳空阈值 周期内收盘价中位数×3%
  if today.p_change > 0 and (today.low - today.pre_close) > jump_threshold:
    #向上跳空
    #记录jump方向 1 向上
    today['jump'] = 1
    #向上跳能量 = (今天最低 - 昨收)/跳空阈值
    today['jump_power'] = (today.low - today.pre_close) / jump_threshold
    jump_pd = jump_pd.append(today)
  
  #当天手收盘 下跌 昨日收盘价与今日最高价 之差 大于 跳空阈值
  elif today.p_change < 0 and (today.pre_close - today.high) > jump_threshold:
    #向下跳空
    today['jump'] = -1
    #向下跳空能量 = (昨收盘价 - 今天最高价) / 跳空阈值
    today['jump_power'] = (today.pre_close - today.high) / jump_threshold
    jump_pd = jump_pd.append(today)
    

# for k1_index in np.arange(0, tsla_df.shape[0]):
#   #ix 一个一个的取值
#   today = tsla_df.ix[k1_index]
#   judge_jump(today)

tsla_df.apply(judge_jump, axis=1)


print(jump_pd)
print(jump_pd[['jump', 'jump_power', 'close', 'date']])
print(jump_pd.filter(['jump', 'jump_power', 'close', 'date', 'p_change', 'pre_close']))

ABuMarketDrawing.plot_candle_form_klpd(tsla_df, view_indexs=jump_pd.index)