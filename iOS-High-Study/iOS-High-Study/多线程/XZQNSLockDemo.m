//
//  XZQNSLockDemo.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/8.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQNSLockDemo.h"

@interface XZQNSLockDemo ()

@property(nonatomic,strong) NSLock *ticketLock;
@property(nonatomic,strong) NSLock *moneyLock;

@end

@implementation XZQNSLockDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ticketLock = [[NSLock alloc] init];
        self.moneyLock = [[NSLock alloc] init];
    }
    return self;
}

- (void)__saleTicket {
    [self.ticketLock lock];
    [super __saleTicket];
    [self.ticketLock unlock];
}

- (void)__saveMoney {
    [self.moneyLock lock];
    [super __saveMoney];
    [self.moneyLock unlock];
}

- (void)__drawMoney {
    [self.moneyLock lock];
    [super __drawMoney];
    [self.moneyLock unlock];
}

@end
