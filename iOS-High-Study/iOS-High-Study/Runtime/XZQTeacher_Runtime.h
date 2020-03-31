//
//  XZQTeacher_Runtime.h
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/3/24.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZQTeacher_Runtime : NSObject

- (void)setTall:(BOOL)tall;
- (void)setRich:(BOOL)rich;
- (void)setHandsome:(BOOL)handsome;
- (BOOL)isTall;
- (BOOL)isRich;
- (BOOL)isHandsome;

- (void)run;

@end

NS_ASSUME_NONNULL_END
