//
//  XZQPerson_super.h
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/3/28.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZQPerson_super : NSObject

@property(nonatomic,assign) int hight;
@property(nonatomic,assign) int weight;
@property(nonatomic,copy) NSString *name;

- (void)print;

- (void)test1;
- (void)test2;

@end

NS_ASSUME_NONNULL_END
