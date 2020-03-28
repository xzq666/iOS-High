//
//  XZQFather_Runtime.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/3/26.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQFather_Runtime.h"
#import <objc/runtime.h>

#import "XZQPerson_Runtime.h"

@implementation XZQFather_Runtime

- (void)fatherTest {
    NSLog(@"%s", __func__);
}

/* ****  动态方法解析  **** */

void c_other(id self, SEL _cmd)
{
    NSLog(@"c_other %@ - %@", self, NSStringFromSelector(_cmd));
}

//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    if (sel == @selector(test)) {
//        // 添加动态方法
//        class_addMethod(self, sel, (IMP)c_other, "v16@0:8");
//        // YES表示有动态方法添加
//        return YES;
//    }
//    return [super resolveInstanceMethod:sel];
//}

+ (BOOL)resolveClassMethod:(SEL)sel {
    if (sel == @selector(test)) {
        // 类方法需要添加到元类对象中
        class_addMethod(object_getClass(self), sel, (IMP)c_other, "v16@0:8");
    }
    return [super resolveClassMethod:sel];
}

//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    if (sel == @selector(test)) {
//        // 添加动态方法
//        Method method = class_getInstanceMethod(self, @selector(fatherTest));
//        class_addMethod(self, sel, method_getImplementation(method), method_getTypeEncoding(method));
//        // YES表示有动态方法添加
//        return YES;
//    }
//    return [super resolveInstanceMethod:sel];
//}

//struct method_t {
//    SEL sel;
//    char *types;
//    IMP imp;
//};

//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    if (sel == @selector(test)) {
//        // 添加动态方法
//        struct method_t *method = (struct method_t *)class_getInstanceMethod(self, @selector(fatherTest));
//        class_addMethod(self, sel, method->imp, method->types);
//        // YES表示有动态方法添加
//        return YES;
//    }
//    return [super resolveInstanceMethod:sel];
//}

/* ****  消息转发  **** */

//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    if (aSelector == @selector(test)) {
//        return [[XZQPerson_Runtime alloc] init];
//    }
//    return [super forwardingTargetForSelector:aSelector];
//}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(test)) {
        return nil;
    }
    return [super forwardingTargetForSelector:aSelector];
}
// 方法签名：返回值类型、参数类型
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(test)) {
        return [NSMethodSignature signatureWithObjCTypes:"v16@0:8"];
    }
    return [super methodSignatureForSelector:aSelector];
}
// NSInvocation封装了一个方法调用，包括方法调用者、方法名和方法参数
// anInvocation.target：方法调用者
// anInvocation.selector：方法名
// anInvocation getArgument: atIndex:
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [anInvocation invokeWithTarget:[[XZQPerson_Runtime alloc] init]];
}

@end
