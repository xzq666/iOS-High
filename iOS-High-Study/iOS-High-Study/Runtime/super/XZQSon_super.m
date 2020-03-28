//
//  XZQSon_super.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/3/28.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQSon_super.h"

@implementation XZQSon_super

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"[self class] = %@", [self class]);
        NSLog(@"[self superclass] = %@", [self superclass]);
        NSLog(@"[super class] = %@", [super class]);
        NSLog(@"[super superclass] = %@", [super superclass]);
    }
    return self;
}

@end
