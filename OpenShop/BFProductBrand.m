//
//  BFNColor+BFNSelection.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFProductBrand.h"


/**
 * Properties names used to match attributes during JSON serialization.
 */
static NSString *const BFProductBrandBrandIDPropertyName  = @"id";
static NSString *const BFProductBrandBrandNamePropertyName = @"name";


/**
 * Properties JSON mappings used to match attributes during serialization.
 */
static NSString *const BFProductBrandBrandIDPropertyJSONMapping   = @"brandID";
static NSString *const BFProductBrandBrandNamePropertyJSONMapping = @"name";



@implementation BFProductBrand


#pragma mark - BFNFiltering Protocol

- (BFNFilterType)filterType {
    return BFNProductFilterTypeBrand;
}

- (id)filterValue {
    return self.name ? (NSString *)self.name : @"";
}


#pragma mark - JSON Serialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             BFProductBrandBrandIDPropertyName   : BFProductBrandBrandIDPropertyJSONMapping,
             BFProductBrandBrandNamePropertyName : BFProductBrandBrandNamePropertyJSONMapping
             };
}

#pragma mark - BFNSelection Protocol

+(NSPredicate *)predicateWithSearchQuery:(NSString *)query {
    if(query && ![query isEqualToString:@""]) {
        return [NSPredicate predicateWithFormat:@"SELF.name contains[cd] %@", query];
    }
    return [NSPredicate predicateWithValue:true];
}

-(NSString *)sectionIndexTitle {
    if(self.name && self.name.length) {
        return [[(NSString *)self.name substringWithRange:NSMakeRange(0, 1)]uppercaseString];
    }
    return nil;
}

-(NSComparisonResult)compare:(id<BFNSelection>)item {
    if([item isKindOfClass:[BFProductBrand class]]) {
        BFProductBrand *brand = (BFProductBrand *)item;
        if(self.name && brand.name) {
            return [self.name compare:(NSString *)brand.name];
        }
        else {
            return self.name ? NSOrderedDescending : (brand.name ? NSOrderedAscending : NSOrderedSame);
        }
    }
    return NSOrderedSame;
}

-(NSString *)displayName {
    return self.name ? (NSString *)self.name : @"";
}



@end