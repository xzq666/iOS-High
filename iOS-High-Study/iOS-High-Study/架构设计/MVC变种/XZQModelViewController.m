//
//  XZQModelViewController.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/20.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQModelViewController.h"
#import "XZQView.h"
#import "XZQModel.h"

@interface XZQModelViewController ()<XZQViewDelegate>

@property(nonatomic,strong) XZQView *xzqView;

@end

@implementation XZQModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.xzqView = [[XZQView alloc] initWithFrame:CGRectMake(100, 100, 100, 130)];
    self.xzqView.delegate = self;
    [self.view addSubview:self.xzqView];
    
    XZQModel *model = [[XZQModel alloc] init];
    model.iconUrl = @"female_icon";
    model.name = @"female";
    
    [self.xzqView setModel:model];
}

- (void)xzqViewClick:(XZQView *)xzqView {
    NSLog(@"控制器监听到了View的点击事件");
}

@end
