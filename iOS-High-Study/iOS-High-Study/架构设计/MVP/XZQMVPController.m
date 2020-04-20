//
//  XZQMVPController.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/20.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQMVPController.h"
#import "XZQPresenter.h"

@interface XZQMVPController ()

@property(nonatomic,strong) XZQPresenter *presenter;

@end

@implementation XZQMVPController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.presenter = [[XZQPresenter alloc] initWithController:self];
}

@end
