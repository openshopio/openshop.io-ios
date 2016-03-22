//
//  BFWishlistItem+CoreDataProperties.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFWishlistItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFWishlistItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *wishlistItemID;
@property (nullable, nonatomic, retain) BFProductVariant *productVariant;

@end

NS_ASSUME_NONNULL_END
