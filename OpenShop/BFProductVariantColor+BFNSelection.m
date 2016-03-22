//
//  BFProductVariantColor+BFNSelection.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFProductVariantColor+BFNSelection.h"


@implementation BFProductVariantColor (BFNSelection)


#pragma mark - BFNSelection Protocol

+ (NSPredicate *)predicateWithSearchQuery:(NSString *)query {
    if(query && ![query isEqualToString:@""]) {
        return [NSPredicate predicateWithFormat:@"SELF.name contains[cd] %@", query];
    }
    return [NSPredicate predicateWithValue:true];
}

- (NSString *)sectionIndexTitle {
    if(self.name && self.name.length) {
        return [[(NSString *)self.name substringWithRange:NSMakeRange(0, 1)]uppercaseString];
    }
    return nil;
}

- (NSComparisonResult)compare:(id<BFNSelection>)item {
    if([item isKindOfClass:[BFProductVariantColor class]]) {
        BFProductVariantColor *color = (BFProductVariantColor *)item;
        if(self.name && color.name) {
            return [self.name compare:(NSString *)color.name];
        }
        else {
            return self.name ? NSOrderedDescending : (color.name ? NSOrderedAscending : NSOrderedSame);
        }
    }
    return NSOrderedSame;
}

- (NSString *)displayName {
    return self.name ? (NSString *)self.name : @"";
}


@end