//
//  GCDTimer.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/11.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "GCDTimerVC.h"
#import "XZQGCDTimer.h"

@interface GCDTimerVC ()

@property(nonatomic,strong) dispatch_source_t timer;

@property(nonatomic,copy) NSString *taskName;

@end

@implementation GCDTimerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 100, 300, 50)];
    textView.backgroundColor = [UIColor systemGrayColor];
    textView.font = [UIFont systemFontOfSize:16.0f];
    textView.text = @"dhaksjdgsufgsdihsdfshdfgsldlafjkadsgalfjsdkfgasldkjfgsdakjfgdslfjasdlgfdskjfasdfsdagdsfsfdsafasdfasdfsdfasdf";
    [self.view addSubview:textView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 200, 100, 40);
    [btn setTitle:@"关闭" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(testClick) forControlEvents:UIControlEventTouchUpInside];
    
    /*
     GCD定时器是基于系统内核的，与RunLoop无关，所以非常准确
     */
//    [self test];
    
//    self.taskName = [XZQGCDTimer execTask:^{
//        NSLog(@"111 - %@", [NSThread currentThread]);
//    } start:2.0 interval:1.0 repeats:YES async:YES];
    
    self.taskName = [XZQGCDTimer execTask:self selector:@selector(taskTest) start:2.0 interval:1.0 repeats:YES async:YES];
    
}

- (void)testClick {
    NSLog(@"关闭");
    [XZQGCDTimer cancelTask:self.taskName];
}

- (void)taskTest {
    NSLog(@"111 - %@", [NSThread currentThread]);
}

- (void)test {
    // 队列
    //    dispatch_queue_t queue = dispatch_get_main_queue();
        dispatch_queue_t queue = dispatch_queue_create("timerQueue", DISPATCH_QUEUE_SERIAL);
        
        // 创建定时器
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        
        // 设置时间
        uint64_t start = 2.0;  // 2秒后开始执行
        uint64_t interval = 1.0;  // 每隔1秒执行
        // 定时器 执行开始时间 执行间隔 误差
        dispatch_source_set_timer(self.timer, dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
        
        // 设置回调
    //    dispatch_source_set_event_handler(self.timer, ^{
    //        NSLog(@"111");
    //    });
        dispatch_source_set_event_handler_f(self.timer, timerHandler);
        
        // 启动定时器
        dispatch_resume(self.timer);
}

void timerHandler(void *param)
{
    NSLog(@"111");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self testClick];
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

@end
