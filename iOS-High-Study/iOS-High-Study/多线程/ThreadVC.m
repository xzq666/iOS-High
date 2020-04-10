//
//  ThreadVC.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/7.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "ThreadVC.h"
#import "XZQOSSpinLockDemo.h"
#import "XZQOSUnfairLockDemo.h"
#import "XZQMutexDemo.h"
#import "XZQMutexDemo2.h"
#import "XZQMutexDemo3.h"
#import "XZQNSLockDemo.h"
#import "XZQNSConditionDemo.h"
#import "XZQNSConditionLockDemo.h"
#import "XZQSeriesQueueDemo.h"
#import "XZQSemaphoreDemo.h"
#import "XZQSynchronizedDemo.h"

#import <pthread.h>

@interface ThreadVC ()

@property(nonatomic,assign) pthread_rwlock_t rwlock;

@property(nonatomic,strong) dispatch_queue_t queue;

@end

@implementation ThreadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    XZQOSSpinLockDemo *osSpinLock = [[XZQOSSpinLockDemo alloc] init];
//    [osSpinLock ticketTest];
//    [osSpinLock moneyTest];
    
//    XZQOSUnfairLockDemo *osUnfairLock = [[XZQOSUnfairLockDemo alloc] init];
//    [osUnfairLock ticketTest];
//    [osUnfairLock moneyTest];
    
//    XZQMutexDemo *mutex = [[XZQMutexDemo alloc] init];
//    [mutex ticketTest];
//    [mutex moneyTest];
    
//    XZQMutexDemo2 *mutex = [[XZQMutexDemo2 alloc] init];
//    [mutex otherTest];
    
//    XZQMutexDemo3 *mutex = [[XZQMutexDemo3 alloc] init];
//    [mutex otherTest];
    
//    XZQNSLockDemo *nslock = [[XZQNSLockDemo alloc] init];
//    [nslock ticketTest];
//    [nslock moneyTest];
    
//    XZQNSConditionDemo *condition = [[XZQNSConditionDemo alloc] init];
//    [condition otherTest];
    
//    XZQNSConditionLockDemo *conditionLock = [[XZQNSConditionLockDemo alloc] init];
//    [conditionLock otherTest];
    
//    XZQSeriesQueueDemo *seriesQueue = [[XZQSeriesQueueDemo alloc] init];
//    [seriesQueue ticketTest];
//    [seriesQueue moneyTest];
    
//    XZQSemaphoreDemo *semaphore = [[XZQSemaphoreDemo alloc] init];
////    [semaphore otherTest];
//    [semaphore ticketTest];
//    [semaphore moneyTest];
    
//    XZQSynchronizedDemo *synchronized = [[XZQSynchronizedDemo alloc] init];
//    [synchronized ticketTest];
//    [synchronized moneyTest];
    
    /* 读写锁
    pthread_rwlock_init(&_rwlock, NULL);
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    for (int i = 0; i < 10; i++) {
        dispatch_async(queue, ^{
            [self read];
        });
        
        dispatch_async(queue, ^{
            [self write];
        });
    }
     */
    
    /*
     dispatch_barrier_async
     */
    self.queue = dispatch_queue_create("rwQueue", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i < 5; i++) {
        [self read2];
        [self read2];
        [self write2];
        [self write2];
    }
    
}

/*
 使用信号量dispatch_semaphore会使无论是读还是写同一时间都只能有一条线程，但实际应用中我们应该同时允许多条线程读或多条线程写，只需确保同一时间没有读和写一起执行即可。
 一般我们会要求多读单写
 */

- (void)read {
    pthread_rwlock_rdlock(&_rwlock);
    
    sleep(1);
    NSLog(@"%s - %@", __func__, [NSThread currentThread]);
    
    pthread_rwlock_unlock(&_rwlock);
}

- (void)write {
    pthread_rwlock_wrlock(&_rwlock);
    
    sleep(1);
    NSLog(@"%s - %@", __func__, [NSThread currentThread]);
    
    pthread_rwlock_unlock(&_rwlock);
}

- (void)read2 {
    dispatch_async(self.queue, ^{
        sleep(1);
        NSLog(@"read");
    });
}

- (void)write2 {
    dispatch_barrier_sync(self.queue, ^{
        sleep(1);
        NSLog(@"write");
    });
}

- (void)dealloc
{
    pthread_rwlock_destroy(&_rwlock);
}

@end
