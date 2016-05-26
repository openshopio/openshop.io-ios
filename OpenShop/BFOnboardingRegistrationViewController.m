//
//  BFOnboardingRegistrationViewController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFOnboardingRegistrationViewController.h"
#import "BFAPIManager.h"
#import "BFAPIRequestUserInfo.h"
#import "BFError.h"
#import "NSString+BFValidation.h"
#import "User.h"
#import "BFAppPreferences.h"
#import "UIWindow+BFOverlays.h"
#import "BFKeyboardToolbar.h"

@interface BFOnboardingRegistrationViewController ()

/**
 * User gender.
 */
@property (nonatomic, assign) UserGender gender;
/**
 * Accessory view for keyboard.
 */
@property (nonatomic, strong) BFKeyboardToolbar *inputAccessoryView;

@end

@implementation BFOnboardingRegistrationViewController


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

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup keyboard toolbar and textfields
    [self setupTextFields];
    // gender
    self.gender = UserGenderFemale;
    [self.checkmarkWoman setSelected:true withAnimation:false];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateTexts];
}

#pragma mark - Input fields setup

- (void)setupTextFields {
    // keyboard toolbar
    __weak __typeof__(self) weakSelf = self;
    self.inputAccessoryView = [[BFKeyboardToolbar alloc] initWithInputViews:@[self.emailTextField, self.passwordTextField] actionButtonTitle:BFLocalizedString(kTranslationRegister, @"Register") actionButtonHandler:^{
        __typeof__(self) strongSelf = weakSelf;
        [strongSelf confirmRegistration];
    }];
    // email text field
    self.emailTextField.tag = BFRegistrationItemEmail;
    self.emailTextField.inputAccessoryView = self.inputAccessoryView;
    // password text field
    self.passwordTextField.tag = BFRegistrationItemPassword;
    self.passwordTextField.inputAccessoryView = self.inputAccessoryView;
}

#pragma mark - Translations & Dynamic Content

- (void)updateTexts {
    // email text field
    self.emailTextField.attributedPlaceholder = [self emailTextFieldPlaceholder];
    // password text field
    self.passwordTextField.attributedPlaceholder = [self passwordTextFieldPlaceholder];
    // register button
    [self.registerButton setTitle:[self registerButtonText] forState:UIControlStateNormal];
    // title label
    self.titleLabel.text = [self titleLabelText];
    // checkmarks
    self.checkmarkManLabel.text = [self checkmarkManText];
    self.checkmarkWomanLabel.text = [self checkmarkWomanText];
}

- (NSString *)checkmarkManText {
    return BFLocalizedString(kTranslationMan, @"Man");
}

- (NSString *)checkmarkWomanText {
    return BFLocalizedString(kTranslationWoman, @"Woman");
}

- (NSString *)titleLabelText {
    return BFLocalizedString(kTranslationDontHaveAnAccount, @"Don't have an account?");
}

- (NSString *)registerButtonText {
    return [BFLocalizedString(kTranslationRegister, @"Register") uppercaseString];
}

- (NSAttributedString *)emailTextFieldPlaceholder {
    return [[NSAttributedString alloc] initWithString:BFLocalizedString(kTranslationEmail, @"Email") attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (NSAttributedString *)passwordTextFieldPlaceholder {
    return [[NSAttributedString alloc] initWithString:BFLocalizedString(kTranslationPassword, @"Password") attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
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


#pragma mark - Buttons Actions

- (IBAction)closeClicked:(id)sender {
    // dismiss view
    [self dismissFormSheetWithCompletionHandler:nil animated:YES];
}

- (IBAction)registerClicked:(id)sender {
    [self confirmRegistration];
}

- (void)confirmRegistration {
    [self.view endEditing:YES];
    
    if (self.emailTextField.text.length && self.passwordTextField.text.length && [self.emailTextField.text isValidEmail]) {
        [self.view.window showIndeterminateSmallProgressOverlayWithTitle:BFLocalizedString(kTranslationRegistering, @"Registering") animated:YES];
        
        // user info
        BFAPIRequestUserInfo *userInfo = [[BFAPIRequestUserInfo alloc]initWithEmail:self.emailTextField.text password:self.passwordTextField.text];
        userInfo.gender = [User userGenderAPIName:self.gender];
        
        __weak __typeof__(self) weakSelf = self;
        [[BFAPIManager sharedManager]registerUserWithInfo:userInfo completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
            [weakSelf.view.window dismissAllOverlaysWithCompletion:^{
                __weak __typeof__(self) strongSelf = weakSelf;
                // registration error
                if(error) {
                    BFError *customError = [BFError errorWithCode:BFErrorCodeUserRegistration];
                    [customError showAlertFromSender:strongSelf];
                }
                else {
                    BFError *loginError = [[BFAPIManager sharedManager]finishUserRequestWithResponse:(NSDictionary *)response];
                    if(loginError) {
                        [loginError showAlertFromSender:strongSelf];
                    }
                    else {
                        // save preferred menu category
//                        if(self.gender == UserGenderMale) {
//                            [[BFAppPreferences sharedPreferences]setPreferredMenuCategory:@(BFMenuCategoryMen)];
//                        }
//                        else {
//                            [[BFAppPreferences sharedPreferences]setPreferredMenuCategory:@(BFMenuCategoryWomen)];
//                        }
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

#pragma mark - Gender Checkmarks Selection

- (IBAction)checkmarkManSelected:(id)sender {
    self.gender = UserGenderMale;
    [self toggleCheckmarksWithAnimation:true];
}

- (IBAction)checkmarkWomanSelected:(id)sender {
    self.gender = UserGenderFemale;
    [self toggleCheckmarksWithAnimation:true];
}

- (void)toggleCheckmarksWithAnimation:(BOOL)animation {
    if(self.gender == UserGenderFemale) {
        [self.checkmarkWoman setSelected:true withAnimation:animation];
        [self.checkmarkMan setSelected:false withAnimation:false];
    }
    else {
        [self.checkmarkWoman setSelected:false withAnimation:false];
        [self.checkmarkMan setSelected:true withAnimation:animation];
    }
}

 
#pragma mark - Status Bar Style

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
