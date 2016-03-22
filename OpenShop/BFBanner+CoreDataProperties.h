//
//  BFBanner+CoreDataProperties.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFBanner.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFBanner (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *bannerID;
@property (nullable, nonatomic, retain) NSString *imageURL;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *target;

@end

NS_ASSUME_NONNULL_END
