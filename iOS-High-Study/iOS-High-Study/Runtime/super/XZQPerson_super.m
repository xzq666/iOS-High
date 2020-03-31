//
//  XZQPerson_super.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/3/28.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQPerson_super.h"

@implementation XZQPerson_super

- (void)print {
    NSLog(@"name is %@", self.name);
}

- (void)test1 {
    NSLog(@"%s", __func__);
}

- (void)test2 {
    NSLog(@"%s", __func__);
}

@end
