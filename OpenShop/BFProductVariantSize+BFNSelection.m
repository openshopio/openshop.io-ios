//
//  BFProductVariantSize+BFNSelection.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFProductVariantSize+BFNSelection.h"


@implementation BFProductVariantSize (BFNSelection)


#pragma mark - BFNSelection Protocol

+ (NSPredicate *)predicateWithSearchQuery:(NSString *)query {
    if(query && ![query isEqualToString:@""]) {
        return [NSPredicate predicateWithFormat:@"SELF.value contains[cd] %@", query];
    }
    return [NSPredicate predicateWithValue:true];
}

- (NSString *)sectionIndexTitle {
    if(self.value && self.value.length) {
        return [[(NSString *)self.value substringWithRange:NSMakeRange(0, 1)]uppercaseString];
    }
    return nil;
}

- (NSComparisonResult)compare:(id<BFNSelection>)item {
    if([item isKindOfClass:[BFProductVariantSize class]]) {
        BFProductVariantSize *size = (BFProductVariantSize *)item;
        if(self.value && size.value) {
            return [self.value compare:(NSString *)size.value];
        }
        else {
            return self.value ? NSOrderedDescending : (size.value ? NSOrderedAscending : NSOrderedSame);
        }
    }
    return NSOrderedSame;
}

- (NSString *)displayName {
    return self.value ? (NSString *)self.value : @"";
}


@end