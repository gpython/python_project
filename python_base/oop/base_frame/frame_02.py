import re
from wsgiref.simple_server import make_server

from webob import dec, exc, Response, Request


class Router:
  def __init__(self, prefix:str=""):
    self.__prefix = prefix
    self.__routetable = []

  def route(self, pattern, *methods):
    def wrapper(handler):
      uri = (methods, re.compile(pattern), handler)
      print("uri: ", uri)
      self.__routetable.append(uri)
      return handler
    return wrapper

  def get(self, pattern):
    return self.route(pattern, "GET")

  def post(self, pattern):
    return self.route(pattern, "POST")

  def match(self, request:Request):
    if not request.path.startswith(self.__prefix):
      return

    for methods, pattern, handler in self.__routetable:
      if not methods or request.method.upper() in methods:
        matcher = pattern.match(request.path.replace(self.__prefix, "", 1))
        if matcher:
          request.kwargs = matcher.groupdict()
          return handler(request)

class App:
  ROUTERS = []
  @classmethod
  def register(cls, router:Router):
    cls.ROUTERS.append(router)

  @dec.wsgify
  def __call__(self, request:Request):
    for router in self.ROUTERS:
      response = router.match(request)
      return response
    raise exc.HTTPNotFound("bno")

idx = Router("/book")
App.register(idx)

@idx.get("^/$")
def index(request:Request):
  res = Response()
  res.body = "index".encode()
  return res

if __name__ == "__main__":
  ip = '127.0.0.1'
  port = 9999
  server = make_server(ip, port, App())
  server.serve_forever()
  server.server_close()


