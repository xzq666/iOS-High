//
//  UIControl+Extension.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/1.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "UIControl+Extension.h"
#import <objc/runtime.h>

@implementation UIControl (Extension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method method1 = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
        Method method2 = class_getInstanceMethod(self, @selector(xzq_sendAction:to:forEvent:));
        // 交换method_t中的IMP同时清空方法缓存
        method_exchangeImplementations(method1, method2);
    });
}

- (void)xzq_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    NSLog(@"%@ - %@ - %@", self, target, NSStringFromSelector(action));
//    [target performSelector:action];
    // 因为方法已经交换，因此调用原来的sendAction需要使用xzq_sendAction
    [self xzq_sendAction:action to:target forEvent:event];
//    if ([self isKindOfClass:[UIButton class]]) {
//        // 拦截了所有的按钮事件
//    }
}

@end
