//
//  BFNCheckmarkView.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import UIKit;

/**
 * The `BFNCheckmarkView` class provides stylable checkmark component. It changes it's
 * state with animation and its visualization can be fully customized. Checkmark
 * sends UIControlEventValueChanged event when its selection state changes.
 */
IB_DESIGNABLE
@interface BFNCheckmarkView : UIControl

/**
 *  Background checkmark line width. By default, this property is set to 1.5.
 */
@property(nonatomic, assign) IBInspectable CGFloat lineWidth;
/**
 *  Background circle stroke width. By default, this property is set to 1.0.
 */
@property(nonatomic, assign) IBInspectable CGFloat circleLineWidth;
/**
 *  Checkmark line stroke color. By default, this property is set to [UIColor whiteColor].
 */
@property(nonatomic, retain) IBInspectable UIColor *lineColor;
/**
 *  Background circle stroke color. By default, this property is set to [[UIColor lightGrayColor]colorWithAlphaComponent:0.5].
 */
@property(nonatomic, retain) IBInspectable UIColor *circleLineColor;
/**
 *  Background circle fill color. By default, this property is set to [UIColor blackColor].
 */
@property(nonatomic, retain) IBInspectable UIColor *backgroundColor;
/**
 *  Selection state change animation duration.
 */
@property(nonatomic, assign) IBInspectable CGFloat animateDuration;
/**
 * Enables checkmark animations when selected. By default, this property is set to true.
 */
@property(nonatomic, assign) IBInspectable BOOL animateSelection;
/**
 * Shows checkmark circle even when checkmark is selected. By default, this property is set to false.
 */
@property(nonatomic, assign) IBInspectable BOOL showsCircle;
/**
 * Allows checkmark to be deselected by touch.
 */
@property(nonatomic, assign) IBInspectable BOOL allowsDeselection;

/**
 * Sets selection state with animation.
 *
 * @param selected Selection state.
 * @param animated Enables animation.
 */
-(void)setSelected:(BOOL) selected withAnimation:(BOOL)animated;

@end
