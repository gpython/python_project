from webob import Response, Request, dec, exc
from wsgiref.simple_server import make_server
import re

class Application:
  ROUTEABLE = []

  @classmethod
  def route(cls, pattern, *methods):
    def wrapper(handler):
      cls.ROUTEABLE.append(methods, re.compile(pattern), handler)
      return handler
    return wrapper

  @classmethod
  def get(cls, pattern):
    return cls.route("GET", pattern)

  @classmethod
  def post(cls, pattern):
    return cls.route("POST", pattern)

  @classmethod
  def head(cls, pattern):
    return cls.route("HEAD", pattern)

  @dec.wsgify
  def __call__(self, request:Request) -> Response:
    for methods, pattern, handler in self.ROUTEABLE:
      if not methods or request.method.upper() in methods:
        matcher = pattern.match(request.path)
        if matcher:
          return handler(request)
    raise exc.HTTPNotFound("not found")

@Application.get("^/$")
def index(request:Request):
  res = Response()
  res.body = "<h1>Hello Index</h1>".encode()
  return res

@Application.post("/python")
def showpython(request:Request):
  res = Response()
  res.body = "<h1>Hello Python Post</h1>".decode()
  return res

if __name__ == '__main__':
  ip = '127.0.0.1'
  port = 9999
  server = make_server(ip, port, Application())
  try:
    server.serve_forever()
  except KeyboardInterrupt:
    pass
  finally:
    server.shutdown()


