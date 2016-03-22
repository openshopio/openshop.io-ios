//
//  BFJSONSerializableObject.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFJSONSerializableObject.h"
#import <Mantle/MTLJSONAdapter.h>
@import ObjectiveC.runtime;

@implementation BFJSONSerializableObject


#pragma mark - JSON Serialization

- (BOOL)updateWithJSONDictionary:(NSDictionary *)JSONDictionary error:(NSError *__autoreleasing*)error {
    id dataObject = [MTLJSONAdapter modelOfClass:self.class fromJSONDictionary:JSONDictionary error:error];
    if(!(*error)) {
        [self mergeValuesForKeysFromModel:dataObject];
    }
    return (*error) == nil;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    // default properties mapping
    NSArray *names = [[self propertyKeys] allObjects];
    return [NSDictionary dictionaryWithObjects:names forKeys:names];
}

- (NSDictionary *)JSONDictionaryWithError:(NSError *__autoreleasing*)error {
    NSMutableDictionary *modifiedDictionaryValue = [[MTLJSONAdapter JSONDictionaryFromModel:self error:error]mutableCopy];
    
    [modifiedDictionaryValue enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL* stop) {
        NSArray *originalKeyOptions = [[[self class] JSONKeyPathsByPropertyKey]allKeysForObject:key];
        if(originalKeyOptions.count) {
            NSString *originalkey = [originalKeyOptions firstObject];
            // remove serialized property with nil value
            if (![self valueForKey:originalkey]) {
                [modifiedDictionaryValue removeObjectForKey:key];
            }
        }
    }];
    
    return [modifiedDictionaryValue copy];
}


#pragma mark - JSON Deserialization

+ (instancetype)deserializedModelFromDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error {
    return [MTLJSONAdapter modelOfClass:self fromJSONDictionary:dictionaryValue error:error];
}


@end
