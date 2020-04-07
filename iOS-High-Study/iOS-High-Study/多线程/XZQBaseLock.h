//
//  XZQBaseLock.h
//  iOS-High-Study
//
//  Created by qhzc-iMac-02 on 2020/4/7.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZQBaseLock : NSObject

/**
存钱、取钱演示
*/
- (void)moneyTest;
/**
 卖票演示
 */
- (void)ticketTest;

/**
 存钱
 */
- (void)__saveMoney;
/**
 取钱
 */
- (void)__drawMoney;
/**
 卖1张票
 */
- (void)__saleTicket;

@end

NS_ASSUME_NONNULL_END
