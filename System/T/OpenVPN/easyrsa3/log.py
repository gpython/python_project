#encoding:utf-8
import logging.config

logging.config.dictConfig({
  'version': 1,
  'disable_existing_loggers': True,
  'formatters': {
    'verbose': {
      'format': "[%(asctime)s] %(levelname)s [%(name)s:%(lineno)s] %(message)s",
      'datefmt': "%Y-%m-%d %H:%M:%S"
    },
    'simple': {
      'format': '%(levelname)s %(message)s'
    },
  },
  'handlers': {
    'null': {
      'level': 'DEBUG',
      'class': 'logging.NullHandler',
    },
    'console': {
      'level': 'DEBUG',
      'class': 'logging.StreamHandler',
      'formatter': 'verbose'
    },
    "file_handler": {
      "class": "logging.handlers.RotatingFileHandler",
      "level": "INFO",
      "formatter": "verbose",
      "filename": "/data/logs/openclient.log",
      "maxBytes": 131072000,
      "backupCount": 5,
      "encoding": "utf8"
    }
  },
  'loggers': {
    '': {
      'handlers': ['file_handler'],
      'level': 'INFO',
    },
  },
  "root": {
    "level": "INFO",
    "handlers": ["file_handler"]
  }
})

