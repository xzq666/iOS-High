//
//  XZQPerson_Runtime.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/3/24.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQPerson_Runtime.h"

#define XZQTALLMASK (1<<0)
#define XZQRICHMASK (1<<1)
#define XZQHANDSOMEMASK (1<<2)

@interface XZQPerson_Runtime () {
    char _tallRichHandsome;
}

@end

@implementation XZQPerson_Runtime

- (void)setTall:(BOOL)tall {
    if (tall) {
        _tallRichHandsome |= XZQTALLMASK;
    } else {
        _tallRichHandsome &= ~XZQTALLMASK;
    }
}

- (void)setRich:(BOOL)rich {
    if (rich) {
        _tallRichHandsome |= XZQRICHMASK;
    } else {
        _tallRichHandsome &= ~XZQRICHMASK;
    }
}

- (void)setHandsome:(BOOL)handsome {
    if (handsome) {
        _tallRichHandsome |= XZQHANDSOMEMASK;
    } else {
        _tallRichHandsome &= ~XZQHANDSOMEMASK;
    }
}

- (BOOL)isTall {
    return !!(_tallRichHandsome & XZQTALLMASK);
}

- (BOOL)isRich {
    return !!(_tallRichHandsome & XZQRICHMASK);
}

- (BOOL)isHandsome {
    return !!(_tallRichHandsome & XZQHANDSOMEMASK);
}

- (void)test {
    NSLog(@"%s", __func__);
}

@end
