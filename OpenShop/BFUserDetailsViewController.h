//
//  BFUserDetailsViewController.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFModalViewController.h"
#import <RETableViewManager.h>
#import <TPKeyboardAvoidingTableView.h>

NS_ASSUME_NONNULL_BEGIN


/**
 * `BFUserDetailsViewController` displays user profile details. The details are split into two sections.
 * First section allows user to change his name, address, phone number and additional info. The second
 * section represents the password change option.
 */
@interface BFUserDetailsViewController : BFModalViewController <BFCustomAppearance, RETableViewManagerDelegate>




@end

NS_ASSUME_NONNULL_END


