//
//  BFOrderItem+CoreDataProperties.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFOrderItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFOrderItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *quantity;
@property (nullable, nonatomic, retain) NSNumber *price;
@property (nullable, nonatomic, retain) NSString *priceFormatted;
@property (nullable, nonatomic, retain) NSNumber *orderItemID;
@property (nullable, nonatomic, retain) BFOrder *inOrder;
@property (nullable, nonatomic, retain) BFProductVariant *productVariant;

@end

NS_ASSUME_NONNULL_END
