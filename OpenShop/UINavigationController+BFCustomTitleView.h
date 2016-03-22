//
//  UINavigationController+BFCustomTitleView.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


NS_ASSUME_NONNULL_BEGIN


/**
 * `BFCustomTitleView` category of UINavigationController manages the custom title view.
 * Title view can contain a text label or image.
 */
@interface UINavigationController (BFCustomTitleView)

/**
 * Sets custom title view text label with current navigation bar appearance attributes.
 *
 * @param text The title view text.
 */
- (void)setCustomTitleViewText:(NSString *)text;
/**
 * Sets custom title view text label with specified font and text color.
 *
 * @param text The title view text.
 * @param font The title view label font.
 * @param color The text color.
 */
- (void)setCustomTitleViewText:(NSString *)text withFont:(UIFont *)font color:(UIColor *)color;
/**
 * Sets custom title view text label with text attributes specified inside the attributed string.
 *
 * @param attributedText title view attributed text.
 */
- (void)setCustomTitleViewAttributedText:(NSAttributedString *)attributedText;
/**
 * Sets custom title view image.
 *
 * @param image title view image.
 */
- (void)setCustomTitleViewImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END


