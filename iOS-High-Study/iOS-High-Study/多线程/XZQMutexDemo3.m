//
//  XZQMutexDemo3.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/8.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQMutexDemo3.h"
#import <pthread.h>

@interface XZQMutexDemo3 ()

@property(nonatomic,assign) pthread_mutex_t mutex;
@property(nonatomic,assign) pthread_cond_t cond;

@property(nonatomic,strong) NSMutableArray *data;

@end

@implementation XZQMutexDemo3

- (instancetype)init
{
    self = [super init];
    if (self) {
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
        // 初始化条件
        pthread_cond_init(&_cond, NULL);
        pthread_mutex_init(&_mutex, &attr);
        pthread_mutexattr_destroy(&attr);
        
        self.data = [NSMutableArray array];
    }
    return self;
}

- (void)otherTest {
    [[[NSThread alloc] initWithTarget:self selector:@selector(__remove) object:nil] start];
    [[[NSThread alloc] initWithTarget:self selector:@selector(__add) object:nil] start];
}

- (void)__add {
    pthread_mutex_lock(&_mutex);
    [self.data addObject:@"1"];
    NSLog(@"添加了元素");
    // 添加元素后通知条件成立
    pthread_cond_signal(&_cond);
    pthread_mutex_unlock(&_mutex);
}

- (void)__remove {
    pthread_mutex_lock(&_mutex);
    // 添加条件，只有当数组中有值时才能删
    if (self.data.count == 0) {
        // 数组中没元素时等待并放开锁
        pthread_cond_wait(&_cond, &_mutex);
    }
    [self.data removeLastObject];
    NSLog(@"删除了元素");
    pthread_mutex_unlock(&_mutex);
}

- (void)dealloc
{
    pthread_mutex_destroy(&_mutex);
    pthread_cond_destroy(&_cond);
}

@end
