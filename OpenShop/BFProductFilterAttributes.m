//
//  BFProductFilterAttributes.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFProductFilterAttributes.h"
#import "BFProductVariantColor+BFNFiltering.h"
#import "BFProductVariantSize+BFNFiltering.h"

@interface BFProductFilterAttributes ()

@end


@implementation BFProductFilterAttributes


#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        // filter items
        self.productVariantColors = [NSMutableArray new];
        self.productBrands = [NSMutableArray new];
        self.productVariantSizes = [NSMutableArray new];
        self.productPriceRange = [[BFProductPriceRange alloc]init];
        // selected filter items
        self.selectedProductVariantColors = [NSMutableArray new];
        self.selectedProductBrands = [NSMutableArray new];
        self.selectedProductVariantSizes = [NSMutableArray new];
        self.selectedProductPriceRange = nil;
    }
    return self;
}


#pragma mark - Filter Items Modification

- (void)addFilterItems:(NSArray *)items {
    // update each filter type with corresponding items
    [self.productVariantColors addObjectsFromArray:[self filterArray:items usingFilterType:BFNProductFilterTypeColor]];
    [self.productVariantSizes addObjectsFromArray:[self filterArray:items usingFilterType:BFNProductFilterTypeSize]];
    [self.productBrands addObjectsFromArray:[self filterArray:items usingFilterType:BFNProductFilterTypeBrand]];
    NSArray *priceRanges = [self filterArray:items usingFilterType:BFNProductFilterTypePriceRange];
    if([priceRanges count]) {
        self.productPriceRange = (BFProductPriceRange *)[priceRanges firstObject];
    }
}

- (void)addSelectedFilterItems:(NSArray *)items {
    // add selected items of filter type
    [self.selectedProductVariantColors addObjectsFromArray:[self filterArray:items usingFilterType:BFNProductFilterTypeColor]];
    [self.selectedProductVariantSizes addObjectsFromArray:[self filterArray:items usingFilterType:BFNProductFilterTypeSize]];
    [self.selectedProductBrands addObjectsFromArray:[self filterArray:items usingFilterType:BFNProductFilterTypeBrand]];
    NSArray *priceRanges = [self filterArray:items usingFilterType:BFNProductFilterTypePriceRange];
    if([priceRanges count]) {
        self.productPriceRange = (BFProductPriceRange *)[priceRanges firstObject];
    }
}

- (NSArray *)filterArray:(NSArray *)array usingFilterType:(BFNFilterType)filterType {
    // filter items of specified type
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        id<BFNFiltering> item = (id<BFNFiltering>)evaluatedObject;
        return [item filterType] == filterType;
    }];
    return [array filteredArrayUsingPredicate:predicate];
}

- (void)setSelectedFilterItems:(NSArray *)items ofFilterType:(BFNFilterType)filterType {
    // clean data source for specififed filter type
    switch (filterType) {
        case BFNProductFilterTypeColor:
            [self.selectedProductVariantColors removeAllObjects];
            break;
        case BFNProductFilterTypeSize:
            [self.selectedProductVariantSizes removeAllObjects];
            break;
        case BFNProductFilterTypeBrand:
            [self.selectedProductBrands removeAllObjects];
            break;
        default:
            break;
    }
    // add selected items
    [self addSelectedFilterItems:items];
}


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    id copy = [[[self class] allocWithZone:zone] init];
    
    if (copy) {
        // copy selected filter items
        if(self.selectedProductVariantColors) {
            [copy setSelectedProductVariantColors:[[NSMutableArray alloc]initWithArray:(NSArray *)self.selectedProductVariantColors]];
        }
        if(self.selectedProductVariantSizes) {
            [copy setSelectedProductVariantSizes:[[NSMutableArray alloc]initWithArray:(NSArray *)self.selectedProductVariantSizes]];
        }
        if(self.selectedProductBrands) {
            [copy setSelectedProductBrands:[[NSMutableArray alloc]initWithArray:(NSArray *)self.selectedProductBrands]];
        }
        if(self.selectedProductPriceRange) {
            [copy setSelectedProductPriceRange:self.selectedProductPriceRange];
        }

        // set filter items
        [copy setProductVariantColors:self.productVariantColors];
        [copy setProductVariantSizes:self.productVariantSizes];
        [copy setProductBrands:self.productBrands];
        [copy setProductPriceRange:self.productPriceRange];
    }
    
    return copy;
}



@end