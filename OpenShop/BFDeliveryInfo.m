//
//  BFDeliveryInfo.m
//  OpenShop
//
//  Created by Petr Škorňok on 27.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFDeliveryInfo.h"
#import "BFCartDelivery.h"

@implementation BFDeliveryInfo

+ (NSString *)keyPathForResponseObject {
    return @"delivery";
}

+ (MMRecordOptions *)defaultOptions {
    MMRecordOptions *options = [super defaultOptions];
    // do not save records in database
    options.automaticallyPersistsRecords = NO;
    return options;
}

@end
