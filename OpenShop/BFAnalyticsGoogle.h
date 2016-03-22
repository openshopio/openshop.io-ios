//
//  BFAnalyticsGoogle.h
//  OpenShop
//
//  Created by Petr Škorňok on 07.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

@import Foundation;

@class BFProduct;

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFAnalyticsGoogle` serves as wrapper around
 * Google Analytics calls.
 */
@interface BFAnalyticsGoogle : NSObject

/**
 * Log purchased product
 */
+ (void)logPurchasedProduct:(BFProduct *)product
                     amount:(NSNumber *)amount
                   quantity:(NSNumber *)quantity
                   category:(NSString *)category
                        sku:(NSString *)sku
              transactionId:(NSString *)transactionId;

@end

NS_ASSUME_NONNULL_END
