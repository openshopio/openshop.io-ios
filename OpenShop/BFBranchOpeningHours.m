//
//  BFBranchOpeningHours.m
//  OpenShop
//
//  Created by Petr Škorňok on 25.02.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFBranchOpeningHours.h"
#import "BFBranch.h"

@implementation BFBranchOpeningHours

+ (MMRecordOptions *)defaultOptions {
    MMRecordOptions *options = [super defaultOptions];
    // do not save records in database
    options.automaticallyPersistsRecords = NO;
    options.entityPrimaryKeyInjectionBlock = ^id(NSEntityDescription *entity,
                                                 NSDictionary *dictionary,
                                                 MMRecordProtoRecord *parentProtoRecord){
//        if ([[entity name] isEqualToString:@"CoverImage"]) {
//            if ([[parentProtoRecord.entity name] isEqualToString:@"User"]) {
//                if (parentProtoRecord.primaryKeyValue != nil) {
//                    return parentProtoRecord.primaryKeyValue;
//                }
//            }
//        }
//        
//        return nil;
        return [NSString stringWithFormat:@"%@%@", dictionary[@"day"], dictionary[@"opening"]];
    };
    
    return options;
}

@end
