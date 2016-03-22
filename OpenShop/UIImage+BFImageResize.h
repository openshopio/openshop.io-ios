//
//  UIImage+BFImageResize.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

/**
 * `BFImageResize` category of UIImage adds possibility to resize image to the desired size
 * while maintaining the image aspect ratio.
 */
@interface UIImage (BFImageResize)

/**
 * Resizes the image to fit the specified width while preserving the aspect ratio.
 *
 * @param imageWidth The image width.
 * @return The resized image.
 */
- (UIImage *)scaleImageToWidth:(CGFloat)imageWidth;
/**
 * Resizes the image to fit the specified height while preserving the aspect ratio.
 *
 * @param imageHeight The image height.
 * @return The resized image.
 */
- (UIImage *)scaleImageToHeight:(CGFloat)imageHeight;
/**
 * Translates the image to fit in the center of specified rectangle size while preserving the original size.
 *
 * @param rectangleSize The image rectangle size.
 * @return The translated image.
 */
- (UIImage*)imageFitInCenterForSize:(CGSize)rectangleSize;
/**
 * Resizes the image to fit in the specified size while preserving the aspect ratio.
 *
 * @param imageSize The image size.
 * @return The resized image.
 */
- (UIImage *)imageFitInSize:(CGSize)imageSize;



@end
