//
//  UIFont+BFFont.m
//  OpenShop
//
//  Created by Petr Škorňok
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "UIFont+BFFont.h"

@implementation UIFont (BFFont)


#pragma mark - Roboto Font Definitions

+ (UIFont *)BFN_robotoRegularWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"Roboto-Regular" size:fontSize];
}

+ (UIFont *)BFN_robotoMediumWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"Roboto-Medium" size:fontSize];
}

+ (UIFont *)BFN_robotoLightWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"Roboto-Light" size:fontSize];
}

+ (UIFont *)BFN_robotoBoldWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"Roboto-Bold" size:fontSize];
}

@end
