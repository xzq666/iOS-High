//
//  XZQNSConditionDemo.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/8.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQNSConditionDemo.h"

@interface XZQNSConditionDemo ()

@property(nonatomic,strong) NSCondition *condition;

@property(nonatomic,strong) NSMutableArray *data;

@end

@implementation XZQNSConditionDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.condition = [[NSCondition alloc] init];
        
        self.data = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)otherTest {
    [[[NSThread alloc] initWithTarget:self selector:@selector(__remove) object:nil] start];
    [[[NSThread alloc] initWithTarget:self selector:@selector(__add) object:nil] start];
}

- (void)__add {
    [self.condition lock];
    [self.data addObject:@"1"];
    NSLog(@"添加了元素");
    // 添加元素后通知条件成立
    [self.condition signal];
    [self.condition unlock];
}

- (void)__remove {
    [self.condition lock];
    // 添加条件，只有当数组中有值时才能删
    if (self.data.count == 0) {
        // 数组中没元素时等待并放开锁
        [self.condition wait];
    }
    [self.data removeLastObject];
    NSLog(@"删除了元素");
    [self.condition unlock];
}

@end
