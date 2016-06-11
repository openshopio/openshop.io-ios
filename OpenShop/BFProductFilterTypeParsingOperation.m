//
//  BFProductFilterTypeParsingOperation.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFProductFilterTypeParsingOperation.h"
#import "BFParsedResult.h"
#import "BFNFiltering.h"
#import "BFProductVariantColor.h"
#import "BFProductVariantSize.h"
#import "BFProductBrand.h"
#import "BFProductPriceRange.h"
#import "BFProductVariantColorParsedResult.h"
#import "BFProductVariantSizeParsedResult.h"
#import "BFProductBrandParsedResult.h"
#import "NSArray+BFObjectFiltering.h"

/**
 * The product filter type name element key path in a raw JSON data.
 */
static NSString *const BFProductFilterTypeParsingNameElementKey = @"name";
/**
 * The product filter type element key path in a raw JSON data.
 */
static NSString *const BFProductFilterTypeParsingTypeElementKey = @"type";
/**
 * The product filter type values element key path in a raw JSON data.
 */
static NSString *const BFProductFilterTypeParsingValuesElementKey = @"values";


@interface BFProductFilterTypeParsingOperation ()


@end


@implementation BFProductFilterTypeParsingOperation


#pragma mark - Parsing

- (void)main {
    // filters
    NSDictionary *filterType = (NSDictionary *)self.rawData;
    if(filterType) {
        // filter type parsing
        [self.managedObjectContext performBlockAndWait:^{
            NSMutableArray *filters = [[NSMutableArray alloc]init];
            // filter type name
            NSString *filterTypeName = [filterType objectForKey:BFProductFilterTypeParsingTypeElementKey];
            if(filterTypeName && [BFAppStructure filterTypeFromAPIName:filterTypeName]) {
                NSArray *filterTypeValues = [filterType objectForKey:BFProductFilterTypeParsingValuesElementKey];
                // filter type values
                if(filterTypeValues) {
                    NSArray *filterTypeItems = [self parseFilterTypeItems:filterTypeValues ofType:(BFNFilterType)[[BFAppStructure filterTypeFromAPIName:filterTypeName]integerValue]];
                    if(filterTypeItems) {
                        [filters addObjectsFromArray:filterTypeItems];
                    }
                }
            }
            
            // save parsed records
            NSError *error;
            if ([self.managedObjectContext save:&error]) {
                if(self.completion) {
                    self.completion(filters, nil, nil);
                }
            }
            else {
                if(self.completion) {
                    self.completion(nil, nil, error);
                }
            }
        }];
    }
    else {
        if(self.completion) {
            self.completion(nil, nil, [BFError errorWithCode:BFErrorCodeNoData]);
        }
    }
}

- (NSArray *)parseFilterTypeItems:(NSArray *)filterTypeValues ofType:(BFNFilterType)filterType {
    NSMutableArray *filterItems = [NSMutableArray new];
    NSMutableArray *filterItemIDs = [NSMutableArray new];
    
    // parse filter items
    for(id filterTypeValue in filterTypeValues) {
        id<BFNFiltering> filterItem;
        NSNumber *filterItemID;
        if([filterTypeValue isKindOfClass:[NSDictionary class]]) {
            switch (filterType) {
                // color filter item
                case BFNProductFilterTypeColor:
                    filterItem = [BFProductVariantColorParsedResult dataModelFromDictionary:(NSDictionary *)filterTypeValue];
                    filterItemID = filterItem ? [(BFProductVariantColor *)filterItem colorID] : nil;
                    break;
                // size filter item
//                case BFNProductFilterTypeSelect:
//                    filterItem = [BFProductVariantSizeParsedResult dataModelFromDictionary:(NSDictionary *)filterTypeValue];
//                    filterItemID = filterItem ? [(BFProductVariantSize *)filterItem sizeID] : nil;
//                    break;
                default:
                    break;
            }
        }
        // save filter item
        if(filterItem && filterItemID && ![filterItemIDs containsObject:filterItemID]) {
            [filterItems addObject:filterItem];
            [filterItemIDs addObject:filterItemID];
        }
    }
    
    // parse product price range filter item
    if (filterType == BFNProductFilterTypeRange) {
        if([(NSArray *)filterTypeValues count] >= 2) {
            BFProductPriceRange *priceRange = [[BFProductPriceRange alloc]init];
            if([[filterTypeValues objectAtIndex:0]isKindOfClass:[NSNumber class]]) {
                priceRange.min = @([[filterTypeValues objectAtIndex:0]integerValue]);
            }
            if([[filterTypeValues objectAtIndex:1]isKindOfClass:[NSNumber class]]) {
                priceRange.max = @([[filterTypeValues objectAtIndex:1]integerValue]);
            }
            [filterItems addObject:priceRange];
        }
    }
    
    return filterItems;
}

@end



