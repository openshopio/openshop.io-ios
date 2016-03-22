//
//  BFBranchTransportView.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import UIKit;
#import "BFAppStructure.h"
#import "BFDimControl.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `BFBranchTransportView` represents shop branch transport option.
 */
IB_DESIGNABLE
@interface BFBranchTransportView : UIView

/**
 * The transport option index.
 */
@property (nonatomic, assign) IBInspectable NSInteger transportIndex;
/**
 * The transport option icon.
 */
@property (nonatomic, weak) IBOutlet UIImageView *icon;
/**
 * The transport option description.
 */
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;

/**
 * Sets transport option visibility.
 *
 * @param visible The option visibility.
 */
- (void)setVisibility:(BOOL)visible;
/**
 * Transport option view did load from nib.
 */
- (void)didLoad;

@end



NS_ASSUME_NONNULL_END
