//
//  ViewController.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/3/5.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <malloc/malloc.h>
#import "XZQPerson.h"
#import "XZQPerson_KVC.h"

#import "XZQPerson_Category.h"
#import "XZQPerson_Category+Test.h"
#import "XZQPerson_Category+Eat.h"

#import "XZQStudent_Category.h"

#import "XZQPerson_block.h"

#import "XZQPerson_Runtime.h"
#import "XZQStudent_Runtime.h"
#import "XZQTeacher_Runtime.h"
#import "MJClassInfo.h"
#import "XZQSonOfSon_Runtime.h"
#import "XZQSon_super.h"

@interface Student : NSObject
{
    @public
    int _age;
    int _height;
    int _no;
}
- (void)studentInstanceMethod;
+ (void)studentClassMethod;
@end

@implementation Student

- (void)studentInstanceMethod {
    
}

+ (void)studentClassMethod {
    
}

@end

@interface ViewController ()

@property(nonatomic,strong) XZQPerson *person1;
@property(nonatomic,strong) XZQPerson *person2;

@end

@implementation ViewController

- (void)printMethodNamesOfClass:(Class)cls {
    unsigned int count;
    // 获得方法数组
    Method *methodList = class_copyMethodList(cls, &count);
    // 存储方法名
    NSMutableString *methodNames = [NSMutableString string];
    // 遍历所有方法
    for (int i = 0; i < count; i++) {
        // 获得方法
        Method method = methodList[i];
        // 获得方法名
        NSString *methodName = NSStringFromSelector(method_getName(method));
        // 拼接方法名
        [methodNames appendString:methodName];
        [methodNames appendString:@", "];
    }
    // 释放内存
    free(methodList);
    // 打印方法名
    NSLog(@"%@ %@", cls, methodNames);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self runloop];
    
    /*
     1.print为什么能够调用
     obj->cls->XZQPerson_super类对象  相当于  person->XZQPerson_super实例对象isa->XZQPerson_super类对象
     
     2.为什么print打印变成了ViewController
     调用方法时会把obj当成XZQPerson_super实例对象，先根据isa指针找到print方法，print方法里用到的_name在isa指针后面，
     也就是通过跳8个字节找到的下一个指针指向的变量就会当成_name。
     */
//    NSString *s = @"123";
//    id cls = [XZQPerson_super class];
//    void *obj = &cls;
//    [(__bridge id)obj print];
}

void observeRunLoopActivities(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    switch (activity) {
        case kCFRunLoopEntry:
            NSLog(@"kCFRunLoopEntry");
            break;
            
        case kCFRunLoopBeforeTimers:
            NSLog(@"kCFRunLoopBeforeTimers");
            break;
            
        case kCFRunLoopBeforeSources:
            NSLog(@"kCFRunLoopBeforeSources");
            break;
            
        case kCFRunLoopBeforeWaiting:
            NSLog(@"kCFRunLoopBeforeWaiting");
            break;
            
        case kCFRunLoopAfterWaiting:
            NSLog(@"kCFRunLoopAfterWaiting");
            break;
            
        case kCFRunLoopExit:
            NSLog(@"kCFRunLoopExit");
            break;
            
        default:
            break;
    }
}

- (void)runloop {
    // NSRunLoop是基于CFRunLoopRef的一层OC包装
    NSLog(@"%p - %p", [NSRunLoop currentRunLoop], [NSRunLoop mainRunLoop]);
    NSLog(@"%p - %p", CFRunLoopGetCurrent(), CFRunLoopGetMain());
    
    // 创建Observer
//    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, observeRunLoopActivities, NULL);
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry: {
                CFRunLoopMode mode = CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent());
                NSLog(@"kCFRunLoopEntry - %@", mode);
                CFRelease(mode);
                break;
            }
                
            case kCFRunLoopExit: {
                CFRunLoopMode mode = CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent());
                NSLog(@"kCFRunLoopExit - %@", mode);
                CFRelease(mode);
                break;
            }
                
            default:
                break;
        }
    });
    // 添加observer
    // kCFRunLoopCommonModes默认包括kCFRunLoopDefaultMode和UITrackingRunLoopMode
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    // 释放
    CFRelease(observer);
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 100, 300, 50)];
    textView.backgroundColor = [UIColor systemGrayColor];
    textView.font = [UIFont systemFontOfSize:16.0f];
    textView.text = @"dhaksjdgsufgsdihsdfshdfgsldlafjkadsgalfjsdkfgasldkjfgsdakjfgdslfjasdlgfdskjfasdfsdagdsfsfdsafasdfasdfsdfasdf";
    [self.view addSubview:textView];
}

void run(id self, SEL _cmd)
{
    NSLog(@"c_other %@ - %@", self, NSStringFromSelector(_cmd));
}

- (void)runtime {
    XZQPerson_Runtime *person = [[XZQPerson_Runtime alloc] init];
    [person test];
    
    person.tall = NO;
    person.rich = YES;
    person.handsome = NO;
    NSLog(@"-->%d", person.isTall);
    NSLog(@"-->%d", person.isRich);
    NSLog(@"-->%d", person.isHandsome);
    
    NSLog(@"-->%zd", class_getInstanceSize([XZQPerson_Runtime class]));
    
    NSLog(@"----------");
    
    XZQStudent_Runtime *student = [[XZQStudent_Runtime alloc] init];
    student.tall = YES;
    student.rich = YES;
    student.handsome = NO;
    NSLog(@"-->%d", student.isTall);
    NSLog(@"-->%d", student.isRich);
    NSLog(@"-->%d", student.isHandsome);
    
    NSLog(@"----------");
    
    XZQTeacher_Runtime *teacher = [[XZQTeacher_Runtime alloc] init];
    teacher.tall = YES;
    teacher.rich = YES;
    teacher.handsome = NO;
    NSLog(@"-->%d", teacher.isTall);
    NSLog(@"-->%d", teacher.isRich);
    NSLog(@"-->%d", teacher.isHandsome);
    
    NSLog(@"----------");
    
    // 类对象、元类对象的内存地址末三位一定是0
    NSLog(@"%p", [ViewController class]);
    NSLog(@"%p", object_getClass([ViewController class]));
    NSLog(@"%p", [person class]);
    NSLog(@"%p", object_getClass([XZQPerson_Runtime class]));
    
    NSLog(@"----------");
    
    NSLog(@"%s", @encode(int));
    NSLog(@"%s", @encode(char));
    NSLog(@"%s", @encode(id));
    NSLog(@"%s", @encode(SEL));
    
    NSLog(@"----------");
    
//    XZQFather_Runtime *father = [[XZQFather_Runtime alloc] init];
//    mj_objc_class *fatherClass = (__bridge mj_objc_class *)[XZQFather_Runtime class];
//    [father fatherTest];
    
    XZQSonOfSon_Runtime *sonOfSon = [[XZQSonOfSon_Runtime alloc] init];
    mj_objc_class *sonOfSonClass = (__bridge mj_objc_class *)[XZQSonOfSon_Runtime class];
    [sonOfSon sonOfSonTest];
    [sonOfSon sonTest];
    [sonOfSon fatherTest];
    [sonOfSon sonOfSonTest];
    [sonOfSon sonTest];
    cache_t cache = sonOfSonClass->cache;
    bucket_t *buckets = cache._buckets;
    for (int i = 0; i < cache._mask + 1; i++) {
        bucket_t bucket = buckets[i];
        NSLog(@"%s, %p", bucket._key, bucket._imp);
    }
    bucket_t bucket = buckets[(long long)@selector(fatherTest) & cache._mask];
    NSLog(@"%s, %p", bucket._key, bucket._imp);
    NSLog(@"%s, %p", @selector(fatherTest), cache.imp(@selector(fatherTest)));
    NSLog(@"%s, %p", @selector(sonTest), cache.imp(@selector(sonTest)));
    NSLog(@"%s, %p", @selector(sonOfSonTest), cache.imp(@selector(sonOfSonTest)));
    
    NSLog(@"----------");
    
    // OC的方法调用：消息机制，给方法调用者发送消息
    XZQFather_Runtime *father = [[XZQFather_Runtime alloc] init];
    // objc_msgSend(father, @selector(fatherTest));
    // 消息接收者：father
    // 消息名称：fatherTest
    [father fatherTest];
    // objc_msgSend([XZQFather_Runtime class], @selector(initialize));
    // 消息接收者：[XZQFather_Runtime class]
    // 消息名称：initialize
    [XZQFather_Runtime initialize];
    NSLog(@"%p %p", sel_registerName("fatherTest"), @selector(fatherTest));
    
    NSLog(@"----------");
    
    [father test];
    [XZQFather_Runtime test];
    [father test];
    [XZQFather_Runtime test];
    
    NSLog(@"----------");
    
    [XZQSon_Runtime test:100];
    
    NSLog(@"----------");
    
    [[XZQSon_super alloc] init];
    /*
     +isKindOfClass：
     for (Class tcls = self->ISA(); tcls; tcls = tcls->superclass) {
         if (tcls == cls) return YES;
     }
     return NO;
     
     +isMemberOfClass
     return self->ISA() == cls;
     */
    BOOL ret1 = [[NSObject class] isKindOfClass:[NSObject class]];
    BOOL ret2 = [[NSObject class] isMemberOfClass:[NSObject class]];
    BOOL ret3 = [[XZQPerson_super class] isKindOfClass:[XZQPerson_super class]];
    BOOL ret4 = [[XZQPerson_super class] isMemberOfClass:[XZQPerson_super class]];
    NSLog(@"%d, %d, %d, %d", ret1, ret2, ret3, ret4);
    
    NSLog(@"----------");
    
    XZQStudent_Runtime *ss = [[XZQStudent_Runtime alloc] init];
    [ss run];
    
    object_setClass(ss, [XZQTeacher_Runtime class]);
    [ss run];
    
    NSLog(@"----------");
    
    // 创建一个类：父类 类名 额外分配的字节数
    Class newClass = objc_allocateClassPair([NSObject class], "XZQDog", 0);
    // 添加成员变量：类 变量名 占字节数 字节对齐 类型
    class_addIvar(newClass, "_age", 4, 1, @encode(int));
    class_addIvar(newClass, "_weight", 4, 1, @encode(int));
    // 添加方法
    class_addMethod(newClass, @selector(run), (IMP)run, "v16@0:8");
    // 注册类
    objc_registerClassPair(newClass);
    id dog = [[newClass alloc] init];
    [dog setValue:@10 forKey:@"_age"];
    [dog setValue:@20 forKey:@"_weight"];
    NSLog(@"%zd", class_getInstanceSize(newClass));
    NSLog(@"%zd", malloc_size((__bridge const void *)dog));
    NSLog(@"%@, %@", [dog valueForKey:@"_age"], [dog valueForKey:@"_weight"]);
    [dog run];
    object_setClass(dog, [XZQTeacher_Runtime class]);
    [dog run];
    // 获取成员变量信息
    XZQPerson_super *ps = [[XZQPerson_super alloc] init];
    Ivar ageIvar = class_getInstanceVariable([XZQPerson_super class], "_hight");
    NSLog(@"%s - %s", ivar_getName(ageIvar), ivar_getTypeEncoding(ageIvar));
    object_setIvar(ps, ageIvar, (__bridge id)(void *)100);
    NSLog(@"%d", ps.hight);
    [ps setValue:@200 forKey:@"weight"];
    NSLog(@"weight:%d", ps.weight);
    
    NSLog(@"----------");
    
    // 成员变量的数量
    unsigned int count;
    Ivar *ivars = class_copyIvarList([XZQPerson_super class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"%s - %s", ivar_getName(ivar), ivar_getTypeEncoding(ivar));
    }
    free(ivars);
    
    // 方法替换
    ps.name = @"xzq";
    [ps print];
    class_replaceMethod([XZQPerson_super class], @selector(print), (IMP)run, "v16@0:8");
    [ps print];
    class_replaceMethod([XZQPerson_super class], @selector(print), imp_implementationWithBlock(^{
        NSLog(@"imp block");
    }), "v");
    [ps print];
    Method method1 = class_getInstanceMethod([XZQPerson_super class], @selector(test1));
    Method method2 = class_getInstanceMethod([XZQPerson_super class], @selector(test2));
    method_exchangeImplementations(method1, method2);
    [ps test1];
    [ps test2];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(10, 100, 80, 30);
    [btn1 setTitle:@"btn1" forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    [btn1 addTarget:self action:@selector(btnClick1) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(100, 100, 80, 30);
    [btn2 setTitle:@"btn2" forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    [btn2 addTarget:self action:@selector(btnClick2) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(190, 100, 80, 30);
    [btn3 setTitle:@"btn3" forState:UIControlStateNormal];
    [self.view addSubview:btn3];
    [btn3 addTarget:self action:@selector(btnClick3) forControlEvents:UIControlEventTouchUpInside];
    
    NSLog(@"----------");
    
    NSString *obj = nil;
    NSMutableArray *array = [NSMutableArray array];
    // 类簇：NSString、NSArray、NSDictionary，真实类型是其他类型
    NSLog(@"%@", [array class]);
    [array addObject:@"jack"];
    [array addObject:obj];
    NSLog(@"%@", array);
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    NSLog(@"%@", [mDict class]);
    mDict[@"name"] = @"jack";
    mDict[@"age"] = nil;
    mDict[obj] = @"age";
    NSLog(@"%@", mDict);
}

- (void)btnClick1 {
    NSLog(@"click1");
}

- (void)btnClick2 {
    NSLog(@"click2");
}

- (void)btnClick3 {
    NSLog(@"click3");
}

int age_ = 100;
static int height_ = 300;

typedef void (^XZQBlock)(void);

- (void)block {
    // 不去调用block不会执行
    void (^block)(void) = ^{
        NSLog(@"This is a block");
    };
    block();
    
    void (^block2)(int, int) = ^(int a, int b){
        NSLog(@"-->%d, %d", a, b);
    };
    block2(10, 20);
    
    int age = 10;
    // block创建时已经将auto变量10捕获了
    void (^block3)(void) = ^{
        NSLog(@"-->%d", age);  // 10
    };
    age = 20;
    block3();
    
    static int height = 30;
    void (^block4)(void) = ^{
        NSLog(@"-->%d", height);
    };
    height = 40;
    block4();
    
    void (^block5)(void) = ^{
        NSLog(@"-->%d, %d, %d", age_, height_, height);
    };
    age_ = 200;
    height_ = 400;
    block5();
    
    NSLog(@"%@", [block5 class]);
    NSLog(@"%@", [[block5 class] superclass]);
    NSLog(@"%@", [[[block5 class] superclass] superclass]);
    NSLog(@"%@", [[[[block5 class] superclass] superclass] superclass]);
    
    NSLog(@"%@", [block3 class]);
    NSLog(@"%@", [^{NSLog(@"age:%d", age);} class]);
    
    NSLog(@"----------");
    
    XZQBlock block6;
    // block强引用person，离开作用域只要block不释放person就不释放（这里的释放指的是类似release的操作）
    {
        XZQPerson_block *person = [[XZQPerson_block alloc] init];
        person.age = 10;
        block6 = ^{
            NSLog(@"-->%d", person.age);
        };
    }
    block6();
    
    NSLog(@"----------");
    
    XZQBlock block7;
    // block弱引用person，离开作用域即使block不释放person也会释放（这里的释放指的是类似release的操作）
    {
        XZQPerson_block *person = [[XZQPerson_block alloc] init];
        __weak XZQPerson_block *person2 = person;
        person2.age = 10;
        block7 = ^{
            NSLog(@"-->%d", person2.age);
        };
    }
    block7();
    
    NSLog(@"----------");
    
    age = 10;
    __block int weight1 = 10;  // 这个变量还是auto
    static int weight2 = 20;
    XZQPerson_block *p = [[XZQPerson_block alloc] init];
    
    XZQBlock block8 = ^{
        p.age = 2000;
        // age = 20; 不能改
        weight1 = 30;
        weight2 = 40;
        NSLog(@"-->%d, %d, %d", age, weight1, weight2);
    };
    block8();
    NSLog(@"-->%d", weight1);
    NSLog(@"-->%d", p.age);
    
    NSLog(@"----------");
    
    XZQPerson_block *xp = [[XZQPerson_block alloc] init];
    xp.age = 10;
    // __weak：不会产生强引用。指向的对象销毁时会自动让指针置为nil
    // __unsafe_unretained：不会产生强引用，不安全。指向的对象销毁时，指针指向的地址值不变
//    __unsafe_unretained typeof(xp) weakXP = xp;
    __weak typeof(xp) weakXP = xp;
    xp.block = ^{
        // 若block与对象之间都是强引用则会产生循环引用
        // NSLog(@"age is %d", xp.age);
        NSLog(@"age is %d", weakXP.age);
    };
    xp.block();
    
    NSLog(@"----------");
        
    __block XZQPerson_block *xp2 = [[XZQPerson_block alloc] init];
    xp2.age = 10;
    xp2.block = ^{
        NSLog(@"age is %d", xp2.age);
        // 必须要清空__block
        xp2 = nil;
    };
    // 必须要调用block
    xp2.block();
    
}

- (void)category {
    // 通过Runtime机制动态将分类的对象方法和类方法加入到对应的class对象和meta-class对象中
    XZQPerson_Category *person = [[XZQPerson_Category alloc] init];
    [person run];
    [person test];
    [person eat];

    [self printMethodNamesOfClass:object_getClass([XZQPerson_Category class])];
    
    // 子类会先调用父类的initialize
    [XZQStudent_Category alloc];
    
    NSLog(@"-------------");
    
    person.weight = 20;
    XZQPerson_Category *person2 = [[XZQPerson_Category alloc] init];
    person2.weight = 30;
    NSLog(@"-->%d, %d", person.weight, person2.weight);
}

- (void)kvc {
    /*
    XZQPerson_KVC *person = [[XZQPerson_KVC alloc] init];
    [person setValue:@10 forKey:@"age"];
    NSLog(@"forKey: %d", person.age);
    [person setValue:@20 forKeyPath:@"age"];
    NSLog(@"forKeyPath: %d", person.age);

    person.cat = [[XZQCat alloc] init];
    // [person setValue:@10 forKey:@"cat.weight"];不成功
    [person setValue:@10 forKeyPath:@"cat.weight"];
    NSLog(@"forKeyPath(cat.weight): %d", person.cat.weight);
     */
    
    XZQPerson_KVC *person = [[XZQPerson_KVC alloc] init];
    // 添加KVO监听
    [person addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    // 通过KVC修改age属性
    [person setValue:@10 forKey:@"age"];  // setAge:
}

- (void)kvo {
    self.person1 = [[XZQPerson alloc] init];
    self.person1.age = 1;
    self.person1.height = 11;
    
    self.person2 = [[XZQPerson alloc] init];
    self.person2.age = 2;
    self.person2.height = 22;
    
    NSLog(@"person1添加KVO之前 - %@ %@", object_getClass(self.person1), object_getClass(self.person2));
    NSLog(@"person1添加KVO之前 - %p %p", [self.person1 methodForSelector:@selector(setAge:)], [self.person2 methodForSelector:@selector(setAge:)]);
    NSLog(@"person1添加KVO之前类对象 - %@ %@", object_getClass(self.person1), object_getClass(self.person2));
    
    // 给person1添加KVO对象
    char *context;
    [self.person1 addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:&context];
    [self.person1 addObserver:self forKeyPath:@"height" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    NSLog(@"person1添加KVO之后 - %@ %@", object_getClass(self.person1), object_getClass(self.person2));
    NSLog(@"person1添加KVO之后 - %p %p", [self.person1 methodForSelector:@selector(setAge:)], [self.person2 methodForSelector:@selector(setAge:)]);
    NSLog(@"person1添加KVO之后类对象 - %@ %@", object_getClass(self.person1), object_getClass(self.person2));
    
    NSLog(@"类对象 - %p %p", object_getClass(self.person1), object_getClass(self.person2));
    NSLog(@"元类对象 - %p %p", object_getClass(object_getClass(self.person1)), object_getClass(object_getClass(self.person2)));
    
    [self printMethodNamesOfClass:object_getClass(self.person1)];
    [self printMethodNamesOfClass:object_getClass(self.person2)];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // self.person1->isa：NSKVONotifying_XZQPerson（Runtime动态创建的类，是XZQPerson的子类）
    // self.person2->isa：XZQPerson
    
    self.person1.age = 21;
    self.person1.height = 30;
    
    self.person2.age = 22;
    self.person2.height = 30;
}

// 当监听对象的属性值发生改变时就会调用
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"监听到%@的%@属性值改变了 - %@", object, keyPath, change);
    NSLog(@"context-->%@", context);
}

- (void)dealloc {
    [self.person1 removeObserver:self forKeyPath:@"age"];
    [self.person1 removeObserver:self forKeyPath:@"height"];
}

/**
 OC对象的本质
 */
- (void)object_benzhi {
    // 获得NSObject类的实例对象的成员变量所占用的大小
    NSLog(@"-->%zd", class_getInstanceSize([NSObject class]));
    // 获得obj指针所指向内存的大小
    NSObject *obj = [[NSObject alloc] init];
    NSLog(@"-->%zd", malloc_size((__bridge const void *)obj));
    
    Student *student = [[Student alloc] init];
    student->_no = 4;
    student->_age = 5;
    NSLog(@"-->%zd", class_getInstanceSize([Student class]));
    NSLog(@"-->%zd", malloc_size((__bridge const void *)student));
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 100, 100)];
    image.image = [UIImage imageNamed:@"female_icon"];
    [self.view addSubview:image];
}

/**
 OC对象的分类
 */
- (void)object_fenlei {
    NSObject *obj1 = [[NSObject alloc] init];
    NSObject *obj2 = [[NSObject alloc] init];
    NSLog(@"%p, %p", obj1, obj2);
    
    // 类对象(一个类的类对象在内存中只有一份)
    // 下面5个的内存地址是一样的
    Class objClass1 = [obj1 class];
    Class objClass2 = [obj2 class];
    Class objClass3 = object_getClass(obj1);
    Class objClass4 = object_getClass(obj2);
    Class objClass5 = [NSObject class];
    NSLog(@"%p, %p, %p, %p, %p", objClass1, objClass2, objClass3, objClass4, objClass5);
    
    // 元类对象
    // 将类对象传入获取元对象
    Class objMetaClass = object_getClass([NSObject class]);
    NSLog(@"%p", objMetaClass);
    
    NSLog(@"-->%d", class_isMetaClass(objClass1));  // 0
    NSLog(@"-->%d", object_isClass(objClass1));  // 1
    NSLog(@"-->%d", class_isMetaClass(objMetaClass));  // 1
    NSLog(@"-->%d", object_isClass(objMetaClass));  // 1
    
    /**
     
     // 传入的可能是instance对象、class对象、meta-class对象
     // 返回对应的class对象、meta-class对象、NSObject的meta-class对象
     Class object_getClass(id obj)
     {
        // 如果是instance对象，返回class对象
        // 如果是class对象，返回meta-class对象
        // 如果是meta-class对象，返回NSObject的meta-class对象
        if (obj) return obj-getIsa();
        else return Nil;
     }
     
     // 传入字符串类名
     // 返回对应的类对象
     Class objc_getClass(const char *aClassName)
     {
        // 根据类名返回类对象
        if (!aClassName) return Nil;
        return look_up_class(aClassName, NO, YES);
     }
     
     // 返回的就是类对象
     - (Class)class {
        return self->isa;
     }
     + (Class)class {
        return self;
     }
     
     */
    
    Student *student = [[Student alloc] init];
    student->_no = 4;
    // objc_msgSend(student, @selector(studentInstanceMethod))
    [student studentInstanceMethod];
    // objc_msgSend([Student class], @selector(studentClassMethod))
    [Student studentClassMethod];
    
    NSLog(@"%p, %p", object_getClass(student), [student class]);
}

@end
