//
//  XZQMutexDemo2.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/8.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQMutexDemo2.h"
#import <pthread.h>

@interface XZQMutexDemo2 ()

@property(nonatomic,assign) pthread_mutex_t mutex;

@end

@implementation XZQMutexDemo2

- (void)initMutex:(pthread_mutex_t *)mutex {
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);  // 递归锁：允许同一线程加多把锁
    pthread_mutex_init(mutex, &attr);
    pthread_mutexattr_destroy(&attr);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initMutex:&_mutex];
    }
    return self;
}

- (void)otherTest {
    pthread_mutex_lock(&_mutex);
    NSLog(@"%s", __func__);
    static int count = 0;
    if (count < 10) {
        count++;
        [self otherTest];
    }
    pthread_mutex_unlock(&_mutex);
}

- (void)dealloc
{
    pthread_mutex_destroy(&_mutex);
}

@end
