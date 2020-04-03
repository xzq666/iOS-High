//
//  XZQPermenantThread.h
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/3.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^XZQPermenantTask)(void);

@interface XZQPermenantThread : NSObject

/*
 开启一个线程
 */
- (void)run;

/*
 执行一个任务
 */
- (void)executeTask:(XZQPermenantTask)task;

/*
 结束一个线程
 */
- (void)stop;

@end

NS_ASSUME_NONNULL_END
