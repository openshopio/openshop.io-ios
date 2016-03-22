//
//  NSArray+BFObjectFiltering.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "NSArray+BFObjectFiltering.h"


@implementation NSArray (BFObjectFiltering)


#pragma mark - Attribute Value Examination

- (id)BFN_minValueForAttribute:(NSString *)attribute {
    return [self valueForKeyPath:[NSString stringWithFormat:@"@min.%@", attribute]];
}

- (id)BFN_maxValueForAttribute:(NSString *)attribute {
    return [self valueForKeyPath:[NSString stringWithFormat:@"@max.%@", attribute]];
}

- (NSNumber *)BFN_avgValueForAttribute:(NSString *)attribute {
    return [self valueForKeyPath:[NSString stringWithFormat:@"@avg.%@", attribute]];
}

- (NSNumber *)BFN_sumValueForAttribute:(NSString *)attribute {
    return [self valueForKeyPath:[NSString stringWithFormat:@"@sum.%@", attribute]];
}


#pragma mark - Attribute Values Selection

- (NSArray *)BFN_distinctValuesOfAttribute:(NSString *)attribute {
    return [self valueForKeyPath:[NSString stringWithFormat:@"@distinctUnionOfObjects.%@", attribute]];
}

- (NSArray *)BFN_valuesOfAttribute:(NSString *)attribute {
    return [self valueForKeyPath:[NSString stringWithFormat:@"@unionOfObjects.%@", attribute]];
}


#pragma mark - Filtered Objects By Attribute Bindings

- (id)BFN_objectForAttributeBindings:(NSDictionary *)bindings {
    return [[self BFN_objectsForAttributeBindings:bindings] firstObject];
}

- (NSArray *)BFN_objectsForAttributeBindings:(NSDictionary *)bindings {
    NSPredicate *__block predicate = [NSPredicate predicateWithValue:true];
    
    [bindings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL * stop) {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate, [NSPredicate predicateWithFormat:@"%K == %@", key, obj]]];
    }];
    
    return [self filteredArrayUsingPredicate:predicate];
}

@end



