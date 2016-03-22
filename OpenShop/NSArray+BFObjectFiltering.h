//
//  NSArray+BFObjectFiltering.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFError.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFObjectFiltering` category of NSArray simplifies objects processing in array. It contains
 * methods for object attribute examination, attribute values selection and array filtering by
 * object attributes and their value bindings.
 */
@interface NSArray (BFObjectFiltering)


#pragma mark - Attribute Value Examination

/**
 * Returns minimum attribute value in the array of objects.
 *
 * @param attribute The object attribute name.
 * @return The minimum attribute value.
 */
- (nullable id)BFN_minValueForAttribute:(NSString *)attribute;
/**
 * Returns maximum attribute value in the array of objects.
 *
 * @param attribute The object attribute name.
 * @return The maximum attribute value.
 */
- (nullable id)BFN_maxValueForAttribute:(NSString *)attribute;
/**
 * Returns average attribute value in the array of objects.
 *
 * @param attribute The object attribute name.
 * @return The average attribute value.
 */
- (nullable NSNumber *)BFN_avgValueForAttribute:(NSString *)attribute;
/**
 * Returns summary of attribute values in the array of objects.
 *
 * @param attribute The object attribute name.
 * @return The summary of attribute values.
 */
- (nullable NSNumber *)BFN_sumValueForAttribute:(NSString *)attribute;


#pragma mark - Attribute Values Selection

/**
 * Returns distinct array of attribute values in the array of objects.
 *
 * @param attribute The object attribute name.
 * @return The distinct array of attribute values.
 */
- (nullable NSArray *)BFN_distinctValuesOfAttribute:(NSString *)attribute;
/**
 * Returns array of attribute values in the array of objects.
 *
 * @param attribute The object attribute name.
 * @return The array of attribute values.
 */
- (nullable NSArray *)BFN_valuesOfAttribute:(NSString *)attribute;


#pragma mark - Filtered Objects By Attribute Bindings

/**
 * Returns filtered object matching given object attributes values bindings.
 *
 * @param bindings The object attribute values bindings.
 * @return The filtered object.
 */
- (nullable id)BFN_objectForAttributeBindings:(NSDictionary *)bindings;
/**
 * Returns filtered array of objects matching given object attributes values bindings.
 *
 * @param bindings The object attribute values bindings.
 * @return The filtered array of objects.
 */
- (NSArray *)BFN_objectsForAttributeBindings:(NSDictionary *)bindings;

@end

NS_ASSUME_NONNULL_END
