//
//  BFProductVariant.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import Foundation;
@import CoreData;
#import "BFRecord.h"

@class BFCartProductItem, BFProduct, BFProductVariantColor, BFProductVariantSize, BFWishlistItem, BFOrderItem;

NS_ASSUME_NONNULL_BEGIN

@interface BFProductVariant : BFRecord


@end

NS_ASSUME_NONNULL_END

#import "BFProductVariant+CoreDataProperties.h"
