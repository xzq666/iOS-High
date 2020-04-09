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

@interface ThreadVC ()

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
    
    XZQSynchronizedDemo *synchronized = [[XZQSynchronizedDemo alloc] init];
    [synchronized ticketTest];
    [synchronized moneyTest];
}

@end
