//
//  BFDataRequestProductInfo.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import CoreData;
#import "BFDataRequestProductInfo.h"
#import "BFAppStructure.h"
#import "BFCartProductItem.h"

/**
 * Properties names used to match attributes during JSON serialization.
 */
static NSString *const BFDataRequestProductInfoCategoryIDPropertyName         = @"categoryID";
static NSString *const BFDataRequestProductInfoBannerIDPropertyName           = @"bannerID";
static NSString *const BFDataRequestProductInfoColorsPropertyName             = @"colors";
static NSString *const BFDataRequestProductInfoSizesPropertyName              = @"sizes";
static NSString *const BFDataRequestProductInfoBrandsPropertyName             = @"brands";
static NSString *const BFDataRequestProductInfoPriceRangePropertyName         = @"priceRange";
static NSString *const BFDataRequestProductInfoSearchQueryPropertyName        = @"searchQuery";
static NSString *const BFDataRequestProductInfoSortTypePropertyName           = @"sortType";
static NSString *const BFDataRequestProductInfoIncludePropertyName            = @"include";

/**
 * Properties JSON mappings used to match attributes during serialization.
 */
static NSString *const BFDataRequestProductInfoCategoryIDPropertyJSONMapping         = @"category";
static NSString *const BFDataRequestProductInfoBannerIDPropertyJSONMapping           = @"banner";
static NSString *const BFDataRequestProductInfoColorsPropertyJSONMapping             = @"color";
static NSString *const BFDataRequestProductInfoSizesPropertyJSONMapping              = @"sizes";
static NSString *const BFDataRequestProductInfoBrandsPropertyJSONMapping             = @"brand";
static NSString *const BFDataRequestProductInfoPriceRangePropertyJSONMapping         = @"price";
static NSString *const BFDataRequestProductInfoSearchQueryPropertyJSONMapping        = @"search";
static NSString *const BFDataRequestProductInfoSortTypePropertyJSONMapping           = @"sort";
static NSString *const BFDataRequestProductInfoIncludePropertyJSONMapping            = @"include";

@interface BFDataRequestProductInfo ()

@end


@implementation BFDataRequestProductInfo


#pragma mark - Initialization

- (instancetype)initWithProductIdentification:(NSNumber *)productID {
    self = [super init];
    if (self) {
        _productID = productID;
    }
    return self;
}

- (instancetype)initWithCategory:(NSNumber *)categoryID {
    self = [super init];
    if (self) {
        _categoryID = categoryID;
    }
    return self;
}

- (instancetype)initWithCategory:(NSNumber *)categoryID
                          offset:(NSNumber *)offset
                           limit:(NSNumber *)limit {
    self = [super initWithOffset:offset limit:limit];
    if (self) {
        _categoryID = categoryID;
    }
    return self;
}


#pragma mark - JSON Serialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *parentKeyPaths = [[super JSONKeyPathsByPropertyKey] mutableCopy];
    [parentKeyPaths addEntriesFromDictionary:@{
             BFDataRequestProductInfoCategoryIDPropertyName     : BFDataRequestProductInfoCategoryIDPropertyJSONMapping,
             BFDataRequestProductInfoBannerIDPropertyName       : BFDataRequestProductInfoBannerIDPropertyJSONMapping,
             BFDataRequestProductInfoColorsPropertyName         : BFDataRequestProductInfoColorsPropertyJSONMapping,
             BFDataRequestProductInfoSizesPropertyName          : BFDataRequestProductInfoSizesPropertyJSONMapping,
             BFDataRequestProductInfoBrandsPropertyName         : BFDataRequestProductInfoBrandsPropertyJSONMapping,
             BFDataRequestProductInfoPriceRangePropertyName     : BFDataRequestProductInfoPriceRangePropertyJSONMapping,
             BFDataRequestProductInfoSearchQueryPropertyName    : BFDataRequestProductInfoSearchQueryPropertyJSONMapping,
             BFDataRequestProductInfoSortTypePropertyName       : BFDataRequestProductInfoSortTypePropertyJSONMapping,
             BFDataRequestProductInfoIncludePropertyName        : BFDataRequestProductInfoIncludePropertyJSONMapping
             }];
    return parentKeyPaths;
}


#pragma mark - JSON Transformers

+ (NSValueTransformer *)priceRangeJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *priceString, BOOL *success, NSError *__autoreleasing *error) {
        NSInteger priceRangeMin = 0;
        NSInteger priceRangeMax = 0;
        // parse minimum and maximum price range value
        if([[priceString componentsSeparatedByString:@"|"]count] > 1) {
            priceRangeMin = [[[priceString componentsSeparatedByString:@"|"]objectAtIndex:0] integerValue];
            priceRangeMax = [[[priceString componentsSeparatedByString:@"|"]objectAtIndex:1] integerValue];
        }
        else {
            priceRangeMin = [priceString integerValue];
        }
        return [NSValue valueWithRange:NSMakeRange(priceRangeMin, priceRangeMax)];
    } reverseBlock:^id(NSValue *priceRange, BOOL *success, NSError *__autoreleasing *error) {
        if(priceRange) {
            // format range string with minimum and maximum value
            return [NSString stringWithFormat:@"%lu|%lu", (unsigned long)[priceRange rangeValue].location, (unsigned long)[priceRange rangeValue].location+[priceRange rangeValue].length];
        }
        return nil;
    }];
}

+ (NSValueTransformer *)sortTypeJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *sortType, BOOL *success, NSError *__autoreleasing *error) {
        if(sortType) {
            return @([BFAppStructure sortTypeFromAPIName:sortType]);
        }
        return nil;
    } reverseBlock:^id(NSNumber *sortType, BOOL *success, NSError *__autoreleasing *error) {
        if(sortType) {
            return [BFAppStructure sortTypeAPIName:[sortType integerValue]];
        }
        return nil;
    }];
}

+ (NSValueTransformer *)colorsJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *colors, BOOL *success, NSError *__autoreleasing *error) {
        if(colors) {
            return [[NSNumberFormatter new] numberFromString:colors];
        }
        return nil;
    } reverseBlock:^id(NSArray *colors, BOOL *success, NSError *__autoreleasing *error) {
        if(colors && colors.count) {
            return [NSString stringWithFormat:@"%@", [colors firstObject]];
        }
        return nil;
    }];
}

+ (NSValueTransformer *)sizesJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *sizes, BOOL *success, NSError *__autoreleasing *error) {
        if(sizes) {
            return [[NSNumberFormatter new] numberFromString:sizes];
        }
        return nil;
    } reverseBlock:^id(NSArray *sizes, BOOL *success, NSError *__autoreleasing *error) {
        if(sizes && sizes.count) {
            return [NSString stringWithFormat:@"%@", [sizes firstObject]];
        }
        return nil;
    }];
}

+ (NSValueTransformer *)brandsJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *brands, BOOL *success, NSError *__autoreleasing *error) {
        if(brands) {
            return [[NSNumberFormatter new] numberFromString:brands];
        }
        return nil;
    } reverseBlock:^id(NSArray *brands, BOOL *success, NSError *__autoreleasing *error) {
        if(brands && brands.count) {
            return [NSString stringWithFormat:@"%@", [brands firstObject]];
        }
        return nil;
    }];
}


#pragma mark - BFDataStorageAccessing Protocol

- (NSPredicate *)dataFetchPredicate {
    NSPredicate *predicate = [NSPredicate predicateWithValue:true];
    NSMutableArray *predicateComponents = [[NSMutableArray alloc]init];
    
    if(self.productID != nil) {
        [predicateComponents addObject:[NSString stringWithFormat:@"productID = %@", self.productID]];
    }
    if(self.categoryID != nil) {
        [predicateComponents addObject:[NSString stringWithFormat:@"categoryID = %@", self.categoryID]];
    }
    if(self.bannerID != nil) {
        [predicateComponents addObject:[NSString stringWithFormat:@"bannerID = %@", self.bannerID]];
    }
    if(self.productVariantID != nil) {
        [predicateComponents addObject:[NSString stringWithFormat:@"productVariants.productVariantID = %@", self.productVariantID]];
    }
    if(self.colors != nil) {
        [predicateComponents addObject:[NSString stringWithFormat:@"productVariants.color.name IN %@", self.colors]];
    }
    if(self.sizes != nil) {
        [predicateComponents addObject:[NSString stringWithFormat:@"productVariants.size.name IN %@", self.sizes]];
    }
    if(self.priceRangeFrom != nil) {
        [predicateComponents addObject:[NSString stringWithFormat:@"price >= %@", self.priceRangeFrom]];
    }
    if(self.priceRangeTo != nil) {
        [predicateComponents addObject:[NSString stringWithFormat:@"price <= %@", self.priceRangeTo]];
    }
    if(self.priceRange != nil) {
        [predicateComponents addObject:[NSString stringWithFormat:@"price BETWEEN %@", self.priceRange]];
    }
    if(self.searchQuery != nil) {
        [predicateComponents addObject:[NSString stringWithFormat:@"name contains[cd] %@", self.searchQuery]];
    }
    if(self.menuCategory != nil) {
        [predicateComponents addObject:[NSString stringWithFormat:@"menuCategory = %@", self.menuCategory]];
    }
    
    // format predicate from components
    NSMutableString *predicateFormat = [[NSMutableString alloc]init];
    for(int i = 0; i < predicateComponents.count; i++) {
        NSString *component = [predicateComponents objectAtIndex:i];
        [predicateFormat appendString:predicateFormat.length ? [NSString stringWithFormat:@" AND %@", component] : [NSString stringWithFormat:@"%@", component]];
    }
    
    return predicateFormat.length ? [NSPredicate predicateWithFormat:predicateFormat] : predicate;
}


@end
