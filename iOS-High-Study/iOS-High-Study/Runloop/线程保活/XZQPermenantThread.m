//
//  XZQPermenantThread.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/3.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQPermenantThread.h"

/* NSThread */
@interface XZQNSThread : NSThread
@end
@implementation XZQNSThread
- (void)dealloc
{
    NSLog(@"%s", __func__);
}
@end

@interface XZQPermenantThread ()

@property(nonatomic,strong) XZQNSThread *innerThread;
@property(nonatomic,assign, getter=isStopped) BOOL stopped;

@end

@implementation XZQPermenantThread

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.stopped = NO;
        __weak typeof(self) weakSelf = self;
        self.innerThread = [[XZQNSThread alloc] initWithBlock:^{
            [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
            while (weakSelf && !weakSelf.isStopped) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
        }];
    }
    return self;
}

#pragma mask - public method

/*
 开启一个线程
 */
- (void)run {
    if (!self.innerThread) {
        return;
    }
    [self.innerThread start];
}

/*
 执行一个任务
 */
- (void)executeTask:(XZQPermenantTask)task {
    if (!self.innerThread || !task) {
        return;
    }
    [self performSelector:@selector(__executeTask:) onThread:self.innerThread withObject:task waitUntilDone:NO];
}

/*
 结束一个线程
 */
- (void)stop {
    if (!self.innerThread) {
        return;
    }
    [self performSelector:@selector(__stop) onThread:self.innerThread withObject:nil waitUntilDone:YES];
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
    [self stop];
}

#pragma mask - private method

- (void)__stop {
    self.stopped = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.innerThread = nil;
}

- (void)__executeTask:(XZQPermenantTask)task {
    task();
}

@end
