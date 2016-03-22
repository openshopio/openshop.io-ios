//
//  BFKeyboardToolbar.h
//  OpenShop
//
//  Created by Petr Škorňok on 20.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

@import UIKit;

typedef void(^KeyboardActionHandler)(void);

/**
 * `BFKeyboardToolbar` is intended to be implemented as 
 * keyboard's inputAccessoryView for navigation between
 * input fields.
 */
@interface BFKeyboardToolbar : UIToolbar

/*
 * Currently active field.
 */
@property (nonatomic, strong) UIView * activeField;

/*
 * Initializer with input views array and handler if the button is tapped.
 *
 * @param inputViewsArray Array containing input views 
 * @param actionButtonTitle title for the action button
 * @param actionButtonHandler Action called when the actionButton is tapped
 */
- (instancetype)initWithInputViews:(NSArray *)inputViewsArray
                 actionButtonTitle:(NSString *)actionButtonTitle
               actionButtonHandler:(KeyboardActionHandler)actionButtonHandler;
/*
 * Add input field.
 */
- (void)addInputView:(UIView *)inputView;
/*
 * Remove input field.
 */
- (void)removeInputView:(UIView *)inputView;

@end
