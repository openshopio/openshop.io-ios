//
//  NSObject+BFRuntimeAdditions.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "NSObject+BFRuntimeAdditions.h"


@implementation NSObject (BFRuntimeAdditions)


#pragma mark - Methods Implementation Exchange

+ (void)BFN_exchangeClassMethod:(SEL)originalSelector withReplacement:(SEL)replacementSelector checkExistence:(BOOL)existence {
    Method originalMethod = class_getClassMethod([self class], originalSelector);
    Method replacementMethod = class_getClassMethod([self class], replacementSelector);
    [self BFN_exchangeMethod:originalMethod withReplacement:replacementMethod checkExistence:existence];
}

+ (void)BFN_exchangeClassMethod:(SEL)originalSelector withReplacement:(SEL)replacementSelector {
    [self BFN_exchangeClassMethod:originalSelector withReplacement:replacementSelector checkExistence:true];
}

+ (void)BFN_exchangeInstanceMethod:(SEL)originalSelector withReplacement:(SEL)replacementSelector checkExistence:(BOOL)existence {
    Method originalMethod = class_getInstanceMethod([self class], originalSelector);
    Method replacementMethod = class_getInstanceMethod([self class], replacementSelector);
    [self BFN_exchangeMethod:originalMethod withReplacement:replacementMethod checkExistence:existence];
}

+ (void)BFN_exchangeInstanceMethod:(SEL)originalSelector withReplacement:(SEL)replacementSelector {
    Method originalMethod = class_getInstanceMethod([self class], originalSelector);
    Method replacementMethod = class_getInstanceMethod([self class], replacementSelector);
    [self BFN_exchangeMethod:originalMethod withReplacement:replacementMethod checkExistence:true];
}

+ (void)BFN_exchangeMethod:(Method)originalMethod withReplacement:(Method)replacementMethod checkExistence:(BOOL)existence {
    // check for method existence
    if(existence && class_addMethod([self class], method_getDescription(replacementMethod)->name, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))) {
        class_replaceMethod([self class], method_getDescription(originalMethod)->name, method_getImplementation(replacementMethod), method_getTypeEncoding(replacementMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, replacementMethod);
    }
}


#pragma mark - Associated Objects Getters & Setters

- (id)BFN_getAssociatedObjectForKey:(void *)key {
    return [self BFN_getAssociatedObjectForKey:key withDefaultValue:nil];
}

- (id)BFN_getAssociatedObjectForKey:(void *)key withDefaultValue:(id)defaultValue {
    @synchronized(self)
    {
        id value = objc_getAssociatedObject(self, key);
        if (!value && defaultValue) {
            value = defaultValue;
            [self BFN_setAssociatedObject:value forKey:key];
        }
        return value;
    }
}

- (void)BFN_setAssociatedObject:(id)object forKey:(void *)key {
    [self BFN_setAssociatedObject:object forKey:key withAssociation:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

- (void)BFN_setAssociatedObject:(id)object forKey:(void *)key withAssociation:(objc_AssociationPolicy)association {
    @synchronized(self)
    {
        objc_setAssociatedObject(self, key, object, association);
    }
}


#pragma mark - Associated Objects Modification

- (void)BFN_addAssociatedObject:(id)object forKey:(void *)key {
    [self BFN_addAssociatedObject:object forObjectKey:nil withKey:key];
}

- (void)BFN_addAssociatedObject:(id)object forObjectKey:(NSString *)objectKey withKey:(void *)key {
    @synchronized(self)
    {
        if(objectKey) {
            id obj = [self BFN_getAssociatedObjectForKey:key withDefaultValue:[[NSMutableDictionary alloc]init]];
            if([obj isKindOfClass:[NSMutableDictionary class]]) {
                [obj setObject:object forKey:objectKey];
            }
        }
        else {
            id obj = [self BFN_getAssociatedObjectForKey:key withDefaultValue:[[NSMutableArray alloc]init]];
            if([obj isKindOfClass:[NSMutableArray class]]) {
                [obj addObject:object];
            }
        }
    }
}

- (void)BFN_removeAssociatedObject:(id)object withKey:(void *)key {
    [self BFN_removeAssociatedObject:object forObjectKey:nil withKey:key];
}

- (void)BFN_removeAssociatedObject:(id)object forObjectKey:(NSString *)objectKey withKey:(void *)key {
    @synchronized(self)
    {
        if(objectKey) {
            id obj = [self BFN_getAssociatedObjectForKey:key withDefaultValue:[[NSMutableDictionary alloc]init]];
            if([obj isKindOfClass:[NSMutableDictionary class]]) {
                [obj removeObjectForKey:objectKey];
            }
        }
        else {
            id obj = [self BFN_getAssociatedObjectForKey:key withDefaultValue:[[NSMutableArray alloc]init]];
            if([obj isKindOfClass:[NSMutableArray class]]) {
                [obj removeObject:object];
            }
        }
    }
}

@end
