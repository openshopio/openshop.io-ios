//
//  BFAppAnalytics.m
//  OpenShop
//
//  Created by Petr Škorňok on 07.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFAnalyticsLogger.h"

#import "BFAnalyticsFacebook.h"
#import "BFAnalyticsGoogle.h"

#import "BFProduct.h"

#import <FBSDKCoreKit/FBSDKAppEvents.h>

@interface BFAnalyticsLogger()

@end

@implementation BFAnalyticsLogger

static BFAnalyticsLoggerType loggers;

+ (BFAnalyticsLoggerType) loggers {
    @synchronized(self) {
        return loggers;
    }
}

+ (void) setLoggers:(BFAnalyticsLoggerType)_loggers {
    @synchronized(self) {
        loggers = _loggers;
    }
}

+ (void)logPurchasedProduct:(BFProduct *)product amount:(NSNumber *)amount quantity:(NSNumber *)quantity category:(NSString *)category sku:(NSString *)sku transactionId:(NSString *)transactionId {
    if (BFAnalyticsLogger.loggers & BFAnalyticsLoggerTypeGoogle) {
        [BFAnalyticsGoogle logPurchasedProduct:product
                                        amount:amount
                                      quantity:quantity
                                      category:category
                                           sku:sku
                                 transactionId:transactionId];
    }
    if (BFAnalyticsLogger.loggers & BFAnalyticsLoggerTypeFacebook) {
        [BFAnalyticsFacebook logPurchasedProduct:product
                                          amount:amount];
    }
    if (BFAnalyticsLogger.loggers & BFAnalyticsLoggerTypeAdjust) {
        DDLogDebug(@"adjust");
    }
    if (BFAnalyticsLogger.loggers & BFAnalyticsLoggerTypeSomeOther) {
        DDLogDebug(@"some other");
    }
}

@end
