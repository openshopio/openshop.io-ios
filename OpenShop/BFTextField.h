//
//  BFTextField.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


NS_ASSUME_NONNULL_BEGIN

/**
 * `BFTextField` extends `UITextField` with possibility to set inner text margins.
 */
IB_DESIGNABLE
@interface BFTextField : UITextField

/**
 * Horizontal inner text margin.
 */
@property (nonatomic, assign) IBInspectable NSInteger horizontalMargin;
/**
 * Vertical inner text margin.
 */
@property (nonatomic, assign) IBInspectable NSInteger verticalMargin;


@end

NS_ASSUME_NONNULL_END
