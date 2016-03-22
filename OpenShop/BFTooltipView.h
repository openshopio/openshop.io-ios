//
//  BFTooltipView.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import UIKit;

/**
 * The `BFTooltipView` class provides stylable tooltip component. Its appearance
 * can be fully customized with background color, border color, border width, popup
 * arrow size, corder radius, tooltip margin, icon and title label.
 */
IB_DESIGNABLE
@interface BFTooltipView : UIControl

/**
 *  Tooltip icon.
 */
@property (nonatomic, weak) IBOutlet UIImageView *icon;
/**
 *  Tooltip title label.
 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/**
 *  Tooltip background color.
 */
@property (nonatomic, strong) IBInspectable UIColor *color;
/**
 *  Tooltip border color.
 */
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
/**
 *  Tooltip border width.
 */
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
/**
 *  Tooltip popup arrow width.
 */
@property (nonatomic, assign) IBInspectable CGFloat arrowWidth;
/**
 *  Tooltip popup arrow height.
 */
@property (nonatomic, assign) IBInspectable CGFloat arrowHeight;
/**
 *  Tooltip corner radius.
 */
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
/**
 *  Tooltip popup margin.
 */
@property (nonatomic, assign) IBInspectable CGFloat margin;

@end
