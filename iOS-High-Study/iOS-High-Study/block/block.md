##  block

block本质上也是一个OC对象，它内部也有个isa指针。
block是封装了函数调用（函数地址）及函数调用环境（所需要的变量等）的OC对象。


问：block的原理是什么？本质是什么？
答：


### block变量捕获
局部变量（涉及到跨函数访问，所以肯定要捕获）
auto（离开作用域就销毁）：会捕获到block内部，值传递。
static：会捕获到block内部，指针传递。
全局变量
不会捕获到block内部，直接访问。


### block类型
block有3种类型，可以通过调用class方法或者isa指针查看具体类型，最终都是继承自NSBlock类型。
__NSGlobalBlock__(__NSConcreteGlobalBlock)：没有访问auto变量。
__NSStackBlock__(__NSConcreteStackBlock)：访问了auto变量。
__NSMallocBlock__(__NSConcreteMallocBlock)：__NSStackBlock__调用了copy。
每一种类型的block调用copy后的结果：
__NSConcreteGlobalBlock：始终在程序的数据区域，什么也不做。
__NSConcreteStackBlock：从栈复制到堆。
__NSConcreteMallocBlock：引用计数增加。


问：__block的作用是什么？有什么使用注意点？
答：


问：block的属性修饰词为什么是copy？使用block有哪些使用注意？
答：


问：block在修改NSMutableArray时需不需要添加__block？
答：
