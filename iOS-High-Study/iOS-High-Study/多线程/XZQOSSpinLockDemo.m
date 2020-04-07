//
//  XZQOSSpinLockDemo.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/7.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQOSSpinLockDemo.h"
#import <libkern/OSAtomic.h>

@interface XZQOSSpinLockDemo ()

@property(nonatomic,assign) OSSpinLock ticketLock;
@property(nonatomic,assign) OSSpinLock moneyLock;

@end

@implementation XZQOSSpinLockDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            self.ticketLock = OS_SPINLOCK_INIT;
            self.moneyLock = OS_SPINLOCK_INIT;
        });
    }
    return self;
}

- (void)__drawMoney {
    // 加锁
    OSSpinLockLock(&_moneyLock);
    
    [super __drawMoney];
    
    // 解锁
    OSSpinLockUnlock(&_moneyLock);
}

- (void)__saveMoney {
    // 加锁
    OSSpinLockLock(&_moneyLock);
    
    [super __saveMoney];
    
    // 解锁
    OSSpinLockUnlock(&_moneyLock);
}

- (void)__saleTicket {
    // 加锁
    OSSpinLockLock(&_ticketLock);
    
    [super __saleTicket];
    
    // 解锁
    OSSpinLockUnlock(&_ticketLock);
}

@end
