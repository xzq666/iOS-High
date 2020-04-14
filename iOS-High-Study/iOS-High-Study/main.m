//
//  main.m
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/3/5.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#import "XZQPerson_copy.h"

extern void _objc_autoreleasePoolPrint(void);

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        BOOL ret1 = [[NSObject class] isKindOfClass:[NSObject class]];
        NSLog(@"ret1:%d", ret1);
        
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
        
        _objc_autoreleasePoolPrint();
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
