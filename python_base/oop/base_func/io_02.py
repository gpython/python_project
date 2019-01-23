#encoding:utf-8

#getvalue()获取全部内容 根文件指针没有关系
#一次读取所有内容 输出 不关心seek位置

from io import StringIO
#内存中构建 sio像文件一样操作
sio = StringIO()

print(sio.readable(), sio.writable(), sio.seekable())

sio.write("Hello\nworld")

sio.seek(0)
print(sio.readline())
print(sio.getvalue()) #无视指针 输出全部内容

sio.close()
