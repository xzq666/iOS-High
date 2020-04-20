//
//  XZQView.h
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/20.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZQModel.h"

NS_ASSUME_NONNULL_BEGIN

@class XZQView;

@protocol XZQViewDelegate <NSObject>

@optional
- (void)xzqViewClick:(XZQView *)xzqView;

@end

@interface XZQView : UIView

@property(nonatomic,weak) id<XZQViewDelegate> delegate;

- (void)setModel:(XZQModel *)model;

@end

NS_ASSUME_NONNULL_END
