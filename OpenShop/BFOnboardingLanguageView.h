//
//  BFOnboardingLanguageView.h
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
 * `BFOnboardingLanguageView` represents option view presented to choose the app language.
 */
IB_DESIGNABLE
@interface BFOnboardingLanguageView : BFDimControl

/**
 * App language code (IB Property)
 */
@property (nonatomic, setter=setLanguageWithCode:) IBInspectable NSString *languageCode;
/**
 * App language.
 */
@property (nonatomic, assign) BFLanguage language;
/**
 * App language flag image.
 */
@property (nonatomic, weak) IBOutlet UIImageView *languageFlag;
/**
 * App language display name.
 */
@property (nonatomic, weak) IBOutlet UILabel *languageTitle;

@end



NS_ASSUME_NONNULL_END
