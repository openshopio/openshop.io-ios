//
//  BFInfoPageViewController.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFModalViewController.h"
#import "BFInfoPage.h"

NS_ASSUME_NONNULL_BEGIN


/**
 * `BFInfoPageViewController` displays information page content.
 */
@interface BFInfoPageViewController : BFModalViewController

/**
 * The information page.
 */
@property (nonatomic, retain) BFInfoPage *infoPage;
/**
 * Text view displaying information page content.
 */
@property (nonatomic, weak) IBOutlet UITextView *contentView;

@end

NS_ASSUME_NONNULL_END
