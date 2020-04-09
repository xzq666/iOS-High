//
//  XZQSemaphoreDemo.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/9.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQSemaphoreDemo.h"

@interface XZQSemaphoreDemo ()

@property(nonatomic,strong) dispatch_semaphore_t semaphore;

@property(nonatomic,strong) dispatch_semaphore_t semaphoreTicket;
@property(nonatomic,strong) dispatch_semaphore_t semaphoreMoney;

@end

@implementation XZQSemaphoreDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.semaphore = dispatch_semaphore_create(5);
        self.semaphoreTicket = dispatch_semaphore_create(1);
        self.semaphoreMoney = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)__saleTicket {
    dispatch_semaphore_wait(self.semaphoreTicket, DISPATCH_TIME_FOREVER);
    [super __saleTicket];
    dispatch_semaphore_signal(self.semaphoreTicket);
}

- (void)__saveMoney {
    dispatch_semaphore_wait(self.semaphoreMoney, DISPATCH_TIME_FOREVER);
    [super __saveMoney];
    dispatch_semaphore_signal(self.semaphoreMoney);
}

- (void)__drawMoney {
    dispatch_semaphore_wait(self.semaphoreMoney, DISPATCH_TIME_FOREVER);
    [super __drawMoney];
    dispatch_semaphore_signal(self.semaphoreMoney);
}

- (void)otherTest {
    for (int i = 0; i < 10; i++) {
        [[[NSThread alloc] initWithTarget:self selector:@selector(test) object:nil] start];
    }
}

- (void)test {
    // 如果信号量的值>0，就让信号量的值减1，并继续往下执行代码
    // 如果信号量的值<=0，就休眠等待，直到信号量的值>0，才继续往下执行代码
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    
    sleep(2);
    NSLog(@"test - %@", [NSThread currentThread]);
    
    // 让信号量的值+1
    dispatch_semaphore_signal(self.semaphore);
}

@end
