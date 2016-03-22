//
//  BFNSeparatorLine.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import UIKit;

/**
 * The BFNSeparatorLine class provides table view row separator imitation.
 */
@interface BFNSeparatorLine : UIView

/**
 * Left margin constraint.
 */
@property (nonatomic, assign) IBOutlet NSLayoutConstraint *leftMarginCons;
/**
 * Right margin constraint.
 */
@property (nonatomic, assign) IBOutlet NSLayoutConstraint *rightMarginCons;
/**
 * Bottom margin constraint.
 */
@property (nonatomic, assign) IBOutlet NSLayoutConstraint *bottomMarginCons;
/**
 * Top margin constraint.
 */
@property (nonatomic, assign) IBOutlet NSLayoutConstraint *topMarginCons;
/**
 * Flag indicating that view is being unhighlighted.
 */
@property (nonatomic, assign) BOOL unhighlighting;

/**
 * Sets left margin of the view.
 *
 * @param leftMargin Left margin in pixels.
 */
-(void)setLeftMargin:(CGFloat)leftMargin;

/**
 * Sets right margin of the view.
 *
 * @param rightMargin Right margin in pixels.
 */
-(void)setRightMargin:(CGFloat)rightMargin;

/**
 * Sets bottom margin of the view.
 *
 * @param bottomMargin Bottom margin in pixels.
 */
-(void)setBottomMargin:(CGFloat)bottomMargin;

/**
 * Sets top margin of the view.
 *
 * @param topMargin Top margin in pixels.
 */
-(void)setTopMargin:(CGFloat)topMargin;


@end
