//
//  BFCategory.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFCategory.h"

/**
 * Properties names used to match attributes during JSON serialization.
 */
static NSString *const BFCategoryCategoryIDPropertyName    = @"categoryID";
static NSString *const BFCategoryNamePropertyName          = @"name";
static NSString *const BFCategoryOriginalIDPropertyName    = @"originalID";
static NSString *const BFCategoryTypePropertyName          = @"type";
static NSString *const BFCategoryIsCategoryPropertyName    = @"isCategory";

/**
 * Properties JSON mappings used to match attributes during serialization.
 */
static NSString *const BFCategoryCategoryIDPropertyJSONMapping    = @"id";
static NSString *const BFCategoryNamePropertyJSONMapping          = @"name";
static NSString *const BFCategoryOriginalIDPropertyJSONMapping    = @"original_id";
static NSString *const BFCategoryTypePropertyJSONMapping          = @"type";
static NSString *const BFCategoryIsCategoryPropertyJSONMapping    = @"is_category";


@implementation BFCategory


#pragma mark - MMRecord Location & Options

+ (NSString *)keyPathForResponseObject {
    return @"navigation";
}

+ (MMRecordOptions *)defaultOptions {
    MMRecordOptions *options = [super defaultOptions];
    // do not save records in database
    options.automaticallyPersistsRecords = NO;
    return options;
}


#pragma mark - JSON Serialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             BFCategoryCategoryIDPropertyName : BFCategoryCategoryIDPropertyJSONMapping,
             BFCategoryNamePropertyName : BFCategoryNamePropertyJSONMapping,
             BFCategoryOriginalIDPropertyName : BFCategoryOriginalIDPropertyJSONMapping,
             BFCategoryTypePropertyName : BFCategoryTypePropertyJSONMapping,
             BFCategoryIsCategoryPropertyName : BFCategoryIsCategoryPropertyJSONMapping,
             };
}



@end
