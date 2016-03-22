//
//  BFRegion+CoreDataProperties.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFRegion.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFRegion (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *regionID;
@property (nullable, nonatomic, retain) NSString *name;

@end

NS_ASSUME_NONNULL_END
