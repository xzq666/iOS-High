//
//  XZQTeacher_Runtime.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/3/24.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQTeacher_Runtime.h"

#define XZQTALLMASK (1<<0)
#define XZQRICHMASK (1<<1)
#define XZQHANDSOMEMASK (1<<2)

@interface XZQTeacher_Runtime () {
    union {
        char bits;
        // 这里的struct只是为了增加可读性
        struct {
            char tall : 1;  // 表示占1位
            char rich : 1;
            char handsome : 1;
        };
    } _tallRichHandsome;
}

@end

@implementation XZQTeacher_Runtime

- (void)setTall:(BOOL)tall {
    if (tall) {
        _tallRichHandsome.bits |= XZQTALLMASK;
    } else {
        _tallRichHandsome.bits &= ~XZQTALLMASK;
    }
}

- (void)setRich:(BOOL)rich {
    if (rich) {
        _tallRichHandsome.bits |= XZQRICHMASK;
    } else {
        _tallRichHandsome.bits &= ~XZQRICHMASK;
    }
}

- (void)setHandsome:(BOOL)handsome {
    if (handsome) {
        _tallRichHandsome.bits |= XZQHANDSOMEMASK;
    } else {
        _tallRichHandsome.bits &= ~XZQHANDSOMEMASK;
    }
}

- (BOOL)isTall {
    return !!(_tallRichHandsome.bits & XZQTALLMASK);
}

- (BOOL)isRich {
    return !!(_tallRichHandsome.bits & XZQRICHMASK);
}

- (BOOL)isHandsome {
    return !!(_tallRichHandsome.bits & XZQHANDSOMEMASK);
}

@end
