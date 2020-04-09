//
//  XZQSeriesQueueDemo.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/9.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQSeriesQueueDemo.h"

@interface XZQSeriesQueueDemo ()

@property(nonatomic,strong) dispatch_queue_t ticketQueue;
@property(nonatomic,strong) dispatch_queue_t moneyQueue;

@end

@implementation XZQSeriesQueueDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ticketQueue = dispatch_queue_create("ticketQueue", DISPATCH_QUEUE_SERIAL);
        self.moneyQueue = dispatch_queue_create("moneyQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)__saleTicket {
    dispatch_sync(self.ticketQueue, ^{
        [super __saleTicket];
    });
}

- (void)__drawMoney {
    dispatch_sync(self.moneyQueue, ^{
        [super __drawMoney];
    });
}

- (void)__saveMoney {
    dispatch_sync(self.moneyQueue, ^{
        [super __saveMoney];
    });
}

@end
