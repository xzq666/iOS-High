//
//  XZQMutexDemo.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/8.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQMutexDemo.h"
#import <pthread.h>

@interface XZQMutexDemo ()

@property(nonatomic,assign) pthread_mutex_t ticketMutex;
@property(nonatomic,assign) pthread_mutex_t moneyMutex;

@end

@implementation XZQMutexDemo

- (void)initMutex:(pthread_mutex_t *)mutex {
    // 初始化锁的属性
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_DEFAULT);
    // 初始化锁
    pthread_mutex_init(mutex, &attr);
    // 销毁资源
    pthread_mutexattr_destroy(&attr);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initMutex:&_ticketMutex];
        [self initMutex:&_moneyMutex];
    }
    return self;
}

- (void)__saleTicket {
    pthread_mutex_lock(&_ticketMutex);
    [super __saleTicket];
    pthread_mutex_unlock(&_ticketMutex);
}

- (void)__saveMoney {
    pthread_mutex_lock(&_moneyMutex);
    [super __saveMoney];
    pthread_mutex_unlock(&_moneyMutex);
}

- (void)__drawMoney {
    pthread_mutex_lock(&_moneyMutex);
    [super __drawMoney];
    pthread_mutex_unlock(&_moneyMutex);
}

- (void)dealloc
{
    pthread_mutex_destroy(&_moneyMutex);
    pthread_mutex_destroy(&_ticketMutex);
}

@end
