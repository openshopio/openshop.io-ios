//
//  BFCartViewController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFOrderFormViewController.h"
#import "BFOrderFormShippingPaymentTableViewCellExtension.h"
#import "BFAddressTableViewCellExtension.h"
#import "BFNoteTableViewCellExtension.h"
#import "BFKeyboardToolbar.h"
#import "BFAPIRequestOrderInfo.h"
#import "BFAPIRequestOrderInfo+BFValidation.h"
#import "BFAPIManager.h"
#import "BFError.h"
#import "UIColor+BFColor.h"
#import "BFAlignedImageButton.h"
#import "BFPaymentViewController.h"
#import "BFShippingViewController.h"
#import "BFOrderSummaryViewController.h"
#import "BFInfoPageViewController.h"
#import "StorageManager.h"
#import "BFCartPayment.h"
#import "BFCartDelivery.h"
#import "BFDeliveryInfo.h"
#import "StorageManager.h"
#import "BFCart.h"
#import "BFInfoPage.h"
#import "UIWindow+BFOverlays.h"
#import "UIFont+BFFont.h"
#import "UIColor+BFColor.h"
#import "NSNotificationCenter+BFAsyncNotifications.h"
#import "NSNotificationCenter+BFManagedNotificationObserver.h"
#import "ShoppingCart.h"
#import <CRToast.h>

/**
 * Delay in seconds for presenting failure overlay.
 */
static CGFloat const orderFailureDismissDelay = 2.0f;
/**
 * Storyboard shipping segue identifier.
 */
static NSString *const shippingSegueIdentifier            = @"shippingSegue";
/**
 * Storyboard payment segue identifier.
 */
static NSString *const paymentSegueIdentifier             = @"paymentSegue";
/**
 * Storyboard info page segue identifier.
 */
static NSString *const infoPageSegueIdentifier            = @"infoPageSegue";
/**
 * Storyboard summary segue identifier.
 */
static NSString *const summarySegueIdentifier             = @"summarySegue";
/**
 * Presenting segue order info parameter.
 */
static NSString *const segueParameterOrderInfo            = @"orderInfo";
/**
 * Presenting segue info page parameter.
 */
static NSString *const segueParameterInfoPage             = @"infoPage";

@interface BFOrderFormViewController ()

/**
 * Shipping and payment items table view cell extension.
 */
@property (nonatomic, strong) BFOrderFormShippingPaymentTableViewCellExtension *shippingAndPaymentItemsExtension;
/**
 * Address TextField items table view cell extension.
 */
@property (nonatomic, strong) BFAddressTableViewCellExtension *addressTextFieldItemsExtension;
/**
 * Address TextField items table view cell extension.
 */
@property (nonatomic, strong) BFNoteTableViewCellExtension *noteItemsExtension;
/**
 * Accessory view for keyboard.
 */
@property (nonatomic, strong) BFKeyboardToolbar *inputAccessoryView;
/**
 * Boolean value indicating if the order is valid.
 */
@property (nonatomic) BOOL isOrderValid;
/**
 * Boolean value indicating if the tableView should scroll to the bottom on appear.
 */
@property (nonatomic) BOOL scrollToBottomOnAppear;

@end


@implementation BFOrderFormViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // title view
    self.navigationItem.title = [BFLocalizedString(kTranslationShippingAndPayment, @"Shipping and payment") uppercaseString];

    // don't scroll to the bottom on the first appearance
    self.scrollToBottomOnAppear = NO;
    
    // setup table view cell extensiosn
    [self setupExtensions];
    
    // set label texts
    [self updateTexts];
    
    // check if order is valid, most probably isn't
    self.isOrderValid = [self validateOrderWithToastMessage:NO];
    
    // cart change listener
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartDidChange) name:BFCartDidChangeNotification object:nil];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.scrollToBottomOnAppear) {
        [self tableViewScrollToBottom];
    }
}

#pragma mark - Lazy init properties

- (BFKeyboardToolbar *)inputAccessoryView {
    if (!_inputAccessoryView) {
        _inputAccessoryView = [[BFKeyboardToolbar alloc] initWithInputViews:nil actionButtonTitle:BFLocalizedString(kTranslationOrder, @"Order") actionButtonHandler:^{
            [self showSummaryViewController:nil];
        }];
    }
    return _inputAccessoryView;
}

#pragma mark - custom Setters & Getters

- (void)setIsOrderValid:(BOOL)isOrderValid {
    _isOrderValid = isOrderValid;
    if (isOrderValid) {
        [self.summaryButton setBackgroundColor:[UIColor BFN_pinkColor]];
    }
    else {
        [self.summaryButton setBackgroundColor:[UIColor lightGrayColor]];
    }
}

#pragma mark - Table View Cell Extensions

- (void)setupExtensions {
    // default values
    [self removeAllExtensions];
    
    // shipping and payment items
    _shippingAndPaymentItemsExtension = [[BFOrderFormShippingPaymentTableViewCellExtension alloc]initWithTableViewController:self];
    [self addExtension:_shippingAndPaymentItemsExtension];
    
    // address TextField items
    _addressTextFieldItemsExtension = [[BFAddressTableViewCellExtension alloc]initWithTableViewController:self
                                                                                       inputAccessoryView:self.inputAccessoryView];
    [self addExtension:_addressTextFieldItemsExtension];
    
    // note items
    _noteItemsExtension = [[BFNoteTableViewCellExtension alloc]initWithTableViewController:self
                                                                        inputAccessoryView:self.inputAccessoryView];
    [self addExtension:_noteItemsExtension];
}

#pragma mark - Translations & Dynamic Content

- (void)updateTexts {
    // summary button
    [self.summaryButton setTitle:[self summaryText] forState:UIControlStateNormal];
    // license agreement label
    self.licenseAgreementLabel.attributedText = [self licenseAgreementText];
    // total price label
    self.totalPriceLabel.text = [self totalPriceText];
    // VAT included label
    self.vatIncludedLabel.text = [self vatIncludedText];
}

- (NSString *)summaryText {
   return [BFLocalizedString(kTranslationSummary, @"Summary") uppercaseString];
}

- (NSAttributedString *)licenseAgreementText {
    UIFont *textFont = [UIFont BFN_robotoRegularWithSize:12.0];
    UIFont *highlightedTextFont = [UIFont BFN_robotoMediumWithSize:12.0];
    UIColor *textColor = [UIColor darkGrayColor];
    UIColor *highlightedTextColor = [UIColor BFN_pinkColor];
    NSString *textFirst = BFLocalizedString(kTranslationByOrderingYouAgreeWithOur, @"By clicking on the \"Order\", you agree to our");
    NSString *textSecond = BFLocalizedString(kTranslationTermsAndConditions, @"terms and conditions");
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@.", textFirst, textSecond]];
    
    // attributes for the first part of the text
    [text addAttribute:NSFontAttributeName value:textFont range:NSMakeRange(0, textFirst.length)];
    [text addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, textFirst.length)];
    
    // attributes for the second part of the text
    [text addAttribute:NSFontAttributeName value:highlightedTextFont range:NSMakeRange(textFirst.length, text.length - textFirst.length)];
    [text addAttribute:NSForegroundColorAttributeName value:highlightedTextColor range:NSMakeRange(textFirst.length, text.length - textFirst.length)];
    
    return text;
}

- (NSString *)totalPriceText {
    NSString *totalPriceText = [[ShoppingCart sharedCart] totalPriceFormatted];
    return totalPriceText;
}

- (NSString *)vatIncludedText {
    return BFLocalizedString(kTranslationVatIncluded, @"inc. VAT");
}

#pragma mark - Cart Did Change Listener Action

// pop to root
- (void)cartDidChange {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Order network request

- (IBAction)showSummaryViewController:(id)sender {
    BOOL isValid = [self validateOrderWithToastMessage:YES];
    if (isValid) {
        // dismiss keyboard
        [self.view endEditing:YES];
        [self performSegueWithViewController:[BFOrderSummaryViewController class] params:nil];
    }
}

#pragma mark - License Agreement Network Request

- (IBAction)licenseAgreementAction:(id)sender {
    // dismiss keyboard
    [self.view endEditing:YES];
    
    // send order network request
    [self.view.window showIndeterminateSmallProgressOverlayWithTitle:nil animated:YES];
    __weak __typeof__(self) weakSelf = self;
    [[BFAPIManager sharedManager] findTermsAndConditionsWithCompletionBlock:^(NSArray * _Nullable records, id  _Nullable customResponse, NSError * _Nullable error) {
        __typeof__(weakSelf) strongSelf = weakSelf;
        [strongSelf.view.window dismissAllOverlaysWithCompletion:^{
            if (error) {
                [strongSelf.view.window showFailureOverlayWithTitle:[error localizedDescription] animated:YES];
                [strongSelf.view.window dismissAllOverlaysWithCompletion:nil animated:YES afterDelay:orderFailureDismissDelay];
            }
            else {
                // Show Info page with Terms and conditions
                BFInfoPage *infoPage = (BFInfoPage *)[records firstObject];
                [strongSelf performSegueWithViewController:[BFInfoPageViewController class] params:@{segueParameterInfoPage : infoPage}];
            }
        } animated:YES afterDelay:0.0];
    }];
}


#pragma mark - Order Validation

- (BOOL)validateOrderWithToastMessage:(BOOL)toastMessage {
    BOOL isValid;
    if (toastMessage) {
        __weak __typeof__(self) weakSelf = self;
        isValid = [[ShoppingCart sharedCart] isValidWithIncompleteShippingPaymentHandler:^(BFShippingAndPaymentItem incompleteShippingPaymentItem) {
            __typeof__(weakSelf) strongSelf = weakSelf;
            [strongSelf shippingPaymentItemShowToastMessage:incompleteShippingPaymentItem];
            NSInteger sectionIndex = [strongSelf indexOfExtension:strongSelf.shippingAndPaymentItemsExtension];
            NSInteger rowIndex = [[BFAppStructure shippingPaymentRowFromItem:incompleteShippingPaymentItem] integerValue];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
            
            if ([self isIndexPathPresentInTableView:indexPath]) {
                [strongSelf.tableView scrollToRowAtIndexPath:indexPath
                                            atScrollPosition:UITableViewScrollPositionTop
                                                    animated:YES];
            }
        } incompleteAddressHandler:^(BFAddressItem incompleteAddressItem) {
            __typeof__(weakSelf) strongSelf = weakSelf;
            [strongSelf.view.window showToastMessage:BFLocalizedString(kTranslationPleaseFillInAllFields, @"Please fill in all fields")
                          withCompletion:nil];
            [strongSelf addressItemBecomeFirstResponder:incompleteAddressItem];
        }];
    }
    else {
        isValid = [[ShoppingCart sharedCart] isValid];
    }
    self.isOrderValid = isValid;
    
    return isValid;
}

- (void)shippingPaymentItemShowToastMessage:(BFShippingAndPaymentItem)incompleteShippingPaymentItem {
    NSString *message;
    id segueController;
    
    // dismiss keyboard
    [self.view endEditing:YES];

    switch (incompleteShippingPaymentItem) {
        case BFShippingAndPaymentItemShipping: {
            message = BFLocalizedString(kTranslationPleaseFillInShipping, @"Please fill in shipping");
            segueController = [BFShippingViewController class];
            break;
        }
        case BFShippingAndPaymentItemPayment: {
            message = BFLocalizedString(kTranslationPleaseFillInPayment, @"Please fill in payment");
            segueController = [BFPaymentViewController class];
            break;
        }
        default:
            break;
    }
    
    __weak __typeof__(self) weakSelf = self;
    CRToastInteractionResponder *interactionResponder = [CRToastInteractionResponder
                                                         interactionResponderWithInteractionType:CRToastInteractionTypeTapOnce
                                                                            automaticallyDismiss:YES
                                                                                            block:^(CRToastInteractionType interactionType) {
                                                                                                __typeof__(weakSelf) strongSelf = weakSelf;
                                                                                                [strongSelf performSegueWithViewController:segueController params:nil];
                                                                                            }];
    NSDictionary *options = @{kCRToastNotificationTypeKey:@(CRToastTypeNavigationBar),
                              kCRToastInteractionRespondersKey:@[interactionResponder]};
    [self.view.window showToastMessage:message
                           withOptions:options
                            completion:nil];
}

- (void)addressItemBecomeFirstResponder:(BFAddressItem)incompleteAddressItem {
    __weak __typeof__(self) weakSelf = self;
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        __typeof__(weakSelf) strongSelf = weakSelf;
        // Scroll to the top of the cell where the field is located.
        // This is necessary step because the field which is not in the view hierarchy
        // won't become first responder
        NSInteger sectionIndex = [strongSelf indexOfExtension:strongSelf.addressTextFieldItemsExtension];
        NSInteger rowIndex = [[BFAppStructure addressRowFromItem:incompleteAddressItem] integerValue];
        [strongSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex]
                              atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    completion:^(BOOL finished) {
        __typeof__(weakSelf) strongSelf = weakSelf;
        // Resign active field
        [strongSelf.inputAccessoryView.activeField resignFirstResponder];
        
        // Address field should become first responder
        UIView *incompleteInputView = [strongSelf.tableView viewWithTag:incompleteAddressItem];
        [incompleteInputView becomeFirstResponder];

     }];
}

#pragma mark - UITableView Helper

- (void)tableViewScrollToBottom {
    if (self.tableView.contentSize.height > self.tableView.frame.size.height) {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:YES];
        // disable scroll for the next time
        self.scrollToBottomOnAppear = NO;
    }
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self updateOrderFromTextField:textField withString:newString];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [self updateOrderFromTextField:textField withString:@""];
    return YES;
}

- (void)updateOrderFromTextField:(UITextField *)textField withString:(NSString *)newString {
    switch (textField.tag) {
        case BFAddressItemName: {
            [[ShoppingCart sharedCart] setName:newString];
            break;
        }
        case BFAddressItemEmail: {
            [[ShoppingCart sharedCart] setEmail:newString];
            break;
        }
        case BFAddressItemPhoneNumber: {
            [[ShoppingCart sharedCart] setPhone:newString];
            break;
        }
        case BFAddressItemStreet: {
            [[ShoppingCart sharedCart] setAddressStreet:newString];
            break;
        }
        case BFAddressItemHouseNumber: {
            [[ShoppingCart sharedCart] setAddressHouseNumber:newString];
            break;
        }
        case BFAddressItemCity: {
            [[ShoppingCart sharedCart] setAddressCity:newString];
            break;
        }
        case BFAddressItemPostalCode: {
            [[ShoppingCart sharedCart] setAddressPostalCode:newString];
            break;
        }
    }
    
    [self validateOrderWithToastMessage:NO];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.inputAccessoryView.activeField = textView;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.inputAccessoryView.activeField = nil;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    [[ShoppingCart sharedCart] setNote:newString];
    
    return YES;
}

/*
 * Updates textView dynamically if user inputs a value
 */
- (void)textViewDidChange:(UITextView *)textView {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

#pragma mark - BFTableViewCellExtensionDelegate

- (void)performSegueWithViewController:(Class)viewController params:(NSDictionary *)dictionary {
    if(viewController == [BFShippingViewController class]) {
        // present the info page view controller
        [self performSegueWithIdentifier:shippingSegueIdentifier sender:self];
    }
    else if(viewController == [BFPaymentViewController class]) {
        // present the settings view controller
        [self performSegueWithIdentifier:paymentSegueIdentifier sender:self];
    }
    else if(viewController == [BFOrderSummaryViewController class]) {
        // present the settings view controller
        self.segueParameters = dictionary;
        [self performSegueWithIdentifier:summarySegueIdentifier sender:self];
    }
    else if(viewController == [BFInfoPageViewController class]) {
        // present the settings view controller
        self.segueParameters = dictionary;
        [self performSegueWithIdentifier:infoPageSegueIdentifier sender:self];
    }
}

#pragma mark - Segue Management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // info page view controller
    if ([[segue identifier] isEqualToString:shippingSegueIdentifier]) {
        if([segue.destinationViewController isKindOfClass:[BFShippingViewController class]]) {
            BFShippingViewController *shippingController = (BFShippingViewController *)segue.destinationViewController;
            shippingController.delegate = self;
            shippingController.orderFormController = self;
            shippingController.deliveryInfo = self.deliveryInfo;
            [self applySegueParameters:shippingController];
        }
    }
    // settings view controller
    else if ([[segue identifier] isEqualToString:paymentSegueIdentifier]) {
        if([segue.destinationViewController isKindOfClass:[BFPaymentViewController class]]) {
            BFPaymentViewController *paymentController = (BFPaymentViewController *)segue.destinationViewController;
            paymentController.delegate = self;
            [self applySegueParameters:paymentController];
        }
    }
    // settings view controller
    else if ([[segue identifier] isEqualToString:summarySegueIdentifier]) {
        if([segue.destinationViewController isKindOfClass:[BFOrderSummaryViewController class]]) {
            BFOrderSummaryViewController *summaryController = (BFOrderSummaryViewController *)segue.destinationViewController;
            [self applySegueParameters:summaryController];
        }
    }
    // info page view controller
    else if ([[segue identifier] isEqualToString:infoPageSegueIdentifier]) {
        if([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
            if([[navController.viewControllers firstObject]isKindOfClass:[BFInfoPageViewController class]]) {
                BFInfoPageViewController *infoPageController = (BFInfoPageViewController *)[navController.viewControllers firstObject];
                [self applySegueParameters:infoPageController];
            }
        }
    }

}

- (IBAction)unwindToOrderFormViewController:(UIStoryboardSegue *)unwindSegue {
    
}

#pragma mark - BFShippingViewControllerDelegate

- (void)shippingViewController:(BFViewController *)controller selectedShipping:(BFCartDelivery *)selectedShipping {
    [self.shippingAndPaymentItemsExtension refreshDataSource];
    [self reloadExtensions:@[self.shippingAndPaymentItemsExtension] withRowAnimation:UITableViewRowAnimationAutomatic];
    // update footer labels, especially total price
    [self updateTexts];
    // validate the order and if it is valid scroll to the bottom on appear
    if ([self validateOrderWithToastMessage:NO]) {
        self.scrollToBottomOnAppear = YES;
    }

    DDLogDebug(@"Selected delivery: %@\nRelated payments: %@", selectedShipping, [[ShoppingCart sharedCart] paymentItems]);
}

#pragma mark - BFPaymentViewControllerDelegate

- (void)paymentViewController:(BFViewController *)controller selectedPayment:(BFCartPayment *)selectedPayment {
    [self reloadExtensions:@[self.shippingAndPaymentItemsExtension] withRowAnimation:UITableViewRowAnimationNone];
    // update footer labels, especially total price
    [self updateTexts];
    // validate the order and if it is valid scroll to the bottom on appear
    if ([self validateOrderWithToastMessage:NO]) {
        self.scrollToBottomOnAppear = YES;
    }

    DDLogDebug(@"Selected payment: %@", selectedPayment);
    
}

#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return false;
}

@end
