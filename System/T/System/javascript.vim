call apply 改变函数内this的指向
var obj = {name: 'this is call and apply'};
function func3(){
  console.log(this);  
}

func3();
func3.call(obj);
func3.apply(obj);


#回调函数
你定义的函数
你没有直接调用此函数
但是最终此函数执行了


#立即执行函数
(function(){
  console.log("---");
})()

只执行一次
什么时候执行 代码执行到函数位置
内部的数据是私有的

每一个函数都有一个prototype属性 它默认指向一个Object空对象(原型对象)
 原型对象中有一个属性constructor 它指向函数对象

给原型对象添加属性(一般都是方法)
 作用 函数的所有实例对象自动拥有原型中的属性


function Person(){

}
//每个函数都有一个属性prototype
//空对象 ---> 原型对象(显示原型对象)
console.log(Person.prototype);

//Person.prototype.constructor == 函数本身 声明当前构造器是谁
//生成实例对象
var person1 = new Person();

//每一个实例对象身上都有一个属性__proto__ 该属性指向当前实例对象的原型对象 隐式原型对象
//构造函数的显示原型对象=== 当前构造函数实例对象的隐士原型对象
console.log(Person.prototype == person1.__proto__); // true
