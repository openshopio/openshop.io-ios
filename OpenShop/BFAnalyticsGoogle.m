//
//  BFAnalyticsGoogle.m
//  OpenShop
//
//  Created by Petr Škorňok on 07.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFAnalyticsGoogle.h"
#import "BFProduct.h"
#import <GAI.h>
#import <GAIDictionaryBuilder.h>
#import <GAIFields.h>

static NSString * const trackerName = @"foo";
static NSString * const trackerUA   = @"UA-73690730";

@implementation BFAnalyticsGoogle

+ (void)logPurchasedProduct:(BFProduct *)product amount:(NSNumber *)amount quantity:(NSNumber *)quantity category:(NSString *)category sku:(NSString *)sku transactionId:(NSString *)transactionId
{
    id tracker = [[GAI sharedInstance] trackerWithName:trackerName trackingId:trackerUA];
    [tracker send:[[GAIDictionaryBuilder createItemWithTransactionId:transactionId                             // (NSString) Transaction ID
                                                                name:product.name                              // (NSString) Product Name
                                                                 sku:sku                                       // (NSString) Product SKU
                                                            category:category                                  // (NSString) Product category
                                                               price:product.price                             // (NSNumber)  Product price
                                                            quantity:quantity                                  // (NSInteger)  Product quantity
                                                        currencyCode:product.currency]                         // (NSString) Currency code
                   build]];
}

@end
