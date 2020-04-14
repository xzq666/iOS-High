//
//  XZQPerson_copy.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/14.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQPerson_copy.h"

@interface XZQPerson_copy () <NSCopying>

@end

@implementation XZQPerson_copy

- (id)copyWithZone:(nullable NSZone *)zone {
    XZQPerson_copy *person = [[XZQPerson_copy allocWithZone:zone] init];
    person.age = self.age;
    person.weight = self.weight;
    return person;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"age is %d, weight is %f", self.age, self.weight];
}

@end
