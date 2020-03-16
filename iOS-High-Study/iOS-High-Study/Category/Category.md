##  Category

### Category的加载处理过程
1、通过Runtime加载某个类的所有Category数据。
2、把所有Category的方法、属性、协议数据合并到一个大数组中。（参与编译顺序靠后的Category数据会在数组的前面）
3、将合并后的分类数据（方法、属性、协议）插入到类原来数据的前面。


问：Category的实现原理？
答：Category编译之后的底层结构是struct category_t，里面存储着Category的对象方法、类方法、属性、协议信息。在程序运行的时候，Runtime会将Category的数据合并到类信息中（类对象、元类对象）。


问：Category和Extension的区别是什么？
答：Class Extension在编译的时候，数据就已经包含在类信息中了；Category是在运行时才将数据合并到类信息中。


问：Category中有load方法吗？load方法是什么时候调用的？load方法能继承吗？
答：


问：load、initialize方法的区别是什么？它们在Category中的调用顺序？出现继承时它们之间的调用过程？
答：


问：Category能否添加成员变量？如果可以如何给Category添加成员变量？
答：
