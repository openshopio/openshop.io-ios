//
//  BFNFiltering.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import "BFAppStructure.h"



NS_ASSUME_NONNULL_BEGIN

/**
 * `BFNFiltering` protocol specifies data model properties required in the
 * filtering process.
 */
@protocol BFNFiltering <NSObject>

/**
 * Returns the data model filter type.
 *
 * @return The filter type.
 */
- (BFNFilterType)filterType;
/**
 * Returns the data model filter value in the filter type.
 *
 * @return The filter value.
 */
- (id)filterValue;

@end

NS_ASSUME_NONNULL_END
