//
//  XZQPerson_KVC.h
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/3/16.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZQCat : NSObject

@property(nonatomic,assign) int weight;

@end

@interface XZQPerson_KVC : NSObject

@property(nonatomic,assign) int age;
@property(nonatomic,strong) XZQCat *cat;

@end

NS_ASSUME_NONNULL_END
