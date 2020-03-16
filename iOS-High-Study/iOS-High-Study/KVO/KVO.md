##  KVO

Key-Value Observing，俗称“键值监听”，可以监听对象某个属性值的变化。


问：iOS用什么方式实现对一个对象的KVO？（KVO的本质是什么？）
答：利用RuntimeAPI动态生成一个子类，并且让instance对象的isa指向这个全新的子类。当修改instance对象的属性时，会调用Foundation的_NSSetXXXValueAndNotify函数。
willChangeValueForKey
父类原来的setter
didChangeValueForKey
内部会触发监听器的监听方法observeValueForKeyPath:ofObject:change:context


问：如何手动触发KVO？
答：手动调用willChangeValueForKey:和didChangeValueForKey:

问：直接修改成员变量会触发KVO吗？
答：不会触发KVO（因为KVO需要通过修改原来的set方法去触发，或者直接手动触发）。
