//
//  XZQPerson_Category+Test.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/3/16.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQPerson_Category+Test.h"
#import <objc/runtime.h>

@implementation XZQPerson_Category (Test)

/* 方式一：static const void *XZQWeightKey = &XZQWeightKey;
- (void)setWeight:(int)weight {
    objc_setAssociatedObject(self, XZQWeightKey, @(weight), OBJC_ASSOCIATION_ASSIGN);
}

- (int)weight {
    return [objc_getAssociatedObject(self, XZQWeightKey) intValue];
} */

/* 方式二
static const char XZQWeightKey;

- (void)setWeight:(int)weight {
    objc_setAssociatedObject(self, &XZQWeightKey, @(weight), OBJC_ASSOCIATION_ASSIGN);
}

- (int)weight {
    return [objc_getAssociatedObject(self, &XZQWeightKey) intValue];
} */

/* 方式三

#define XZQWeightKey @"weight"

- (void)setWeight:(int)weight {
    objc_setAssociatedObject(self, XZQWeightKey, @(weight), OBJC_ASSOCIATION_ASSIGN);
}

- (int)weight {
    return [objc_getAssociatedObject(self, XZQWeightKey) intValue];
} */

// 方式四
- (void)setWeight:(int)weight {
    // _cmd相当于@selector(setWeight:)，这里不使用
    objc_setAssociatedObject(self, @selector(weight), @(weight), OBJC_ASSOCIATION_ASSIGN);
}

- (int)weight {
    // 这里的_cmd相当于@selector(weight)
    return [objc_getAssociatedObject(self, _cmd) intValue];
}

+ (void)initialize {
    NSLog(@"XZQPerson_Category Test +initialize");
}

+ (void)load {
    NSLog(@"XZQPerson_Category Test +load");
}

- (void)run {
    NSLog(@"run-test");
}

- (void)test {
    NSLog(@"test");
}

@end
