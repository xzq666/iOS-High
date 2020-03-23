##  block

block本质上也是一个OC对象，它内部也有个isa指针。
block是封装了函数调用（函数地址）及函数调用环境（所需要的变量等）的OC对象。


问：block的原理是什么？本质是什么？
答：block本质上也是一个OC对象，封装了函数调用及函数调用环境。


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


### block的copy
在ARC环境下，编译器会根据情况自动将栈上的block复制到堆上。比如：
1、block作为函数返回值时。
2、将block赋值给__strong指针时。
3、block作为Cocoa API中方法名含有UsingBlock的方法参数时。
4、block作为GCD参数时。


### 对象类型的auto变量
当block内部访问了对象类型的auto变量时：
1、若block在栈上，不会对auto变量产生强引用；
2、若block在堆上
  1）会调用block内部的copy函数；
  2）copy函数内部会调用_Block_object_assign函数；
  3）_Block_object_assign函数会根据auto变量的修饰符（__strong、__weak、__unsafe_unretained）做出相应操作，类似于retain（形成强引用、弱引用）。
3、若block从堆上移除
  1）会调用block内部的dispose函数；
  2）dispose函数内部会调用_Block_object_dispose函数；
  3）_Block_object_dispose函数会自动释放引用的auto变量，类似于release。
  
  
  ### __block修饰符
  __block可以用于解决block内部无法修改auto变量值的问题；
  __block不能修饰全局变量、静态变量（static）；
  编译器会将__block变量包装成一个对象。
  
  
  ### __block的内存管理
  当block在栈上时，并不会对__block变量产生强引用；
  当block被copy到堆时：
  1、会调用block内部的copy函数；
  2、copy函数内部会调用_Block_object_assign函数；
  3、_Block_object_assign函数会对__block变量形成强引用（retain）。
  当block从堆中移除时：
  1、会调用block内部的dispose函数；
  2、dispose函数内部会调用_Block_object_dispose函数；
  3、_Block_object_dispose函数会自动释放引用的__block变量（release）。
  
  
  ### 被__block修饰的对象类型
  当block在栈上时，并不会对__block变量产生强引用；
  当block被copy到堆时：
  1、会调用block内部的copy函数；
  2、copy函数内部会调用_Block_object_assign函数；
  3、_Block_object_assign函数会根据所指向对象的修饰符（__strong、__weak、__unsafe_unretained）做出相应操作，形成强引用或弱引用
  （注意这里仅限于ARC，MRC时不会retain）。
  当block从堆中移除时：
  1、会调用block内部的dispose函数；
  2、dispose函数内部会调用_Block_object_dispose函数；
  3、_Block_object_dispose函数会自动释放所指向的对象（release）。
  
  
  问：__block的作用是什么？有什么使用注意点？
  答：__block可以用于解决block内部无法修改auto变量值的问题。__block不能修饰全局变量和static静态变量。
  
  
  ### 解决循环引用问题
  1、ARC
  1）用__weak、__unsafe_unretained解决。（首选）
  2）用__block解决（必须要调用block）。
  2、MRC
  1）用__unsafe_unretained解决（MRC中没有__weak）。
  2）用__block解决。（因为MRC中使用__block是不会对所指向对象进行retain）


问：block的属性修饰词为什么是copy？使用block有哪些使用注意？
答：block进行copy是为了将其copy到堆上，从而自己管理内存。使用block需要注意循环引用的问题。


问：block在修改NSMutableArray时需不需要添加__block？
答：不需要。
