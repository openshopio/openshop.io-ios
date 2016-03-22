//
//  BFOrderShipping.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import Foundation;
@import CoreData;
#import "BFRecord.h"
#import "BFAPIResponseDataModelMapping.h"

@class BFOrder;

NS_ASSUME_NONNULL_BEGIN

@interface BFOrderShipping : BFRecord <BFAPIResponseDataModelMapping>


@end

NS_ASSUME_NONNULL_END

#import "BFOrderShipping+CoreDataProperties.h"
