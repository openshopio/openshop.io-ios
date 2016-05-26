//
//  BFCartViewController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFCartViewController.h"
#import "BFTabBarController.h"
#import "BFButtonFooterView.h"
#import "BFOrderFormViewController.h"
#import "BFBannersViewController.h"
#import "BFProductDetailViewController.h"
#import "BFEditCartProductViewController.h"
#import "BFAPIManager.h"
#import "UIWindow+BFOverlays.h"
#import "BFCartProductsTableViewCellExtension.h"
#import "BFCartDiscountsTableViewCellExtension.h"
#import "BFDataResponseCartInfo.h"
#import "BFDataRequestProductInfo.h"
#import "BFAPIRequestCartDiscountInfo.h"
#import "BFNavigationStepsView.h"
#import "MGSwipeTableCell+BFNSwipeGestureTutorial.h"
#import "UIColor+BFColor.h"
#import "NSNotificationCenter+BFAsyncNotifications.h"
#import "NSNotificationCenter+BFManagedNotificationObserver.h"
#import "ShoppingCart.h"
#import <Masonry.h>

/**
 * Delay in seconds for presenting success overlay.
 */
static CGFloat const orderSucessDismissDelay = 1.4;
/**
 * Delay in seconds for presenting failure overlay.
 */
static CGFloat const orderFailureDismissDelay = 2.0;
/**
 * Top navigation height.
 */
static CGFloat const topNavigationHeight = 20.0;
/**
 * Bottom navigation height.
 */
static CGFloat const bottomNavigationHeight = 60.0;
/**
 * Storyboard embed footer button segue identifier.
 */
static NSString *const embedFooterButtonSegueIdentifier   = @"embedFooterButtonSegue";
/**
 * Storyboard edit product in the cart segue identifier.
 */
static NSString *const editProductInCartSegueIdentifier   = @"editProductInCartSegue";
/**
 * Storyboard product detail segue identifier.
 */
static NSString *const productDetailSegueIdentifier       = @"productDetailSegue";
/**
 * Storyboard order form segue identifier.
 */
static NSString *const orderFormSegueIdentifier           = @"orderFormSegue";
/**
 * Presenting segue delivery info parameter.
 */
static NSString *const segueParameterDeliveryInfo         = @"deliveryInfo";
/**
 * Confirm button index within UIAlertView.
 */
static NSInteger const confirmButtonIndex = 1;

@interface BFCartViewController ()

/**
 * Product items table view cell extension.
 */
@property (nonatomic, strong) BFCartProductsTableViewCellExtension *productItemsExtension;
/**
 * Discount items table view cell extension.
 */
@property (nonatomic, strong) BFCartDiscountsTableViewCellExtension *discountItemsExtension;
/**
 * Bottom navigation button height constraint.
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerButtonHeightConstraint;
/**
 * Top navigation button height constraint.
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationStepsHeightConstraint;
/**
 * Top navigation outlet.
 */
@property (weak, nonatomic) IBOutlet BFNavigationStepsView *navigationStepsView;
/**
 * Flag indicating the table view cell swipe tutorial presentation.
 */
@property (nonatomic, assign) BOOL swipeTutorialEnabled;
/**
 * Price footer view.
 */
@property (weak, nonatomic) IBOutlet UIView *priceFooterView;
/**
 * Spinner footer view.
 */
@property (nonatomic, strong) UIView *spinnerFooterView;
/**
 * Label displaying number of pieces in cart.
 */
@property (weak, nonatomic) IBOutlet UILabel *numberOfPiecesLabel;
/**
 * Label displaying total price of cart.
 */
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
/**
 * Button for adding discounts.
 */
@property (weak, nonatomic) IBOutlet UIButton *discountButton;
/**
 * VAT included label.
 */
@property (weak, nonatomic) IBOutlet UILabel *vatIncludedLabel;

@end

@implementation BFCartViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // empty data set customization
    [self customizeEmptyDataSet];
    
    // table view cell swipe tutorial
    self.swipeTutorialEnabled = YES;
    
    // language changed notification observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopChangedAction) name:BFLanguageDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // title view
    self.navigationItem.title = [BFLocalizedString(kTranslationShoppingCart, @"Shopping cart") uppercaseString];
    // fetch data
    [self reloadDataFromNetwork];
}

#pragma mark - Table View Cell Extensions

- (void)setupExtensions {
    // default values
    [self removeAllExtensions];
    
    // data source arrays
    NSArray *products = [[ShoppingCart sharedCart] products];
    NSArray *discounts = [[ShoppingCart sharedCart] discounts];

    // product items
    if (products.count) {
        _productItemsExtension = [[BFCartProductsTableViewCellExtension alloc]initWithTableViewController:self];
        _productItemsExtension.swipeTutorialEnabled = self.swipeTutorialEnabled;
        __weak __typeof__(self) weakSelf = self;
        _productItemsExtension.productRemovalDidBeginCallback = ^{
            __typeof__(weakSelf) strongSelf = weakSelf;
            strongSelf.tableView.tableFooterView = strongSelf.spinnerFooterView;
        };
        _productItemsExtension.productRemovalDidFinishCallback = ^(NSError *error){
            __typeof__(weakSelf) strongSelf = weakSelf;
            if (error) {
                BFError *customError = [BFError errorWithError:error];
                [customError showAlertFromSender:weakSelf];
                [strongSelf reloadDataFromNetwork];
            }
            else {
                // reload bottom and top navigation bar
                [strongSelf updateNavigationBarsAnimated:NO];
                // reload label info
                [strongSelf updateTableFooterViewFromNetwork:YES];
            }
        };
        [self addExtension:_productItemsExtension];

        // table view cell swipe tutorial
        self.swipeTutorialEnabled = NO;
    }

    if (discounts.count) {
        // discount items
        _discountItemsExtension = [[BFCartDiscountsTableViewCellExtension alloc]initWithTableViewController:self];
        __weak __typeof__(self) weakSelf = self;
        _discountItemsExtension.discountRemovalDidBeginCallback = ^{
            __typeof__(weakSelf) strongSelf = weakSelf;
            strongSelf.tableView.tableFooterView = strongSelf.spinnerFooterView;
        };
        _discountItemsExtension.discountRemovalDidFinishCallback = ^(NSError *error){
            __typeof__(weakSelf) strongSelf = weakSelf;
            if (error) {
                BFError *customError = [BFError errorWithError:error];
                [customError showAlertFromSender:weakSelf];
            }
            [strongSelf reloadDataFromNetwork];
        };
        [self addExtension:_discountItemsExtension];
    }
}

- (void)cleanDataSource {
    [self removeAllExtensions];
    
    [[ShoppingCart sharedCart] clearCart];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    // scroll to top to display empty data set correctly
    [self.tableView setContentOffset:CGPointZero];
    [self.tableView reloadData];
}

#pragma mark - Language changed notification

- (void)shopChangedAction {
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - Data Fetching

- (void)reloadDataFromNetwork {
    // data fetching flag
    self.loadingData = true;
    // empty data source
    [self cleanDataSource];
    // hide top and bottom navigation
    [self updateNavigationBarsAnimated:NO];

    // fetch categories
    __weak __typeof__(self) weakSelf = self;
    [[ShoppingCart sharedCart] findShoppingCartContentsCompletion:^(NSError *error) {
        // error results
        if(error) {
            BFError *customError = [BFError errorWithError:error];
            [customError showAlertFromSender:weakSelf];
        }
        else {
            [self updateNavigationBarsAnimated:YES];
            [self updateTableFooterViewFromNetwork:NO];
            [self updateFooterLabels];
            
            [weakSelf setupExtensions];
        }
        // data fetching flag
        weakSelf.loadingData = false;
    }];
}

- (void)setLoadingData:(BOOL)loadingData {
    [super setLoadingData:loadingData];
    [self.tableView layoutSubviews];
    [self.tableView reloadData];
}

#pragma mark - Segue Management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // embed footer button controller
    if ([[segue identifier] isEqualToString:embedFooterButtonSegueIdentifier]) {
        if([segue.destinationViewController isKindOfClass:[BFButtonFooterView class]]) {
            BFButtonFooterView *footerButtonController = (BFButtonFooterView *)segue.destinationViewController;
            __weak __typeof(self)weakSelf = self;
            footerButtonController.actionButtonTitle = [BFLocalizedString(kTranslationContinue, @"Continue") uppercaseString];
            footerButtonController.actionButtonBlock = ^{
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                
                // delivery-info network request
                [strongSelf.view.window showIndeterminateSmallProgressOverlayWithTitle:nil animated:YES];
                __weak __typeof__(self) weakSelf = self;
                [[BFAPIManager sharedManager] findShoppingCartDeliveryInfoWithCompletionBlock:^(NSArray * _Nullable records, id  _Nullable customResponse, NSError * _Nullable error) {
                    __typeof__(weakSelf) strongSelf = weakSelf;
                    [strongSelf.view.window dismissAllOverlaysWithCompletion:^{
                        if (error) {
                            [strongSelf.view.window showFailureOverlayWithTitle:[error localizedDescription] animated:YES];
                            [strongSelf.view.window dismissAllOverlaysWithCompletion:nil animated:YES afterDelay:orderFailureDismissDelay];
                        }
                        else {
                            __typeof__(weakSelf) strongSelf = weakSelf;
                            BFDeliveryInfo *deliveryInfo = [records firstObject];
                            [strongSelf performSegueWithViewController:[BFOrderFormViewController class] params:@{ segueParameterDeliveryInfo : deliveryInfo }];
                        }
                    } animated:YES afterDelay:1.4];
                }];
            };
            [self applySegueParameters:footerButtonController];
        }
    }
    // order form segue
    if ([[segue identifier] isEqualToString:orderFormSegueIdentifier]) {
        if([segue.destinationViewController isKindOfClass:[BFOrderFormViewController class]]) {
            BFOrderFormViewController *orderFormController = (BFOrderFormViewController *)segue.destinationViewController;
            // apply delivery array params
            [self applySegueParameters:orderFormController];
        }
    }
    // product detail controller
    if ([[segue identifier] isEqualToString:productDetailSegueIdentifier]) {
        if([segue.destinationViewController isKindOfClass:[BFProductDetailViewController class]]) {
            BFProductDetailViewController *productDetailController = (BFProductDetailViewController *)segue.destinationViewController;
            [self applySegueParameters:productDetailController];
        }
    }
    // edit product in cart controller
    if ([[segue identifier] isEqualToString:editProductInCartSegueIdentifier]) {
        if([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
            if([[navController.viewControllers firstObject]isKindOfClass:[BFEditCartProductViewController class]]) {
                BFEditCartProductViewController *editProductController = (BFEditCartProductViewController *)[navController.viewControllers firstObject];
                [self applySegueParameters:editProductController];
            }
        }
    }
}

- (IBAction)unwindToCartViewController:(UIStoryboardSegue *)unwindSegue {
    [self performSegueWithViewController:[BFBannersViewController class] params:nil];
}

#pragma mark - BFTableViewCellExtensionDelegate

- (void)performSegueWithViewController:(Class)viewController params:(NSDictionary *)dictionary {
    // present order form
    if(viewController == [BFOrderFormViewController class]) {
        self.segueParameters = dictionary;
        [self performSegueWithIdentifier:orderFormSegueIdentifier sender:self];
    }
    // switch to offers
    else if (viewController == [BFBannersViewController class]) {
        UITabBarController *tabBarController = self.tabBarController;
        if ([tabBarController isKindOfClass:[BFTabBarController class]]) {
            [(BFTabBarController *)tabBarController setSelectedItem:BFTabBarItemOffers withPopToRootViewController:YES];
        }
        else {
            [self.tabBarController setSelectedIndex:BFTabBarItemOffers];
        }
    }
    // product detail controller
    else if(viewController == [BFProductDetailViewController class]) {
        self.segueParameters = dictionary;
        [self performSegueWithIdentifier:productDetailSegueIdentifier sender:self];
    }
    // product detail controller
    else if(viewController == [BFEditCartProductViewController class]) {
        self.segueParameters = dictionary;
        [self performSegueWithIdentifier:editProductInCartSegueIdentifier sender:self];
    }
}

#pragma mark - DZNEmptyDataSetSource Customization

- (void)customizeEmptyDataSet {
    self.emptyDataSubtitleColor = [UIColor BFN_pinkColor];
    self.emptyDataImage = [UIImage imageNamed:@"EmptyCartPlaceholder"];
    self.emptyDataTitle = BFLocalizedString(kTranslationEmptyCartHeadline, @"Empty cart");
    self.emptyDataSubtitle = [BFLocalizedString(kTranslationEmptyCartSubheadline, @"Go shopping") uppercaseString];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self emptyDataSetTapAction];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    [self emptyDataSetTapAction];
}

- (void)emptyDataSetTapAction {
    if (!self.loadingData) {
        [self.tabBarController setSelectedIndex:BFTabBarItemOffers];
    }
}

#pragma mark - Discount code action

- (IBAction)discountCodeTapped:(id)sender
{
    
    NSString *title = BFLocalizedString(kTranslationEnterDiscountCode, @"Enter discount code");
    
    if ([UIAlertController class]) {
        UIAlertController *alertController;
        UIAlertAction *useCodeAction;
        UIAlertAction *otherAction;
        
        alertController = [UIAlertController alertControllerWithTitle:title
                                                              message:nil
                                                       preferredStyle:UIAlertControllerStyleAlert];
        useCodeAction = [UIAlertAction actionWithTitle:BFLocalizedString(kTranslationApplyDiscountCode, @"Apply")
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action) {
                                                   UITextField *codeTextField = alertController.textFields.firstObject;
                                                   [self useDiscountCode:codeTextField.text];
                                               }];
        otherAction = [UIAlertAction actionWithTitle:BFLocalizedString(kTranslationCancel, @"Cancel")
                                               style:UIAlertActionStyleCancel
                                             handler:^(UIAlertAction *action) {
                                                 // do something here
                                             }];
        // note: you can control the order buttons are shown, unlike UIActionSheet
        [alertController addAction:otherAction];
        [alertController addAction:useCodeAction];
        [alertController setModalPresentationStyle:UIModalPresentationPopover];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = BFLocalizedString(kTranslationDiscountCode, @"Discount code");
        }];
        
        UIPopoverPresentationController *popPresenter = [alertController
                                                         popoverPresentationController];
        popPresenter.sourceView = self.discountButton;
        popPresenter.sourceRect = self.discountButton.bounds;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alertController animated:YES completion:nil];
            // necessary to set tint color after presenting
            // to fix the issue when the color changes back to the default blue one
            // after highlight
            alertController.view.tintColor = [UIColor BFN_pinkColor];
        });
    }
    else {
        /**
         * iOS 7 compatibility
         */
        UIAlertView *alertViewEnterDiscountCode = [[UIAlertView alloc] initWithTitle:title
                                                                             message:nil
                                                                            delegate:self
                                                                   cancelButtonTitle:BFLocalizedString(kTranslationCancel, @"Cancel")
                                                                   otherButtonTitles:BFLocalizedString(kTranslationConfirm, @"Confirm"),nil];
        alertViewEnterDiscountCode.alertViewStyle=UIAlertViewStylePlainTextInput;
        [alertViewEnterDiscountCode show];
    }
    
}

/**
 * iOS 7 compatibility
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case confirmButtonIndex: {
            NSString *discountCode = [[alertView textFieldAtIndex:0] text];
            [self useDiscountCode:discountCode];
            break;
        }
            
        default:
            break;
    }
}

- (void)useDiscountCode:(NSString*)discountCode
{
    // Dismiss keyboard
    [self.view endEditing:YES];
    
    // Show Progress Overlay
    [self.view.window showIndeterminateSmallProgressOverlayWithTitle:BFLocalizedString(kTranslationApplyingDiscountCode, @"Applying discount code")
                                                            animated:YES];

    // Add Discount network request
    BFAPIRequestCartDiscountInfo *discountInfo = [[BFAPIRequestCartDiscountInfo alloc] initWithDiscountCode:discountCode];
    __weak __typeof__(self) weakSelf = self;
    [[BFAPIManager sharedManager] addDiscountToCartWithInfo:discountInfo completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        __typeof__(weakSelf) strongSelf = weakSelf;
        [strongSelf.view.window dismissAllOverlaysWithCompletion:^{
            if (error) {
                [strongSelf.view.window showFailureOverlayWithTitle:[error localizedDescription] animated:YES];
                [strongSelf.view.window dismissAllOverlaysWithCompletion:nil animated:YES afterDelay:orderFailureDismissDelay];
            }
            else {
                __typeof__(weakSelf) strongSelf = weakSelf;
                [strongSelf reloadDataFromNetwork];
            }
        } animated:YES afterDelay:orderSucessDismissDelay];

    }];
}

#pragma mark - UI helper methods

- (void)updateNavigationBarsAnimated:(BOOL)animated {
    if ([[[ShoppingCart sharedCart] products] count]) {
        self.footerButtonHeightConstraint.constant = bottomNavigationHeight;
        self.navigationStepsHeightConstraint.constant = topNavigationHeight;
    }
    else {
        self.footerButtonHeightConstraint.constant = 0.0;
        self.navigationStepsHeightConstraint.constant = 0.0;
    }
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
            [self.navigationStepsView setNeedsDisplay];
        }];
    }
    else {
        [self.view layoutIfNeeded];
        [self.navigationStepsView setNeedsDisplay];
    }
}

- (void)updateFooterLabels {
    NSNumber *numberOfPieces = [[ShoppingCart sharedCart] productCount];
    NSString *totalPriceFormatted = [[ShoppingCart sharedCart] totalPriceFormatted];
    // number of pieces label
    self.numberOfPiecesLabel.text = [NSString stringWithFormat:@"%@ %@", numberOfPieces, BFLocalizedString(kTranslationPieces, @"pcs")];
    // total price label
    self.totalPriceLabel.text = totalPriceFormatted;
}

- (void)updateTableFooterViewFromNetwork:(BOOL)fromNetwork {
    if (fromNetwork) {
        // start spinning
        self.tableView.tableFooterView = self.spinnerFooterView;
        __weak __typeof__(self) weakSelf = self;
        // cart-info network request
        [[ShoppingCart sharedCart] findShoppingCartInfoCompletion:^(NSError *error) {
            __typeof__(weakSelf) strongSelf = weakSelf;
            if (!error) {
                [strongSelf updateFooterLabels];
            }
            [strongSelf updateTableFooterViewFromNetwork:NO];
        }];
    }
    else {
        if ([[[ShoppingCart sharedCart] products] count]) {
            self.tableView.tableFooterView = self.priceFooterView;
        }
        else {
            [self cleanDataSource];
            [self.tableView reloadEmptyDataSet];
        }
    }
}

#pragma mark - Lazy loading properties

- (UIView *)spinnerFooterView
{
    if (!_spinnerFooterView) {
        _spinnerFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        
        [_spinnerFooterView addSubview:spinner];
        
        [spinner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self->_spinnerFooterView);
        }];
    }
    return _spinnerFooterView;
}

#pragma mark - Custom Appearance

+ (void)customizeAppearance {

}

@end
