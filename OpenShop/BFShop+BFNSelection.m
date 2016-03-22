//
//  BFShop+BFNSelection.m
//  OpenShop
//
//  Created by Petr Škorňok on 05.02.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFShop+BFNSelection.h"

@implementation BFShop (BFNSelection)

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
    if([item isKindOfClass:[BFShop class]]) {
        BFShop *shop = (BFShop *)item;
        if(self.name && shop.name) {
            return [self.name compare:(NSString *)shop.name];
        }
        else {
            return self.name ? NSOrderedDescending : (shop.name ? NSOrderedAscending : NSOrderedSame);
        }
    }
    return NSOrderedSame;
}

- (NSString *)displayName {
    return self.name ? (NSString *)self.name : @"";
}

-(NSURL *)displayImageURL {
    return self.flagIcon && self.flagIcon.length > 0 ? [NSURL URLWithString:self.flagIcon] : nil;
}

@end
