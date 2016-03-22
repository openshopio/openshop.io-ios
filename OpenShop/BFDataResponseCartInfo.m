//
//  BFDataResponseCartInfo.m
//  OpenShop
//
//  Created by Petr Škorňok on 02.02.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFDataResponseCartInfo.h"

/**
 * Properties names used to match attributes during JSON deserialization.
 */
static NSString *const BFDataResponseCartInfoProductCountPropertyName          = @"productCount";
static NSString *const BFDataResponseCartInfoTotalPricePropertyName        = @"totalPrice";
static NSString *const BFDataResponseCartInfoTotalPriceFormattedPropertyName        = @"totalPriceFormatted";

/**
 * Properties JSON mappings used to match attributes during deserialization.
 */
static NSString *const BFDataResponseCartInfoProductCountPropertyJSONMapping   = @"product_count";
static NSString *const BFDataResponseCartInfoTotalPricePropertyJSONMapping = @"total_price";
static NSString *const BFDataResponseCartInfoTotalPriceFormattedPropertyJSONMapping = @"total_price_formatted";



@interface BFDataResponseCartInfo ()

@end


@implementation BFDataResponseCartInfo


#pragma mark - JSON Deserialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             BFDataResponseCartInfoProductCountPropertyName   : BFDataResponseCartInfoProductCountPropertyJSONMapping,
             BFDataResponseCartInfoTotalPricePropertyName : BFDataResponseCartInfoTotalPricePropertyJSONMapping,
             BFDataResponseCartInfoTotalPriceFormattedPropertyName : BFDataResponseCartInfoTotalPriceFormattedPropertyJSONMapping,
             };
}

@end
