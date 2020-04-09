//
//  XZQSynchronizedDemo.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/9.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQSynchronizedDemo.h"

@interface XZQSynchronizedDemo ()

@end

@implementation XZQSynchronizedDemo

- (void)__saleTicket {
    static NSLock *lock;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lock = [[NSLock alloc] init];
    });
    @synchronized (lock) {
        [super __saleTicket];
    }
}

- (void)__saveMoney {
    @synchronized (self) {
        [super __saveMoney];
    }
}

- (void)__drawMoney {
    @synchronized (self) {
        [super __drawMoney];
    }
}

@end
