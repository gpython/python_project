pip install jupyter
jupyther notebook

创建ndarray np.array()
ndarray还可以是多维数组  但是元素类型必须相同

T 数组转制 高维数组而言
dtype 数组元素类型
size 数组元素个数
ndim 数组维数
shape 数组维度大小 元组形式

astype() 类型转换 'int32' 'float32'
a = numpy.arange(100)
a = numpy.array([[1,2,3,4,5], [6,7,8,9,10]])
a.stype
a.zise
a.shape
a.T


array() 将列表转换为数组 可选择显示指定dtype
arange() range的numpy版 支持浮点数
linspace 类似于arange() 第三个参数为 数组长度
zeros() 根据指定形状和dtype创建全0的数组
ones() 根据指定形状和dtype创建全1的数组
empty() 根据指定的形状和dtype创建空数组
eye() 根据指定的边长和dtype创建单位矩阵


data = np.arange(15).reshape(3,5)
data[2,3]   #取第二行三列值 逗号左边表示行 右边表示列
data[2:]    #取第二行以后行
data[1:3, 2:4] #取1到3行 中的 2到4列数

d = data[2:3]
d.shape
d[:, 2:3] = 9999  #此修改也会修改data中相应值
print(data)       #data中值也发生更改
与列表不同 数组切片时并不会自动复制 在切片数组上的修改会影响原数组
解决方法 使用copy()

d = data[2:3].copy()

a = [random.randint(0, 20) for _ in range(20)]
list(filter(lambda x: x>5, a))

#布尔型索引
aa = np.array(a)
aa[aa>5]

aa[(aa%5==0) & (aa>6)]
aa[(aa%5==0) | (aa>6)]

#花式索引
aa[[1,3,5,7,8]]
aa[:,[2,4]]   #逗号左边行 右边列 花式索引 取所有行中的 第2 4列

#通用函数 直接应用于数组
#一元函数
abs sqrt exp log ceil floor rint/round
trunc modf isnan isinf cos sin tan

#二元函数
add substract multiply divide power mod
maximum mininum


#numpy数学和统计方法
sum     求和
cumsum  求累计和
mean    求平均数
std     求标准差
var     求方差    一组数 于这组数平均值的 差值 波动大小
min     求最小值
max     求最大值
argmin  求最小值索引
argmax  求最大值索引

#numpy 随机数生成
rand    #给定形状产生随机数组 0-1之间随机数
randint #给定形状产生随机整数
choice  #给定形状产生随机选择
shuffle #于random.shuffle相同
uniform #给定形状产生随机数组

#标准库random
random.random() 返回0-1任意值
random.randint(0,10) #范围内任意整数
random.uniform(0, 10) #范围内任意浮点数
a = [4, 1, 2, 56, 6, 6, 3, 4, 5]
random.shuffle(a) #对原列表a洗牌

#Pandas
Series 是一种类似于一维数组的对象
有一组数据和一组与之相关的数据标签(索引)组成

pandas Series特性
Series支持Numpy模块的特性
    从ndarray创建Series Series(arr)
    于标量运算 sr*2
    两个Series运算 sr1+sr2
    索引 sr[0], sr[[1,2,4]]  花式索引 切片索引
    通用函数 np.abs(sr)
    布尔过滤 sr[sr>0]
Series支持字典的特性 (标签)
    从字典创建Series Series(dict)
    in运算 'a' in sr
    键索引 sr['a'] sr[['a', 'b', 'c']]

整数索引
sr = pd.Series(np.arange(10))

如果索引是整数类型 则根据整数进行数据操作时 总是面向标签的

loc     以标签 解释    标签tag 形式Pandas Series数据对齐
iloc    以下标索引 解释 -1 -2 -3 形式

Pandas Series数据对齐
pandas运算时 会按索引进行对齐然后计算 如果存在不同的索引
则结果的索引是两个操作数索引的并集

两个Series对象相加的时候将缺省值设置为0
a.add(b, fill_value=0)

pandas DataFrame
DataFrame 是一个表格型的数据类型  含有一组有序的列
DataFrame 可以被看作是由Series组成的字典 并且共用一个索引

创建方式
pd.DataFrame({"one":[1,2,3,4], 'two':[10,20,30,40]})

pd.DataFrame({
    "one":pd.Series([1,2,3,4], index=['a', 'b', 'c', 'd']),
    'two':pd.Series([10,20,30,40], index=['c','v','f','b'])
})
a = _
a.index     #行索引
a.columns   #列索引
a.values    #值
a.T         #行列转换 转置
a.describe()
#指定列 名称修改
a.rename(columns={"orign_name":"new_name", "orign_name":"new_name"})
a[["one", "two"]]   #花式索引 选取两列
a.loc[:10, ["one", "two"]]    #locl逗号前为哪几行 逗号后为哪几列 数字索引前十行 one two列
a.loc['a':'c', ["one", "two"]] #标签索引

a.iloc[:10, 2:4]            #iloc 只能为数字 逗号前为行 逗号后为列 前十行 2-4列

a["one"]
a[["one", "two"]]
a["one"][2]
a[0:3]
a[:3]["one"]
a[:3]["one","two"]

pandas DataFrame数据对齐和缺失数据
DataFrame处理缺失 数据
dropna()    #默认删除行 nan
dropna(how="all") #删除行中 所有值都为 nana
dropna(axis=1)    #axis 轴 0为行 1为列
dropna(axis=1, how="all") #删除所有列为nan

fillna(0)    #nan填充为0
isnull()
notnull()

pandas 常用方法 使用Series DataFrame
mean(axis=0, skipna=False)
sum(axis=1)
sort_index(axis, ..., ascending) #按行或列索引排序
sort_values(by, axis, ascending) #按值排序
Numpy通用函数同样适用于pandas
apply(func, axis=0)     #将自定义的函数应用于各行或各列上 func可返回标量或者Series
applymap(func)          #将函数应用在 DataFrame 各个元素上
map(func)               #将函数应用在 Series 各个元素上


pandas 从文件读取
读取文件 从文件名 URL 文件对象中加载数据
read_csv    #默认分隔符 逗号
read_table  #默认分隔符 \t

读取文件函数主要参数
sep         指定分隔符 可用正则表达式 如'\s+'
header=None 指定文件无列名  默认第一行为列名
names        指定列名
index_col   指定某列作为索引
skip_row    指定跳过某些行
na_values   指定某些字符串表示缺失值
parse_dates 指定某些列是否被解析为日期 布尔值或列表
nrows       指定读取几行文件
chunksize   分块读取文件 指定块大小

#date为索引 解析日期为 date
pd.read_csv("./000858.csv", index_col="date", parse_dates=["date"])
_["2018-01"]

#日期序列
df = pd.date_range("2018-01-02", "2018-05-04", freq="B")

#短期均线上穿长期均线 金叉 |短均线-长均线|绝对值变化范围

df.groupby("Column_title").sum()
df.groupby("Column_title").get_group("some_title")
df.groupby(["A", "B"]).sum()


Matplotlib强大的绘图工具
import matplotlib.pyplot as plt

绘图函数 plt.plot()
显示图像 plt.show()

df[["ma5", "ma20'"]].plot()
plt.show()

