#### 对象
- 实例化一个对象 的同时对属性进行初始化
- 共同点 都是函数 可以创建对象 都可以传入参数

- 工厂模式
    - 函数名首字母小写
    - 函数内部有 new Object; var obj = new Object();
    - 有返回值      ; return obj
    - new 之后的对象是当前的对象
    - 直接调用函数就可以创建对象

- 自定义构造函数  (大部分使用情况)
    - 函数名 首字母是大写
    - 没有new
    - 没有返回值
    - this 是当前的对象
    - 通过new的方式来创建对象
    
```angular2html
//自定义构造函数 实例化对象
function Person(name, age, sex){
    this.name = name;
    this.age = age;
    this.sex = sex;
    this.eat = function(){
        console.log("eatinggggg");
    }
}
//构造函数 创建对象
//实例对象 是通过构造函数来创建的
// Person是构造函数 
var per = New Person('google', 10, 'F');
per.eat();

console.log(per);    //实例对象
console.log(Person);  //构造函数

console.log(per.constructor == Person); //实例对象的构造器 就是构造函数 true

console.log(per.__proto__.constructor == Person); //true
console.log(per.__proto__.constructor == Person.prototype.constructor); //true

console.log(per instanceof Person); //尽可能使用 对象 instanceof 构造函数 方式来判断

```    
```angular2html
//通过原型来添加方法
function Person(name, age){
    this.name = name;
    this.age = age;
}
//通过原型来添加方法  解决数据共享 节省内存空间
Person.prototype.eat = function(){
    console.log("eat share function");
}

var p1 = new Person('aaa', 10);
var p2 = new Person('bbb', 20);

console.log(p1.eat == p2.eat); //true



```
    
    
    
    
