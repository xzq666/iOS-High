##  Runtime

Objective-C是一门动态性比较强的编程语言，跟C、C++等语言有着很大的不同。
Objective-C的动态性都是由Runtime API来支撑的。
Runtime API提供的接口基本都是C语言的，源码由C/C++/汇编语言编写。


### isa详解

要想学习Runtime，首先要了解它底层的一些常用数据结构，比如isa指针。
在arm64架构之前，isa就是一个普通的指针，存储着Class、Meta-Class对象的内存地址。
从arm64架构开始，对isaz进行了优化，变成了一个共用体(union)结构，还使用位域来存储更多的信息（8个字节64位）
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
引用计数器是否过大无法存储在isa中
如果为1，那么引用计数会存储在一个叫SideTable的类的属性中
uintptr_t extra_rc
里面存储的值是引用计数器减1


### Class的结构

"
struct objc_class : objc_object {
    // Class ISA;  // 继承自objc_object
    Class superclass;
    cache_t cache;             // 方法缓存
    class_data_bits_t bits;    // 用于获取具体的类信息
}
"
bits & FAST_DATA_MASK -> class_rw_t
"
struct class_rw_t {
    // Be warned that Symbolication knows the layout of this structure.
    uint32_t flags;
    uint16_t version;
    uint16_t witness;
    const class_ro_t *ro;
    method_array_t methods;   // 方法列表
    property_array_t properties;   // 属性列表
    protocol_array_t protocols;   // 协议列表
    Class firstSubclass;
    Class nextSiblingClass;
    char *demangledName;
}
class_rw_t里面的methods、properties、protocols是二维数组，是可读可写的，包含了类的初始内容、分类的内容。
struct class_ro_t {
    uint32_t flags;
    uint32_t instanceStart;
    uint32_t instanceSize;  // instance对象占用的内存空间
#ifdef __LP64__
    uint32_t reserved;
#endif
    const uint8_t * ivarLayout;
    const char * name;  // 类名
    method_list_t * baseMethodList;
    protocol_list_t * baseProtocols;
    const ivar_list_t * ivars;  // 成员变量列表
    const uint8_t * weakIvarLayout;
    property_list_t *baseProperties;
}
class_ro_t里面的baseMethodList、baseProtocols、ivars、baseProperties是一维数组，是只读的，包含了类的初始内容。
"


### method_t

method_t是对方法\函数的封装。
"
struct method_t {
    SEL name;  // 函数名
    const char *types;  // 编码（返回值类型、参数类型）
    MethodListIMP imp;  // 指向函数的指针（函数地址）arm64下就是IMP
}
"
1、IMP代表函数的具体实现。
2、SEL代表方法\函数名，一般叫做选择器，底层结构跟char *类似。
1）可以通过@selector()和sel_registerName()获得；
2）可以通过sel_getName()和NSStringFromSelector()转成字符串；
3）不同类中相同名字的方法，所对应的方法选择器是相同的。
3、types包含了函数返回值、参数编码的字符串。
iOS中提供了一个叫做@encode的指令，可以将具体的类型表示成字符串编码。


### 方法缓存

Class内部结构中有个方法缓存（cache_t），用散列表（哈希表）来缓存曾经调用过的方法，可以提高方法的查找速度。
cache_t核心结构：
explicit_atomic<struct bucket_t *> _buckets;  // 散列表
explicit_atomic<mask_t> _mask;  // 散列表的长度-1
bucket_t核心结构
explicit_atomic<SEL> _sel;  // SEL作为key
explicit_atomic<uintptr_t> _imp;  // 函数的内存地址


### objc_msgSend执行流程

OC中的方法调用其实都是转换为objc_msgSend函数的调用。
objc_msgSend的执行流程可以分为3大阶段：
1、消息发送</br>
![avatar](https://github.com/xzq666/iOS-High/blob/master/iOS-High-Study/iOS-High-Study/Runtime/消息发送.jpg)
2、动态方法解析</br>
![avatar](https://github.com/xzq666/iOS-High/blob/master/iOS-High-Study/iOS-High-Study/Runtime/动态方法解析.jpg)
3、消息转发</br>
将消息转发给别人。
![avatar](https://github.com/xzq666/iOS-High/blob/master/iOS-High-Study/iOS-High-Study/Runtime/消息转发.jpg)


问：讲一下OC的消息机制？</br>
答：OC中的方法调用其实都是转成了objc_msgSend函数的调用，给receiver（方法调用者）发送了一条消息（selector方法名）。
objc_msgSend底层有三大阶段：消息发送（当前类、父类中查找）、动态方法解析、消息转发。


问：消息转发机制流程？</br>
答： 
1、调用forwardingTargetForSelector:方法，若返回值不为nil，则调用objc_msgSend(返回值, SEL)；若返回nil，则调用methodSignatureForSelector:方法。
2、若返回值不为nil，则调用forwardInvocation:方法；若为nil则调用doesNotRecognizeSelector:方法。


### super

[super message]的底层实现</br>
1、消息接收者仍然是子类对象。
2、从父类开始查找方法的实现。


问：什么是Runtime？平时项目中有用过吗？</br>
答：
