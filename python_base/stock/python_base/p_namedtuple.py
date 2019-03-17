from collections import namedtuple
from collections import OrderedDict
from functools import reduce, partial

date_array = ["20180301", "20190302", "20190303", "20190304", "20190305"]
price_array = [30.14, 29.58, 26.36, 32.56, 32.82]

stock_namedtuple = namedtuple("stock", ("date", "price"))

stock_namedtuple_list = [stock_namedtuple(date, price) for date, price in zip(date_array, price_array)]

print(stock_namedtuple_list)
print(stock_namedtuple_list[1].price)
print(stock_namedtuple_list[1].date)

stock_dict = OrderedDict((date, price) for date, price in zip(date_array, price_array))
print(stock_dict.keys())
print(stock_dict.values())
print(stock_dict)
print(max(zip(price_array, date_array)))


def find_second_max(stock_dict):
  stock_prices_sorted = sorted(zip(stock_dict.values(), stock_dict.keys()))
  return stock_prices_sorted[-2]

if callable(find_second_max):
  print(find_second_max(stock_dict))
  

######
find_second_max_lambda = lambda dict_array: sorted(zip(dict_array.values(), dict_array.keys()))[-2]
print(find_second_max_lambda(stock_dict))

"""
price_float_array = [float(price_str) for price_str in stock_dict.values()]


pp_array = [(price1, price2) for price1, price2 in zip(price_float_array[:-1], price_float_array[1:])]
print(pp_array)

####
change_array = list(map(lambda pp: reduce(lambda a, b: round((b-a)/a, 3), pp), pp_array))
print("*"*60)
x = list(map(lambda x: reduce(lambda a,b: round((b-a)/a, 3), x), pp_array))
print(x)

change_array.insert(0, 0)
print(change_array)

#涨跌幅
stock_namedtuple = namedtuple('stock', ('date', 'price', 'change'))
stock_dict = OrderedDict(
  (date, stock_namedtuple(date, price, change))
  for date, price, change in zip(date_array, price_array, change_array)
)
print(stock_dict)

up_days = filter(lambda day: day.change>0, stock_dict.values())
print(up_days)


print(stock_dict)
"""
price_float_array = [float(price_str) for price_str in stock_dict.values()]
pp_array = [(price1, price2) for price1, price2 in zip(price_float_array[:-1], price_float_array[1:])]
change_array = list(map(lambda pp: reduce(lambda a, b: round((a-b)/a, 3), pp), pp_array))
stock_namedtuple = namedtuple("stock", ("date", "price", "change"))
stock_dict = OrderedDict(
  (date, stock_namedtuple(date, price, change))
  for date, price, change, in zip(date_array, price_array, change_array)
)
print(stock_dict)
print(stock_dict.keys())
print(stock_dict.values())


######
def filter_stock(stock_array_dict, want_up=True, want_calc_sum=False):
  if not isinstance(stock_array_dict, OrderedDict):
    raise TypeError("stock_array_dict must be OrderedDict")
  
  filter_func = (lambda p_day: p_day.change>0) if want_up else(lambda p_day: p_day.change < 0)
  
  want_days = list(filter(filter_func, stock_array_dict.values()))
  
  if not want_calc_sum:
    return want_days
  
  change_sum = 0.0
  for day in want_days:
    change_sum += day.change
  return change_sum

d = filter_stock(stock_dict)
print("*"*70)
print(d)
d = filter_stock(stock_dict, want_up=False)
d = filter_stock(stock_dict, want_calc_sum=True)
d = filter_stock(stock_dict, want_up=False, want_calc_sum=True)
print(d)

filter_stock_up_days = partial(filter_stock, want_up=True, want_calc_sum=False)
filter_stock_down_days = partial(filter_stock, want_up=False, want_calc_sum=False)
filter_stock_down_sums = partial(filter_stock, want_up=False, want_calc_sum=True)
filter_stock_up_sums = partial(filter_stock, want_up=True, want_calc_sum=True)

d = filter_stock_down_sums(stock_dict)
d = filter_stock_up_days(stock_dict)
d = filter_stock_up_sums(stock_dict)
