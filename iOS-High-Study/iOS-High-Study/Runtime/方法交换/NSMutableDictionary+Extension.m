//
//  NSMutableDictionary+Extension.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/1.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "NSMutableDictionary+Extension.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary (Extension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = NSClassFromString(@"__NSDictionaryM");
        Method method1 = class_getInstanceMethod(cls, @selector(setObject:forKeyedSubscript:));
        Method method2 = class_getInstanceMethod(cls, @selector(xzq_setObject:forKeyedSubscript:));
        method_exchangeImplementations(method1, method2);
    });
}

- (void)xzq_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    if (!key) {
        return;
    }
    [self xzq_setObject:obj forKeyedSubscript:key];
}

@end
