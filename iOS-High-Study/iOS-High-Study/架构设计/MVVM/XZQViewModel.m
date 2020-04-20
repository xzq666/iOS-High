//
//  XZQViewModel.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/20.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQViewModel.h"
#import "XZQMVVMView.h"

@interface XZQViewModel ()<XZQViewDelegate>

@property(nonatomic,strong) XZQMVVMView *xzqView;

@property(nonatomic,copy) NSString *iconUrl;
@property(nonatomic,copy) NSString *name;

@end

@implementation XZQViewModel

- (instancetype)initWithController:(UIViewController *)controller {
    if (self = [super init]) {
        self.xzqView = [[XZQMVVMView alloc] initWithFrame:CGRectMake(100, 100, 100, 130)];
        self.xzqView.delegate = self;
        self.xzqView.viewModel = self;
        [controller.view addSubview:self.xzqView];
        
        XZQModel *model = [[XZQModel alloc] init];
        model.iconUrl = @"female_icon";
        model.name = @"female";
        
        // 设置数据
        self.name = model.name;
        self.iconUrl = model.iconUrl;
    }
    return self;
}

- (void)xzqViewClick:(XZQMVVMView *)xzqView {
    NSLog(@"ViewModel监听到了View的点击事件");
}

@end
