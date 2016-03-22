//
//  BFOrder.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFOrder.h"
#import "BFCartDelivery.h"
#import "BFOrderItem.h"

@implementation BFOrder

+ (NSString *)keyPathForResponseObject {
    return nil;
}

+ (MMRecordOptions *)defaultOptions {
    MMRecordOptions *options = [super defaultOptions];
    // do not save records in database
    // delete all orphans
    options.deleteOrphanedRecordBlock = ^(MMRecord *orphan,
                                      NSArray *populatedRecords,
                                      id responseObject,
                                      BOOL *stop) {
        return NO;
    };
    return options;
}

@end
