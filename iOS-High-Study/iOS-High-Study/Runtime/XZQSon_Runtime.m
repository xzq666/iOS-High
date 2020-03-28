//
//  XZQSon_Runtime.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/3/26.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQSon_Runtime.h"

@implementation XZQSon_Runtime

- (void)sonTest {
    NSLog(@"%s", __func__);
}

+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(test:)) {
        return [NSMethodSignature signatureWithObjCTypes:"v20@0:8i16"];
    }
    return [super methodSignatureForSelector:aSelector];
}

+ (void)forwardInvocation:(NSInvocation *)anInvocation {
    int age;
    // 参数顺序：receiver、selector、other arguments
    [anInvocation getArgument:&age atIndex:2];
    NSLog(@"age is %d", age);
}

@end
