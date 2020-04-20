//
//  XZQMVVMView.h
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/20.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZQModel.h"

NS_ASSUME_NONNULL_BEGIN

@class XZQMVVMView, XZQViewModel;

@protocol XZQViewDelegate <NSObject>

@optional
- (void)xzqViewClick:(XZQMVVMView *)xzqView;

@end

@interface XZQMVVMView : UIView

@property(nonatomic,weak) id<XZQViewDelegate> delegate;
@property(nonatomic,weak) XZQViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
