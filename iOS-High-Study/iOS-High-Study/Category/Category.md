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
1、Category中有load方法。
2、+load方法会在Runtime加载类、分类时调用，每个类、分类的+load在程序运行过程中只调用一次。先调用类的+load（按照编译先后顺序调用，调用子类的+load之前会先调用父类的+load），再调用分类的+load（按照编译先后顺序调用）。
3、可以继承，但一般情况下我们不会主动去调用，都是让系统自动调用。


### initialize方法
initialize方法只会在类第一次接收到消息时初始化。
调用顺序：先调用父类的+initialize，再调用子类的+initialize。
+initialize和+load的很大区别是，+initialize是通过objc_msgSend进行调用的，所以有以下特点：
1、如果子类没有实现+initialize，会调用父类的+initialize（所以父类的+initialize可能会被调用多次，但不代表初始化多次）
2、如果分类实现了+initialize，就覆盖类本身的+initialize调用


问：load、initialize方法的区别是什么？它们在Category中的调用顺序？出现继承时它们之间的调用过程？
答：
1、调用方式：load是根据函数地址直接调用，initialize是通过objc_msgSend调用；调用时刻：load是Runtime加载类、分类的时候调用（只会调用1次），initialize是类第一次接收到消息时调用，每一个类只会initialize一次（父类的initialize方法可能被调用多次）；
2、load先按照编译顺序调用类的load，调用子类的load之前会调用父类的load，然后再按照编译顺序调用分类的load；initialize在类第一次接收到消息时通过objc_msgSend调用，先调用父类的initialize再调用子类的initialize，若分类实现了initialize就覆盖类原来的initialize调用，若子类没有实现initialize，会调用父类的initialize。
3、load先调用父类的load再调用子类的load；initialize先调用父类的initialize再调用子类的initialize。
    


问：Category能否添加成员变量？如果可以如何给Category添加成员变量？
答：
