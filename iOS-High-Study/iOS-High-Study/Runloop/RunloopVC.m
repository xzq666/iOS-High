//
//  RunloopVC.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/2.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "RunloopVC.h"
#import "XZQThread.h"

@interface RunloopVC ()

@property(nonatomic,strong) XZQThread *thread;
@property(nonatomic,assign, getter=isStopped) BOOL stopped;

@end

@implementation RunloopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.stopped = NO;
//    self.thread = [[XZQThread alloc] initWithTarget:self selector:@selector(run_runloop) object:nil];
    __weak typeof(self) weakSelf = self;
    self.thread = [[XZQThread alloc] initWithBlock:^{
        NSLog(@"%@ - begin", [NSRunLoop currentRunLoop]);
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
        // NSRunLoop的run方法是无法停止的，它专门用于开启一个永不销毁的线程
//        [[NSRunLoop currentRunLoop] run];
        // 自己实现类似run方法的功能，但是可控制停止
        while (!weakSelf.isStopped) {
            // [NSDate distantFuture]表示很久很久以后，可以看成不会因为休眠太久而停止
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        NSLog(@"%@ - end", [NSThread currentThread]);
    }];
    [self.thread start];
    
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
}

// 这个方法的目的是线程保活
- (void)run_runloop {
    NSLog(@"%s - %@", __func__, [NSThread currentThread]);
    [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
    NSLog(@"%s - end", __func__);
}

// 这个方法是子线程需要执行的任务
- (void)test_runloop {
    NSLog(@"%s - %@", __func__, [NSThread currentThread]);
}

- (void)test {
    [self performSelector:@selector(test_runloop) onThread:self.thread withObject:nil waitUntilDone:NO];
}

- (void)stop {
    [self performSelector:@selector(stop_runloop) onThread:self.thread withObject:nil waitUntilDone:NO];
}

// 用于停止子线程的RunLoop
- (void)stop_runloop {
    // 设置标记
    self.stopped = YES;
    // 停止RunLoop
    CFRunLoopStop(CFRunLoopGetCurrent());
    NSLog(@"%s - %@", __func__, [NSThread currentThread]);
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    [self stop_runloop];
}

@end
