//
//  OSUnfairLockDemo.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/8.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQOSUnfairLockDemo.h"
#import <os/lock.h>

@interface XZQOSUnfairLockDemo ()

@property(nonatomic,assign) os_unfair_lock ticketLock;
@property(nonatomic,assign) os_unfair_lock moneyLock;

@end

@implementation XZQOSUnfairLockDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ticketLock = OS_UNFAIR_LOCK_INIT;
        self.moneyLock = OS_UNFAIR_LOCK_INIT;
    }
    return self;
}

- (void)__saleTicket {
    os_unfair_lock_lock(&_ticketLock);
    [super __saleTicket];
    os_unfair_lock_unlock(&_ticketLock);
}

- (void)__saveMoney {
    os_unfair_lock_lock(&_moneyLock);
    [super __saveMoney];
    os_unfair_lock_unlock(&_moneyLock);
}

- (void)__drawMoney {
    os_unfair_lock_lock(&_moneyLock);
    [super __drawMoney];
    os_unfair_lock_unlock(&_moneyLock);
}

@end
