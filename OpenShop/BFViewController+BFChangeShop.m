//
//  BFViewController+BFChangeShop.m
//  OpenShop
//
//  Created by Petr Škorňok on 13.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFViewController+BFChangeShop.h"
#import "BFAppPreferences.h"
#import "BFShop.h"
#import "UIWindow+BFOverlays.h"

/**
 * Shop selection overlay dismiss delay.
 */
static CGFloat const selectionOverlayDelay             = 1.0;

@implementation BFViewController (BFChangeShop)

- (void)selectShop:(NSNumber *)shopIdentification completion:(void(^)())completionBlock
{
    // activity indicator
    [self.view.window showIndeterminateSmallProgressOverlayWithTitle:BFLocalizedString(kTranslationChangingShop, @"Changing shop") animated:YES];
    // save selected shop
    [[BFAppPreferences sharedPreferences]setSelectedShop:shopIdentification];
    
    [self.view.window dismissAllOverlaysWithCompletion:^{
        // dismiss view controller
        if (completionBlock) {
            completionBlock();
        }
    } animated:YES afterDelay:selectionOverlayDelay];
}
@end
