//
//  BFFormSheetViewController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFFormSheetViewController.h"

@implementation BFFormSheetViewController


#pragma mark - MZFormSheetController Presentation

- (void)presentFormSheetWithOptionsHandler:(MZFormSheetOptionsHandler)options animated:(BOOL)animated fromSender:(UIViewController *)sender {
    [self presentFormSheetWithSize:self.preferredContentSize optionsHandler:options animated:animated fromSender:sender];
}

- (void)presentFormSheetWithSize:(CGSize)viewSize optionsHandler:(nullable MZFormSheetOptionsHandler)options animated:(BOOL)animated fromSender:(UIViewController *)sender {
    MZFormSheetPresentationViewController *formSheet = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:self];
    
    // default presentation options
    [self applyDefaultOptions:formSheet];
    // custom options
    if(options) {
        options(formSheet);
    }
    // view size
    formSheet.presentationController.contentViewSize = viewSize;
    
    // present form sheet view controller
    [sender presentViewController:formSheet animated:animated completion:nil];
    
    // assign sender for later use
    self.sender = sender;
}

- (void)applyDefaultOptions:(MZFormSheetPresentationViewController *)formSheet {
    formSheet.presentationController.shouldCenterVertically = true;
    formSheet.presentationController.transparentTouchEnabled = false;
    formSheet.presentationController.shouldDismissOnBackgroundViewTap = true;
    formSheet.presentationController.movementActionWhenKeyboardAppears = MZFormSheetActionWhenKeyboardAppearsMoveToTopInset;
    formSheet.presentationController.dismissalTransitionDidEndCompletionHandler = nil;
    formSheet.presentationController.dismissalTransitionWillBeginCompletionHandler = nil;
    formSheet.presentationController.presentationTransitionWillBeginCompletionHandler = nil;
    formSheet.presentationController.presentationTransitionDidEndCompletionHandler = nil;

    formSheet.shadowRadius = 0.0;
    formSheet.contentViewCornerRadius = 0.0;
}


#pragma mark - MZFormSheetController Dismissal

- (void)dismissFormSheetWithCompletionHandler:(void (^)(void))completion animated:(BOOL)animated {
    [self dismissViewControllerAnimated:animated completion:completion];
}


@end


