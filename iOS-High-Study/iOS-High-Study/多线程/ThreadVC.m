//
//  ThreadVC.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/7.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "ThreadVC.h"
#import "XZQOSSpinLockDemo.h"

@interface ThreadVC ()

@end

@implementation ThreadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    XZQOSSpinLockDemo *osSpinLock = [[XZQOSSpinLockDemo alloc] init];
    [osSpinLock ticketTest];
    [osSpinLock moneyTest];
}

@end
