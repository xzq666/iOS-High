##  Runloop


### 含义
1、运行循环。<br/>
2、在程序运行过程中循环做一些事情。<br/>


### 应用范畴
1、定时器（Timer）、PerformSelector<br/>
2、GCD Async Main Queue<br/>
3、事件响应、手势识别、界面刷新<br/>
4、网络请求<br/>
5、AutoreleasePool<br/>


### Runloop基本作用
1、保持程序的持续运行<br/>
2、处理App中的各种事件（触摸事件、定时器事件等）<br/>
3、节省CPU资源，提高程序性能：该做事时做事，该休息时休息<br/>


### Runloop对象
iOS中有2套API来访问和使用RunLoop：<br/>
1、Foundation：NSRunLoop<br/>
2、Core Foundation：CFRunLoopRef<br/>

NSRunLoop和CFRunLoopRef都代表着RunLoop对象，NSRunLoop是基于CFRunLoopRef的一层OC包装。<br/>
CFRunLoopRef是开源的：https://opensource.apple.com/tarballs/CF/


### Runloop与线程
1、每条线程都有唯一的一个与之对应的RunLoop对象<br/>
2、RunLoop保存在一个全局的Dictionary里，线程作为key，RunLoop作为value<br/>
3、线程刚创建时并没有RunLoop对象，RunLoop会在第一次获取它时创建<br/>
4、RunLoop会在线程结束时销毁<br/>
5、主线程的RunLoop已经自动获取（创建），子线程默认没有开启RunLoop<br/>


### Runloop相关的类
Core Foundation中关于RunLoop的5个类：<br/>
1、CFRunLoopRef<br/>
2、CFRunLoopModeRef<br/>
3、CFRunLoopSourceRef<br/>
4、CFRunLoopTimerRef<br/>
5、CFRunLoopObserverRef<br/>


### CFRunLoopModeRef
1、CFRunLoopModeRef代表RunLoop的运行模式<br/>
2、一个RunLoop包含若干个Mode，每个Mode又包含若干个Source0/Source1/Timer/Observer<br/>
3、RunLoop启动时只能选择其中一个Mode，作为currentMode<br/>
4、如果需要切换Mode，只能退出当前Loop，再重新选择一个Mode进入。不同组的Source0/Source1/Timer/Observer能分隔开来，互不影响<br/>
5、如果Mode里没有任何Source0/Source1/Timer/Observer，RunLoop会立马退出<br/>
常见的2种Mode：<br/>
1、kCFRunLoopDefaultMode（NSDefaultRunLoopMode）：App的默认Mode，通常主线程是在这个Mode下运行。
2、UITrackingRunLoopMode：界面跟踪Mode，用于ScrollView追踪触摸滑动，保证界面滑动时不受其他 Mode 影响。


### CFRunLoopObserverRef
1、kCFRunLoopEntry：即将进入Loop<br/>
2、kCFRunLoopBeforeTimers：即将处理Timer<br/>
3、kCFRunLoopBeforeSources：即将进入Source<br/>
4、kCFRunLoopBeforeWaiting：即将进入休眠<br/>
5、kCFRunLoopAfterWaiting：刚从休眠中唤醒<br/>
6、kCFRunLoopExit：即将退出Loop<br/>
7、kCFRunLoopAllActivities<br/>


### RunLoop运行逻辑
1、Source0<br/>
1）触摸事件处理<br/>
2）performSelector:onThread:<br/>
2、Source1<br/>
1）基于Port的线程间通信<br/>
2）系统事件捕捉<br/>
3、Timers<br/>
1）NSTimer<br/>
2）performSelector:withObject:afterDelay:<br/>
4、Observers<br/>
1）用于监听RunLoop的状态<br/>
2）UI刷新（BeforeWaiting）<br/>
3）Autorelease pool（BeforeWaiting）<br/>


### RunLoop在实际开发中的应用
1、控制线程生命周期（线程保活，例如AFNetworking）；<br/>
2、解决NSTimer在滑动时停止工作的问题；<br/>
3、监控应用卡顿；<br/>
4、性能优化；<br/>


问：讲讲runloop，项目中有用到吗？
答：运行循环。在程序运行过程中循环做一些事情。
1、控制线程生命周期（线程保活，例如AFNetworking）；<br/>
2、解决NSTimer在滑动时停止工作的问题；<br/>
3、监控应用卡顿；<br/>
4、性能优化；<br/>


问：runloop内部实现逻辑？
答：
01、通知Observers：进入Loop<br/>
02、通知Observers：即将处理Timers<br/>
03、通知Observers：即将处理Sources<br/>
04、处理Blocks<br/>
05、处理Source0（可能会再次处理Blocks）<br/>
06、如果存在Source1，就跳转到第8步<br/>
07、通知Observers：开始休眠（等待消息唤醒）<br/>
08、通知Observers：结束休眠（被某个消息唤醒）<br/>
    01> 处理Timer<br/>
    02> 处理GCD Async To Main Queue<br/>
    03> 处理Source1<br/>
09、处理Blocks<br/>
10、根据前面的执行结果，决定如何操作<br/>
    01> 回到第02步<br/>
    02> 退出Loop<br/>
11、通知Observers：退出Loop


问：runloop和线程的关系？
答：一对一。
1、每条线程都有唯一的一个与之对应的RunLoop对象<br/>
2、RunLoop保存在一个全局的Dictionary里，线程作为key，RunLoop作为value<br/>
3、线程刚创建时并没有RunLoop对象，RunLoop会在第一次获取它时创建<br/>
4、RunLoop会在线程结束时销毁<br/>
5、主线程的RunLoop已经自动获取（创建），子线程默认没有开启RunLoop<br/>


问：timer与runloop的关系？
答：CFRunLoopRef下的currentMode中存放着当前模式下的timer，当timer模式为通用模式时，timer会放到_commonModeItems中。


问：程序中添加每3秒响应一次的NSTimer，当拖动tableView的timer可能无法响应要怎么解决？
答：使用[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes]将NSTimer添加到当前RunLoop下。


问：runloop是怎么响应用户操作的，具体流程是怎么样的？
答：source1捕捉响应，source0执行响应。


问：说说runloop的几种状态？
答：
1、kCFRunLoopEntry：即将进入Loop<br/>
2、kCFRunLoopBeforeTimers：即将处理Timer<br/>
3、kCFRunLoopBeforeSources：即将进入Source<br/>
4、kCFRunLoopBeforeWaiting：即将进入休眠<br/>
5、kCFRunLoopAfterWaiting：刚从休眠中唤醒<br/>
6、kCFRunLoopExit：即将退出Loop<br/>


问：runloop的mode作用是什么？
答：常见的有2种Mode：<br/>
1、kCFRunLoopDefaultMode（NSDefaultRunLoopMode）：App的默认Mode，通常主线程是在这个Mode下运行。
2、UITrackingRunLoopMode：界面跟踪Mode，用于ScrollView追踪触摸滑动，保证界面滑动时不受其他 Mode 影响。
