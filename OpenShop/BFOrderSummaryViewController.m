//
//  BFOrderSummaryViewController.m
//  OpenShop
//
//  Created by Petr Škorňok on 23.01.16.
//  Copyright © 2016 Business-Factory. All rights reserved.
//

#import "BFOrderSummaryViewController.h"
#import "BFOrderSentViewController.h"
#import "BFBannersViewController.h"
#import "BFTabBarController.h"
#import "BFOrderSummaryProductsTableViewCellExtension.h"
#import "BFOrderSummaryShippingPaymentTableViewCellExtension.h"
#import "BFOrderSummaryAddressTableViewCellExtension.h"
#import "BFButtonFooterView.h"
#import "BFAPIManager.h"
#import "ShoppingCart.h"
#import "UIWindow+BFOverlays.h"
#import "NSNotificationCenter+BFAsyncNotifications.h"
#import "NSNotificationCenter+BFManagedNotificationObserver.h"
#import "NSObject+BFStoryboardInitialization.h"

/**
 * Delay in seconds for presenting success overlay.
 */
static CGFloat const orderSuccessDismissDelay = 1.0;
/**
 * Delay in seconds for presenting failure overlay.
 */
static CGFloat const orderFailureDismissDelay = 2.0;
/**
 * Storyboard unwind to cart segue identifier.
 */
static NSString *const unwindToCartSegueIdentifier = @"unwindToCart";
/**
 * Storyboard embed footer button segue identifier.
 */
static NSString *const embedFooterButtonSegueIdentifier            = @"embedFooterButtonSegue";


@interface BFOrderSummaryViewController ()

/**
 * Product items table view cell extension.
 */
@property (nonatomic, strong) BFOrderSummaryProductsTableViewCellExtension *productItemsExtension;
/**
 * Shipping and payment items table view cell extension.
 */
@property (nonatomic, strong) BFOrderSummaryShippingPaymentTableViewCellExtension *shippingPaymentItemsExtension;
/**
 * Address items table view cell extension.
 */
@property (nonatomic, strong) BFOrderSummaryAddressTableViewCellExtension *addressItemsExtension;

@end

@implementation BFOrderSummaryViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup table view cell extensions
    [self setupExtensions];
    
    // cart change listener
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartDidChange) name:BFCartDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // title view
    self.navigationItem.title = [BFLocalizedString(kTranslationSummary, @"Summary") uppercaseString];
}

#pragma mark - Table View Cell Extensions

- (void)setupExtensions {
    // default values
    [self removeAllExtensions];
    
    // product items
    _productItemsExtension = [[BFOrderSummaryProductsTableViewCellExtension alloc]initWithTableViewController:self];
    [self addExtension:_productItemsExtension];
    
    // shipping and payment items
    _shippingPaymentItemsExtension = [[BFOrderSummaryShippingPaymentTableViewCellExtension alloc]initWithTableViewController:self];
    [self addExtension:_shippingPaymentItemsExtension];
    
    // address items
    _addressItemsExtension = [[BFOrderSummaryAddressTableViewCellExtension alloc]initWithTableViewController:self];
    [self addExtension:_addressItemsExtension];
}

#pragma mark - Cart Did Change Listener Action

// pop to root
- (void)cartDidChange {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Order Network Request

- (void)confirmOrder {
    // send order network request
    [self.view.window showIndeterminateSmallProgressOverlayWithTitle:BFLocalizedString(kTranslationSendingOrder, @"Sending order") animated:YES];
    
    __weak __typeof__(self) weakSelf = self;
    [[ShoppingCart sharedCart] createOrderCompletionBlock:^(NSError *error) {
        __typeof__(weakSelf) strongSelf = weakSelf;
        [strongSelf.view.window dismissAllOverlaysWithCompletion:^{
            if (error) {
                NSString *failureMessage = [BFError APIFailureMessageWithError:error];
                [strongSelf.view.window showFailureOverlayWithTitle:failureMessage animated:YES];
                [strongSelf.view.window dismissAllOverlaysWithCompletion:nil animated:YES afterDelay:orderFailureDismissDelay];
            }
            else {
                [strongSelf.view.window showSuccessOverlayWithTitle:BFLocalizedString(kTranslationOrderSent, @"Order sent") animated:YES];
                [strongSelf.view.window dismissAllOverlaysWithCompletion:^{
                    __typeof__(weakSelf) strongSelf = weakSelf;
                    //  show Order Sent Form Sheet Controller
                    [strongSelf performSegueWithViewController:[BFOrderSentViewController class] params:nil];
                } animated:YES afterDelay:orderSuccessDismissDelay];
            }
        } animated:YES afterDelay:orderSuccessDismissDelay];
    }];
}

#pragma mark - BFTableViewCellExtensionDelegate

- (void)performSegueWithViewController:(Class)viewController params:(NSDictionary *)dictionary {
    // present order form
    if(viewController == [BFOrderSentViewController class]) {
        [self presentOrderSentController];
    }
    // present offers
    else if(viewController == [BFBannersViewController class]) {
        [self performSegueWithIdentifier:unwindToCartSegueIdentifier sender:self];
    }
}

#pragma mark - Segue Management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // embed footer button controller
    if ([[segue identifier] isEqualToString:embedFooterButtonSegueIdentifier]) {
        if([segue.destinationViewController isKindOfClass:[BFButtonFooterView class]]) {
            BFButtonFooterView *footerButtonController = (BFButtonFooterView *)segue.destinationViewController;
            footerButtonController.actionButtonTitle = [BFLocalizedString(kTranslationOrderCommand, @"Order") uppercaseString];
            __weak __typeof(self)weakSelf = self;
            footerButtonController.actionButtonBlock = ^{
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf confirmOrder];
            };
            [self applySegueParameters:footerButtonController];
        }
    }
}

- (void)presentOrderSentController {
    BFOrderSentViewController *orderSentController = (BFOrderSentViewController *)[self BFN_mainStoryboardClassInstanceWithClass:[BFOrderSentViewController class]];
    // present form sheet
    [orderSentController presentFormSheetWithOptionsHandler:^(MZFormSheetPresentationViewController *formSheetController) {
        __weak __typeof__(self) weakSelf = self;
        formSheetController.contentViewCornerRadius = 5.0;
        formSheetController.presentationController.dismissalTransitionDidEndCompletionHandler = ^(UIViewController *presentedFSViewController, BOOL completed) {
            __typeof__(weakSelf) strongSelf = weakSelf;
            [strongSelf performSegueWithViewController:[BFBannersViewController class] params:nil];
        };
    } animated:YES fromSender:self];
}


#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return false;
}

@end
