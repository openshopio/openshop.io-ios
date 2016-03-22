//
//  BFProductVariantColor+CoreDataProperties.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFProductVariantColor.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFProductVariantColor (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *colorID;
@property (nullable, nonatomic, retain) NSString *hexValue;
@property (nullable, nonatomic, retain) NSString *imageURL;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<BFProductVariant *> *productVariants;

@end

@interface BFProductVariantColor (CoreDataGeneratedAccessors)

- (void)addProductVariantsObject:(BFProductVariant *)value;
- (void)removeProductVariantsObject:(BFProductVariant *)value;
- (void)addProductVariants:(NSSet<BFProductVariant *> *)values;
- (void)removeProductVariants:(NSSet<BFProductVariant *> *)values;

@end

NS_ASSUME_NONNULL_END
