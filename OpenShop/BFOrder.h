//
//  BFOrder.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import Foundation;
@import CoreData;
#import "BFRecord.h"

@class BFOrderShipping, BFOrderItem;

NS_ASSUME_NONNULL_BEGIN

@interface BFOrder : BFRecord


@end

NS_ASSUME_NONNULL_END

#import "BFOrder+CoreDataProperties.h"
