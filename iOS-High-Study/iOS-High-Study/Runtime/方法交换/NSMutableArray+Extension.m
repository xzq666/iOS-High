//
//  NSMutableArray+Extension.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/1.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "NSMutableArray+Extension.h"
#import <objc/runtime.h>

@implementation NSMutableArray (Extension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 类簇：NSString、NSArray、NSDictionary，真实类型是其他类型
        NSLog(@"-->%@", self);
        Class cls = NSClassFromString(@"__NSArrayM");
        Method method1 = class_getInstanceMethod(cls, @selector(insertObject:atIndex:));
        Method method2 = class_getInstanceMethod(cls, @selector(xzq_insertObject:atIndex:));
        method_exchangeImplementations(method1, method2);
    });
}

- (void)xzq_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (anObject == nil) {
        return;
    }
    [self xzq_insertObject:anObject atIndex:index];
}

@end
