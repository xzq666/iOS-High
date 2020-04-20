//
//  XZQMVVMController.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/20.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQMVVMController.h"
#import "XZQViewModel.h"

@interface XZQMVVMController ()

@property(nonatomic,strong) XZQViewModel *viewModel;

@end

@implementation XZQMVVMController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewModel = [[XZQViewModel alloc] initWithController:self];
}

@end
