##  KVC

Key-Value Coding，俗称“键值编码”，可以通过一个key来访问某个属性。
常见的API有：
- (void)setValue:(id)value forKeyPath:(NSString *)keyPath;
- (void)setValue:(id)value forKey:(NSString *)keyPath;
- (id)valueForKeyPath:(NSString *)keyPath;
- (id)valueForKey:(NSString *)key;


问：通过KVC修改属性会触发KVO吗？
答：会触发KVO。


问：KVC赋值和取值过程是怎么样的？原理是什么？
答：
赋值过程
1、按照setKey:、_setKey:顺序查找方法。
2、若找到方法则传递参数、调用方法；若没找到方法查看accessInstanceVariablesDirectly方法的返回值。
3、若返回NO调用setValue:forUndefinedKey:并抛出异常NSUnknownKeyException；若返回YES按照_key、_isKey、key、isKey顺序查找成员变量。
4、若找到成员变量直接赋值；若没找到调用setValue:forUndefinedKey:并抛出异常NSUnknownKeyException。
取值过程
1、按照getKey、key、isKey、_key顺序查找方法。
2、若找到方法则调用方法；若没找到则查看accessInstanceVariablesDirectly方法的返回值。
3、若返回NO调用valueForUndefinedKey:并抛出异常NSUnknownKeyException；若返回YES按照_key、_isKey、key、isKey顺序查找成员变量。
4、若找到成员变量直接赋值；若没找到调用valueForUndefinedKey:并抛出异常NSUnknownKeyException。
