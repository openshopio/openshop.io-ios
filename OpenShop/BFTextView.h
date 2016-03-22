//
//  BFTextView.h
//  OpenShop
//
//  Created by Petr Škorňok on 20.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFTextView` adds insets to the edge of UITextView
 */
IB_DESIGNABLE
@interface BFTextView : UITextView

/**
 * Top inset.
 */
@property (nonatomic, assign) IBInspectable CGFloat topInset;
/**
 * Left inset.
 */
@property (nonatomic, assign) IBInspectable CGFloat leftInset;
/**
 * Right inset.
 */
@property (nonatomic, assign) IBInspectable CGFloat rightInset;
/**
 * Bottom inset.
 */
@property (nonatomic, assign) IBInspectable CGFloat bottomInset;

@end
NS_ASSUME_NONNULL_END
