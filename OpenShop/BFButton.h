//
//  BFButton.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


NS_ASSUME_NONNULL_BEGIN

/**
 * `BFButton` extends `UIButton` with possibility to extend button touch area
 * out of its bounds. This subclass also correctly layouts title label frame
 * when custom font is applied.
 */
@interface BFButton : UIButton

/**
 * Button hit test edge insets.
 */
@property (nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;
/**
 * Top hit test edge inset (IB Property).
 */
@property (nonatomic, assign) IBInspectable NSInteger hitTestInsetTop;
/**
 * Right hit test edge inset (IB Property).
 */
@property (nonatomic, assign) IBInspectable NSInteger hitTestInsetRight;
/**
 * Bottom hit test edge inset (IB Property).
 */
@property (nonatomic, assign) IBInspectable NSInteger hitTestInsetBottom;
/**
 * Left hit test edge inset (IB Property).
 */
@property (nonatomic, assign) IBInspectable NSInteger hitTestInsetLeft;

@end

NS_ASSUME_NONNULL_END
