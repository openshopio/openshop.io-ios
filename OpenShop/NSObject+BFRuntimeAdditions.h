//
//  NSObject+BFRuntimeAdditions.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import ObjectiveC.runtime;

NS_ASSUME_NONNULL_BEGIN


/**
 * `BFRuntimeAdditions` is a category that extends NSObject to make manage runtime object management simple.
 * It helps with object associations, it manages associated arrays, dictionaries and simplifies method
 * implementation exchanges to override the default behaviour.
 */
@interface NSObject (BFRuntimeAdditions)

/**
 * Exchanges class method implementation specified by a selector with a class method implementation specified by
 * a replacement selector.
 *
 * @param originalSelector The selector specifying original method.
 * @param replacementSelector The selector specifying replacement method.
 */
+ (void)BFN_exchangeClassMethod:(SEL)originalSelector withReplacement:(SEL)replacementSelector;
/**
 * Exchanges class method implementation specified by a selector with a class method implementation specified by
 * a replacement selector. If the replacement method is not implemented by the class it can be added to the class
 * with the optional existence parameter.
 *
 * @param originalSelector The selector specifying original method.
 * @param replacementSelector The selector specifying replacement method.
 * @param existence The replacement method existence is verified if set to TRUE.
 */
+ (void)BFN_exchangeClassMethod:(SEL)originalSelector withReplacement:(SEL)replacementSelector checkExistence:(BOOL)existence;
/**
 * Exchanges instance method implementation specified by a selector with an instance method implementation specified by
 * a replacement selector.
 *
 * @param originalSelector The selector specifying original method.
 * @param replacementSelector The selector specifying replacement method.
 */
+ (void)BFN_exchangeInstanceMethod:(SEL)originalSelector withReplacement:(SEL)replacementSelector;
/**
 * Exchanges instance method implementation specified by a selector with an instance method implementation specified by
 * a replacement selector. If the replacement method is not implemented by the class it can be added to the class
 * with the optional existence parameter.
 *
 * @param originalSelector The selector specifying original method.
 * @param replacementSelector The selector specifying replacement method.
 * @param existence The replacement method existence is verified if set to TRUE.
 */
+ (void)BFN_exchangeInstanceMethod:(SEL)originalSelector withReplacement:(SEL)replacementSelector checkExistence:(BOOL)existence;

/**
 * Returns the value associated with a given object for a given key.
 *
 * @param key The key for the association.
 * @return existence The value associated with the key for object.
 */
- (id)BFN_getAssociatedObjectForKey:(void *)key;
/**
 * Returns the value associated with a given object for a given key. The default association value can be specified
 * if none value is associated.
 *
 * @param key The key for the association.
 * @param defaultValue The default association value.
 * @return existence The value associated with the key for object.
 */
- (id)BFN_getAssociatedObjectForKey:(void *)key withDefaultValue:(nullable id)defaultValue;

/**
 * Sets an associated value for a given object using a given key.
 *
 * @param object The source object for the association.
 * @param key The key for the association.
 */
- (void)BFN_setAssociatedObject:(id)object forKey:(void *)key;
/**
 * Sets an associated value for a given object using a given key and association policy.
 *
 * @param object The source object for the association.
 * @param key The key for the association.
 * @param association The policy for the association.
 */
- (void)BFN_setAssociatedObject:(id)object forKey:(void *)key withAssociation:(objc_AssociationPolicy)association;

/**
 * Inserts a value into an associated object with a given key.
 *
 * @param object The source object to be inserted into an associated object.
 * @param key The key for the association.
 */
- (void)BFN_addAssociatedObject:(id)object forKey:(void *)key;
/**
 * Inserts a value using the object key into an associated object with a given key.
 *
 * @param object The source object to be inserted into an associated object.
 * @param objectKey The source object key.
 * @param key The key for the association.
 */
- (void)BFN_addAssociatedObject:(id)object forObjectKey:(nullable NSString *)objectKey withKey:(void *)key;
/**
 * Removes a value from an associated object with a given key.
 *
 * @param object The object to be removed from an associated object.
 * @param key The key for the association.
 */
- (void)BFN_removeAssociatedObject:(id)object withKey:(void *)key;
/**
 * Removes a value using the object key from an associated object with a given key.
 *
 * @param object The object to be removed from an associated object.
 * @param objectKey The object key.
 * @param key The key for the association.
 */
- (void)BFN_removeAssociatedObject:(id)object forObjectKey:(nullable NSString *)objectKey withKey:(void *)key;
    
@end

NS_ASSUME_NONNULL_END
