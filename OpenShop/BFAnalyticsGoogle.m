//
//  BFAnalyticsGoogle.m
//  OpenShop
//
//  Created by Petr Škorňok on 07.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFAnalyticsGoogle.h"
#import "BFProduct.h"

@import Firebase;

static NSString * const trackerName = @"foo";
static NSString * const trackerUA   = @"UA-73690730-2";

@implementation BFAnalyticsGoogle

+ (void)logPurchasedProduct:(BFProduct *)product amount:(NSNumber *)amount quantity:(NSNumber *)quantity category:(NSString *)category sku:(NSString *)sku transactionId:(NSString *)transactionId
{
    [FIRAnalytics logEventWithName:kFIREventEcommercePurchase
                        parameters:@{
                                     kFIRParameterItemID:transactionId,
                                     kFIRParameterItemName:product.name,
                                     kFIRParameterItemCategory:category,
                                     kFIRParameterPrice:product.price,
                                     kFIRParameterQuantity:quantity,
                                     kFIRParameterCurrency:product.currency
                                     }];
}

@end
