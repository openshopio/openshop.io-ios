//
//  BFDimControl.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


NS_ASSUME_NONNULL_BEGIN

/**
 * `BFDimControl` extends `UIControl` with the view dimming support. It is designed for occasions
 * where group of elements should respond to the same touch event and show the highlighted state
 * of all components like an `UIButton`.
 */
@interface BFDimControl : UIControl

/**
 * Dimming layer background alpha value.
 */
@property (nonatomic, strong) NSNumber *highlightedOverlayAlpha;

@end

NS_ASSUME_NONNULL_END
