//
//  BFAlignedImageButton.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFButton.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFAlignedImageButton` extends `UIButton` to reposition button's image. The image
 * can be pushed left, pushed right or right aligned to the title text.
 */
IB_DESIGNABLE
@interface BFAlignedImageButton : BFButton

/**
 * Spacing between the title text and the image view.
 */
@property (nonatomic, assign) IBInspectable NSInteger imageSpacing;
/**
 * Margin between the image view and the button border.
 */
@property (nonatomic, assign) IBInspectable NSInteger imageMargin;
/**
 * Pushes the image to be aligned with the left button border.
 */
@property (nonatomic, assign) IBInspectable BOOL pushedLeft;
/**
 * Pushes the image to be aligned with the right button border.
 */
@property (nonatomic, assign) IBInspectable BOOL pushedRight;

@end

NS_ASSUME_NONNULL_END
