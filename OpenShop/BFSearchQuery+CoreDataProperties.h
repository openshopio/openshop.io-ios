//
//  BFSearchQuery+CoreDataProperties.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFSearchQuery.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFSearchQuery (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *searchQueryID;
@property (nullable, nonatomic, retain) NSNumber *quantity;
@property (nullable, nonatomic, retain) NSString *query;
@property (nullable, nonatomic, retain) NSDate *date;

@end

NS_ASSUME_NONNULL_END
