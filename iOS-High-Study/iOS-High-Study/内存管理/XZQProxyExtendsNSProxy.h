//
//  XZQProxyExtendsNSProxy.h
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/10.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZQProxyExtendsNSProxy : NSProxy

@property(nonatomic,weak) id target;

+ (id)initWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
