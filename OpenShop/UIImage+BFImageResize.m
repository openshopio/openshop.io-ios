//
//  UIImage+BFImageResize.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "UIImage+BFImageResize.h"


@implementation UIImage (BFImageResize)


#pragma mark - Image Resizing

- (UIImage *)scaleImageToWidth:(CGFloat)imageWidth {
    CGFloat oldWidth = self.size.width;
    CGFloat scaleFactor = imageWidth / oldWidth;

    CGFloat newWidth = oldWidth * scaleFactor;
    CGFloat newHeight = self.size.height * scaleFactor;
    
    return [self redrawImageInRect:CGRectMake(0, 0, newWidth, newHeight)];
}

- (UIImage *)scaleImageToHeight:(CGFloat)imageHeight {
    CGFloat oldHeight = self.size.height;
    CGFloat scaleFactor = imageHeight / oldHeight;
    
    CGFloat newHeight = oldHeight * scaleFactor;
    CGFloat newWidth = self.size.width * scaleFactor;
    
    return [self redrawImageInRect:CGRectMake(0, 0, newWidth, newHeight)];
}

- (UIImage*)imageFitInCenterForSize:(CGSize)rectangleSize {
    // redraw the image to fit the size
    CGSize imageOriginalSize = self.size;
    
    // translate image if its size is less than the rectangle size
    if (imageOriginalSize.width <= rectangleSize.width && imageOriginalSize.height <= rectangleSize.height) {
        // image origin
        CGFloat newOriginX = (rectangleSize.width - imageOriginalSize.width) / 2.0f;
        CGFloat newOriginY = (rectangleSize.height - imageOriginalSize.height) / 2.0f;
        // image size
        CGFloat newHeight = imageOriginalSize.height;
        CGFloat newWidth = imageOriginalSize.width;
        
        return [self redrawImageInRect:CGRectMake(newOriginX, newOriginY, newWidth, newHeight)];
    }
    return nil;
}

- (UIImage *)imageFitInSize:(CGSize)imageSize {
    CGFloat horizontalRatio = imageSize.width / self.size.width;
    CGFloat verticalRatio = imageSize.height / self.size.height;
    if(horizontalRatio > verticalRatio) {
        return [self scaleImageToHeight:imageSize.height];
    }
    else {
        return [self scaleImageToWidth:imageSize.width];
    }
}


#pragma mark - Image Resize Helpers

- (UIImage *)redrawImageInRect:(CGRect)imageRect {
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // params
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    // image drawing
    [self drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}



@end


