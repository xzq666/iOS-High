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
    [self runtime];
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
    [self.person1 addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"123"];
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
