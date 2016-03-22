//
//  BFShareImageProvider.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFShareImageProvider` models a proxy for image data passed to an activity view controller.
 */
@interface BFShareImageProvider : UIActivityItemProvider <UIActivityItemSource>

/**
 * The image data.
 */
@property (nonatomic, strong) UIImage *image;

/**
 * Creates the image data provider.
 *
 * @param image The image data.
 * @return The newly-initialized `BFShareImageProvider`.
 */
- (instancetype)initWithImage:(UIImage *)image;

@end


NS_ASSUME_NONNULL_END
