//
//  BFAnalyticsFacebook.m
//  OpenShop
//
//  Created by Petr Škorňok on 07.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFAnalyticsFacebook.h"
#import "BFProduct.h"
#import <FBSDKCoreKit/FBSDKAppEvents.h>

@implementation BFAnalyticsFacebook

+ (void)logPurchasedProduct:(BFProduct *)product amount:(NSNumber *)amount
{
    [FBSDKAppEvents logPurchase:[amount doubleValue]
                       currency:product.currency
                     parameters:@{
                                  FBSDKAppEventParameterNameContentType : @"product",
                                  FBSDKAppEventParameterNameContentID   : [NSString stringWithFormat:@"%@", product.remoteID]
                                  }
     ];
}

@end
