//
//  BFAppAnalytics.h
//  OpenShop
//
//  Created by Petr Škorňok on 07.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

@import Foundation;

@class BFProduct;

@protocol BFAnalyticsProtocol;

NS_ASSUME_NONNULL_BEGIN

/**
 * Analytics tools enum. Because of the bitwise operations,
 * it is important to add "<< [following number]" after new type.
 */
typedef NS_ENUM(NSUInteger, BFAnalyticsLoggerType) {
    BFAnalyticsLoggerTypeNone       = 0,
    BFAnalyticsLoggerTypeGoogle     = 1 << 0,
    BFAnalyticsLoggerTypeFacebook   = 1 << 1,
    BFAnalyticsLoggerTypeAdjust     = 1 << 2,
    BFAnalyticsLoggerTypeSomeOther  = 1 << 3,
};

@interface BFAnalyticsLogger : NSObject

/**
 * Loggers array getter returning Analytics tools to log with.
 */
+ (BFAnalyticsLoggerType) loggers;

/**
 * Loggers array setter to specify different Analytics tools to log with.
 */
+ (void) setLoggers:(BFAnalyticsLoggerType)_loggers;

/**
 * Log purchased product.
 */
+ (void)logPurchasedProduct:(BFProduct *)product
                     amount:(NSNumber *)amount
                   quantity:(NSNumber *)quantity
                   category:(NSString *)category
                        sku:(NSString *)sku
              transactionId:(NSString *)transactionId;

@end

NS_ASSUME_NONNULL_END
