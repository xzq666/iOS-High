//
//  XZQStudent_Runtime.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/3/24.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQStudent_Runtime.h"

@interface XZQStudent_Runtime () {
    // 结构体支持位域操作
    struct {
        char tall : 1;  // 表示占1位
        char rich : 1;
        char handsome : 1;
    } _tallRichHandsome;
}

@end

@implementation XZQStudent_Runtime

- (void)setTall:(BOOL)tall {
    _tallRichHandsome.tall = tall;
}

- (void)setRich:(BOOL)rich {
    _tallRichHandsome.rich = rich;
}

- (void)setHandsome:(BOOL)handsome {
    _tallRichHandsome.handsome = handsome;
}

- (BOOL)isTall {
    return _tallRichHandsome.tall;
}

- (BOOL)isRich {
    return _tallRichHandsome.rich;
}

- (BOOL)isHandsome {
    return _tallRichHandsome.handsome;
}

@end
