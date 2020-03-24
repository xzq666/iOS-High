##  Runtime

Objective-C是一门动态性比较强的编程语言，跟C、C++等语言有着很大的不同。
Objective-C的动态性都是由Runtime API来支撑的。
Runtime API提供的接口基本都是C语言的，源码由C/C++/汇编语言编写。


### isa详解

要想学习Runtime，首先要了解它底层的一些常用数据结构，比如isa指针。
在arm64架构之前，isa就是一个普通的指针，存储着Class、Meta-Class对象的内存地址。
从arm64架构开始，对isaz进行了优化，变成了一个共用体(union)结构，还使用位域来存储更多的信息。
uintptr_t nonpointer
0，代表普通的指针，存储着Class、Meta-Class对象的内存地址
1，代表优化过，使用位域存储更多的信息
uintptr_t has_assoc
是否有设置过关联对象，如果没有，释放时会更快
uintptr_t has_cxx_dtor
是否有C++的析构函数（.cxx_destruct），如果没有，释放时会更快
uintptr_t shiftcls
存储着Class、Meta-Class对象的内存地址信息
uintptr_t magic
用于在调试时分辨对象是否未完成初始化
uintptr_t weakly_referenced
是否有被弱引用指向过，如果没有，释放时会更快
uintptr_t deallocating 
对象是否正在释放
uintptr_t has_sidetable_rc
里面存储的值是引用计数器减1
uintptr_t extra_rc
引用计数器是否过大无法存储在isa中
如果为1，那么引用计数会存储在一个叫SideTable的类的属性中


问：讲一下OC的消息机制？
答：


问：消息转发机制流程？
答：


问：什么是Runtime？平时项目中有用过吗？
答：


问：
答：

