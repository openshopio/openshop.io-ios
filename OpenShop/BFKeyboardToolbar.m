//
//  BFKeyboardToolbar.m
//  OpenShop
//
//  Created by Petr Škorňok on 20.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFKeyboardToolbar.h"
#import "UIColor+BFColor.h"
#import "UIFont+BFFont.h"

@interface BFKeyboardToolbar()

/*
 * Array of input views for navigation between them.
 */
@property (nonatomic, strong) NSMutableArray * inputViewsArray;
/*
 * Button action handler.
 */
@property (nonatomic, strong) KeyboardActionHandler actionButtonHandler;
/*
 * Button action title.
 */
@property (nonatomic, strong) NSString *actionButtonTitle;

@end

@implementation BFKeyboardToolbar

#pragma mark - Initialization

- (instancetype)initWithInputViews:(NSArray *)inputViewsArray actionButtonTitle:(NSString *)actionButtonTitle actionButtonHandler:(KeyboardActionHandler)actionButtonHandler {
    self = [super init];
    if (self) {
        self.actionButtonTitle = actionButtonTitle;
        self.inputViewsArray = [[NSMutableArray alloc] initWithArray:inputViewsArray];
        self.actionButtonHandler = actionButtonHandler;
        [self setup];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - Lazy init properties

- (NSMutableArray *)inputViewsArray {
    if (!_inputViewsArray) {
        _inputViewsArray = [[NSMutableArray alloc] init];
    }
    return _inputViewsArray;
}

#pragma mark - Setup

- (void)setup {
    self.barStyle = UIBarStyleDefault;
    self.translucent = NO;
    self.userInteractionEnabled = YES;
    self.tintColor = [UIColor BFN_pinkColor];
    [self sizeToFit];
    
    // navigation
    UIBarButtonItem *prevButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackButtonIcon"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(previousInputAction:)];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NextButtonIcon"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(nextInputAction:)];
    
    // action button
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithTitle:self.actionButtonTitle
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(orderAction:)];
    [actionButton setTitleTextAttributes:@{NSFontAttributeName: [UIFont BFN_robotoMediumWithSize:15]}
                               forState:UIControlStateNormal];
    
    UIBarButtonItem *flexibleSpaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                         target:nil
                                                                                         action:nil];
    UIBarButtonItem *fixedSpaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                      target:nil
                                                                                      action:nil];
    fixedSpaceButton.width = 20.0f;
    UIBarButtonItem *marginSpaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                       target:nil
                                                                                       action:nil];
    marginSpaceButton.width = 5.0f;
    
    [self setItems:@[marginSpaceButton,
                     prevButton,
                     fixedSpaceButton,
                     nextButton,
                     flexibleSpaceButton,
                     actionButton,
                     marginSpaceButton]];
}

#pragma mark - Input fields methods

- (void)addInputView:(UIView *)inputView
{
    if (inputView && ![self.inputViewsArray containsObject:inputView]) {
        [self.inputViewsArray addObject:inputView];
    }
}

- (void)removeInputView:(UIView *)inputView
{
    if (inputView && [self.inputViewsArray containsObject:inputView]) {
        [self.inputViewsArray removeObject:inputView];
    }
}

#pragma mark - Keyboard toolbar actions

- (void)orderAction:(id)sender
{
    if (self.actionButtonHandler) {
        self.actionButtonHandler();
    }
}

- (void)nextInputAction:(id)sender
{
    UIView *currentResponder = self.activeField;
    NSInteger currentResponderIndex = [self.inputViewsArray indexOfObject:currentResponder];
    NSInteger nextResponderIndex = currentResponderIndex+1;

    if (currentResponderIndex != NSNotFound && nextResponderIndex < self.inputViewsArray.count && nextResponderIndex >= 0) {
        UIView *nextResponder = self.inputViewsArray[nextResponderIndex];
        if ([nextResponder canBecomeFirstResponder]) {
            [currentResponder resignFirstResponder];
            [nextResponder becomeFirstResponder];
        }
    }
}

- (void)previousInputAction:(id)sender
{
    UIView *currentResponder = self.activeField;
    NSInteger currentResponderIndex = [self.inputViewsArray indexOfObject:currentResponder];
    NSInteger nextResponderIndex = currentResponderIndex-1;
    
    if (currentResponderIndex != NSNotFound && nextResponderIndex < self.inputViewsArray.count && nextResponderIndex >= 0) {
        UIView *nextResponder = self.inputViewsArray[nextResponderIndex];
        if ([nextResponder canBecomeFirstResponder]) {
            [currentResponder resignFirstResponder];
            [nextResponder becomeFirstResponder];
        }
    }
}

#pragma mark - Setters & getters

- (void)setActiveField:(UIView *)activeField {
    _activeField = activeField;
    [_activeField becomeFirstResponder];
}

@end
