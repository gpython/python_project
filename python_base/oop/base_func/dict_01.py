#encoding:utf-8
source = {'a':{'b':1, 'c':2}, 'd':{'e':3, 'f':{'g':4}}}
# target = {}

# def flatmap(src, prefix=''):
#   for k, v in src.items():
#     if isinstance(v, (list, tuple,set, dict)):
#       flatmap(v, prefix=prefix+'.')
#     else:
#       target[prefix+k] = v
#
# flatmap(source)
# print(target)


######
def flatmap(src):
  def _flatmap(src, dst=None, prefix='.'):
    for k, v in src.items():
      key = prefix + k
      if isinstance(v, (list, tuple, dict, set)):
        _flatmap(v, dst, key+'.')
      else:
        dst[key] = v

  dst = {}
  _flatmap(src, dst)
  return dst

print(flatmap(source))

