//
//  BFStoryboardNoAnimationSegue.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


NS_ASSUME_NONNULL_BEGIN


/**
 * `BFStoryboardNoAnimationSegue` disables view controller animation when performing storyboard segue.
 * iOS 9 has this feature by default, pre iOS 9 it is required to use this subclass.
 */
@interface BFStoryboardNoAnimationSegue : UIStoryboardSegue



@end

NS_ASSUME_NONNULL_END
