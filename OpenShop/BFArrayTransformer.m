//
//  BFArrayTransformer.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFArrayTransformer.h"


@implementation BFArrayTransformer


#pragma mark - NSValueTransformer

+ (Class)transformedValueClass {
    return [NSData class];
}

+ (BOOL)allowsReverseTransformation {
    return YES;
}

- (id)transformedValue:(id)value {
    if([value isKindOfClass:[NSData class]]) {
        return value;
    }
    return [NSKeyedArchiver archivedDataWithRootObject:value];
}

- (id)reverseTransformedValue:(id)value {
    return (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:value];
}

@end
