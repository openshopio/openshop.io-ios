//
//  UIColor+BFColor.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "UIColor+BFColor.h"

@implementation UIColor (BFColor)


#pragma mark - Color Definitions

+ (UIColor *)BFN_pinkColor {
    return [self BFN_pinkColorWithAlpha:1.0f];
}

+ (UIColor *)BFN_orangeColor {
    return [self BFN_orangeColorWithAlpha:1.0f];
}

+ (UIColor *)BFN_darkerDimColor {
    return [self BFN_blackColorWithAlpha:0.7f];
}

+ (UIColor *)BFN_dimColor {
    return [self BFN_blackColorWithAlpha:0.5f];
}

+ (UIColor *)BFN_lighterDimColor {
    return [self BFN_blackColorWithAlpha:0.3f];
}

+ (UIColor *)BFN_blackColorWithAlpha:(CGFloat)alpha {
    // #000000
    return [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:alpha];
}

+ (UIColor *)BFN_pinkColorWithAlpha:(CGFloat)alpha {
    // #ee1f65
    return [UIColor colorWithRed:0.933 green:0.122 blue:0.396 alpha:alpha];
}

+ (UIColor *)BFN_orangeColorWithAlpha:(CGFloat)alpha {
    // #f58345
    return [UIColor colorWithRed:0.961 green:0.514 blue:0.271 alpha:alpha];
}

+ (UIColor *)BFN_FBBlueColorWithAlpha:(CGFloat)alpha {
    // #0c53a5
    return [UIColor colorWithRed:0.047 green:0.325 blue:0.647 alpha:alpha];
}

+ (UIColor *)BFN_greyColor {
    return [self BFN_greyColorWithAlpha:1.0f];
}

+ (UIColor *)BFN_greyColorWithAlpha:(CGFloat)alpha {
    // #f7f7f7
    return [UIColor colorWithWhite:0.98 alpha:alpha];
}

+ (UIColor *)BFN_lightGreySeparatorColor {
    // #dedede
    return [UIColor colorWithRed:0.871 green:0.871 blue:0.871 alpha:1];
}


@end
