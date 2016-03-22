//
//  BFProductImageView.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import UIKit;

/**
 * The `BFProductImageView` extends `UIImageView` with custom image rendering options and
 * the possibility to specify the placeholder image.
 */
@interface BFProductImageView : UIImageView
/**
 * The placeholder image.
 */
@property (nonatomic, strong) UIImage *placeholderImage;

@end
