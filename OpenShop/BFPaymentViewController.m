//
//  BFPaymentViewController.m
//  OpenShop
//
//  Created by Petr Škorňok on 23.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFPaymentViewController.h"
#import "BFOrderFormViewController.h"
#import "BFOrderFormViewController.h"
#import "BFPaymentTableViewCellExtension.h"
#import "BFButtonFooterView.h"
#import "UIWindow+BFOverlays.h"
#import "NSNotificationCenter+BFAsyncNotifications.h"
#import "NSNotificationCenter+BFManagedNotificationObserver.h"
#import "ShoppingCart.h"

/**
 * Storyboard embed footer button segue identifier.
 */
static NSString *const embedFooterButtonSegueIdentifier = @"embedFooterButtonSegue";
/**
 * Storyboard order form segue identifier.
 */
static NSString *const unwindToOrderFormSegueIdentifier = @"unwindToOrderFormSegue";

@interface BFPaymentViewController ()

/**
 * Payment items table view cell extension.
 */
@property (nonatomic, strong) BFPaymentTableViewCellExtension *paymentItemsExtension;
/**
 * Footer button.
 */
@property (nonatomic, strong) BFButtonFooterView *footerButtonView;

@end

@implementation BFPaymentViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup table view cell extensions
    [self setupExtensions];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // title view
    self.navigationItem.title = [BFLocalizedString(kTranslationPayment, @"Payment") uppercaseString];
    
    [self refreshFooterButton];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // inform delegate about selected delivery
    BFCartPayment *payment = [[ShoppingCart sharedCart] selectedPayment];
    if (payment && [self.delegate respondsToSelector:@selector(paymentViewController:selectedPayment:)]) {
        // report selection changes
        [self.delegate paymentViewController:self selectedPayment:payment];
    }
}

#pragma mark - Update Footer Button

- (void)refreshFooterButton {
    BFCartPayment *payment = [[ShoppingCart sharedCart] selectedPayment];
    self.footerButtonView.canPerformAction = payment != nil;
}

#pragma mark - Table View Cell Extensions

- (void)setupExtensions {
    // default values
    [self removeAllExtensions];
    
    // payment items
    _paymentItemsExtension = [[BFPaymentTableViewCellExtension alloc]initWithTableViewController:self];
    _paymentItemsExtension.paymentItems = [[ShoppingCart sharedCart] paymentItems];
    _paymentItemsExtension.didSelectPaymentBlock = ^(BFCartPayment *payment) {
        [[ShoppingCart sharedCart] setSelectedPayment:payment];
    };

    [self addExtension:_paymentItemsExtension];
}

#pragma mark - BFTableViewCellExtensionDelegate

- (void)performSegueWithViewController:(Class)viewController params:(NSDictionary *)dictionary {
    // present order form
    if(viewController == [BFOrderFormViewController class]) {
        self.segueParameters = dictionary;
        [self performSegueWithIdentifier:unwindToOrderFormSegueIdentifier sender:self];
    }
}

#pragma mark - Cart Did Change Listener Action

// pop to root
- (void)cartDidChange {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Segue Management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // embed footer button controller
    if ([[segue identifier] isEqualToString:embedFooterButtonSegueIdentifier]) {
        if([segue.destinationViewController isKindOfClass:[BFButtonFooterView class]]) {
            BFButtonFooterView *footerButtonController = (BFButtonFooterView *)segue.destinationViewController;
            __weak __typeof(self)weakSelf = self;
            footerButtonController.actionButtonTitle = BFLocalizedString(kTranslationOrder, @"Order");
            footerButtonController.actionButtonBlock = ^{
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf performSegueWithIdentifier:unwindToOrderFormSegueIdentifier sender:self];
            };
            footerButtonController.disabledActionButtonBlock = ^{
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf.view.window showToastWarningMessage:BFLocalizedString(kTranslationPleaseFillInPayment, @"Please fill in payment")
                                                 withCompletion:nil];
            };
            self.footerButtonView = footerButtonController;
            [self applySegueParameters:footerButtonController];
        }
    }
}

#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return false;
}

@end
