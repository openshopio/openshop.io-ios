//
//  BFRecord.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFRecord.h"

/**
 * Core data managed object model date formatter.
 */
static NSDateFormatter *recordDateFormatter;
/**
 * Core data managed object model prefix.
 */
static NSString *const managedObjectModelPrefix = @"BF";


@implementation BFRecord


#pragma mark - MMRecord Location & Options

+ (NSString *)keyPathForResponseObject {
    return @"records";
}

+ (MMRecordOptions *)defaultOptions {
    // record options
    MMRecordOptions* opt = [super defaultOptions];
    // save records in database
    opt.automaticallyPersistsRecords = YES;
    // delete all orphans
    opt.deleteOrphanedRecordBlock = ^(MMRecord *orphan,
                                      NSArray *populatedRecords,
                                      id responseObject,
                                      BOOL *stop) {
        return YES;
    };
    
    return opt;
}

+ (MMRecordOptions *)collectionOptions {
    // record options
    return [self defaultOptions];
}

+ (NSDateFormatter *)dateFormatter {
    if (!recordDateFormatter) {
        recordDateFormatter = [[NSDateFormatter alloc] init];
        // 1997-07-16T19:20:30+01:00
        [recordDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssxxx"];
    }
    
    return recordDateFormatter;
}


#pragma mark - MagicalRecord

+ (NSString *)entityName {
    // remove model prefix to retrieve name
    return [NSStringFromClass([self class]) substringFromIndex:[managedObjectModelPrefix length]];
}


@end
