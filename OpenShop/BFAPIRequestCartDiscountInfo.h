//
//  BFAPIRequestCartDiscountInfo.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import "BFJSONSerializableObject.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFAPIRequestCartDiscountInfo` encapsulates information used when accessing remote API
 * with shopping cart discounts requests.
 */
@interface BFAPIRequestCartDiscountInfo : BFJSONSerializableObject
/**
 * Shopping cart discount identification.
 */
@property (strong, nullable) NSNumber *discountID;
/**
 * Shopping cart discount code.
 */
@property (strong, nullable) NSString *discountCode;


/**
 * Initializes a `BFAPIRequestCartDiscountInfo` object with shopping cart discount code.
 *
 * @param discountCode The discount code.
 * @return The newly-initialized `BFAPIRequestCartDiscountInfo`.
 */
- (instancetype)initWithDiscountCode:(NSString *)discountCode;
/**
 * Initializes a `BFAPIRequestCartDiscountInfo` object with shopping cart discount ID.
 *
 * @param discountID The discount identifier.
 * @return The newly-initialized `BFAPIRequestCartDiscountInfo`.
 */
- (instancetype)initWithDiscountIdentifier:(NSNumber *)discountID;



@end

NS_ASSUME_NONNULL_END

