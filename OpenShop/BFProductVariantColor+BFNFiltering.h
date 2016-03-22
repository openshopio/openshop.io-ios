//
//  BFProductVariantColor+BFNFiltering.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFProductVariantColor.h"
#import "BFNFiltering.h"
#import "BFAPIResponseDataModelMapping.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFNFiltering` category of BFProductVariantColor adds ability to be used as the filtering data source item
 * and to be serializable to JSON. It implements the `BFNFiltering` protocol specifying required methods during
 * the filtering process and the `BFAPIResponseDataModelMapping` protocol to map data model properties to the
 * different key paths in JSON.
 */
@interface BFProductVariantColor (BFNFiltering) <BFNFiltering, BFAPIResponseDataModelMapping>




@end

NS_ASSUME_NONNULL_END
