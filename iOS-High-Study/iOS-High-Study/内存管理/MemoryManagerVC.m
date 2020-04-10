//
//  MemoryManagerVC.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/10.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "MemoryManagerVC.h"
#import "XZQProxy.h"
#import "XZQProxyExtendsNSProxy.h"

@interface MemoryManagerVC ()

@property(nonatomic,strong) CADisplayLink *link;
@property(nonatomic,strong) NSTimer *timer;

@end

@implementation MemoryManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 保证调用频率和屏幕的刷帧频率一致，60FPS
//    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(linkTest)];
//    self.link = [CADisplayLink displayLinkWithTarget:[XZQProxy initWithTarget:self] selector:@selector(linkTest)];
//    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    // NSTimer对target产生强引用，target又对NSTimer产生强引用，会引发循环引用
    // self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTest) userInfo:nil repeats:YES];
    
    // 解决1
//    __weak typeof(self) weakSelf = self;
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        [weakSelf timerTest];
//    }];
    
    // 解决2
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:[XZQProxy initWithTarget:self] selector:@selector(timerTest) userInfo:nil repeats:YES];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:[XZQProxyExtendsNSProxy initWithTarget:self] selector:@selector(timerTest) userInfo:nil repeats:YES];
}

- (void)linkTest {
    NSLog(@"%s", __func__);
}

- (void)timerTest {
    NSLog(@"%s", __func__);
}

- (void)dealloc
{
    [self.link invalidate];
    [self.timer invalidate];
    NSLog(@"%s", __func__);
}

@end
