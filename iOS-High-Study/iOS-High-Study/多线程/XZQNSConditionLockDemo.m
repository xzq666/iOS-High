//
//  XZQNSConditionLockDemo.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/9.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQNSConditionLockDemo.h"

@interface XZQNSConditionLockDemo ()

@property(nonatomic,strong) NSConditionLock *conditionLock;

@end

@implementation XZQNSConditionLockDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.conditionLock = [[NSConditionLock alloc] initWithCondition:1];
    }
    return self;
}

- (void)otherTest {
    [[[NSThread alloc] initWithTarget:self selector:@selector(__one) object:nil] start];
    [[[NSThread alloc] initWithTarget:self selector:@selector(__two) object:nil] start];
    [[[NSThread alloc] initWithTarget:self selector:@selector(__three) object:nil] start];
}

- (void)__one {
    [self.conditionLock lockWhenCondition:1];
    NSLog(@"1");
    [self.conditionLock unlockWithCondition:2];
}

- (void)__two {
    [self.conditionLock lockWhenCondition:2];
    NSLog(@"2");
    [self.conditionLock unlockWithCondition:3];
}

- (void)__three {
    [self.conditionLock lockWhenCondition:3];
    NSLog(@"3");
    [self.conditionLock unlock];
}

@end
