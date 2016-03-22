//
//  BFAnalyticsFacebook.h
//  OpenShop
//
//  Created by Petr Škorňok on 07.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

@import Foundation;

@class BFProduct;

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFAnalyticsFacebook` serves as wrapper around 
 * Facebook Analytics calls.
 */
@interface BFAnalyticsFacebook : NSObject

/**
 * Log purchased product
 */
+ (void)logPurchasedProduct:(BFProduct *)product amount:(NSNumber *)amount;

@end

NS_ASSUME_NONNULL_END
