#encoding:utf-8
from flask import Flask
# from flask_cache import Cache
from config import config
# from utils.setting import RedisCache

# cache = Cache(config=RedisCache)

def create_app(config_name):
  app = Flask(__name__)
  app.config.from_object(config[config_name])
  config[config_name].init_app(app)

  # cache.init_app(app)

  from .api import api as api_blueprint

  app.register_blueprint(api_blueprint, url_prefix='/api')

  return app
