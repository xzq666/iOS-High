//
//  XZQProxyExtendsNSProxy.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/10.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQProxyExtendsNSProxy.h"

@implementation XZQProxyExtendsNSProxy

+ (id)initWithTarget:(id)target {
    // NSProxy的子类不需要调用init，NSProxy本身就没有init
    XZQProxyExtendsNSProxy *proxy = [XZQProxyExtendsNSProxy alloc];
    proxy.target = target;
    return proxy;
}

/*
 NSProxy的子类在方法找不到时不会去父类中寻找，也不会经过动态方法解析，而是直接走消息转发阶段的方法签名
 NSProxy不提供forwardingTargetForSelector方法
 */

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:self.target];
}

@end
