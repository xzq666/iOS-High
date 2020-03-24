//
//  XZQPerson_Runtime.h
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/3/24.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZQPerson_Runtime : NSObject

//@property(nonatomic,assign,getter=isTall) BOOL tall;
//@property(nonatomic,assign) BOOL rich;
//@property(nonatomic,assign) BOOL handsome;

- (void)setTall:(BOOL)tall;
- (void)setRich:(BOOL)rich;
- (void)setHandsome:(BOOL)handsome;
- (BOOL)isTall;
- (BOOL)isRich;
- (BOOL)isHandsome;

- (void)test;

@end

NS_ASSUME_NONNULL_END
