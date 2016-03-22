//
//  BFCategory+CoreDataProperties.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFCategory.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFCategory (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *categoryID;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *originalID;
@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSNumber *isCategory;
@property (nullable, nonatomic, retain) NSOrderedSet<BFCategory *> *children;
@property (nullable, nonatomic, retain) BFCategory *parent;

@end

@interface BFCategory (CoreDataGeneratedAccessors)

- (void)insertObject:(BFCategory *)value inChildrenAtIndex:(NSUInteger)idx;
- (void)removeObjectFromChildrenAtIndex:(NSUInteger)idx;
- (void)insertChildren:(NSArray<BFCategory *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeChildrenAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInChildrenAtIndex:(NSUInteger)idx withObject:(BFCategory *)value;
- (void)replaceChildrenAtIndexes:(NSIndexSet *)indexes withChildren:(NSArray<BFCategory *> *)values;
- (void)addChildrenObject:(BFCategory *)value;
- (void)removeChildrenObject:(BFCategory *)value;
- (void)addChildren:(NSOrderedSet<BFCategory *> *)values;
- (void)removeChildren:(NSOrderedSet<BFCategory *> *)values;

@end

NS_ASSUME_NONNULL_END
