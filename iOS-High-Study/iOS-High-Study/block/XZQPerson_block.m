//
//  XZQPerson_block.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/3/20.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQPerson_block.h"

@implementation XZQPerson_block

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

- (void)test {
    __weak typeof(self) weakSelf = self;
    self.block = ^{
        __strong typeof(weakSelf) mySelf = weakSelf;
        NSLog(@"%d", mySelf->_age);
    };
}

@end
