//
//  XZQView.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/20.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQView.h"

@interface XZQView ()

@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UILabel *label;

@end

@implementation XZQView

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

- (void)setModel:(XZQModel *)model {
    _imageView.image = [UIImage imageNamed:model.iconUrl];
    _label.text = model.name;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(xzqViewClick:)]) {
        [self.delegate xzqViewClick:self];
    }
}

@end
