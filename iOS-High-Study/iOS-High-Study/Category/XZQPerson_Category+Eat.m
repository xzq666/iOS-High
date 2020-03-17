//
//  XZQPerson_Category+Eat.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/3/16.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQPerson_Category+Eat.h"

@implementation XZQPerson_Category (Eat)

+ (void)initialize {
    NSLog(@"XZQPerson_Category Eat +initialize");
}

+ (void)load {
    NSLog(@"XZQPerson_Category Eat +load");
}

- (void)run {
    NSLog(@"run-eat");
}

- (void)eat {
    NSLog(@"eat");
}

@end
