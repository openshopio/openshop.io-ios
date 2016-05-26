//
//  BFUserDetailsViewController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFUserDetailsViewController.h"
#import "BFAPIManager.h"
#import "UIFont+BFFont.h"
#import "UINavigationController+BFCustomTitleView.h"
#import "UIColor+BFColor.h"
#import "User.h"
#import "BFTableViewCategoryHeaderFooterView.h"
#import "BFAPIRequestUserInfo.h"
#import "BFCustomRETableViewTextCell.h"
#import "UIWindow+BFOverlays.h"

/**
 * Button footer view nib file name.
 */
static NSString *const buttonFooterViewNibName   = @"BFTableViewButtonHeaderFooterView";
/**
 * User details header view nib file name.
 */
static NSString *const groupedHeaderViewNibName  = @"BFTableViewGroupedHeaderFooterView";
/**
 * User details header view content horizontal margin.
 */
static CGFloat const horizontalCellContentMargin = 15.0f;


@interface BFUserDetailsViewController ()

/**
 * The table view content manager.
 */
@property (nonatomic, strong) RETableViewManager *manager;
/**
 * The user details items.
 */
@property (nonatomic, strong) NSMutableArray *userDetailsItems;
/**
 * The old password item.
 */
@property (nonatomic, strong) RETextItem *oldPasswordItem;
/**
 * The new password item.
 */
@property (nonatomic, strong) RETextItem *theNewPasswordItem;
/**
 * The password confirmation item.
 */
@property (nonatomic, strong) RETextItem *confirmPasswordItem;


@end


@implementation BFUserDetailsViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // table view cell extensions
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // title view
    [self.navigationController setCustomTitleViewText:[BFLocalizedString(kTranslationMyAccount, @"My account") uppercaseString]];
}

#pragma mark - User Details

- (void)addUserDetailsItemWithTitle:(NSString *)title forKey:(NSString *)key {
    [self addUserDetailsItemWithTitle:title enabled:true forKey:key];
}

- (void)addUserDetailsItemWithTitle:(NSString *)title enabled:(BOOL)enabled forKey:(NSString *)key {
    id value = [[User sharedUser]respondsToSelector:NSSelectorFromString(key)] ? [[User sharedUser]valueForKey:key] : nil;

    // user details item
    RETextItem *item = [RETextItem itemWithTitle:title value:value placeholder:nil];
    item.name = key;
    item.enabled = enabled;

    [_userDetailsItems addObject:item];
}

- (UIView *)getUserDetailsFooterView {
    BFTableViewHeaderFooterView *buttonFooterView = (BFTableViewHeaderFooterView *)[self getFooterView];
    if(buttonFooterView) {
        [buttonFooterView.actionButton setTitle:BFLocalizedString(kTranslationUserDetailsConfirm, @"Confirm") forState:UIControlStateNormal];
        [buttonFooterView.actionButton addTarget:self action:@selector(confirmUserDetails:) forControlEvents:UIControlEventTouchUpInside];
        [buttonFooterView setHorizontalMargin:horizontalCellContentMargin];
    }
    return buttonFooterView;
}

- (IBAction)confirmUserDetails:(id)sender {
    // dismiss keyboard
    [self.view endEditing:YES];
    // activity indicator
    [self.view.window showIndeterminateSmallProgressOverlayWithTitle:nil animated:YES];
    
    // save all current user details
    NSMutableDictionary *userDetailsCache = [[NSMutableDictionary alloc]init];
    [_userDetailsItems enumerateObjectsUsingBlock:^(RETextItem *obj, NSUInteger idx, BOOL *stop) {
        if([[User sharedUser]valueForKey:obj.name]) {
            [userDetailsCache setObject:(id)[[User sharedUser]valueForKey:obj.name] forKey:obj.name];
        }
        // set new user details
        [[User sharedUser]setValue:obj.value forKey:obj.name];
    }];
    
    // update user profile
    __weak __typeof__(self) weakSelf = self;
    [[BFAPIManager sharedManager]updateUserDetailsWithCompletionBlock:^(id response, NSError *error) {
        __typeof__(weakSelf) strongSelf = weakSelf;
        __weak __typeof__(strongSelf) weakSelf = strongSelf;
        [strongSelf.view.window dismissAllOverlaysWithCompletion:^{
            // error management
            if(error) {
                // revert user details
                [userDetailsCache enumerateKeysAndObjectsUsingBlock:^(id key, id  obj, BOOL *stop) {
                    [[User sharedUser]setValue:obj forKey:key];
                }];
                
                BFError *customError = [BFError errorWithError:error];
                [customError showAlertFromSender:weakSelf];
            }
            // user profile successfully updated
            else {
                [self dismissAnimated:YES];
            }
        } animated:YES];
    }];
}


#pragma mark - Password Change

- (UIView *)getPasswordChangeHeaderView {
    BFTableViewHeaderFooterView *groupedHeaderView = (BFTableViewHeaderFooterView *)[self getHeaderView];
    if(groupedHeaderView) {
        [groupedHeaderView setHorizontalMargin:horizontalCellContentMargin];
        [groupedHeaderView.headerlabel setText:[BFLocalizedString(kTranslationUserDetailsPasswordChange, @"Password change") uppercaseString]];
    }
    return groupedHeaderView;
}

- (UIView *)getPasswordChangeFooterView {
    BFTableViewHeaderFooterView *buttonFooterView = (BFTableViewHeaderFooterView *)[self getFooterView];
    if(buttonFooterView) {
        [buttonFooterView.actionButton setTitle:BFLocalizedString(kTranslationChangePassword, @"Change password") forState:UIControlStateNormal];
        [buttonFooterView.actionButton addTarget:self action:@selector(confirmPasswordChange:) forControlEvents:UIControlEventTouchUpInside];
        buttonFooterView.actionButton.backgroundColor = [UIColor darkGrayColor];
        [buttonFooterView setHorizontalMargin:horizontalCellContentMargin];
    }
    return buttonFooterView;
}

- (IBAction)confirmPasswordChange:(id)sender {
    // dismiss keyboard
    [self.view endEditing:YES];
    
    // incomplete input
    if(!self.confirmPasswordItem.value.length || !self.theNewPasswordItem.value.length) {
        BFError *customError = [BFError errorWithCode:BFErrorCodeIncompleteInput];
        [customError showAlertFromSender:self];
    }
    // the new password and the confirmation does not match
    else if(![self.theNewPasswordItem.value isEqualToString:self.confirmPasswordItem.value]) {
        BFError *customError = [BFError errorWithCode:BFErrorCodePasswordsMatch];
        [customError showAlertFromSender:self];
    }
    else {
        // password change info
        BFAPIRequestUserInfo *userInfo = [[BFAPIRequestUserInfo alloc]initWithOldPassword:self.oldPasswordItem.value newPassword:self.theNewPasswordItem.value];
        // activity indicator
        [self.view.window showIndeterminateSmallProgressOverlayWithTitle:nil animated:YES];
        
        // change user password
        __weak __typeof__(self) weakSelf = self;
        [[BFAPIManager sharedManager]changeUserPasswordWithInfo:userInfo completionBlock:^(id response, NSError *error) {
            __typeof__(weakSelf) strongSelf = weakSelf;
            __weak __typeof__(strongSelf) weakSelf = strongSelf;
            [strongSelf.view.window dismissAllOverlaysWithCompletion:^{
                // error management
                if(error) {
                    BFError *customError = [BFError errorWithError:error];
                    [customError showAlertFromSender:weakSelf];
                }
                // user password successfully changed
                else {
                    [self dismissAnimated:YES];
                }
            } animated:YES];
        }];
    }
}


#pragma mark - Content Setup

- (void)setupTableView {
    // content manager
    if (!_manager) {
        _manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:nil];
        [_manager registerClass:NSStringFromClass([RETextItem class]) forCellWithReuseIdentifier:NSStringFromClass([BFCustomRETableViewTextCell class])];
    }
    else {
        [_manager removeAllSections];
    }
    
    // user details section
    UIView *userDetailsFooter = [self getUserDetailsFooterView];
    RETableViewSection *userDetailsSection = [RETableViewSection sectionWithHeaderView:nil footerView:userDetailsFooter];
    
    _userDetailsItems = [[NSMutableArray alloc]init];
    
    // user name
    [self addUserDetailsItemWithTitle:BFLocalizedString(kTranslationUserDetailsName, @"Name") forKey:UserNamePropertyName];
    // user email
    [self addUserDetailsItemWithTitle:BFLocalizedString(kTranslationUserDetailsEmail, @"Email") enabled:false forKey:UserEmailPropertyName];
    // user phone
    [self addUserDetailsItemWithTitle:BFLocalizedString(kTranslationUserDetailsPhone, @"Phone") forKey:UserPhonePropertyName];
    // user address street
    [self addUserDetailsItemWithTitle:BFLocalizedString(kTranslationUserDetailsStreet, @"Street") forKey:UserAddressStreetPropertyName];
    // user address house number
    [self addUserDetailsItemWithTitle:BFLocalizedString(kTranslationUserDetailsHouseNumber, @"House number") forKey:UserAddressHouseNumberPropertyName];
    // user address city
    [self addUserDetailsItemWithTitle:BFLocalizedString(kTranslationUserDetailsCity, @"City") forKey:UserAddressCityPropertyName];
    // user zip
    [self addUserDetailsItemWithTitle:BFLocalizedString(kTranslationUserDetailsZip, @"Postal code") forKey:UserAddressPostalCodePropertyName];

    [userDetailsSection addItemsFromArray:_userDetailsItems];
    [self.manager addSection:userDetailsSection];

    // password change
    UIView *passwordChangeHeader = [self getPasswordChangeHeaderView];
    UIView *passwordChangeFooter = [self getPasswordChangeFooterView];
    RETableViewSection *passwordChangeSection = [RETableViewSection sectionWithHeaderView:passwordChangeHeader footerView:passwordChangeFooter];
    
    // old password
    self.oldPasswordItem = [RETextItem itemWithTitle:BFLocalizedString(kTranslationUserDetailsOldPassword, @"Old password") value:nil placeholder:nil];
    self.oldPasswordItem.secureTextEntry = true;
    // new password
    self.theNewPasswordItem = [RETextItem itemWithTitle:BFLocalizedString(kTranslationUserDetailsNewPassword, @"New password") value:nil placeholder:nil];
    self.theNewPasswordItem.secureTextEntry = true;
    // confirm password
    self.confirmPasswordItem = [RETextItem itemWithTitle:BFLocalizedString(kTranslationUserDetailsConfirmPassword, @"Confirm password") value:nil placeholder:nil];
    self.confirmPasswordItem.secureTextEntry = true;

    [passwordChangeSection addItemsFromArray:@[self.oldPasswordItem, self.theNewPasswordItem, self.confirmPasswordItem]];
    [self.manager addSection:passwordChangeSection];
}

- (UIView *)getFooterView {
    return [[[NSBundle mainBundle] loadNibNamed:buttonFooterViewNibName owner:self options:nil] firstObject];
}

- (UIView *)getHeaderView {
    return [[[NSBundle mainBundle] loadNibNamed:groupedHeaderViewNibName owner:self options:nil] firstObject];
}


#pragma mark - Custom Appearance

+ (void)customizeAppearance {
    [[REActionBar appearance] setTintColor:[UIColor BFN_pinkColor]];
}


@end
