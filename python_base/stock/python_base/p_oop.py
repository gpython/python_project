import itertools
from abc import ABCMeta, abstractmethod
from collections import namedtuple, OrderedDict
from functools import reduce


class StockTradeDay(object):
  def __init__(self, price_array, start_date, date_array=None):
    #
    self.__price_array = price_array
    #
    self.__date_array = self._init_days(start_date, date_array)
    #
    self.__change_array = self.__init_change()
    #
    self.stock_dict = self._init_stock_dict()
    
  def __init_change(self):
    price_float_array = [float(price_str) for price_str in self.__price_array]
    
    pp_array = [(price1, price2) for price1, price2 in zip(price_float_array[:-1], price_float_array[1:])]
    
    change_array = list(map(lambda pp: reduce(lambda a, b: round((a-b)/a, 3), pp),  pp_array))
    
    change_array.insert(0, 0)
    
    return change_array
  
  def _init_days(self, start_date, date_array):
    if date_array is None:
      date_array = [str(start_date + ind) for ind, _ in enumerate(self.__price_array)]
      
    else:
      date_array = [str(date) for date in date_array]
    
    return date_array
  
  def _init_stock_dict(self):
    stock_namedtuple = namedtuple("stock", ("date", "price", "change"))
    
    stock_dict = OrderedDict(
      (date, stock_namedtuple(date, price, change))
      for date, price, change in zip(self.__date_array, self.__price_array, self.__change_array)
    )
    
    return stock_dict
  
  def filter_stock(self, want_up=True, want_calc_sum=False):
    filter_func = (lambda p_day: p_day.change>0) if want_up else(lambda p_day: p_day.change<0)
    
    want_days = list(filter(filter_func, self.stock_dict.values()))
    
    if not want_calc_sum:
      return want_days
    
    change_sum = 0.0
    for day in want_days:
      change_sum += day.change
    return change_sum
    
  def __str__(self):
    return str(self.stock_dict)
  
  __repr__ = __str__
  
  def __iter__(self):
    for key in self.stock_dict:
      yield self.stock_dict[key]

  def __getitem__(self, item):
    date_key = self.__date_array[item]
    return self.stock_dict[date_key]
  
  def __len__(self):
    return len(self.stock_dict)
  
    
price_array = ["30.14", "29.58", "26.36", "32.56", "32.82"]
s = StockTradeDay(price_array, 20190301)
print(s)
print(s[1])
print(s.filter_stock())
for i in s:
  print(i)

    
class TradeStrategyBase(metaclass=ABCMeta):
  @abstractmethod
  def buy_strategy(self, *args, **kwargs):
    pass
  
  @abstractmethod
  def sell_strategy(self, *args, **kwargs):
    pass
  
class TradeStrategy1(TradeStrategyBase):
  #
  s_keep_stock_threshold = 20
  
  def __init__(self):
    self.keep_stock_day = 0
    
    self.__buy_change_threshold = 0.07
    
  def buy_strategy(self, trade_ind, trade_day, trade_days):
    if self.keep_stock_day == 0 and trade_day.change > self.__buy_change_threshold:
      self.keep_stock_day += 1
      
    elif self.keep_stock_day > 0:
      self.keep_stock_day += 1
  
  def sell_strategy(self, trade_ind, trade_day, trade_days):
    if self.keep_stock_day > TradeStrategy1.s_keep_stock_threshold:
      self.keep_stock_day = 0
  
  @property
  def buy_change_threshold(self):
    return self.__buy_change_threshold
  
  @buy_change_threshold.setter
  def buy_change_threshold(self, buy_change_threshold):
    if not isinstance(buy_change_threshold, float):
      raise TypeError("buy_change_threshold must be float!")
    self.__buy_change_threshold = round(buy_change_threshold, 2)
    
class TradeLoopBack(object):
  def __init__(self, trade_days, trade_strategy):
    self.trade_days = trade_days
    self.trade_strategy = trade_strategy
    self.profit_array = []
    
  def execute_trade(self):
    for ind, day in enumerate(self.trade_days):
      if self.trade_strategy.keep_stock_day > 0:
        self.profit_array.append(day.change)
      
      
      if hasattr(self.trade_strategy, "buy_strategy"):
        self.trade_strategy.buy_strategy(ind, day, self.trade_days)
        
      if hasattr(self.trade_strategy, "sell_strategy"):
        self.trade_strategy.sell_strategy(ind, day, self.trade_days)
 
 
class TradeStrategy2(TradeStrategyBase):
  s_keep_stock_threshold = 10
  s_buy_change_threshold = -0.10
  
  def __init__(self):
    self.keep_stock_day = 0
    
  def buy_strategy(self, trade_ind, trade_day, trade_days):
    if self.keep_stock_day == 0 and trade_ind >= 1:
      today_down = trade_day.change < 0
      yesterday_down = trade_days[trade_ind -1].change < 0
      down_rate = trade_day.change + trade_days[trade_ind-1].change
      
      if today_down and yesterday_down and down_rate < TradeStrategy2.s_buy_change_threshold:
        self.keep_stock_day += 1
        
      elif self.keep_stock_day > 0:
        self.keep_stock_day += 1
      
  
  def sell_strategy(self, trade_ind, trade_day, trade_days):
    if self.keep_stock_day >= TradeStrategy2.s_keep_stock_threshold:
      self.keep_stock_day = 0
        
    
  @classmethod
  def set_keep_stock_threshold(cls, keep_stock_threshold):
    cls.s_keep_stock_threshold = keep_stock_threshold
    
  @staticmethod
  def set_buy_change_threshold(buy_change_threashold):
    TradeStrategy2.s_buy_change_threshold = buy_change_threashold


def calc(keep_stock_threshold, buy_change_threshold):
  """
  :param keep_stock_threshold: 持股天数
  :param buy_change_threshold: 下跌买入阈值
  :return: 盈亏情况 输入的持股天数 输入的下跌买入阈值
  """
  
  trade_strategy2 = TradeStrategy2()
  TradeStrategy2.set_buy_change_threshold(buy_change_threshold)
  TradeStrategy2.set_keep_stock_threshold(keep_stock_threshold)
  
  trade_loop_back = TradeLoopBack(g_trade_days, trade_strategy2)
  trade_loop_back.execute_trade()
  
  profit = 0.0 if len(trade_loop_back.profit_array) == 0 else reduce(lambda a, b: a+b, trade_loop_back.profit_array)
  
  return profit, keep_stock_threshold, buy_change_threshold


keep_stock_list = list(range(2,30, 2))
buy_change_list = [buy_change/100.0 for buy_change in range(-5, -16, -1)]

result = []

for keep_stock_threshold, buy_change_threshold in itertools.product(keep_stock_list, buy_change_list):
  result.append(calc(keep_stock_list, buy_change_threshold))

print(sort(result)[::-1][:10])
    

#####
keep_stock_list = list(range(2, 30, 2))

buy_change_list = [buy_change/100.0 for buy_change in xrange(-1, -100, -1)]

result = []

def when_done(r):
  result.append(r.result())

with ProcessPoolExecutor() as pool:
  for keep_stock_threshold, buy_change_threshold in itertools.product(keep_stock_list, buy_change_threshold):
    future_result = pool.submit(calc, keep_stock_threshold, buy_change_threshold)
    future_result.add_done_callback(when_done)

result = []

def when_done(r):
  result.append(r.result())
  
with ThreadPoolExecutor(max_workers=8) as pool:
  for keep_stock_threshold, buy_change_threshold in itertools.product(keep_stock_list, buy_change_threshold):
    future_result = pool.submit(calc, keep_stock_threshold, buy_change_threshold)
    future_result.add_done_callback(when_done)
    
   
    
keep_stock_list = range(1,504, 1)
buy_change_list = [buy_change/100.0 for buy_change in range(-1, -100, -1)]
def do_single_task():
  task_list = list(itertools.product(keep_stock_list, buy_change_list))
  for keep_stock_threshold, buy_change_threshold in task_list:
    calc(keep_stock_threshold, buy_change_threshold)

import numba as nb
do_single_task_nb = nb.jit(do_single_task)
do_single_task_nb()
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
  
  
  