//
//  BFLabel.h
//  OpenShop
//
//  Created by Petr Škorňok on 20.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFAlignedImageButton` extends `UIButton` to reposition button's image at the right edge
 * of the title text.
 */
IB_DESIGNABLE
@interface BFLabel : UILabel
/**
 * Set custom font name for attributed label.
 */
@property (nonatomic, copy) IBInspectable NSString* fontName;

@end

NS_ASSUME_NONNULL_END
