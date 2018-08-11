//
//  BFFormSheetViewController.h
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//


#import "BFViewController.h"
#import <MZFormSheetPresentationController.h>
#import <MZFormSheetPresentationViewController.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Form sheet options handler block type.
 */
typedef void (^MZFormSheetOptionsHandler)(MZFormSheetPresentationViewController *__nonnull formSheetController);


/**
 * `BFFormSheetViewController` adds to the base view controller custom form sheet presentation abilities.
 * View controller subclassing `BFFormSheetViewController` can be presented as form sheet popover with
 * specified view size and presentation options.
 */
@interface BFFormSheetViewController : BFViewController

/**
 * Sender which presented form sheet.
 */
@property (nonatomic, strong) UIViewController *sender;

/**
 * Presents a form sheet controller with custom options and completion handler.
 *
 * @param options The custom options handler.
 * @param sender The form sheet presentation sender.
 */
- (void)presentFormSheetWithOptionsHandler:(nullable MZFormSheetOptionsHandler)options animated:(BOOL)animated fromSender:(UIViewController *)sender;
/**
 * Presents a form sheet controller with custom options, completion handler and animated transition from sender.
 *
 * @param options The custom options handler.
 * @param animated The animated transition.
 * @param sender The form sheet presentation sender.
 */
- (void)presentFormSheetWithSize:(CGSize)viewSize optionsHandler:(nullable MZFormSheetOptionsHandler)options animated:(BOOL)animated fromSender:(UIViewController *)sender;

/**
 * Dismisses a form sheet controller animated transition.
 *
 * @param animated The animated transition.
 */
- (void)dismissFormSheetWithCompletionHandler:(void (^ __nullable)(void))completion animated:(BOOL)animated;


@end

NS_ASSUME_NONNULL_END
