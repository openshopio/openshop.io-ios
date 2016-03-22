//
//  NSNumber+BFNSelection.m
//  OpenShop
//
//  Created by Petr Škorňok on 23.02.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "NSNumber+BFNSelection.h"

@implementation NSNumber (BFNSelection)

#pragma mark - BFNSelection Protocol

+ (NSPredicate *)predicateWithSearchQuery:(NSString *)query {
    return [NSPredicate predicateWithValue:true];
}

- (NSString *)sectionIndexTitle {
    return nil;
}

- (NSComparisonResult)compare:(id<BFNSelection>)item {
    return NSOrderedSame;
}

- (NSString *)displayName {
    return self ? [NSString stringWithFormat:@"%@", self] : @"";
}

@end
