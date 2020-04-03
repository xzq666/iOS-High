//
//  PermenantThreadVC.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/3.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "PermenantThreadVC.h"
#import "XZQPermenantThread.h"

@interface PermenantThreadVC ()

@property(nonatomic,strong) XZQPermenantThread *thread;

@end

@implementation PermenantThreadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 200, 100, 40);
    [btn setTitle:@"test" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stopBtn.frame = CGRectMake(140, 200, 100, 40);
    [stopBtn setTitle:@"stop" forState:UIControlStateNormal];
    [self.view addSubview:stopBtn];
    [stopBtn addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    
    self.thread = [[XZQPermenantThread alloc] init];
    [self.thread run];
}

- (void)test {
    [self.thread executeTask:^{
        NSLog(@"执行任务 - %@", [NSThread currentThread]);
    }];
}

- (void)stop {
    [self.thread stop];
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

@end
