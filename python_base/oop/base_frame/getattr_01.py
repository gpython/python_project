class DictObj:
  def __init__(self, d:dict):
    if not isinstance(d, dict):
      self.__dict__["_dict"] = {}
    else:
      self.__dict__["_dict"] = d

  def __getattr__(self, item):
    try:
      return self._dict[item]
    except KeyError:
      raise AttributeError("Attribute {} not found".format(item))

  def __setattr__(self, key, value):
    raise NotImplementedError

d = DictObj({'google':'this is igoogle'})

print(d.google)
print(d.__dict__)