##StringIO

- 时间
    - 时间戳 datetime.datetime.now().timestamp()
    - 花费时间间隔 
    
    ```python
    import datetime
    start = datetime.datetime.now()
    delta = (datetime.datetime.now() - start).total_seconds()
   ``` 

- sorted 排序函数
- zip

- io模块中的类
    - from io import StringIO
    - 内存中 开辟一个文本模式的buffer 可以像文件对象一样操作它
    - 当close方法被调用的时候 这个buffer会被释放
    - 减少磁盘IO过程 在内存中操作
```python
#getvalue()获取全部内容 根文件指针没有关系 
#一次读取所有内容 输出 不关心seek位置

from io import StringIO, BytesIO
#内存中构建 sio像文件一样操作
sio = StringIO()
#sio = BytesIO()

print(sio.readable(), sio.writable(), sio.seekable())

sio.write("Hello\nworld")

sio.seek(0)
print(sio.readline())
print(sio.getvalue()) #无视指针 输出全部内容

sio.close()
```

- BytesIO
    - from io import BytesIO
    - 内存中开辟一个二进制模式的buffer 可以像文件对象一样操作他
    - 当close方法调用时 这个buffer被释放