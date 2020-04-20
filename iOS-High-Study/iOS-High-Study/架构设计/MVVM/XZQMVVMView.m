//
//  XZQMVVMView.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/20.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQMVVMView.h"
#import "NSObject+FBKVOController.h"

@interface XZQMVVMView ()

@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UILabel *label;

@end

@implementation XZQMVVMView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [self addSubview:imageView];
        _imageView = imageView;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 100, 30)];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _label = label;
    }
    return self;
}

- (void)setViewModel:(XZQViewModel *)viewModel {
    _viewModel = viewModel;
    
    __weak typeof(self) weakSelf = self;
    
    [self.KVOController observe:viewModel keyPath:@"name" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        weakSelf.label.text = change[NSKeyValueChangeNewKey];
    }];
    
    [self.KVOController observe:viewModel keyPath:@"iconUrl" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        weakSelf.imageView.image = [UIImage imageNamed:change[NSKeyValueChangeNewKey]];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(xzqViewClick:)]) {
        [self.delegate xzqViewClick:self];
    }
}

@end
