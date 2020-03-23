//
//  XZQPerson_block.h
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/3/20.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^XZQBlock) (void);

@interface XZQPerson_block : NSObject

@property(nonatomic,assign) int age;
@property(nonatomic,copy) XZQBlock block;

@end

NS_ASSUME_NONNULL_END
