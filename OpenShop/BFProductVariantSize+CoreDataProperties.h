//
//  BFProductVariantSize+CoreDataProperties.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFProductVariantSize.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFProductVariantSize (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *sizeID;
@property (nullable, nonatomic, retain) NSString *value;
@property (nullable, nonatomic, retain) NSSet<BFProductVariant *> *productVariants;

@end

@interface BFProductVariantSize (CoreDataGeneratedAccessors)

- (void)addProductVariantsObject:(BFProductVariant *)value;
- (void)removeProductVariantsObject:(BFProductVariant *)value;
- (void)addProductVariants:(NSSet<BFProductVariant *> *)values;
- (void)removeProductVariants:(NSSet<BFProductVariant *> *)values;

@end

NS_ASSUME_NONNULL_END
