//
//  BFProduct+CoreDataProperties.h
//  OpenShop
//
//  Created by Petr Škorňok on 03.04.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
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
@property (nullable, nonatomic, retain) NSOrderedSet<BFProductVariant *> *productVariants;
@property (nullable, nonatomic, retain) NSSet<BFProduct *> *relatedProducts;
@property (nullable, nonatomic, retain) NSSet<BFProduct *> *relatedTo;

@end

@interface BFProduct (CoreDataGeneratedAccessors)

- (void)insertObject:(BFProductVariant *)value inProductVariantsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromProductVariantsAtIndex:(NSUInteger)idx;
- (void)insertProductVariants:(NSArray<BFProductVariant *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeProductVariantsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInProductVariantsAtIndex:(NSUInteger)idx withObject:(BFProductVariant *)value;
- (void)replaceProductVariantsAtIndexes:(NSIndexSet *)indexes withProductVariants:(NSArray<BFProductVariant *> *)values;
- (void)addProductVariantsObject:(BFProductVariant *)value;
- (void)removeProductVariantsObject:(BFProductVariant *)value;
- (void)addProductVariants:(NSOrderedSet<BFProductVariant *> *)values;
- (void)removeProductVariants:(NSOrderedSet<BFProductVariant *> *)values;

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
