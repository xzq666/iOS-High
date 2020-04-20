//
//  XZQPresenter.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/20.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQPresenter.h"
#import "XZQView.h"

@interface XZQPresenter ()<XZQViewDelegate>

@property(nonatomic,strong) XZQView *xzqView;

@end

@implementation XZQPresenter

- (instancetype)initWithController:(UIViewController *)controller {
    if (self = [super init]) {
        self.xzqView = [[XZQView alloc] initWithFrame:CGRectMake(100, 100, 100, 130)];
        self.xzqView.delegate = self;
        [controller.view addSubview:self.xzqView];
        
        XZQModel *model = [[XZQModel alloc] init];
        model.iconUrl = @"female_icon";
        model.name = @"female";
        
        [self.xzqView setModel:model];
    }
    return self;
}

- (void)xzqViewClick:(XZQView *)xzqView {
    NSLog(@"Presenter监听到了View的点击事件");
}

@end
