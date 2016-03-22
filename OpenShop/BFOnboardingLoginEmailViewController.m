//
//  BFOnboardingLoginEmailViewController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFOnboardingLoginEmailViewController.h"
#import "BFAPIManager.h"
#import "BFAPIRequestUserInfo.h"
#import "BFError.h"
#import "NSString+BFValidation.h"
#import "User.h"
#import "UIWindow+BFOverlays.h"
#import "BFKeyboardToolbar.h"

/**
 * Content view layout change animation duration.
 */
static CGFloat const layoutChangeAnimationDuration = 0.4f;


@interface BFOnboardingLoginEmailViewController ()

/**
 * Content view elements contraints used to control contant view changes.
 */
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *passwordTextFieldTopConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *passwordTextFieldHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *changeViewButtonTopConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *changeViewButtonHeightConstraint;
/**
 * Initial content view elements contraints values.
 */
@property (nonatomic, assign) CGFloat passwordTextFieldTopValue;
@property (nonatomic, assign) CGFloat passwordTextFieldHeightValue;
@property (nonatomic, assign) CGFloat changeViewButtonTopValue;
@property (nonatomic, assign) CGFloat changeViewButtonHeightValue;
/**
 * Initial content view height.
 */
@property (nonatomic, assign) CGFloat currentFrameHeight;
/**
 * Current content view state. Password reset view is visible if TRUE.
 */
@property (nonatomic, assign) BOOL isDisplayingPasswordReset;
/**
 * Accessory view for keyboard.
 */
@property (nonatomic, strong) BFKeyboardToolbar *inputAccessoryView;

@end

@implementation BFOnboardingLoginEmailViewController


#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self)
    {
        [self setDefaults];
    }
    return self;
}

- (void)setDefaults {
    // properties
    _allowsPasswordReset = true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // current height
    _currentFrameHeight = self.preferredContentSize.height;
    // setup keyboard toolbar and textfields
    [self setupTextFields];
    // default contraint values
    [self setupConstraints];
    // default texts
    self.isDisplayingPasswordReset = NO;
    [self updateTexts];
}

#pragma mark - Input fields setup

- (void)setupTextFields {
    if (self.isDisplayingPasswordReset) {
        self.inputAccessoryView = nil;
        self.emailTextField.inputAccessoryView = nil;
        self.passwordTextField.inputAccessoryView = nil;
    }
    else {
        // keyboard toolbar
        __weak __typeof__(self) weakSelf = self;
        self.inputAccessoryView = [[BFKeyboardToolbar alloc] initWithInputViews:@[self.emailTextField, self.passwordTextField] actionButtonTitle:BFLocalizedString(kTranslationLogin, @"Login") actionButtonHandler:^{
            __typeof__(self) strongSelf = weakSelf;
            [strongSelf confirmLogin];
        }];
        // email text field
        self.emailTextField.attributedPlaceholder = [self emailTextFieldPlaceholder];
        self.emailTextField.tag = BFLoginItemEmail;
        self.emailTextField.inputAccessoryView = self.inputAccessoryView;
        // password text field
        self.passwordTextField.attributedPlaceholder = [self passwordTextFieldPlaceholder];
        self.passwordTextField.tag = BFLoginItemPassword;
        self.passwordTextField.inputAccessoryView = self.inputAccessoryView;
    }
}

#pragma mark - Constraints setup

- (void)setupConstraints {
    self.passwordTextFieldTopValue = self.passwordTextFieldTopConstraint.constant;
    self.passwordTextFieldHeightValue = self.passwordTextFieldHeightConstraint.constant;
    self.changeViewButtonTopValue = self.changeViewButtonTopConstraint.constant;
    self.changeViewButtonHeightValue = self.changeViewButtonHeightConstraint.constant;
}

#pragma mark - Translations & Dynamic Content

- (void)updateTexts {
    // title label
    self.titleLabel.text = [self titleLabelText];
    // confirm button
    [self.confirmButton setTitle:[self confirmButtonText] forState:UIControlStateNormal];
    // change view
    [self.changeViewButton setTitle:[self changeViewButtonText] forState:UIControlStateNormal];
}

- (NSString *)titleLabelText {
    return self.isDisplayingPasswordReset ?
        BFLocalizedString(kTranslationDidYouForgetPassword, @"Have you forgotten the password?") :
        BFLocalizedString(kTranslationEnterEmailAndPassword, @"Enter email and password");
}

- (NSString *)confirmButtonText {
    return self.isDisplayingPasswordReset ?
    [BFLocalizedString(kTranslationPasswordRetrieval, @"Password recovery") uppercaseString] :
    [BFLocalizedString(kTranslationLogin, @"Login") uppercaseString];
}

- (NSString *)changeViewButtonText {
    return self.isDisplayingPasswordReset ?
    BFLocalizedString(kTranslationLoginWithEmail, @"Login with email") :
    BFLocalizedString(kTranslationDidYouForgetPassword, @"Have you forgotten the password?");
}

- (NSAttributedString *)emailTextFieldPlaceholder {
    return [[NSAttributedString alloc] initWithString:BFLocalizedString(kTranslationEmail, @"Email") attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (NSAttributedString *)passwordTextFieldPlaceholder {
    return [[NSAttributedString alloc] initWithString:BFLocalizedString(kTranslationPassword, @"Password") attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}


#pragma mark - Properties Setters

- (void)setAllowsPasswordReset:(BOOL)allowsPasswordReset {
    _allowsPasswordReset = allowsPasswordReset;
    // adjust view frame
    [self setChangeViewButtonHidden:!_allowsPasswordReset withAnimation:false];
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.inputAccessoryView.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.inputAccessoryView.activeField = nil;
    // Workaround for the jumping text bug.
    [textField resignFirstResponder];
    [textField layoutIfNeeded];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Layout Changes

- (void)setChangeViewButtonHidden:(BOOL)hidden withAnimation:(BOOL)animation {
    if(hidden) {
        self.currentFrameHeight -= (_changeViewButtonTopValue+_changeViewButtonHeightValue);
    }
    else {
        self.currentFrameHeight += (_changeViewButtonTopValue+_changeViewButtonHeightValue);
    }
    
    if(animation) {
        [UIView animateWithDuration:layoutChangeAnimationDuration animations:^{
            [self updateChangeViewButton:hidden];
        }];
    }
    else {
        [self updateChangeViewButton:hidden];
    }
}

- (void)updateChangeViewButton:(BOOL)hidden {
    self.changeViewButtonHeightConstraint.constant = hidden ? self.changeViewButtonHeightValue : 0;
    self.changeViewButtonTopConstraint.constant = hidden ? self.changeViewButtonTopValue : 0;
    self.changeViewButton.hidden = hidden;
    
    CGRect currentFrame = self.view.frame;
    currentFrame.size.height = self.currentFrameHeight;
    self.view.frame = currentFrame;
    [self.view layoutIfNeeded];
}

- (void)setEmailLoginViewWithAnimation:(BOOL)animation {
    self.currentFrameHeight += (_passwordTextFieldHeightValue+_passwordTextFieldTopValue);
    
    if(animation) {
        [UIView animateWithDuration:layoutChangeAnimationDuration animations:^{
            [self toggleContentViewToEmailLogin:true];
        }];
    }
    else {
        [self toggleContentViewToEmailLogin:true];
    }
}

- (void)setPasswordResetViewWithAnimation:(BOOL)animation {
    self.currentFrameHeight -= (_passwordTextFieldHeightValue+_passwordTextFieldTopValue);
    
    if(animation) {
        [UIView animateWithDuration:layoutChangeAnimationDuration animations:^{
            [self toggleContentViewToEmailLogin:false];
        }];
    }
    else {
        [self toggleContentViewToEmailLogin:false];
    }
}

- (void)toggleContentViewToEmailLogin:(BOOL)emailLogin {
    CGRect currentFrame = self.view.frame;
    currentFrame.size.height = self.currentFrameHeight;
    
    // view must shrink before all constraints have been maximized
    if(emailLogin) {
        self.view.frame = currentFrame;
    }
    
    // contraints update
    self.passwordTextFieldHeightConstraint.constant = emailLogin ? self.passwordTextFieldHeightValue : 0;
    self.passwordTextFieldTopConstraint.constant = emailLogin ? self.passwordTextFieldTopValue : 0;
    self.passwordTextField.alpha = emailLogin ? 1.0f : 0.0f;
    
    // view must shrink after all constraints have been minimized
    if(!emailLogin) {
        self.view.frame = currentFrame;
    }

    [self.view layoutIfNeeded];
    
    // text changes
    self.isDisplayingPasswordReset = !emailLogin;
    [self updateTexts];
}

#pragma mark - Buttons Actions

- (IBAction)closeClicked:(id)sender {
    // dismiss view
    [self dismissFormSheetWithCompletionHandler:nil animated:YES];
}

- (IBAction)changeViewClicked:(id)sender {
    [self.view endEditing:YES];
    
    // update view
    if (self.isDisplayingPasswordReset) {
        [self setEmailLoginViewWithAnimation:true];
    }
    else {
        [self setPasswordResetViewWithAnimation:true];
    }
    
    // update input accessory view
    [self setupTextFields];
}

- (IBAction)confirmClicked:(id)sender {
    [self confirmLogin];
}

- (void)confirmLogin {
    [self.view endEditing:YES];
    
    if (self.isDisplayingPasswordReset) {
        [self tryToResetPassword];
    }
    else {
        [self tryToLogin];
    }
}

- (void)tryToResetPassword {
    if (self.emailTextField.text.length && [self.emailTextField.text isValidEmail]) {
        [self.view.window showIndeterminateSmallProgressOverlayWithTitle:BFLocalizedString(kTranslationPasswordRetrievalInProgress, @"Recovering the password") animated:YES];
        
        // user info
        BFAPIRequestUserInfo *userInfo = [[BFAPIRequestUserInfo alloc]initWithEmail:self.emailTextField.text password:nil];
        
        __weak __typeof__(self) weakSelf = self;
        [[BFAPIManager sharedManager]resetUserPasswordWithInfo:userInfo completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
            [weakSelf.view.window dismissAllOverlaysWithCompletion:^{
                // strong reference because of multiple following statements
                __typeof__(self) strongSelf = weakSelf;
                // password reset error
                if(error) {
                    BFError *customError = [BFError errorWithCode:BFErrorCodeGeneric];
                    [customError showAlertFromSender:strongSelf];
                }
                else {
                    [strongSelf.view.window showSuccessOverlayWithTitle:BFLocalizedString(kTranslationNewPasswordWasSentToYourEmail, @"New password has been sent to your email") animated:YES];
                    // break retain cycle in nested block
                    __weak __typeof__(self) weakSelf = strongSelf;
                    // return to email login view
                    [strongSelf.view.window dismissAllOverlaysWithCompletion:^{
                        [weakSelf setEmailLoginViewWithAnimation:YES];
                    } animated:YES afterDelay:2.0];
                }
            } animated:YES];
            
        }];
    }
    // invalid input
    else {
        BFError *customError = [BFError errorWithCode:self.emailTextField.text.length ? BFErrorCodeInvalidInputEmail : BFErrorCodeIncompleteInput];
        [customError showAlertFromSender:self];
    }
}

- (void)tryToLogin {
    if (self.emailTextField.text.length && self.passwordTextField.text.length && [self.emailTextField.text isValidEmail]) {
        [self.view.window showIndeterminateSmallProgressOverlayWithTitle:BFLocalizedString(kTranslationLoggingIn, @"Logging in") animated:YES];
        
        // user info
        BFAPIRequestUserInfo *userInfo = [[BFAPIRequestUserInfo alloc]initWithEmail:self.emailTextField.text password:self.passwordTextField.text];
        
        __weak __typeof__(self) weakSelf = self;
        [[BFAPIManager sharedManager]loginUserWithInfo:userInfo completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
            [weakSelf.view.window dismissAllOverlaysWithCompletion:^{
                __weak __typeof__(self) strongSelf = weakSelf;
                // email login error
                if(error) {
                    BFError *customError = [BFError errorWithCode:BFErrorCodeUserLogin];
                    [customError showAlertFromSender:strongSelf];
                }
                else {
                    BFError *loginError = [[BFAPIManager sharedManager]finishUserRequestWithResponse:(NSDictionary *)response];
                    if(loginError) {
                        [loginError showAlertFromSender:strongSelf];
                    }
                    else {
                        // dismiss view
                        [strongSelf dismissFormSheetWithCompletionHandler:nil animated:YES];
                    }
                }
            } animated:YES];
        }];
    }
    // invalid input
    else {
        BFError *customError = [BFError errorWithCode:(self.emailTextField.text.length && self.passwordTextField.text.length) ? BFErrorCodeInvalidInputEmail : BFErrorCodeIncompleteInput];
        [customError showAlertFromSender:self];
    }

}


#pragma mark - Status Bar Style

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
 


@end
