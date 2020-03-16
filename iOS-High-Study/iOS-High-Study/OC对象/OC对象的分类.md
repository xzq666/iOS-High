##  OC对象的分类

Objective-C中的对象主要可以分为3种：instance对象（实例对象）、class对象（类对象）、meta-class对象（元类对象）。


### instance对象
instance对象就是通过类alloc出来的对象，每次调用alloc都会产生新的instance对象。
NSObject *obj1 = [[NSObject alloc] init];
NSObject *obj2 = [[NSObject alloc] init];
obj1、obj2是NSObject的instance对象，它们是不同的两个对象，分别占据两块不同的内存空间。
instance对象在内存中存储的信息包括：isa指针、其他成员对象。

### class对象
Class objClass1 = [obj1 class];
Class objClass2 = [obj2 class];
Class objClass3 = object_getClass(obj1);
Class objClass4 = object_getClass(obj2);
Class objClass5 = [NSObject class];
objClass1~objClass5都是NSObject的class对象，它们是同一个对象，每个类在内存中有且只有一个class对象。
class对象在内存中存储的信息主要包括：
isa指针、superclass指针、
类的属性信息(@property)、类的对象方法信息(instance method)、
类的协议信息(protocol)、类的成员变量信息(ivar)。

### meta-class对象
Class objMetaClass = object_getClass([NSObject class]);
objMetaClass是NSObject的meta-class对象，每个类在内存中有且只有一个meta-class对象。
meta-class对象和class对象的内存结构是一样的，但是用途不一样。
meta-class对象在内存中存储的信息主要包括：
isa指针、superclass指针、
类的类方法信息。


问：对象的isa指针指向哪里？
答：1、instance对象的isa指向class对象。当调用对象方法时，通过instance对象的isa找到class对象，最后找到对象方法的实现进行调用。
       2、class对象的isa指向meta-class对象。当调用类方法时，通过class对象的isa找到meta-class对象，最后找到类方法的实现进行调用。
       3、meta-class对象的isa指向基类的meta-class对象。 
instance的isa指向class
class的isa指向meta-class
meta-class的isa指向meta-class
class的superclass指向父类的class（如果没有父类，superclass指针为nil）
meta-class的superclass指向父类的meta-class（基类的meta-class的superclass指向基类的class）

问：OC的类信息放在哪里？
答：1、对象方法、属性、成员变量、协议信息存放在class对象中
       2、类方法存放在meta-class对象中
       3、成员变量的具体值存放在instance对象中
