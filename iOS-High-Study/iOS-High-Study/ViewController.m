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
    [self category];
}

- (void)category {
    // 通过Runtime机制动态将分类的对象方法和类方法加入到对应的class对象和meta-class对象中
    XZQPerson_Category *person = [[XZQPerson_Category alloc] init];
    [person run];
    [person test];
    [person eat];
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
