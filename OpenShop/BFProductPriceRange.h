//
//  BFProductPriceRange.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFProductVariantColor.h"
#import "BFNFiltering.h"
#import "BFAPIResponseDataModelMapping.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFProductPriceRange` serves as the product price range wrapper. It implements
 * the `BFNFiltering` protocol specifying required methods during the filtering process.
 */
@interface BFProductPriceRange : NSObject  <BFNFiltering>

/**
 * Product price range minimum value.
 */
@property (nonatomic, strong) NSNumber *min;
/**
 * Product price range maximum value.
 */
@property (nonatomic, strong) NSNumber *max;


@end

NS_ASSUME_NONNULL_END
