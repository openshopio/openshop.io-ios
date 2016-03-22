//
//  UIColor+BFColor.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import UIKit;

/**
 * `BFColor` category of UIColor defines custom application colors.
 */
@interface UIColor (BFColor)

/**
 * Returns custom pink color.
 *
 * @return The pink color.
 */
+ (UIColor *)BFN_pinkColor;
/**
 * Returns custom orange color.
 *
 * @return The orange color.
 */
+ (UIColor *)BFN_orangeColor;
/**
 * Returns custom lighter dim color.
 *
 * @return The lighter dim color.
 */
+ (UIColor *)BFN_lighterDimColor;
/**
 * Returns custom dim color.
 *
 * @return The dim color.
 */
+ (UIColor *)BFN_dimColor;
/**
 * Returns custom darker dim color.
 *
 * @return The darker dim color.
 */
+ (UIColor *)BFN_darkerDimColor;
/**
 * Returns custom pink color with specified alpha value.
 *
 * @return The pink color with alpha value.
 */
+ (UIColor *)BFN_pinkColorWithAlpha:(CGFloat)alpha;
/**
 * Returns custom orange color with specified alpha value.
 *
 * @return The orange color with alpha value.
 */
+ (UIColor *)BFN_orangeColorWithAlpha:(CGFloat)alpha;
/**
 * Returns custom facebook blue color with specified alpha value.
 *
 * @return The facebook blue color with alpha value.
 */
+ (UIColor *)BFN_FBBlueColorWithAlpha:(CGFloat)alpha;
/**
 * Returns custom grey color.
 *
 * @return The grey color.
 */
+ (UIColor *)BFN_greyColor;
/**
 * Returns custom grey color with specified alpha value.
 *
 * @return The grey color with alpha value.
 */
+ (UIColor *)BFN_greyColorWithAlpha:(CGFloat)alpha;
/**
 * Returns custom light grey color for table view separator.
 *
 * @return The light grey color.
 */
+ (UIColor *)BFN_lightGreySeparatorColor;


@end
