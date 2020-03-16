##  OC对象的本质

Objective-C代码底层实现是C/C++代码。
所有Objective-C的面向对象都是基于C/C++的数据结构实现的。

问：Objective-C的对象、类主要是基于C/C++的什么数据结构实现的？
答：结构体。

将Objective-C代码转换为C/C++代码
xcrun -sdk iphoneos clang -arch arm64 -rewrite-objc OC源文件 -o  输出的cpp文件

问：一个OC对象在内存中是如何布局的？
答：NSObject的底层实现
@interface NSObject {
    Class isa;
}
@end
struct NSObject_IMPL {
    Class isa;
};
typedef struct objc_class *Class

问：一个OC对象占多少内存？
答：系统分配了16个字节给NSObject对象，但NSObject对象内部只使用了8个字节的空间（64bit环境下，可以通过class_getInstanceSize方法获取）。

创建一个实例对象，至少需要多少内存？
#import <objc/runtime.h>
class_getInstanceSize([NSObject class]);
创建一个实例对象，实际上分配了多少内存？
#import <malloc/malloc.h>
malloc_size((__bridge const void *)obj);

### 常用LLDB指令
print/p：打印
po(print object)：打印对象
#### 读取内存
memory read/数量格式字节数 内存地址
x/数量格式字节数 内存地址
例如：x/3xw 0x10010
格式：x是16进制、f是浮点、d是10进制
字节大小：
b是byte 1字节
h是half word  2字节
w是word  4字节
g是giant word  8字节
#### 修改内存中的值：
memory write 内存地址 数值
例如：memory write 0x0000010 10


