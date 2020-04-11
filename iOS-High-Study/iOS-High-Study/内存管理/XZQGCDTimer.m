//
//  XZQGCDTimer.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/11.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQGCDTimer.h"

@implementation XZQGCDTimer

static NSMutableDictionary *timers_;
static dispatch_semaphore_t semaphore_;

+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timers_ = [NSMutableDictionary dictionary];
        semaphore_ = dispatch_semaphore_create(1);
    });
}

+ (NSString *)execTask:(void(^)(void))task
   start:(NSTimeInterval)start
interval:(NSTimeInterval)interval
 repeats:(BOOL)repeats
           async:(BOOL)async {
    
    if (!task || start < 0 || (interval <= 0 && repeats)) {
        return nil;
    }
    
    dispatch_queue_t queue = async ? dispatch_queue_create("timerQueue", DISPATCH_QUEUE_SERIAL) : dispatch_get_main_queue();
        
    // 创建定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 设置时间
    // 定时器 执行开始时间 执行间隔 误差
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
    
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    
    // 定时器唯一标识
    NSString *name = [NSString stringWithFormat:@"%zd", timers_.count];
    timers_[name] = timer;
    
    dispatch_semaphore_signal(semaphore_);
    
    // 设置回调
    dispatch_source_set_event_handler(timer, ^{
        task();
        
        if (!repeats) {
            [self cancelTask:name];
        }
    });
        
    // 启动定时器
    dispatch_resume(timer);
    
    return name;
}

+ (NSString *)execTask:(id)target
              selector:(SEL)selector
                 start:(NSTimeInterval)start
              interval:(NSTimeInterval)interval
               repeats:(BOOL)repeats
                 async:(BOOL)async {
    if (!target || !selector) {
        return nil;
    }
    return [self execTask:^{
        if ([target respondsToSelector:selector]) {
            [target performSelector:selector];
        }
    } start:start interval:interval repeats:repeats async:async];
}

+ (void)cancelTask:(NSString *)taskName {
    if (taskName.length == 0) {
        return;
    }
    
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    
    dispatch_source_t timer = timers_[taskName];
    if (timer) {
        dispatch_source_cancel(timer);
        [timers_ removeObjectForKey:taskName];
    }
    
    dispatch_semaphore_signal(semaphore_);
}

@end
