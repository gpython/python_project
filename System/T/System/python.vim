pdb
l => list 显示当前代码
n => next 向下执行一行代码
c => continue 继续执行代码
b => breakpoint 添加断点
clear  删除断点
p => print 打印一个变量值
s => step  进入到一个函数
a => args  打印所有形参数据
q => quit  退出调试
r => return  快速执行到函数的最后一行



from multiprocessing import Pool

#进程池中最多有三个进程一起执行
pool = Pool(3)
#向进程池添加任务
#如果添加的任务数量超过了进程池中进程个数 那么不会导致添加不进去
#添加到进程中的任务 如果还没有被执行的话 那么此时 他们会等待进程池中的
#进程完成一个任务后 会自动的去用刚刚的那个进程 完成当前新任务
pool.apply_async(func, (args,))

#关闭进程池 相当于 不能再次添加新任务了
pool.close()

#主进程 创建/添加任务后 主进程默认不会等待进程池中的任务执行完成后结束
#而是当主进程中的任务做完之后 立马结束
#如果这个地方没有join 会导致进程池中的任务不会执行
pool.join()

#进程中通信
from multiprocessing import Queue

#进程池间通信
#from multiprocessing impor Manager, Pool

Queue.qsize()
Queue.empty()
Queue.full()
Queue.get()



线程
 全局变量是共享的 所有线程共享一份
 函数里的代码变量不是共享的 各个线程独享一份
