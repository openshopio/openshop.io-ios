//
//  UIFont+BFFont.h
//  OpenShop
//
//  Created by Petr Škorňok
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import UIKit;

/**
 * `BFFont` category of UIFont defines custom application fonts.
 */
@interface UIFont (BFFont)

/**
 * Returns custom Roboto Regular font with specified size.
 *
 * @param fontSize The font size.
 * @return The Roboto Regular font.
 */
+ (UIFont *)BFN_robotoRegularWithSize:(CGFloat)fontSize;
/**
 * Returns custom Roboto Medium font with specified size.
 *
 * @param fontSize The font size.
 * @return The Roboto Medium font.
 */
+ (UIFont *)BFN_robotoMediumWithSize:(CGFloat)fontSize;
/**
 * Returns custom Roboto Light font with specified size.
 *
 * @param fontSize The font size.
 * @return The Roboto Light font.
 */
+ (UIFont *)BFN_robotoLightWithSize:(CGFloat)fontSize;
/**
 * Returns custom Roboto Bold font with specified size.
 *
 * @param fontSize The font size.
 * @return The Roboto Bold font.
 */
+ (UIFont *)BFN_robotoBoldWithSize:(CGFloat)fontSize;

@end
