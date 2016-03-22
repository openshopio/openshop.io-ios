//
//  BFButtonFooterView.h
//  OpenShop
//
//  Created by Petr Škorňok on 27.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

@import UIKit;

@interface BFButtonFooterView : UIViewController

/**
 * Action button block callback.
 */
@property (nonatomic, copy) void (^actionButtonBlock)(void);
/**
 * Disabled action button block callback.
 */
@property (nonatomic, copy) void (^disabledActionButtonBlock)(void);
/**
 * Action button title.
 */
@property (nonatomic, strong) NSString *actionButtonTitle;
/**
 * Value indicating if the view can perform action.
 */
@property (nonatomic) BOOL canPerformAction;


@end
