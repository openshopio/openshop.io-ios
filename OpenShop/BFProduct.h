//
//  BFProduct.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import Foundation;
@import CoreData;
#import "BFRecord.h"
#import "BFAPIResponseDataModelMapping.h"

@class BFProductVariant;

NS_ASSUME_NONNULL_BEGIN

@interface BFProduct : BFRecord <BFAPIResponseDataModelMapping>

/**
 * Returns formatted product price and discount information.
 *
 * @param percentage Boolean value which determines if the percentage string should be included
 * @return The formatted price and discount.
 */
- (NSAttributedString *)priceAndDiscountFormattedWithPercentage:(BOOL)percentage;

/**
 * Returns formatted product discount price information.
 *
 * @param color The color used for the discount foreground
 * @return The formatted discount.
 */
- (NSAttributedString *)discountFormattedWithColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END

#import "BFProduct+CoreDataProperties.h"
