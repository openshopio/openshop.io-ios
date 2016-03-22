//
//  BFProduct+CoreDataProperties.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFProduct.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFProduct (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *brand;
@property (nullable, nonatomic, retain) NSNumber *categoryID;
@property (nullable, nonatomic, retain) NSString *currency;
@property (nullable, nonatomic, retain) NSNumber *discountPrice;
@property (nullable, nonatomic, retain) NSString *discountPriceFormatted;
@property (nullable, nonatomic, retain) NSString *imageURL;
@property (nullable, nonatomic, retain) NSString *imageURLHighRes;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *price;
@property (nullable, nonatomic, retain) NSString *priceFormatted;
@property (nullable, nonatomic, retain) NSString *productDescription;
@property (nullable, nonatomic, retain) NSNumber *productID;
@property (nullable, nonatomic, retain) NSString *productURL;
@property (nullable, nonatomic, retain) NSNumber *remoteID;
@property (nullable, nonatomic, retain) NSSet<BFProductVariant *> *productVariants;
@property (nullable, nonatomic, retain) NSSet<BFProduct *> *relatedProducts;
@property (nullable, nonatomic, retain) NSSet<BFProduct *> *relatedTo;

@end

@interface BFProduct (CoreDataGeneratedAccessors)

- (void)addProductVariantsObject:(BFProductVariant *)value;
- (void)removeProductVariantsObject:(BFProductVariant *)value;
- (void)addProductVariants:(NSSet<BFProductVariant *> *)values;
- (void)removeProductVariants:(NSSet<BFProductVariant *> *)values;

- (void)addRelatedProductsObject:(BFProduct *)value;
- (void)removeRelatedProductsObject:(BFProduct *)value;
- (void)addRelatedProducts:(NSSet<BFProduct *> *)values;
- (void)removeRelatedProducts:(NSSet<BFProduct *> *)values;

- (void)addRelatedToObject:(BFProduct *)value;
- (void)removeRelatedToObject:(BFProduct *)value;
- (void)addRelatedTo:(NSSet<BFProduct *> *)values;
- (void)removeRelatedTo:(NSSet<BFProduct *> *)values;

@end

NS_ASSUME_NONNULL_END
