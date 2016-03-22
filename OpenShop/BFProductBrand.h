//
//  BFNColor+BFNSelection.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFProductVariantColor.h"
#import "BFNFiltering.h"
#import "BFAPIResponseDataModelMapping.h"
#import "BFNSelection.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFNSelection` category of BFNColor adds ability to be able to directly work with BFNColor in the
 * `BFNSelectionViewController`. It implements `BFNSelection` protocol specifying required methods
 * during the selection process.
 */
@interface BFProductBrand : NSObject <BFNFiltering, BFNSelection, BFAPIResponseDataModelMapping>

@property (nonatomic, strong, nullable) NSNumber *brandID;
@property (nonatomic, copy, nullable) NSString *name;


@end

NS_ASSUME_NONNULL_END
