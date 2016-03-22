//
//  BFAPIRequestCartProductInfo.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFAPIRequestCartProductInfo.h"

/**
 * Properties names used to match attributes during JSON serialization.
 */
static NSString *const BFAPIRequestCartProductInfoProductVariantIDPropertyName       = @"productVariantID";
static NSString *const BFAPIRequestCartProductInfoQuantityPropertyName               = @"quantity";

/**
 * Properties JSON mappings used to match attributes during serialization.
 */
static NSString *const BFAPIRequestCartProductInfoProductVariantIDPropertyJSONMapping = @"product_variant_id";
static NSString *const BFAPIRequestCartProductInfoQuantityPropertyJSONMapping         = @"quantity";


@implementation BFAPIRequestCartProductInfo


#pragma mark - Initialization

- (instancetype)initWithProductVariantIdentification:(NSNumber *)productVariantIdentification
                                            quantity:(NSNumber *)quantity {
    self = [super init];
    if (self) {
        _productVariantID = productVariantIdentification;
        _quantity = quantity;
    }
    return self;
}

- (instancetype)initWithCartProductIdentification:(NSNumber *)cartProductIdentification
                                         quantity:(NSNumber *)quantity {
    self = [super init];
    if (self) {
        _cartProductID = cartProductIdentification;
        _quantity = quantity;
    }
    return self;
}

- (instancetype)initWithProductVariantIdentification:(NSNumber *)productVariantIdentification
                           cartProductIdentification:(NSNumber *)cartProductIdentification
                                            quantity:(NSNumber *)quantity {
    self = [super init];
    if (self) {
        _productVariantID = productVariantIdentification;
        _cartProductID = cartProductIdentification;
        _quantity = quantity;
    }
    return self;
}

#pragma mark - JSON Serialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             BFAPIRequestCartProductInfoProductVariantIDPropertyName       : BFAPIRequestCartProductInfoProductVariantIDPropertyJSONMapping,
             BFAPIRequestCartProductInfoQuantityPropertyName               : BFAPIRequestCartProductInfoQuantityPropertyJSONMapping,
             };
}


@end
